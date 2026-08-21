import Fastify from 'fastify'
import { readFileSync } from 'node:fs'
import { resolve, dirname, isAbsolute } from 'node:path'
import { fileURLToPath } from 'node:url'
import { Readable } from 'node:stream'
import { config } from './config.js'
import { PlanetStore } from './store/PlanetStore.js'
import { MoonStore } from './store/MoonStore.js'
import type { Planet, Moon } from './types.js'
import routes from './routes/index.js'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

export async function build() {
  const fastify = Fastify({
    logger: config.logging,
  })

  // ONE envelope for every failure: { error, message }.
  //
  // `error` used to be `err.name`, which is only meaningful for the error
  // classes this app throws. Fastify's own failures carry internal names, so
  // the commonest 400 of all — an Ajv schema violation — reached clients as
  //
  //     { "error": "Error", "message": "body must have required property 'name'" }
  //
  // and a malformed JSON body as "FastifyError". Meanwhile the branch that
  // produced "Validation Error" (with a space, as app/README.md documents) was
  // UNREACHABLE: Fastify sets statusCode 400 on a validation error before the
  // handler runs, so the first branch always won.
  //
  // Now: keep the name when it is one of ours — those are the distinctions the
  // API deliberately exposes — and otherwise use the name for the status. Every
  // source of a given status then produces one label, in one style.
  // Label per STATUS, not per thrown class.
  //
  // This began as "keep err.name when it is one of ours, else derive from the
  // status", then gained an agreement check so a 500 could not be labelled
  // ValidationError just because something of that name threw. With that check
  // in place the name branch became a no-op — it returned err.name only when
  // err.name already equalled the status label — so it is gone, along with the
  // set of names it consulted.
  //
  // Nothing is lost: the map below reproduces every name this app throws
  // (NotFoundError 404, ValidationError 400, ConflictError 409), and deriving
  // from the status is what makes Fastify's own failures answer in the same
  // shape as ours.
  const STATUS_ERRORS: Record<number, string> = {
    400: 'ValidationError',
    404: 'NotFoundError',
    409: 'ConflictError',
    500: 'InternalServerError',
  }

  fastify.setErrorHandler((error, request, reply) => {
    const err = error as any
    const status =
      'number' === typeof err.statusCode && 400 <= err.statusCode ? err.statusCode : 500

    const name = STATUS_ERRORS[status] ||
      (500 <= status ? 'InternalServerError' : 'RequestError')

    // Only server faults are ours to investigate; a 4xx is the caller's.
    if (500 <= status) {
      request.log.error(err)
    }

    reply.status(status).send({
      error: name,
      message: err.message,
    })
  })

  // Fastify's not-found path NEVER reaches setErrorHandler, so without this the
  // commonest 404 of all — an unmatched route or an unsupported method —
  // answered with a different shape from every other failure:
  //
  //   {"message":"Route GET:/nope not found","error":"Not Found","statusCode":404}
  //
  // Three fields instead of two, and "Not Found" with a space: exactly the
  // style the error handler above exists to eliminate. README.md's "every
  // failure uses one envelope" was false for it.
  fastify.setNotFoundHandler((request, reply) => {
    reply.status(404).send({
      error: 'NotFoundError',
      message: `Route ${request.method}:${request.url} not found`,
    })
  })

  // DATA_PATH was read into config and then ignored: this line hardcoded
  // the file, so setting the documented env var did nothing at all.
  //
  // A relative value resolves against the app root rather than the CWD —
  // the default './solar.data.json' has to keep working whichever
  // directory the server is started from, and `npm start`, the test
  // harness and validate:full do not agree on that.
  const dataPath = isAbsolute(config.data.initialDataPath)
    ? config.data.initialDataPath
    : resolve(__dirname, '../..', config.data.initialDataPath)
  const rawData = JSON.parse(readFileSync(dataPath, 'utf-8')) as {
    planet: Record<string, Planet>
    moon: Record<string, Moon>
  }

  const moonStore = new MoonStore()
  const planetStore = new PlanetStore(moonStore)

  Object.values(rawData.planet).forEach((p) => planetStore.create(p))
  Object.values(rawData.moon).forEach((m) => moonStore.create(m))

  fastify.decorate('planetStore', planetStore)
  fastify.decorate('moonStore', moonStore)

  fastify.addHook('preParsing', async (request, _reply, payload) => {
    if (
      request.method === 'DELETE' &&
      request.headers['content-type']?.includes('application/json')
    ) {
      const chunks: Buffer[] = []
      for await (const chunk of payload) {
        chunks.push(typeof chunk === 'string' ? Buffer.from(chunk) : chunk as Buffer)
      }
      const body = Buffer.concat(chunks).toString().trim()
      if (body === '') {
        return Readable.from(Buffer.from('{}'))
      }
      return Readable.from(Buffer.from(body))
    }
    return payload
  })

  await fastify.register(routes)

  return fastify
}

export async function main() {
  const fastify = await build()

  try {
    await fastify.listen({
      host: config.server.host,
      port: config.server.port,
    })
    console.log(`Base URL: http://${config.server.host}:${config.server.port}`)
  } catch (err) {
    fastify.log.error(err)
    process.exit(1)
  }
}

if (import.meta.url === `file://${process.argv[1]}`) {
  main()
}

import { describe, test, beforeEach, afterEach } from 'node:test'
import { strictEqual, match } from 'node:assert'
import { build } from '../../src/server.js'
import type { FastifyInstance } from 'fastify'

// Pins the ERROR ENVELOPE, which nothing asserted before.
//
// `error` was `err.name`, so it reported whatever internal name the throwing
// library used: an Ajv schema violation — the commonest 400 this server
// produces — reached clients as "Error", and a malformed JSON body as
// "FastifyError". The branch that produced the documented "Validation Error"
// could never run, because Fastify sets statusCode 400 before the handler.
//
// None of that was visible to a test, which is why it survived: every case
// below returns a 4xx either way, so only the label distinguishes the bug from
// the fix.
describe('Error envelope', () => {
  let app: FastifyInstance

  beforeEach(async () => {
    app = await build()
  })

  afterEach(async () => {
    await app.close()
  })

  async function envelope(req: any) {
    const res = await app.inject(req)
    return { status: res.statusCode, body: JSON.parse(res.body) }
  }

  test('a schema violation is a ValidationError, not "Error"', async () => {
    const { status, body } = await envelope({
      method: 'POST', url: '/api/planet', payload: { kind: 'rock' },
    })
    strictEqual(status, 400)
    strictEqual(body.error, 'ValidationError')
    match(body.message, /required property/)
  })

  test('a malformed JSON body is a ValidationError, not "FastifyError"', async () => {
    const { status, body } = await envelope({
      method: 'POST',
      url: '/api/planet',
      payload: '{bad',
      headers: { 'content-type': 'application/json' },
    })
    strictEqual(status, 400)
    strictEqual(body.error, 'ValidationError')
  })

  test('a missing record is a NotFoundError', async () => {
    const { status, body } = await envelope({
      method: 'GET', url: '/api/planet/no-such-planet',
    })
    strictEqual(status, 404)
    strictEqual(body.error, 'NotFoundError')
  })

  test('an unmatched route is a NotFoundError, not "Not Found"', async () => {
    const { status, body } = await envelope({ method: 'GET', url: '/no-such-route' })
    strictEqual(status, 404)
    strictEqual(body.error, 'NotFoundError')
    strictEqual(body.statusCode, undefined, 'the envelope is exactly { error, message }')
  })

  test('an unsupported method on a real path is a NotFoundError', async () => {
    const { status, body } = await envelope({ method: 'PATCH', url: '/api/planet' })
    strictEqual(status, 404)
    strictEqual(body.error, 'NotFoundError')
  })

  test('a duplicate id is a ConflictError', async () => {
    const { status, body } = await envelope({
      method: 'POST',
      url: '/api/planet',
      payload: { id: 'earth', name: 'Earth again', kind: 'rock', diameter: 1 },
    })
    strictEqual(status, 409)
    strictEqual(body.error, 'ConflictError')
  })

  test('every failure carries both error and message', async () => {
    for (const req of [
      { method: 'POST', url: '/api/planet', payload: { kind: 'rock' } },
      { method: 'GET', url: '/api/planet/no-such-planet' },
      // Unmatched route and unsupported method: these do NOT go through
      // setErrorHandler — Fastify answers them on its own not-found path — so
      // leaving them out of this list is what let the envelope diverge here
      // while every case above passed.
      { method: 'GET', url: '/no-such-route' },
      { method: 'PATCH', url: '/api/planet' },
    ]) {
      const { body } = await envelope(req)
      strictEqual(typeof body.error, 'string', 'error must be present')
      strictEqual(typeof body.message, 'string', 'message must be present')
      match(body.error, /^[A-Z][A-Za-z]*Error$/, `not PascalCase: ${body.error}`)
    }
  })
})

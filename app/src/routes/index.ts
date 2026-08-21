import type { FastifyInstance } from 'fastify'
import planetRoutes from './planet.routes.js'
import moonRoutes from './moon.routes.js'
import { debugRouteEnabled } from '../config.js'

export default async function routes(fastify: FastifyInstance) {
  fastify.addSchema({
    $id: 'planet',
    type: 'object',
    properties: {
      id: { type: 'string' },
      name: { type: 'string' },
      kind: { type: 'string' },
      diameter: { type: 'number' },
      terraformState: { type: 'string' },
      forbidState: { type: 'string' },
      forbidReason: { type: 'string' },
    },
  })

  fastify.addSchema({
    $id: 'moon',
    type: 'object',
    properties: {
      id: { type: 'string' },
      name: { type: 'string' },
      planet_id: { type: 'string' },
      kind: { type: 'string' },
      diameter: { type: 'number' },
    },
  })

  fastify.addSchema({
    $id: 'error',
    type: 'object',
    properties: {
      error: { type: 'string' },
      message: { type: 'string' },
    },
  })

  // Registered only when it cannot be reached off-box. See debugRouteEnabled:
  // this dumps the whole store with no auth and is not in the OpenAPI
  // definition, so on a non-loopback bind it is a data-disclosure endpoint.
  // Not registering beats registering-and-refusing: there is then no route to
  // find, and no handler that a later edit could accidentally un-guard.
  if (debugRouteEnabled()) {
    fastify.get('/debug', async (request, reply) => {
      reply.send({
        data: {
          planet: fastify.planetStore.getAll(),
          moon: fastify.moonStore.getAll(),
        },
      })
    })
  }

  await fastify.register(planetRoutes)
  await fastify.register(moonRoutes)
}

import type { FastifyRequest, FastifyReply } from 'fastify'
import type { CreateMoonInput, UpdateMoonInput } from '../types.js'
import { ConflictError, NotFoundError, ValidationError } from '../utils/errors.js'
import Nid from 'nid'
const nid = (Nid as any).default || Nid

export const moonHandlers = {
  async list(
    request: FastifyRequest<{ Params: { planet_id: string } }>,
    reply: FastifyReply
  ) {
    const planetStore = request.server.planetStore
    const moonStore = request.server.moonStore

    const planet = planetStore.getById(request.params.planet_id)
    if (!planet) {
      throw new NotFoundError('Planet', request.params.planet_id)
    }

    const moons = moonStore.getByPlanetId(request.params.planet_id)
    reply.send(moons)
  },

  async get(
    request: FastifyRequest<{
      Params: { planet_id: string; moon_id: string }
    }>,
    reply: FastifyReply
  ) {
    const moonStore = request.server.moonStore
    const moon = moonStore.getById(request.params.moon_id)

    // The parent id in the path is part of the identity, not decoration.
    // Matching on moon_id alone made GET /api/planet/mars/moon/luna return
    // earth's luna.
    if (!moon || moon.planet_id !== request.params.planet_id) {
      throw new NotFoundError('Moon', request.params.moon_id)
    }

    reply.send(moon)
  },

  async create(
    request: FastifyRequest<{ Params: { planet_id: string }; Body: CreateMoonInput }>,
    reply: FastifyReply
  ) {
    const planetStore = request.server.planetStore
    const moonStore = request.server.moonStore

    const planet = planetStore.getById(request.params.planet_id)
    if (!planet) {
      throw new NotFoundError('Planet', request.params.planet_id)
    }

    if (request.body.planet_id !== request.params.planet_id) {
      throw new ValidationError(
        'planet_id in body must match planet_id in path'
      )
    }

    // Honour a client-supplied id — see the note in planet.handlers.ts.
    const id = request.body.id ?? nid(8)

    if (moonStore.getById(id)) {
      throw new ConflictError('Moon', id)
    }

    const moon = moonStore.create({ ...request.body, id })
    reply.code(201).send(moon)
  },

  async update(
    request: FastifyRequest<{
      Params: { planet_id: string; moon_id: string }
      Body: UpdateMoonInput
    }>,
    reply: FastifyReply
  ) {
    const moonStore = request.server.moonStore

    // Check ownership BEFORE mutating: update() used to write first and only
    // then discover the moon, so a request under the wrong parent still
    // applied its changes.
    const existing = moonStore.getById(request.params.moon_id)

    if (!existing || existing.planet_id !== request.params.planet_id) {
      throw new NotFoundError('Moon', request.params.moon_id)
    }

    // A moon cannot be reparented by PUTting a different planet_id — the
    // body used to be merged wholesale, silently moving it out from under
    // the URL that addressed it. Mirrors the check `create` already makes.
    if (
      undefined !== request.body.planet_id &&
      request.body.planet_id !== request.params.planet_id
    ) {
      throw new ValidationError(
        'planet_id in body must match planet_id in path'
      )
    }

    const moon = moonStore.update(request.params.moon_id, request.body)

    if (!moon) {
      throw new NotFoundError('Moon', request.params.moon_id)
    }

    reply.send(moon)
  },

  async delete(
    request: FastifyRequest<{
      Params: { planet_id: string; moon_id: string }
    }>,
    reply: FastifyReply
  ) {
    const moonStore = request.server.moonStore

    // Ownership check before the delete, for the same reason as update:
    // DELETE /api/planet/mars/moon/luna used to destroy earth's luna.
    const existing = moonStore.getById(request.params.moon_id)

    if (!existing || existing.planet_id !== request.params.planet_id) {
      throw new NotFoundError('Moon', request.params.moon_id)
    }

    const deleted = moonStore.delete(request.params.moon_id)

    if (!deleted) {
      throw new NotFoundError('Moon', request.params.moon_id)
    }

    reply.code(204).send()
  },
}

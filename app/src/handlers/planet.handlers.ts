import type { FastifyRequest, FastifyReply } from 'fastify'
import type { CreatePlanetInput, UpdatePlanetInput, TerraformRequest, ForbidRequest } from '../types.js'
import { ConflictError, NotFoundError } from '../utils/errors.js'
import Nid from 'nid'
const nid = (Nid as any).default || Nid

export const planetHandlers = {
  async list(request: FastifyRequest, reply: FastifyReply) {
    const planetStore = request.server.planetStore
    const planets = planetStore.getAll()
    reply.send(planets)
  },

  async get(
    request: FastifyRequest<{ Params: { planet_id: string } }>,
    reply: FastifyReply
  ) {
    const planetStore = request.server.planetStore
    const planet = planetStore.getById(request.params.planet_id)

    if (!planet) {
      throw new NotFoundError('Planet', request.params.planet_id)
    }

    reply.send(planet)
  },

  async create(
    request: FastifyRequest<{ Body: CreatePlanetInput }>,
    reply: FastifyReply
  ) {
    const planetStore = request.server.planetStore

    // Honour a client-supplied id. OpenAPI requires one on create and the
    // generated SDK type does too, so overwriting it with nid(8) broke every
    // SDK create round-trip: the caller got back a record it could not then
    // load by the id it had chosen. Generated only when absent, which keeps
    // the server a superset of the spec.
    const id = request.body.id ?? nid(8)

    if (planetStore.getById(id)) {
      throw new ConflictError('Planet', id)
    }

    const planet = planetStore.create({ ...request.body, id })
    reply.code(201).send(planet)
  },

  async update(
    request: FastifyRequest<{ Params: { planet_id: string }; Body: UpdatePlanetInput }>,
    reply: FastifyReply
  ) {
    const planetStore = request.server.planetStore
    const planet = planetStore.update(request.params.planet_id, request.body)

    if (!planet) {
      throw new NotFoundError('Planet', request.params.planet_id)
    }

    reply.send(planet)
  },

  async delete(
    request: FastifyRequest<{ Params: { planet_id: string } }>,
    reply: FastifyReply
  ) {
    const planetStore = request.server.planetStore
    const deleted = planetStore.delete(request.params.planet_id)

    if (!deleted) {
      throw new NotFoundError('Planet', request.params.planet_id)
    }

    reply.code(204).send()
  },

  async terraform(
    request: FastifyRequest<{
      Params: { planet_id: string }
      Body: TerraformRequest
    }>,
    reply: FastifyReply
  ) {
    const planetStore = request.server.planetStore
    const planet = planetStore.getById(request.params.planet_id)

    if (!planet) {
      throw new NotFoundError('Planet', request.params.planet_id)
    }

    const { start, stop } = request.body
    let state = planet.terraformState || 'idle'

    if (start) {
      state = 'terraforming'
    } else if (stop) {
      state = 'idle'
    }

    planetStore.update(request.params.planet_id, { terraformState: state })

    reply.send({ ok: true, state })
  },

  async forbid(
    request: FastifyRequest<{
      Params: { planet_id: string }
      Body: ForbidRequest
    }>,
    reply: FastifyReply
  ) {
    const planetStore = request.server.planetStore
    const planet = planetStore.getById(request.params.planet_id)

    if (!planet) {
      throw new NotFoundError('Planet', request.params.planet_id)
    }

    const { forbid, why } = request.body
    const forbidState = forbid ? 'forbidden' : 'allowed'

    planetStore.update(request.params.planet_id, {
      forbidState,
      forbidReason: forbid ? why : undefined,
    })

    reply.send({ ok: true, state: forbidState })
  },
}

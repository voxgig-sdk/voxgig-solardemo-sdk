import { describe, test, before, after } from 'node:test'
import { strictEqual } from 'node:assert'
import { build } from '../../src/server.js'
import type { FastifyInstance } from 'fastify'

describe('Planet API Integration', () => {
  let app: FastifyInstance

  before(async () => {
    app = await build()
  })

  after(async () => {
    await app.close()
  })

  test('GET /api/planet returns all planets', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/api/planet',
    })

    strictEqual(res.statusCode, 200)
    const planets = JSON.parse(res.payload)
    strictEqual(planets.length, 8)
  })

  test('GET /api/planet/:planet_id returns specific planet', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/api/planet/earth',
    })

    strictEqual(res.statusCode, 200)
    const planet = JSON.parse(res.payload)
    strictEqual(planet.id, 'earth')
    strictEqual(planet.name, 'Earth')
  })

  test('GET /api/planet/:planet_id returns 404 for non-existent planet', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/api/planet/non-existent',
    })

    strictEqual(res.statusCode, 404)
  })

  test('full planet lifecycle', async () => {
    const createRes = await app.inject({
      method: 'POST',
      url: '/api/planet',
      payload: {
        id: 'test-planet',
        name: 'Test Planet',
        kind: 'rock',
        diameter: 5000,
      },
    })
    strictEqual(createRes.statusCode, 201)

    const getRes = await app.inject({
      method: 'GET',
      url: '/api/planet/test-planet',
    })
    strictEqual(getRes.statusCode, 200)
    const planet = JSON.parse(getRes.payload)
    strictEqual(planet.name, 'Test Planet')

    const updateRes = await app.inject({
      method: 'PUT',
      url: '/api/planet/test-planet',
      payload: {
        id: 'test-planet',
        name: 'Updated Planet',
        kind: 'rock',
        diameter: 5000,
      },
    })
    strictEqual(updateRes.statusCode, 200)
    const updated = JSON.parse(updateRes.payload)
    strictEqual(updated.name, 'Updated Planet')

    const deleteRes = await app.inject({
      method: 'DELETE',
      url: '/api/planet/test-planet',
    })
    strictEqual(deleteRes.statusCode, 204)

    const notFoundRes = await app.inject({
      method: 'GET',
      url: '/api/planet/test-planet',
    })
    strictEqual(notFoundRes.statusCode, 404)
  })

  test('POST /api/planet/:planet_id/terraform starts terraforming', async () => {
    const res = await app.inject({
      method: 'POST',
      url: '/api/planet/mars/terraform',
      payload: { start: true },
    })

    strictEqual(res.statusCode, 200)
    const body = JSON.parse(res.payload)
    strictEqual(body.ok, true)
    strictEqual(body.state, 'terraforming')
  })

  test('POST /api/planet/:planet_id/terraform stops terraforming', async () => {
    const res = await app.inject({
      method: 'POST',
      url: '/api/planet/mars/terraform',
      payload: { stop: true },
    })

    strictEqual(res.statusCode, 200)
    const body = JSON.parse(res.payload)
    strictEqual(body.ok, true)
    strictEqual(body.state, 'idle')
  })

  test('POST /api/planet/:planet_id/forbid marks planet as forbidden', async () => {
    const res = await app.inject({
      method: 'POST',
      url: '/api/planet/venus/forbid',
      payload: { forbid: true, why: 'Dangerous atmosphere' },
    })

    strictEqual(res.statusCode, 200)
    const body = JSON.parse(res.payload)
    strictEqual(body.ok, true)
    strictEqual(body.state, 'forbidden')
  })

  test('POST /api/planet/:planet_id/forbid allows planet', async () => {
    const res = await app.inject({
      method: 'POST',
      url: '/api/planet/venus/forbid',
      payload: { forbid: false },
    })

    strictEqual(res.statusCode, 200)
    const body = JSON.parse(res.payload)
    strictEqual(body.ok, true)
    strictEqual(body.state, 'allowed')
  })

  test('terraform on non-existent planet returns 404', async () => {
    const res = await app.inject({
      method: 'POST',
      url: '/api/planet/non-existent/terraform',
      payload: { start: true },
    })

    strictEqual(res.statusCode, 404)
  })
})

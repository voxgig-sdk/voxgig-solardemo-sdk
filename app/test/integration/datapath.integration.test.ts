import { describe, test, before, after } from 'node:test'
import { strictEqual, ok } from 'node:assert'
import { mkdtempSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import type { FastifyInstance } from 'fastify'

// M2 — DATA_PATH was documented in config.ts and then ignored, because
// build() hardcoded the seed file. This pins that it is actually read.
//
// config.ts is evaluated when server.js is first imported, so DATA_PATH has
// to be set BEFORE that import — hence the dynamic import inside before().
// `node --test` runs each test file in its own process, so this cannot leak
// into the other suites, which rely on the default seed data.
describe('DATA_PATH', () => {
  let app: FastifyInstance

  before(async () => {
    const file = join(
      mkdtempSync(join(tmpdir(), 'solardemo-datapath-')),
      'alt.data.json'
    )

    writeFileSync(
      file,
      JSON.stringify({
        planet: {
          xanadu: { id: 'xanadu', name: 'Xanadu', kind: 'rock', diameter: 1234 },
        },
        moon: {
          castalia: {
            id: 'castalia',
            name: 'Castalia',
            planet_id: 'xanadu',
            kind: 'rock',
            diameter: 12,
          },
        },
      })
    )

    process.env.DATA_PATH = file

    const { build } = await import('../../src/server.js')
    app = await build()
  })

  after(async () => {
    delete process.env.DATA_PATH
    await app.close()
  })

  test('an absolute DATA_PATH replaces the default seed data', async () => {
    const res = await app.inject({ method: 'GET', url: '/api/planet' })

    strictEqual(res.statusCode, 200)
    const planets = JSON.parse(res.payload)

    // The default file seeds 8 planets; this one seeds exactly one, so a
    // hardcoded path would show up here as 8 rather than 1.
    strictEqual(planets.length, 1)
    strictEqual(planets[0].id, 'xanadu')
  })

  test('nested data from DATA_PATH is loaded too', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/api/planet/xanadu/moon/castalia',
    })

    strictEqual(res.statusCode, 200)
    const moon = JSON.parse(res.payload)
    strictEqual(moon.name, 'Castalia')
    strictEqual(moon.planet_id, 'xanadu')
  })

  test('a planet from the default seed data is absent', async () => {
    const res = await app.inject({ method: 'GET', url: '/api/planet/earth' })

    ok(
      404 === res.statusCode,
      'earth comes from the default file — seeing it means DATA_PATH was ignored'
    )
  })
})

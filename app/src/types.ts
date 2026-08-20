import type { PlanetStore } from './store/PlanetStore.js'
import type { MoonStore } from './store/MoonStore.js'

export interface Planet {
  id: string
  name: string
  kind: string
  diameter: number
  terraformState?: 'idle' | 'terraforming' | 'complete'
  forbidState?: 'allowed' | 'forbidden'
  forbidReason?: string
}

export interface Moon {
  id: string
  name: string
  planet_id: string
  kind: string
  diameter: number
}

export interface TerraformRequest {
  start?: boolean
  stop?: boolean
}

export interface TerraformResponse {
  ok: boolean
  state: string
}

export interface ForbidRequest {
  forbid: boolean
  why?: string
}

export interface ForbidResponse {
  ok: boolean
  state: string
}

// `id` is OPTIONAL on create, not absent: OpenAPI and the generated SDK types
// both require the client to supply one, and the server generates it only when
// it is omitted. `Omit<_, 'id'>` is what made the handlers overwrite it.
export type CreatePlanetInput = Omit<Planet, 'id'> & { id?: string }
export type UpdatePlanetInput = Partial<Planet>
export type CreateMoonInput = Omit<Moon, 'id'> & { id?: string }
export type UpdateMoonInput = Partial<Moon>

declare module 'fastify' {
  interface FastifyInstance {
    planetStore: PlanetStore
    moonStore: MoonStore
  }
}

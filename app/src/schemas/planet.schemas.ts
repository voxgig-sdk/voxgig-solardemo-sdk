export const planetSchemas = {
  list: {
    response: {
      200: {
        type: 'array',
        items: { $ref: 'planet#' },
      },
    },
  },
  get: {
    params: {
      type: 'object',
      required: ['planet_id'],
      properties: {
        planet_id: { type: 'string' },
      },
    },
    response: {
      200: { $ref: 'planet#' },
      404: { $ref: 'error#' },
    },
  },
  create: {
    body: {
      type: 'object',
      required: ['name', 'kind', 'diameter'],
      properties: {
        // OpenAPI's POST /api/planet body is the full Planet schema, which
        // requires `id`, and the generated SDK type PlanetCreateData.id is
        // likewise required — so every SDK caller sends one. This schema
        // omitted `id` while setting additionalProperties:false, which made
        // a spec-conforming create a 400. Accepted here, and optional so the
        // server stays a superset of the spec: omit it and one is generated.
        id: { type: 'string' },
        name: { type: 'string' },
        kind: { type: 'string' },
        diameter: { type: 'number' },
      },
      additionalProperties: false,
    },
    response: {
      201: { $ref: 'planet#' },
      400: { $ref: 'error#' },
      409: { $ref: 'error#' },
    },
  },
  update: {
    params: {
      type: 'object',
      required: ['planet_id'],
      properties: {
        planet_id: { type: 'string' },
      },
    },
    body: {
      type: 'object',
      properties: {
        id: { type: 'string' },
        name: { type: 'string' },
        kind: { type: 'string' },
        diameter: { type: 'number' },
      },
      additionalProperties: false,
    },
    response: {
      200: { $ref: 'planet#' },
      404: { $ref: 'error#' },
    },
  },
  delete: {
    params: {
      type: 'object',
      required: ['planet_id'],
      properties: {
        planet_id: { type: 'string' },
      },
    },
    response: {
      204: {
        type: 'null',
      },
      404: { $ref: 'error#' },
    },
  },
  terraform: {
    params: {
      type: 'object',
      required: ['planet_id'],
      properties: {
        planet_id: { type: 'string' },
      },
    },
    body: {
      type: 'object',
      properties: {
        start: { type: 'boolean' },
        stop: { type: 'boolean' },
      },
      additionalProperties: false,
    },
    response: {
      200: {
        type: 'object',
        properties: {
          ok: { type: 'boolean' },
          state: { type: 'string' },
        },
      },
      404: { $ref: 'error#' },
    },
  },
  forbid: {
    params: {
      type: 'object',
      required: ['planet_id'],
      properties: {
        planet_id: { type: 'string' },
      },
    },
    body: {
      type: 'object',
      required: ['forbid'],
      properties: {
        forbid: { type: 'boolean' },
        why: { type: 'string' },
      },
      additionalProperties: false,
    },
    response: {
      200: {
        type: 'object',
        properties: {
          ok: { type: 'boolean' },
          state: { type: 'string' },
        },
      },
      404: { $ref: 'error#' },
    },
  },
}

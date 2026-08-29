// Project-owned secrets extension. See SecretsFeature.ts for why this is
// hand-written rather than generated.

export { SecretsFeature } from './SecretsFeature'

// The vendored sekreto surface, so consumers can build provider chains
// (env/dotenv/vault/custom) without adding a dependency.
export * as sekreto from './sekreto'

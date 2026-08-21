import { test, describe } from 'node:test'
import { strictEqual, ok } from 'node:assert'
import { readFileSync, readdirSync } from 'node:fs'
import { join, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'
import { createHash } from 'node:crypto'

// The OpenAPI definition exists TWICE and nothing checked the copies agree.
//
//   app/def/…yaml   the definition the project was bootstrapped from
//                   (DEV.md's create-sdkgen command names this path)
//   .sdk/def/…yaml  the copy the model consumes (`def:` in sdk-base.aontu)
//
// Neither is generated from the other, so an edit to one silently diverges:
// the SDKs would be generated from one definition while the documented source
// of truth said something else, and nothing anywhere would fail.
//
// This lives in app/ because app/ is the only hand-written suite CI runs that
// can see both paths — .sdk has no test runner, and ts/test is generated.
describe('OpenAPI definition copies', () => {

  // app/ compiles to ESM, so there is no __dirname here.
  const HERE = dirname(fileURLToPath(import.meta.url))
  // dist/test -> dist -> app -> repo root
  const ROOT = join(HERE, '..', '..', '..')
  const APP_DEF = join(ROOT, 'app', 'def')
  const SDK_DEF = join(ROOT, '.sdk', 'def')

  const yamls = (dir: string) =>
    readdirSync(dir).filter((f) => f.endsWith('.yaml')).sort()

  const sha = (p: string) =>
    createHash('sha256').update(readFileSync(p)).digest('hex')

  test('both locations hold the same definition files', () => {
    const appFiles = yamls(APP_DEF)
    ok(0 < appFiles.length, 'no .yaml found under app/def')
    for (const f of appFiles) {
      ok(yamls(SDK_DEF).includes(f), `${f} is in app/def but not .sdk/def`)
    }
  })

  test('the copies are byte-identical', () => {
    for (const f of yamls(APP_DEF)) {
      strictEqual(sha(join(APP_DEF, f)), sha(join(SDK_DEF, f)),
        `${f} differs between app/def and .sdk/def — the SDKs are generated ` +
        `from .sdk/def, so they and the documented source have diverged. ` +
        `Copy the intended one over the other.`)
    }
  })
})

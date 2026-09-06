

import Path from 'node:path'
import * as Fs from 'node:fs'

import { test, describe, afterEach } from 'node:test'
import assert from 'node:assert'


import { SolardemoSDK, BaseFeature, stdutil } from '../../..'

import {
  envOverride,
  liveClientOptions,
  liveDelay,
  loadEnvLocal,
  makeCtrl,
  makeMatch,
  makeReqdata,
  makeStepData,
  makeValid,
  maybeSkipControl,
} from '../../utility'


// AFTER the imports on purpose: TypeScript hoists `import` above any
// statement in the emitted CommonJS, so a loader placed above them would
// run only after every imported module had already been evaluated - and
// anything reading process.env at module scope would miss these values.
loadEnvLocal(__dirname + '/../../../.env.local')


describe('PlanetEntity', async () => {

  // Per-test live pacing. Delay is read from sdk-test-control.json's
  // `test.live.delayMs`; only sleeps when SOLARDEMO_TEST_LIVE=TRUE.
  afterEach(liveDelay('SOLARDEMO_TEST_LIVE'))

  test('instance', async () => {
    const testsdk = SolardemoSDK.test()
    const ent = testsdk.Planet()
    assert(null != ent)
  })


  test('basic', async (t) => {

    const live = 'TRUE' === process.env.SOLARDEMO_TEST_LIVE
    for (const op of ['create', 'list', 'update', 'load', 'remove']) {
      if (maybeSkipControl(t, 'entityOp', 'planet.' + op, live)) return
    }

    const setup = basicSetup()
    // The basic flow consumes synthetic IDs and field values from the
    // fixture (entity TestData.json). Those don't exist on the live API.
    // Skip live runs unless the user provided a real ENTID env override.
    if (setup.syntheticOnly) {
      t.skip('live entity test uses synthetic IDs from fixture — set SOLARDEMO_TEST_PLANET_ENTID JSON to run live')
      return
    }
    const client = setup.client
    const struct = setup.struct

    const isempty = struct.isempty
    const select = struct.select


    // CREATE
    const planet_ref01_ent = client.Planet()
    let planet_ref01_data = setup.data.new.planet['planet_ref01']

    planet_ref01_data = (await planet_ref01_ent.create(planet_ref01_data)).data()
    assert(null != planet_ref01_data.id)


    // LIST
    const planet_ref01_match: any = {}

    const planet_ref01_list = (await planet_ref01_ent.list(planet_ref01_match)).map((e: any) => e.data())

    assert(!isempty(select(planet_ref01_list, { id: planet_ref01_data.id })))


    // UPDATE
    const planet_ref01_data_up0: any = {}
    planet_ref01_data_up0.id = planet_ref01_data.id

    const planet_ref01_markdef_up0 = { name: 'kind', value: 'Mark01-planet_ref01_' + setup.now }
    ;(planet_ref01_data_up0 as any)[planet_ref01_markdef_up0.name] = planet_ref01_markdef_up0.value

    const planet_ref01_resdata_up0 = (await planet_ref01_ent.update(planet_ref01_data_up0)).data()
    assert(planet_ref01_resdata_up0.id === planet_ref01_data_up0.id)

    assert((planet_ref01_resdata_up0 as any)[planet_ref01_markdef_up0.name] === planet_ref01_markdef_up0.value)


    // LOAD
    const planet_ref01_match_dt0: any = {}
    planet_ref01_match_dt0.id = planet_ref01_data.id
    const planet_ref01_data_dt0 = (await planet_ref01_ent.load(planet_ref01_match_dt0)).data()
    assert(planet_ref01_data_dt0.id === planet_ref01_data.id)


    // REMOVE
    const planet_ref01_match_rm0: any = { id: planet_ref01_data.id }
    await planet_ref01_ent.remove(planet_ref01_match_rm0)
  

    // LIST
    const planet_ref01_match_rt0: any = {}

    const planet_ref01_list_rt0 = (await planet_ref01_ent.list(planet_ref01_match_rt0)).map((e: any) => e.data())

    assert(isempty(select(planet_ref01_list_rt0, { id: planet_ref01_data.id })))


  })
})



function basicSetup(extra?: any) {
  // TODO: fix test def options
  const options: any = {} // null

  // TODO: needs test utility to resolve path
  const entityDataFile =
    Path.resolve(__dirname, 
      '../../../../.sdk/test/entity/planet/PlanetTestData.json')

  // TODO: file ready util needed?
  const entityDataSource = Fs.readFileSync(entityDataFile).toString('utf8')

  // TODO: need a xlang JSON parse utility in voxgig/struct with better error msgs
  const entityData = JSON.parse(entityDataSource)

  options.entity = entityData.existing

  let client = SolardemoSDK.test(options, extra)
  const struct = client.utility().struct
  const merge = struct.merge
  const transform = struct.transform

  let idmap = transform(
    ['planet01','planet02','planet03'],
    {
      '`$PACK`': ['', {
        '`$KEY`': '`$COPY`',
        '`$VAL`': ['`$FORMAT`', 'upper', '`$COPY`']
      }]
    })

  // Detect whether the user provided a real ENTID JSON via env var. The
  // basic flow consumes synthetic IDs from the fixture file; without an
  // override those synthetic IDs reach the live API and 4xx. Surface this
  // to the test so it can skip rather than fail.
  const idmapEnvVal = process.env['SOLARDEMO_TEST_PLANET_ENTID']
  const idmapOverridden = null != idmapEnvVal && idmapEnvVal.trim().startsWith('{')

  const env = envOverride({
    'SOLARDEMO_TEST_PLANET_ENTID': idmap,
    'SOLARDEMO_TEST_LIVE': 'FALSE',
    'SOLARDEMO_TEST_EXPLAIN': 'FALSE',
  })

  idmap = env['SOLARDEMO_TEST_PLANET_ENTID']

  const live = 'TRUE' === env.SOLARDEMO_TEST_LIVE

  if (live) {
    client = new SolardemoSDK(merge([
      // FIRST, so the generated fields below win: sdk-test-control.json's
      // test.client.options adds to the live client, it does not redirect it.
      liveClientOptions(),
      {
      },
      // 'extra || {}', not a bare 'extra': struct.merge returns UNDEFINED when the
      // last entry is undefined, and basicSetup is normally called with no
      // argument at all - so a bare 'extra' silently discarded the apikey
      // and server values above and handed the SDK undefined. Harmless
      // while there was nothing in that object; not harmless now.
      extra || {}
    ]))
  }

  const setup = {
    idmap,
    env,
    options,
    client,
    struct,
    data: entityData,
    explain: 'TRUE' === env.SOLARDEMO_TEST_EXPLAIN,
    live,
    syntheticOnly: live && !idmapOverridden,
    now: Date.now(),
  }

  return setup
}
  

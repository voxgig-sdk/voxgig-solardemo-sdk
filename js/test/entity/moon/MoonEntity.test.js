
const envlocal = __dirname + '/../../../.env.local'
require('dotenv').config({ quiet: true, path: [envlocal] })

const Path = require('node:path')
const Fs = require('node:fs')

const { test, describe, afterEach } = require('node:test')
const assert = require('node:assert')


const { SolardemoSDK, BaseFeature, stdutil, config } = require('../../..')

const {
  envOverride,
  liveClientOptions,
  liveDelay,
  makeCtrl,
  makeMatch,
  makeReqdata,
  makeStepData,
  makeValid,
} = require('../../utility')


describe('MoonEntity', async () => {

  // Per-test live pacing. Delay is read from sdk-test-control.json's
  // `test.live.delayMs`; only sleeps when SOLARDEMO_TEST_LIVE=TRUE.
  afterEach(liveDelay('SOLARDEMO_TEST_LIVE'))

  test('instance', async () => {
    const testsdk = SolardemoSDK.test()
    const ent = testsdk.Moon()
    assert(null != ent)
  })


  test('basic', async () => {

    const setup = basicSetup()
    const client = setup.client
    const struct = setup.struct

    const isempty = struct.isempty
    const select = struct.select


    // CREATE
    const moon_ref01_ent = client.Moon()
    let moon_ref01_data = setup.data.new.moon['moon_ref01']
    moon_ref01_data['planet_id'] = setup.idmap['planet01']

    moon_ref01_data = (await moon_ref01_ent.create(moon_ref01_data)).data()
    assert(null != moon_ref01_data.id)


    // LIST
    const moon_ref01_match = {}
    moon_ref01_match['planet_id'] = setup.idmap['planet01']

    const moon_ref01_list = (await moon_ref01_ent.list(moon_ref01_match)).map((e) => e.data())

    assert(!isempty(select(moon_ref01_list, { id: moon_ref01_data.id })))


    // UPDATE
    const moon_ref01_data_up0 = {}
    moon_ref01_data_up0.id = moon_ref01_data.id
    moon_ref01_data_up0 ['planet_id'] = setup.idmap['planet_id']

    const moon_ref01_markdef_up0 = { name: 'kind', value: 'Mark01-moon_ref01_' + setup.now }
    moon_ref01_data_up0 [moon_ref01_markdef_up0.name] = moon_ref01_markdef_up0.value

    const moon_ref01_resdata_up0 = (await moon_ref01_ent.update(moon_ref01_data_up0)).data()
    assert(moon_ref01_resdata_up0.id === moon_ref01_data_up0.id)

    assert(moon_ref01_resdata_up0[moon_ref01_markdef_up0.name] === moon_ref01_markdef_up0.value)


    // LOAD
    const moon_ref01_match_dt0 = {}
    moon_ref01_match_dt0.id = moon_ref01_data.id
    const moon_ref01_data_dt0 = (await moon_ref01_ent.load(moon_ref01_match_dt0)).data()
    assert(moon_ref01_data_dt0.id === moon_ref01_data.id)


    // REMOVE
    const moon_ref01_match_rm0 = {}
    moon_ref01_match_rm0.id = moon_ref01_data.id
    await moon_ref01_ent.remove(moon_ref01_match_rm0)
  

    // LIST
    const moon_ref01_match_rt0 = {}
    moon_ref01_match_rt0['planet_id'] = setup.idmap['planet01']

    const moon_ref01_list_rt0 = (await moon_ref01_ent.list(moon_ref01_match_rt0)).map((e) => e.data())

    assert(isempty(select(moon_ref01_list_rt0, { id: moon_ref01_data.id })))


  })
})



function basicSetup(extra) {
  // TODO: fix test def options
  const options = {} // null

  // TODO: needs test utility to resolve path
  const entityDataFile =
    Path.resolve(__dirname,
      '../../../../.sdk/test/entity/moon/MoonTestData.json')

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
    ['moon01','moon02','moon03','planet01','planet02','planet03'],
    {
      '`$PACK`': ['', {
        '`$KEY`': '`$COPY`',
        '`$VAL`': ['`$FORMAT`', 'upper', '`$COPY`']
      }]
    })

  const env = envOverride({
    'SOLARDEMO_TEST_MOON_ENTID': idmap,
    'SOLARDEMO_TEST_LIVE': 'FALSE',
    'SOLARDEMO_TEST_EXPLAIN': 'FALSE',
  })

  idmap = env['SOLARDEMO_TEST_MOON_ENTID']

  if ('TRUE' === env.SOLARDEMO_TEST_LIVE) {
    client = new SolardemoSDK(merge([
      // FIRST, so the generated fields below win: sdk-test-control.json's
      // test.client.options adds to the live client, it does not redirect it.
      liveClientOptions(),
      {
      },
      // 'extra || {}', not a bare 'extra': struct.merge returns UNDEFINED when
      // the last entry is undefined, and basicSetup is normally called with no
      // argument at all - so a bare 'extra' silently discarded the apikey and
      // server values above and handed the SDK undefined.
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
    now: Date.now(),
  }

  return setup
}
  

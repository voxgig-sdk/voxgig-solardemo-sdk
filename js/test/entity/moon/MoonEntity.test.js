
const envlocal = __dirname + '/../../../.env.local'
require('../../utility').loadEnvLocal(envlocal)

const Path = require('node:path')
const Fs = require('node:fs')

const { test, describe, afterEach } = require('node:test')
const assert = require('node:assert')
const { createLiveTransport } = require('../../live-runner')
const { runLiveEntity } = require('../../live-entity')


const { VoxgigSolardemoSDK, BaseFeature, stdutil, config } = require('../../..')

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
  // `test.live.delayMs`; only sleeps when VOXGIG_SOLARDEMO_TEST_LIVE=TRUE.
  afterEach(liveDelay('VOXGIG_SOLARDEMO_TEST_LIVE'))

  test('instance', async () => {
    const testsdk = VoxgigSolardemoSDK.test()
    const ent = testsdk.Moon()
    assert(null != ent)
  })


  test('basic', async (t) => {

    
    const setup = basicSetup()
    if (setup.live) {
      return runLiveEntity(setup, {"active":true,"alias":{"field":{}},"fields":{"diameter":{"a":true,"fo":"float","h":"Diameter","n":"diameter","r":true,"t":"`$NUMBER`","key$":"diameter","index$":0},"id":{"a":true,"h":"Id","n":"id","r":true,"t":"`$STRING`","key$":"id","index$":1},"kind":{"a":true,"h":"Kind","n":"kind","r":true,"t":"`$STRING`","key$":"kind","index$":2},"name":{"a":true,"h":"Name","n":"name","r":true,"t":"`$STRING`","key$":"name","index$":3},"planet_id":{"a":true,"h":"Planet Id","n":"planet_id","r":true,"t":"`$STRING`","key$":"planet_id","index$":4}},"id":{"field":"id","name":"id"},"name":"moon","op":{"create":{"input":"data","name":"create","points":[{"a":true,"co":{"id":"POST /api/planet/{planet_id}/moon","source":"openapi3","version":2},"g":{"params":[{"a":true,"k":"param","n":"planet_id","or":"planet_id","r":true,"t":"`$STRING`","index$":0}]},"k":"http","m":"POST","o":"/api/planet/{planet_id}/moon","q":{"exist":["planet_id"]},"r":{},"s":[{"lit":"api"},{"lit":"planet"},{"var":"planet_id"},{"lit":"moon"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":0}],"key$":"create"},"list":{"input":"data","name":"list","points":[{"a":true,"co":{"id":"GET /api/planet/{planet_id}/moon","source":"openapi3","version":2},"g":{"params":[{"a":true,"k":"param","n":"planet_id","or":"planet_id","r":true,"t":"`$STRING`","index$":0}]},"k":"http","m":"GET","o":"/api/planet/{planet_id}/moon","q":{"exist":["planet_id"]},"r":{},"s":[{"lit":"api"},{"lit":"planet"},{"var":"planet_id"},{"lit":"moon"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":0}],"key$":"list"},"load":{"input":"data","name":"load","points":[{"a":true,"co":{"id":"GET /api/planet/{planet_id}/moon/{moon_id}","source":"openapi3","version":2},"g":{"params":[{"a":true,"k":"param","n":"id","or":"moon_id","r":true,"t":"`$STRING`","index$":0},{"a":true,"k":"param","n":"planet_id","or":"planet_id","r":true,"t":"`$STRING`","index$":1}]},"k":"http","m":"GET","o":"/api/planet/{planet_id}/moon/{moon_id}","q":{"exist":["id","planet_id"]},"r":{"param":{"moon_id":"id"}},"s":[{"lit":"api"},{"lit":"planet"},{"var":"planet_id"},{"lit":"moon"},{"var":"id"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":0}],"key$":"load"},"remove":{"input":"data","name":"remove","points":[{"a":true,"co":{"id":"DELETE /api/planet/{planet_id}/moon/{moon_id}","source":"openapi3","version":2},"g":{"params":[{"a":true,"k":"param","n":"id","or":"moon_id","r":true,"t":"`$STRING`","index$":0},{"a":true,"k":"param","n":"planet_id","or":"planet_id","r":true,"t":"`$STRING`","index$":1}]},"k":"http","m":"DELETE","o":"/api/planet/{planet_id}/moon/{moon_id}","q":{"exist":["id","planet_id"]},"r":{"param":{"moon_id":"id"}},"s":[{"lit":"api"},{"lit":"planet"},{"var":"planet_id"},{"lit":"moon"},{"var":"id"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":0}],"key$":"remove"},"update":{"input":"data","name":"update","points":[{"a":true,"co":{"id":"PUT /api/planet/{planet_id}/moon/{moon_id}","source":"openapi3","version":2},"g":{"params":[{"a":true,"k":"param","n":"id","or":"moon_id","r":true,"t":"`$STRING`","index$":0},{"a":true,"k":"param","n":"planet_id","or":"planet_id","r":true,"t":"`$STRING`","index$":1}]},"k":"http","m":"PUT","o":"/api/planet/{planet_id}/moon/{moon_id}","q":{"exist":["id","planet_id"]},"r":{"param":{"moon_id":"id"}},"s":[{"lit":"api"},{"lit":"planet"},{"var":"planet_id"},{"lit":"moon"},{"var":"id"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":0}],"key$":"update"}},"relations":{"ancestors":[["$.main.kit.entity.planet"]]},"key$":"moon","name__orig":"moon","Name":"Moon","name_":"moon","name-":"moon","NAME":"MOON","index$":0}, {"active":true,"entity":"moon","key$":"BasicMoonFlow","kind":"basic","name":"BasicMoonFlow","param":{},"step":[{"a":true,"d":{},"i":{"ref":"moon_ref01"},"m":{"planet_id":"planet01"},"o":"create","s":[],"v":[],"index$":0},{"a":true,"d":{},"i":{},"m":{"planet_id":"planet01"},"o":"list","s":[],"v":[{"apply":"ItemExists","def":{"ref":"moon_ref01"}}],"index$":1},{"a":true,"d":{"planet_id":"planet01"},"i":{"ref":"moon_ref01","srcdatavar":"moon_ref01_data","suffix":"_up0","textfield":"kind"},"m":{},"o":"update","s":[{"apply":"TextFieldMark","def":{"mark":"Mark01-moon_ref01"}}],"v":[],"index$":2},{"a":true,"d":{},"i":{"ref":"moon_ref01","srcdatavar":"moon_ref01_data","suffix":"_dt0"},"m":{"id":"moon01","planet_id":"planet01"},"o":"load","s":[],"v":[{"apply":"TextFieldMark","def":{"mark":"Mark01-moon_ref01"}}],"index$":3},{"a":true,"d":{},"i":{"ref":"moon_ref01","suffix":"_rm0"},"m":{"id":"moon01","planet_id":"planet01"},"o":"remove","s":[],"v":[],"index$":4},{"a":true,"d":{},"i":{"suffix":"_rt0"},"m":{"planet_id":"planet01"},"o":"list","s":[],"v":[{"apply":"ItemNotExists","def":{"ref":"moon_ref01"}}],"index$":5}]}, 'Moon', {"POST /api/planet/{planet_id}/moon":{"protocol":"http","requestBody":{"required":true,"content":{"application/json":{"schema":{"type":"object","required":["id","name","planet_id","kind","diameter"],"properties":{"id":{"type":"string","key$":"id"},"name":{"type":"string","key$":"name"},"planet_id":{"type":"string","key$":"planet_id"},"kind":{"type":"string","key$":"kind"},"diameter":{"type":"number","format":"float","key$":"diameter"}},"x-ref":"#/components/schemas/Moon","index$":1}}}},"parameters":[{"name":"planet_id","in":"path","required":true,"schema":{"type":"string"},"index$":0}]},"GET /api/planet/{planet_id}/moon":{"protocol":"http","parameters":[{"name":"planet_id","in":"path","required":true,"schema":{"type":"string"},"index$":0}]},"GET /api/planet/{planet_id}/moon/{moon_id}":{"protocol":"http","parameters":[{"name":"planet_id","in":"path","required":true,"schema":{"type":"string"},"index$":0},{"name":"moon_id","in":"path","required":true,"schema":{"type":"string"},"index$":1}]},"DELETE /api/planet/{planet_id}/moon/{moon_id}":{"protocol":"http","parameters":[{"name":"planet_id","in":"path","required":true,"schema":{"type":"string"},"index$":0},{"name":"moon_id","in":"path","required":true,"schema":{"type":"string"},"index$":1}]},"PUT /api/planet/{planet_id}/moon/{moon_id}":{"protocol":"http","requestBody":{"required":true,"content":{"application/json":{"schema":{"type":"object","required":["id","name","planet_id","kind","diameter"],"properties":{"id":{"type":"string","key$":"id"},"name":{"type":"string","key$":"name"},"planet_id":{"type":"string","key$":"planet_id"},"kind":{"type":"string","key$":"kind"},"diameter":{"type":"number","format":"float","key$":"diameter"}},"x-ref":"#/components/schemas/Moon","index$":1}}}},"parameters":[{"name":"planet_id","in":"path","required":true,"schema":{"type":"string"},"index$":0},{"name":"moon_id","in":"path","required":true,"schema":{"type":"string"},"index$":1}]}})
    }
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

  let client = VoxgigSolardemoSDK.test(options, extra)
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
    'VOXGIG_SOLARDEMO_TEST_MOON_ENTID': idmap,
    'VOXGIG_SOLARDEMO_TEST_LIVE': 'FALSE',
    'VOXGIG_SOLARDEMO_TEST_EXPLAIN': 'FALSE',
  })

  idmap = env['VOXGIG_SOLARDEMO_TEST_MOON_ENTID']

  const live = 'TRUE' === env.VOXGIG_SOLARDEMO_TEST_LIVE
  const transport = createLiveTransport()
  if (live) {
    const rawIds = process.env['VOXGIG_SOLARDEMO_TEST_MOON_ENTID']
    idmap = rawIds && rawIds.trim() ? JSON.parse(rawIds) : {}
    if (!idmap || Array.isArray(idmap) || typeof idmap !== 'object') {
      throw new Error('Live ENTID must be a JSON object')
    }
    client = new VoxgigSolardemoSDK(merge([
      // FIRST, so the generated fields below win: sdk-test-control.json's
      // test.client.options adds to the live client, it does not redirect it.
      liveClientOptions(),
      {
      },
      // 'extra || {}', not a bare 'extra': struct.merge returns UNDEFINED when
      // the last entry is undefined, and basicSetup is normally called with no
      // argument at all - so a bare 'extra' silently discarded the apikey and
      // server values above and handed the SDK undefined.
      extra || {},
      { system: { fetch: transport.fetch } }
    ]))
  }

  const setup = {
    idmap,
    env,
    options,
    client,
    struct,
    data: entityData,
    explain: 'TRUE' === env.VOXGIG_SOLARDEMO_TEST_EXPLAIN,
    live,
    transport,
    now: Date.now(),
  }

  return setup
}
  

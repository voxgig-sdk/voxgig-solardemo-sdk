
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


describe('PlanetEntity', async () => {

  // Per-test live pacing. Delay is read from sdk-test-control.json's
  // `test.live.delayMs`; only sleeps when VOXGIG_SOLARDEMO_TEST_LIVE=TRUE.
  afterEach(liveDelay('VOXGIG_SOLARDEMO_TEST_LIVE'))

  test('instance', async () => {
    const testsdk = VoxgigSolardemoSDK.test()
    const ent = testsdk.Planet()
    assert(null != ent)
  })


  test('basic', async (t) => {

    
    const setup = basicSetup()
    if (setup.live) {
      return runLiveEntity(setup, {"active":true,"alias":{"field":{}},"fields":{"diameter":{"a":true,"fo":"float","h":"Diameter","n":"diameter","r":true,"t":"`$NUMBER`","key$":"diameter","index$":0},"forbidReason":{"a":true,"h":"Forbid Reason","n":"forbidReason","r":false,"ro":true,"sh":"Why the planet is forbidden, carried from the forbid action's `why`.","t":"`$STRING`","key$":"forbidReason","index$":1},"forbidState":{"a":true,"h":"Forbid State","n":"forbidState","r":false,"ro":true,"sh":"Set by the forbid action, and absent until it first runs.","t":"`$STRING`","key$":"forbidState","index$":2},"id":{"a":true,"h":"Id","n":"id","r":true,"t":"`$STRING`","key$":"id","index$":3},"kind":{"a":true,"h":"Kind","n":"kind","r":true,"t":"`$STRING`","key$":"kind","index$":4},"name":{"a":true,"h":"Name","n":"name","r":true,"t":"`$STRING`","key$":"name","index$":5},"terraformState":{"a":true,"h":"Terraform State","n":"terraformState","r":false,"ro":true,"sh":"Set by the terraform action, and absent until it first runs.","t":"`$STRING`","key$":"terraformState","index$":6}},"id":{"field":"id","name":"id"},"name":"planet","op":{"create":{"input":"data","name":"create","points":[{"a":true,"co":{"id":"POST /api/planet/{planet_id}/forbid","source":"openapi3","version":2},"g":{"params":[{"a":true,"k":"param","n":"id","or":"planet_id","r":true,"t":"`$STRING`","index$":0}]},"k":"http","m":"POST","o":"/api/planet/{planet_id}/forbid","q":{"$action":"forbid","exist":["id"]},"r":{"param":{"planet_id":"id"}},"s":[{"lit":"api"},{"lit":"planet"},{"var":"id"},{"lit":"forbid"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":0},{"a":true,"co":{"id":"POST /api/planet/{planet_id}/terraform","source":"openapi3","version":2},"g":{"params":[{"a":true,"k":"param","n":"id","or":"planet_id","r":true,"t":"`$STRING`","index$":0}]},"k":"http","m":"POST","o":"/api/planet/{planet_id}/terraform","q":{"$action":"terraform","exist":["id"]},"r":{"param":{"planet_id":"id"}},"s":[{"lit":"api"},{"lit":"planet"},{"var":"id"},{"lit":"terraform"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":1},{"a":true,"co":{"id":"POST /api/planet","source":"openapi3","version":2},"g":{},"k":"http","m":"POST","o":"/api/planet","q":{},"r":{},"s":[{"lit":"api"},{"lit":"planet"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":2}],"key$":"create"},"list":{"input":"data","name":"list","points":[{"a":true,"co":{"id":"GET /api/planet","source":"openapi3","version":2},"g":{},"k":"http","m":"GET","o":"/api/planet","q":{},"r":{},"s":[{"lit":"api"},{"lit":"planet"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":0}],"key$":"list"},"load":{"input":"data","name":"load","points":[{"a":true,"co":{"id":"GET /api/planet/{planet_id}","source":"openapi3","version":2},"g":{"params":[{"a":true,"k":"param","n":"id","or":"planet_id","r":true,"t":"`$STRING`","index$":0}]},"k":"http","m":"GET","o":"/api/planet/{planet_id}","q":{"exist":["id"]},"r":{"param":{"planet_id":"id"}},"s":[{"lit":"api"},{"lit":"planet"},{"var":"id"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":0}],"key$":"load"},"remove":{"input":"data","name":"remove","points":[{"a":true,"co":{"id":"DELETE /api/planet/{planet_id}","source":"openapi3","version":2},"g":{"params":[{"a":true,"k":"param","n":"id","or":"planet_id","r":true,"t":"`$STRING`","index$":0}]},"k":"http","m":"DELETE","o":"/api/planet/{planet_id}","q":{"exist":["id"]},"r":{"param":{"planet_id":"id"}},"s":[{"lit":"api"},{"lit":"planet"},{"var":"id"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":0}],"key$":"remove"},"update":{"input":"data","name":"update","points":[{"a":true,"co":{"id":"PUT /api/planet/{planet_id}","source":"openapi3","version":2},"g":{"params":[{"a":true,"k":"param","n":"id","or":"planet_id","r":true,"t":"`$STRING`","index$":0}]},"k":"http","m":"PUT","o":"/api/planet/{planet_id}","q":{"exist":["id"]},"r":{"param":{"planet_id":"id"}},"s":[{"lit":"api"},{"lit":"planet"},{"var":"id"}],"t":{"req":"`reqdata`","res":"`body`"},"index$":0}],"key$":"update"}},"relations":{"ancestors":[]},"key$":"planet","name__orig":"planet","Name":"Planet","name_":"planet","name-":"planet","NAME":"PLANET","index$":1}, {"active":true,"entity":"planet","key$":"BasicPlanetFlow","kind":"basic","name":"BasicPlanetFlow","param":{},"step":[{"a":true,"d":{},"i":{"ref":"planet_ref01"},"m":{},"o":"create","s":[],"v":[],"index$":0},{"a":true,"d":{},"i":{},"m":{},"o":"list","s":[],"v":[{"apply":"ItemExists","def":{"ref":"planet_ref01"}}],"index$":1},{"a":true,"d":{},"i":{"ref":"planet_ref01","srcdatavar":"planet_ref01_data","suffix":"_up0","textfield":"kind"},"m":{},"o":"update","s":[{"apply":"TextFieldMark","def":{"mark":"Mark01-planet_ref01"}}],"v":[],"index$":2},{"a":true,"d":{},"i":{"ref":"planet_ref01","srcdatavar":"planet_ref01_data","suffix":"_dt0"},"m":{"id":"planet01"},"o":"load","s":[],"v":[{"apply":"TextFieldMark","def":{"mark":"Mark01-planet_ref01"}}],"index$":3},{"a":true,"d":{},"i":{"ref":"planet_ref01","suffix":"_rm0"},"m":{"id":"planet01"},"o":"remove","s":[],"v":[],"index$":4},{"a":true,"d":{},"i":{"suffix":"_rt0"},"m":{},"o":"list","s":[],"v":[{"apply":"ItemNotExists","def":{"ref":"planet_ref01"}}],"index$":5}]}, 'Planet', {"POST /api/planet/{planet_id}/forbid":{"protocol":"http","requestBody":{"required":true,"content":{"application/json":{"schema":{"type":"object","properties":{"forbid":{"type":"boolean"},"why":{"type":"string"}}}}}},"parameters":[{"name":"planet_id","in":"path","required":true,"schema":{"type":"string"},"index$":0}]},"POST /api/planet/{planet_id}/terraform":{"protocol":"http","requestBody":{"required":true,"content":{"application/json":{"schema":{"type":"object","properties":{"start":{"type":"boolean"},"stop":{"type":"boolean"}}}}}},"parameters":[{"name":"planet_id","in":"path","required":true,"schema":{"type":"string"},"index$":0}]},"POST /api/planet":{"protocol":"http","requestBody":{"required":true,"content":{"application/json":{"schema":{"type":"object","required":["id","name","kind","diameter"],"properties":{"id":{"type":"string","key$":"id"},"name":{"type":"string","key$":"name"},"kind":{"type":"string","key$":"kind"},"diameter":{"type":"number","format":"float","key$":"diameter"},"terraformState":{"type":"string","readOnly":true,"description":"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.","key$":"terraformState"},"forbidState":{"type":"string","readOnly":true,"description":"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.","key$":"forbidState"},"forbidReason":{"type":"string","readOnly":true,"description":"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.","key$":"forbidReason"}},"x-ref":"#/components/schemas/Planet","index$":1}}}},"parameters":[]},"GET /api/planet":{"protocol":"http","parameters":[]},"GET /api/planet/{planet_id}":{"protocol":"http","parameters":[{"name":"planet_id","in":"path","required":true,"schema":{"type":"string"},"index$":0}]},"DELETE /api/planet/{planet_id}":{"protocol":"http","parameters":[{"name":"planet_id","in":"path","required":true,"schema":{"type":"string"},"index$":0}]},"PUT /api/planet/{planet_id}":{"protocol":"http","requestBody":{"required":true,"content":{"application/json":{"schema":{"type":"object","required":["id","name","kind","diameter"],"properties":{"id":{"type":"string","key$":"id"},"name":{"type":"string","key$":"name"},"kind":{"type":"string","key$":"kind"},"diameter":{"type":"number","format":"float","key$":"diameter"},"terraformState":{"type":"string","readOnly":true,"description":"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.","key$":"terraformState"},"forbidState":{"type":"string","readOnly":true,"description":"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.","key$":"forbidState"},"forbidReason":{"type":"string","readOnly":true,"description":"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.","key$":"forbidReason"}},"x-ref":"#/components/schemas/Planet","index$":1}}}},"parameters":[{"name":"planet_id","in":"path","required":true,"schema":{"type":"string"},"index$":0}]}})
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
    const planet_ref01_match = {}

    const planet_ref01_list = (await planet_ref01_ent.list(planet_ref01_match)).map((e) => e.data())

    assert(!isempty(select(planet_ref01_list, { id: planet_ref01_data.id })))


    // UPDATE
    const planet_ref01_data_up0 = {}
    planet_ref01_data_up0.id = planet_ref01_data.id

    const planet_ref01_markdef_up0 = { name: 'kind', value: 'Mark01-planet_ref01_' + setup.now }
    planet_ref01_data_up0 [planet_ref01_markdef_up0.name] = planet_ref01_markdef_up0.value

    const planet_ref01_resdata_up0 = (await planet_ref01_ent.update(planet_ref01_data_up0)).data()
    assert(planet_ref01_resdata_up0.id === planet_ref01_data_up0.id)

    assert(planet_ref01_resdata_up0[planet_ref01_markdef_up0.name] === planet_ref01_markdef_up0.value)


    // LOAD
    const planet_ref01_match_dt0 = {}
    planet_ref01_match_dt0.id = planet_ref01_data.id
    const planet_ref01_data_dt0 = (await planet_ref01_ent.load(planet_ref01_match_dt0)).data()
    assert(planet_ref01_data_dt0.id === planet_ref01_data.id)


    // REMOVE
    const planet_ref01_match_rm0 = {}
    planet_ref01_match_rm0.id = planet_ref01_data.id
    await planet_ref01_ent.remove(planet_ref01_match_rm0)
  

    // LIST
    const planet_ref01_match_rt0 = {}

    const planet_ref01_list_rt0 = (await planet_ref01_ent.list(planet_ref01_match_rt0)).map((e) => e.data())

    assert(isempty(select(planet_ref01_list_rt0, { id: planet_ref01_data.id })))


  })
})



function basicSetup(extra) {
  // TODO: fix test def options
  const options = {} // null

  // TODO: needs test utility to resolve path
  const entityDataFile =
    Path.resolve(__dirname,
      '../../../../.sdk/test/entity/planet/PlanetTestData.json')

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
    ['planet01','planet02','planet03'],
    {
      '`$PACK`': ['', {
        '`$KEY`': '`$COPY`',
        '`$VAL`': ['`$FORMAT`', 'upper', '`$COPY`']
      }]
    })

  const env = envOverride({
    'VOXGIG_SOLARDEMO_TEST_PLANET_ENTID': idmap,
    'VOXGIG_SOLARDEMO_TEST_LIVE': 'FALSE',
    'VOXGIG_SOLARDEMO_TEST_EXPLAIN': 'FALSE',
  })

  idmap = env['VOXGIG_SOLARDEMO_TEST_PLANET_ENTID']

  const live = 'TRUE' === env.VOXGIG_SOLARDEMO_TEST_LIVE
  const transport = createLiveTransport()
  if (live) {
    const rawIds = process.env['VOXGIG_SOLARDEMO_TEST_PLANET_ENTID']
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
  

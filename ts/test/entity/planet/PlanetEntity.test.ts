
const envlocal = __dirname + '/../../../.env.local'
require('dotenv').config({ quiet: true, path: [envlocal] })

import Path from 'node:path'
import * as Fs from 'node:fs'

import { test, describe } from 'node:test'
import assert from 'node:assert'


import { SolardemoSDK, BaseFeature, stdutil } from '../../..'

import {
  envOverride,
  makeCtrl,
  makeMatch,
  makeReqdata,
  makeStepData,
  makeValid,
} from '../../utility'


describe('PlanetEntity', async () => {

  test('instance', async () => {
    const testsdk = SolardemoSDK.test()
    const ent = testsdk.Planet()
    assert(null != ent)
  })


  test('basic', async () => {

    const setup = basicSetup()
    const client = setup.client
    const struct = setup.struct

    const isempty = struct.isempty
    const select = struct.select

    console.log('SETUP')
    console.dir(setup.data, { depth: null })

    // CREATE
    const d01 = setup.data.new.planet['planet_ref01']
    console.log('d01', d01)

    const planet_ref01_ent = client.Planet()
    const planet_ref01_data =
      await planet_ref01_ent.create(d01)
    assert(null != planet_ref01_data.id)


    // LIST
    const planet_ref01_match: any = {}

    const planet_ref01_list = await planet_ref01_ent.list(planet_ref01_match)
    console.log('l01', planet_ref01_list)

    assert(!isempty(select(planet_ref01_list, { id: planet_ref01_data.id })))


    // UPDATE
    const planet_ref01_data_up0: any = {}
    planet_ref01_data_up0.id = planet_ref01_data.id

    const planet_ref01_markdef_up0 = { name: 'kind', value: 'Mark01-planet_ref01_' + setup.now }
    planet_ref01_data_up0[planet_ref01_markdef_up0.name] = planet_ref01_markdef_up0.value

    console.log('UP-A', planet_ref01_data_up0)
    const planet_ref01_resdata_up0 = await planet_ref01_ent.update(planet_ref01_data_up0)
    assert(planet_ref01_resdata_up0.id === planet_ref01_data_up0.id)

    assert(planet_ref01_resdata_up0[planet_ref01_markdef_up0.name] === planet_ref01_markdef_up0.value)


    // LOAD
    const planet_ref01_match_dt0: any = {}
    planet_ref01_match_dt0.id = planet_ref01_data.id
    const planet_ref01_data_dt0 = await planet_ref01_ent.load(planet_ref01_match_dt0)
    assert(planet_ref01_data_dt0.id === planet_ref01_data.id)

    // REMOVE
    const planet_ref01_match_rm0: any = {}
    planet_ref01_match_rm0.id = planet_ref01_data.id
    await planet_ref01_ent.remove(planet_ref01_match_rm0)


    // LIST
    const planet_ref01_match_rt0: any = {}

    const planet_ref01_list_rt0 = await planet_ref01_ent.list(planet_ref01_match_rt0)

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
    ['${entity.name}01', '${entity.name}02', '${entity.name}03'],
    {
      '`$PACK`': ['', {
        '`$KEY`': '`$COPY`',
        '`$VAL`': ['`$FORMAT`', 'upper', '`$COPY`']
      }]
    })

  const env = envOverride({
    'SOLARDEMO_TEST_PLANET_ENTID': idmap,
    'SOLARDEMO_TEST_LIVE': 'FALSE',
    'SOLARDEMO_TEST_EXPLAIN': 'FALSE',
    'SOLARDEMO_APIKEY': 'NONE',
  })

  idmap = env['SOLARDEMO_TEST_PLANET_ENTID']

  if ('TRUE' === env.SOLARDEMO_TEST_LIVE) {
    client = new SolardemoSDK(merge([
      {
        apikey: env.SOLARDEMO_APIKEY,
      },
      extra
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


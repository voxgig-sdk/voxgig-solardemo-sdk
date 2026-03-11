
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


describe('MoonEntity', async () => {

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

    moon_ref01_data = await moon_ref01_ent.create(moon_ref01_data)
    assert(null != moon_ref01_data.id)


    // LIST
    const moon_ref01_match: any = {}
    moon_ref01_match['planet_id'] = setup.idmap['planet01']

    const moon_ref01_list = await moon_ref01_ent.list(moon_ref01_match)

    assert(!isempty(select(moon_ref01_list, { id: moon_ref01_data.id })))


    // UPDATE
    const moon_ref01_data_up0: any = {}
    moon_ref01_data_up0.id = moon_ref01_data.id
    moon_ref01_data_up0 ['planet_id'] = setup.idmap['planet_id']

    const moon_ref01_markdef_up0 = { name: 'kind', value: 'Mark01-moon_ref01_' + setup.now }
    moon_ref01_data_up0 [moon_ref01_markdef_up0.name] = moon_ref01_markdef_up0.value

    const moon_ref01_resdata_up0 = await moon_ref01_ent.update(moon_ref01_data_up0)
    assert(moon_ref01_resdata_up0.id === moon_ref01_data_up0.id)

    assert(moon_ref01_resdata_up0[moon_ref01_markdef_up0.name] === moon_ref01_markdef_up0.value)


    // LOAD
    const moon_ref01_match_dt0: any = {}
    moon_ref01_match_dt0.id = moon_ref01_data.id
    const moon_ref01_data_dt0 = await moon_ref01_ent.load(moon_ref01_match_dt0)
    assert(moon_ref01_data_dt0.id === moon_ref01_data.id)


    // REMOVE
    const moon_ref01_match_rm0: any = {}
    moon_ref01_match_rm0.id = moon_ref01_data.id
    await moon_ref01_ent.remove(moon_ref01_match_rm0)
  

    // LIST
    const moon_ref01_match_rt0: any = {}
    moon_ref01_match_rt0['planet_id'] = setup.idmap['planet01']

    const moon_ref01_list_rt0 = await moon_ref01_ent.list(moon_ref01_match_rt0)

    assert(isempty(select(moon_ref01_list_rt0, { id: moon_ref01_data.id })))


  })
})



function basicSetup(extra?: any) {
  // TODO: fix test def options
  const options: any = {} // null

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
    ['${entity.name}01','${entity.name}02','${entity.name}03','planet01','planet02','planet03'],
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
    'SOLARDEMO_APIKEY': 'NONE',
  })

  idmap = env['SOLARDEMO_TEST_MOON_ENTID']

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
  

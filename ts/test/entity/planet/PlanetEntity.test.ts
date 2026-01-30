
const envlocal = __dirname + '/../../../.env.local'
require('dotenv').config({ quiet: true, path: [envlocal] })

import Path from 'node:path'
import * as Fs from 'node:fs'

import { test, describe } from 'node:test'
import assert from 'node:assert'


import { SolardemoSDK, BaseFeature, utility } from '../../..'

import {
  makeStepData,
  makeMatch,
  makeReqdata,
  makeValid,
  makeCtrl,
  envOverride,
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


    // CREATE
    const planet_ref01_ent = client.Planet()
    const planet_ref01_data = 
      await planet_ref01_ent.create(setup.data.new.planet['planet_ref01'])
    assert(null != planet_ref01_data.id)


    // LIST
    const planet_ref01_match = {}
    const planet_ref01_list = await planet_ref01_ent.list(planet_ref01_match)

    assert(null != planet_ref01_list.find((entdata: any) =>
      entdata.data().id == planet_ref01_data.id))


    // UPDATE
    const planet_ref01_data_up0: any = {}
    planet_ref01_data_up0.id = planet_ref01_data.id

    const planet_ref01_markdef_up0 = { name: 'kind', value: 'Mark01-planet_ref01_'+setup.now }
    planet_ref01_data_up0[planet_ref01_markdef_up0.name] = planet_ref01_markdef_up0.value

    const planet_ref01_resdata_up0 = await planet_ref01_ent.update(planet_ref01_data_up0)
    assert.equal(planet_ref01_resdata_up0.id, planet_ref01_data_up0.id)

    assert.equal(planet_ref01_resdata_up0[planet_ref01_markdef_up0.name], planet_ref01_markdef_up0.value)


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
    const planet_ref01_match_rt0 = {}
    const planet_ref01_list_rt0 = await planet_ref01_ent.list(planet_ref01_match_rt0)

    assert(null == planet_ref01_list_rt0.find((entdata: any) =>
      entdata.data().id == planet_ref01_data.id))


  })
})



function basicSetup(extra?: any) {
  extra = extra || {}

  const options: any = {} // null

  const entityDataFile =
    Path.resolve(__dirname, 
      '../../../../.sdk/test/entity/planet/PlanetTestData.json')

  const entityDataSource =
    Fs.readFileSync(entityDataFile).toString('utf8')

  // TODO: need a xlang JSON parse utility in voxgig/struct with better error msgs
  const entityData = JSON.parse(entityDataSource)

  options.entity = entityData.existing

  const setup: any = {
    dm: {
      // p: envOverride($ {jsonify(basicflow.param, { offset: 2 + indent })}),
      p: {},
      s: {},
    },
    options,
  }

  const { merge } = utility.struct

  let client = SolardemoSDK.test(options, extra)
  // if ('TRUE' === setup.dm.p.SOLARDEMO_TEST_LIVE) {
  //   client = new SolardemoSDK(merge([
  //     {
  //       apikey: process.env.SOLARDEMO_APIKEY,
  //     },
  //     extra])
  //   )
  // }

  setup.data = entityData  
  setup.client = client    
  setup.struct = client.utility().struct
  setup.explain = 'TRUE' === setup.dm.p.SOLARDEMO_TEST_EXPLAIN
  setup.now = Date.now()

  return setup
}


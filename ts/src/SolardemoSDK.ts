// Solardemo Ts SDK

import { TestFeature } from './feature/test/TestFeature'

import { MoonEntity } from './entity/MoonEntity'
import { PlanetEntity } from './entity/PlanetEntity'


import { inspect } from 'node:util'

import type { Context, Feature } from './types'

import { Config } from './Config'
import { Utility } from './utility/Utility'


import { BaseFeature } from './feature/base/BaseFeature'

const utility = new Utility()


class SolardemoSDK {
  _mode: string = 'live'
  _options: any
  _utility = utility
  _features: Feature[]
  _rootctx: Context

  constructor(options?: any) {

    this._rootctx = this._utility.makeContext({
      client: this,
      utility: this._utility,
      config: Config,
      options,
      shared: new WeakMap()
    })

    this._options = this._utility.options(this._rootctx)

    const getpath = this._utility.struct.getpath

    if (true === getpath(this._options.feature, 'test.active')) {
      this._mode = 'test'
    }

    this._rootctx.options = this._options

    this._features = []

    const addfeature = this._utility.addfeature
    const initfeature = this._utility.initfeature

    addfeature(this._rootctx, new TestFeature())

    if (null != this._options.extend) {
      for (let f of this._options.extend) {
        addfeature(this._rootctx, f)
      }
    }

    for (let f of this._features) {
      initfeature(this._rootctx, f)
    }

    const featureHook = this._utility.featureHook
    featureHook(this._rootctx, 'PostConstruct')
  }


  options() {
    return { ...this._options }
  }


  utility() {
    return { ...this._utility }
  }



  Moon(data?: any) {
    const self = this
    return new MoonEntity(self,data)
  }


  Planet(data?: any) {
    const self = this
    return new PlanetEntity(self,data)
  }




  static test(testopts?: any, sdkopts?: any) {
    sdkopts = sdkopts || {}
    sdkopts.feature = sdkopts.feature || {}
    sdkopts.feature.test = testopts || {}
    sdkopts.feature.test.active = true

    const testsdk = new SolardemoSDK(sdkopts)
    testsdk._mode = 'test'

    return testsdk
  }


  tester(testopts?: any, sdkopts?: any) {
    return SolardemoSDK.test(testopts, sdkopts)
  }


  toJSON() {
    return { name: 'Solardemo' }
  }

  toString() {
    return 'Solardemo ' + this._utility.struct.jsonify(this.toJSON())
  }

  [inspect.custom]() {
    return this.toString()
  }

}


class SolardemoEntity {

}



const SDK = SolardemoSDK

export {
  utility,

  BaseFeature,
  SolardemoEntity,

  SolardemoSDK,
  SDK,
}



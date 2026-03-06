
import { SolardemoSDK } from './SolardemoSDK'

import { Alt } from './Alt'
import { Context } from './Context'
import { Control } from './Control'
import { Operation } from './Operation'
import { Response } from './Response'
import { Result } from './Result'
import { Spec } from './Spec'


type FeatureOptions = Record<string, any> | {
  active: boolean
}


interface Feature {
  version: string
  name: string
  active: boolean

  init: (ctx: Context, options: FeatureOptions) => void | Promise<any>

  PostConstruct: (this: SolardemoSDK, ctx: Context) => void | Promise<any>
  PostConstructEntity: (this: SolardemoSDK, ctx: Context) => void | Promise<any>
  SetData: (this: SolardemoSDK, ctx: Context) => void | Promise<any>
  GetData: (this: SolardemoSDK, ctx: Context) => void | Promise<any>
  GetMatch: (this: SolardemoSDK, ctx: Context) => void | Promise<any>

  PreOperation: (this: SolardemoSDK, ctx: Context) => void | Promise<any>
  PreSpec: (this: SolardemoSDK, ctx: Context) => void | Promise<any>
  PreRequest: (this: SolardemoSDK, ctx: Context) => void | Promise<any>
  PreResponse: (this: SolardemoSDK, ctx: Context) => void | Promise<any>
  PreResult: (this: SolardemoSDK, ctx: Context) => void | Promise<any>
  PostOperation: (this: SolardemoSDK, ctx: Context) => void | Promise<any>
}


export {
  Alt,
  Context,
  Control,
  Operation,
  Response,
  Result,
  Spec,
}


export type {
  Feature,
  FeatureOptions,
}

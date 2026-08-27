# Solardemo SDK utility registration
require_relative '../core/utility_type'
require_relative 'clean'
require_relative 'done'
require_relative 'make_error'
require_relative 'feature_add'
require_relative 'feature_hook'
require_relative 'feature_init'
require_relative 'fetcher'
require_relative 'make_fetch_def'
require_relative 'make_context'
require_relative 'make_options'
require_relative 'make_request'
require_relative 'make_response'
require_relative 'make_result'
require_relative 'make_point'
require_relative 'make_spec'
require_relative 'make_url'
require_relative 'param'
require_relative 'prepare_auth'
require_relative 'prepare_body'
require_relative 'prepare_headers'
require_relative 'prepare_method'
require_relative 'prepare_params'
require_relative 'prepare_path'
require_relative 'prepare_query'
require_relative 'graphql'
require_relative 'result_basic'
require_relative 'result_body'
require_relative 'result_headers'
require_relative 'transform_request'
require_relative 'transform_response'

SolardemoUtility.registrar = ->(u) {
  u.clean = SolardemoUtilities::Clean
  u.done = SolardemoUtilities::Done
  u.make_error = SolardemoUtilities::MakeError
  u.feature_add = SolardemoUtilities::FeatureAdd
  u.feature_hook = SolardemoUtilities::FeatureHook
  u.feature_init = SolardemoUtilities::FeatureInit
  u.fetcher = SolardemoUtilities::Fetcher
  u.make_fetch_def = SolardemoUtilities::MakeFetchDef
  u.make_context = SolardemoUtilities::MakeContext
  u.make_options = SolardemoUtilities::MakeOptions
  u.make_request = SolardemoUtilities::MakeRequest
  u.make_response = SolardemoUtilities::MakeResponse
  u.make_result = SolardemoUtilities::MakeResult
  u.make_point = SolardemoUtilities::MakePoint
  u.make_spec = SolardemoUtilities::MakeSpec
  u.make_url = SolardemoUtilities::MakeUrl
  u.param = SolardemoUtilities::Param
  u.prepare_auth = SolardemoUtilities::PrepareAuth
  u.prepare_body = SolardemoUtilities::PrepareBody
  u.prepare_headers = SolardemoUtilities::PrepareHeaders
  u.prepare_method = SolardemoUtilities::PrepareMethod
  u.prepare_params = SolardemoUtilities::PrepareParams
  u.prepare_path = SolardemoUtilities::PreparePath
  u.prepare_query = SolardemoUtilities::PrepareQuery
  u.graphql_body = SolardemoUtilities::GraphqlBody
  u.graphql_errors = SolardemoUtilities::GraphqlErrors
  u.result_basic = SolardemoUtilities::ResultBasic
  u.result_body = SolardemoUtilities::ResultBody
  u.result_headers = SolardemoUtilities::ResultHeaders
  u.transform_request = SolardemoUtilities::TransformRequest
  u.transform_response = SolardemoUtilities::TransformResponse
}

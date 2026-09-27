# VoxgigSolardemo SDK utility registration
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

VoxgigSolardemoUtility.registrar = ->(u) {
  u.clean = VoxgigSolardemoUtilities::Clean
  u.done = VoxgigSolardemoUtilities::Done
  u.make_error = VoxgigSolardemoUtilities::MakeError
  u.feature_add = VoxgigSolardemoUtilities::FeatureAdd
  u.feature_hook = VoxgigSolardemoUtilities::FeatureHook
  u.feature_init = VoxgigSolardemoUtilities::FeatureInit
  u.fetcher = VoxgigSolardemoUtilities::Fetcher
  u.make_fetch_def = VoxgigSolardemoUtilities::MakeFetchDef
  u.make_context = VoxgigSolardemoUtilities::MakeContext
  u.make_options = VoxgigSolardemoUtilities::MakeOptions
  u.make_request = VoxgigSolardemoUtilities::MakeRequest
  u.make_response = VoxgigSolardemoUtilities::MakeResponse
  u.make_result = VoxgigSolardemoUtilities::MakeResult
  u.make_point = VoxgigSolardemoUtilities::MakePoint
  u.make_spec = VoxgigSolardemoUtilities::MakeSpec
  u.make_url = VoxgigSolardemoUtilities::MakeUrl
  u.param = VoxgigSolardemoUtilities::Param
  u.prepare_auth = VoxgigSolardemoUtilities::PrepareAuth
  u.prepare_body = VoxgigSolardemoUtilities::PrepareBody
  u.prepare_headers = VoxgigSolardemoUtilities::PrepareHeaders
  u.prepare_method = VoxgigSolardemoUtilities::PrepareMethod
  u.prepare_params = VoxgigSolardemoUtilities::PrepareParams
  u.prepare_path = VoxgigSolardemoUtilities::PreparePath
  u.prepare_query = VoxgigSolardemoUtilities::PrepareQuery
  u.graphql_body = VoxgigSolardemoUtilities::GraphqlBody
  u.graphql_errors = VoxgigSolardemoUtilities::GraphqlErrors
  u.result_basic = VoxgigSolardemoUtilities::ResultBasic
  u.result_body = VoxgigSolardemoUtilities::ResultBody
  u.result_headers = VoxgigSolardemoUtilities::ResultHeaders
  u.transform_request = VoxgigSolardemoUtilities::TransformRequest
  u.transform_response = VoxgigSolardemoUtilities::TransformResponse
}

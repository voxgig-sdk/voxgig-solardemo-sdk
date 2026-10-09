# VoxgigSolardemo SDK utility: prepare_body
require_relative 'media'
module VoxgigSolardemoUtilities
  PrepareBody = ->(ctx) {
    return nil unless ctx.op.input == "data"
    return VoxgigSolardemoUtilities.raw_body(ctx.reqdata) if VoxgigSolardemoUtilities.raw_request?(ctx.point)
    ctx.utility.transform_request.call(ctx)
  }
end

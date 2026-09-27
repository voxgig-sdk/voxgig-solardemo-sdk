# VoxgigSolardemo SDK utility: make_context
require_relative '../core/context'
module VoxgigSolardemoUtilities
  MakeContext = ->(ctxmap, basectx) {
    VoxgigSolardemoContext.new(ctxmap, basectx)
  }
end

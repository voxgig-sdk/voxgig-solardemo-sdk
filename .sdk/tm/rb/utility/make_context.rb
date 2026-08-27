# Solardemo SDK utility: make_context
require_relative '../core/context'
module SolardemoUtilities
  MakeContext = ->(ctxmap, basectx) {
    SolardemoContext.new(ctxmap, basectx)
  }
end

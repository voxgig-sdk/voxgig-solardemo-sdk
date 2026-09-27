# VoxgigSolardemo SDK utility: make_context

from projectname_sdk.core.context import VoxgigSolardemoContext


def make_context_util(ctxmap, basectx):
    return VoxgigSolardemoContext(ctxmap, basectx)

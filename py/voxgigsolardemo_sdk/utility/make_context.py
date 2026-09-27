# VoxgigSolardemo SDK utility: make_context

from voxgigsolardemo_sdk.core.context import VoxgigSolardemoContext


def make_context_util(ctxmap, basectx):
    return VoxgigSolardemoContext(ctxmap, basectx)

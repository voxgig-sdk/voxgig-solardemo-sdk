# Solardemo SDK utility: make_context

from solardemo_sdk.core.context import SolardemoContext


def make_context_util(ctxmap, basectx):
    return SolardemoContext(ctxmap, basectx)

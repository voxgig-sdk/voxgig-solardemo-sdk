# VoxgigSolardemo SDK feature factory

from voxgigsolardemo_sdk.feature.base_feature import VoxgigSolardemoBaseFeature
from voxgigsolardemo_sdk.feature.debug_feature import VoxgigSolardemoDebugFeature
from voxgigsolardemo_sdk.feature.idempotency_feature import VoxgigSolardemoIdempotencyFeature
from voxgigsolardemo_sdk.feature.metrics_feature import VoxgigSolardemoMetricsFeature
from voxgigsolardemo_sdk.feature.paging_feature import VoxgigSolardemoPagingFeature
from voxgigsolardemo_sdk.feature.ratelimit_feature import VoxgigSolardemoRatelimitFeature
from voxgigsolardemo_sdk.feature.retry_feature import VoxgigSolardemoRetryFeature
from voxgigsolardemo_sdk.feature.secrets_feature import VoxgigSolardemoSecretsFeature
from voxgigsolardemo_sdk.feature.test_feature import VoxgigSolardemoTestFeature
from voxgigsolardemo_sdk.feature.timeout_feature import VoxgigSolardemoTimeoutFeature


_FEATURES = {
    "base": lambda: VoxgigSolardemoBaseFeature(),
    "debug": lambda: VoxgigSolardemoDebugFeature(),
    "idempotency": lambda: VoxgigSolardemoIdempotencyFeature(),
    "metrics": lambda: VoxgigSolardemoMetricsFeature(),
    "paging": lambda: VoxgigSolardemoPagingFeature(),
    "ratelimit": lambda: VoxgigSolardemoRatelimitFeature(),
    "retry": lambda: VoxgigSolardemoRetryFeature(),
    "secrets": lambda: VoxgigSolardemoSecretsFeature(),
    "test": lambda: VoxgigSolardemoTestFeature(),
    "timeout": lambda: VoxgigSolardemoTimeoutFeature(),
}


def _make_feature(name):
    factory = _FEATURES.get(name)
    if factory is not None:
        return factory()
    return _FEATURES["base"]()


# True when this SDK was generated with the named feature class - the
# constructor's tolerance for extend-carried features reads this (an
# active name with no generated class must not become a BaseFeature
# stray when an extend instance carries it).
def _has_feature(name):
    return name in _FEATURES

<?php
declare(strict_types=1);

// VoxgigSolardemo SDK feature factory

require_once __DIR__ . '/feature/BaseFeature.php';
require_once __DIR__ . '/feature/DebugFeature.php';
require_once __DIR__ . '/feature/IdempotencyFeature.php';
require_once __DIR__ . '/feature/MetricsFeature.php';
require_once __DIR__ . '/feature/PagingFeature.php';
require_once __DIR__ . '/feature/RatelimitFeature.php';
require_once __DIR__ . '/feature/RetryFeature.php';
require_once __DIR__ . '/feature/SecretsFeature.php';
require_once __DIR__ . '/feature/TestFeature.php';
require_once __DIR__ . '/feature/TimeoutFeature.php';


class VoxgigSolardemoFeatures
{
    public static function make_feature(string $name)
    {
        switch ($name) {
            case "base":
                return new VoxgigSolardemoBaseFeature();
            case "debug":
                return new VoxgigSolardemoDebugFeature();
            case "idempotency":
                return new VoxgigSolardemoIdempotencyFeature();
            case "metrics":
                return new VoxgigSolardemoMetricsFeature();
            case "paging":
                return new VoxgigSolardemoPagingFeature();
            case "ratelimit":
                return new VoxgigSolardemoRatelimitFeature();
            case "retry":
                return new VoxgigSolardemoRetryFeature();
            case "secrets":
                return new VoxgigSolardemoSecretsFeature();
            case "test":
                return new VoxgigSolardemoTestFeature();
            case "timeout":
                return new VoxgigSolardemoTimeoutFeature();
            default:
                return new VoxgigSolardemoBaseFeature();
        }
    }

    /**
     * Does a generated feature class back this name? False for a name only
     * an options extend instance can supply (the station adopt path) - the
     * constructor uses this to skip make_feature for such names instead of
     * adding a stray BaseFeature.
     */
    public static function has_feature(string $name): bool
    {
        switch ($name) {
            case "base":
            case "debug":
            case "idempotency":
            case "metrics":
            case "paging":
            case "ratelimit":
            case "retry":
            case "secrets":
            case "test":
            case "timeout":
                return true;
            default:
                return false;
        }
    }
}

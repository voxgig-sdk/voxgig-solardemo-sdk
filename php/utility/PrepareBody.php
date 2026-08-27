<?php
declare(strict_types=1);

// Solardemo SDK utility: prepare_body

class SolardemoPrepareBody
{
    public static function call(SolardemoContext $ctx): mixed
    {
        if ($ctx->op->input === 'data') {
            return ($ctx->utility->transform_request)($ctx);
        }
        return null;
    }
}

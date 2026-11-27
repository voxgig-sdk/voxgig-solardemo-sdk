<?php
declare(strict_types=1);

// VoxgigSolardemo SDK utility: prepare_auth

// This SDK is configured with authentication off, so there is no
// credential to place. The class stays in the pipeline because make_spec
// calls prepare_auth unconditionally.
class VoxgigSolardemoPrepareAuth
{
    public static function call(VoxgigSolardemoContext $ctx): array
    {
        $spec = $ctx->spec;
        if (!$spec) {
            return [null, $ctx->make_error('auth_no_spec', 'Expected context spec property to be defined.')];
        }

        return [$spec, null];
    }
}

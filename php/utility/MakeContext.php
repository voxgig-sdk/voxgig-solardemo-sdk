<?php
declare(strict_types=1);

// Solardemo SDK utility: make_context

require_once __DIR__ . '/../core/Context.php';

class SolardemoMakeContext
{
    public static function call(array $ctxmap, ?SolardemoContext $basectx): SolardemoContext
    {
        return new SolardemoContext($ctxmap, $basectx);
    }
}

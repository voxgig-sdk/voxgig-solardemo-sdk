<?php
declare(strict_types=1);

// VoxgigSolardemo SDK utility: make_context

require_once __DIR__ . '/../core/Context.php';

class VoxgigSolardemoMakeContext
{
    public static function call(array $ctxmap, ?VoxgigSolardemoContext $basectx): VoxgigSolardemoContext
    {
        return new VoxgigSolardemoContext($ctxmap, $basectx);
    }
}

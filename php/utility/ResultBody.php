<?php
declare(strict_types=1);

// VoxgigSolardemo SDK utility: result_body

class VoxgigSolardemoResultBody
{
    public static function call(VoxgigSolardemoContext $ctx): ?VoxgigSolardemoResult
    {
        $response = $ctx->response;
        $result = $ctx->result;
        if ($result && $response && $response->json_func && $response->body) {
            $result->body = ($response->json_func)();
        }
        return $result;
    }
}

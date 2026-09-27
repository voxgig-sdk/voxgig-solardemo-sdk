<?php
declare(strict_types=1);

// VoxgigSolardemo SDK utility: result_headers

class VoxgigSolardemoResultHeaders
{
    public static function call(VoxgigSolardemoContext $ctx): ?VoxgigSolardemoResult
    {
        $response = $ctx->response;
        $result = $ctx->result;
        if ($result) {
            if ($response && is_array($response->headers)) {
                $result->headers = $response->headers;
            } else {
                $result->headers = [];
            }
        }
        return $result;
    }
}

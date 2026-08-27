<?php
declare(strict_types=1);

// Solardemo SDK utility: result_headers

class SolardemoResultHeaders
{
    public static function call(SolardemoContext $ctx): ?SolardemoResult
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

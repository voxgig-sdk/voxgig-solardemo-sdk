<?php
declare(strict_types=1);

// Solardemo SDK utility: result_body

class SolardemoResultBody
{
    public static function call(SolardemoContext $ctx): ?SolardemoResult
    {
        $response = $ctx->response;
        $result = $ctx->result;
        if ($result && $response && $response->json_func && $response->body) {
            $result->body = ($response->json_func)();
        }
        return $result;
    }
}

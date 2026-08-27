<?php
declare(strict_types=1);

// Solardemo SDK exists test

require_once __DIR__ . '/../solardemo_sdk.php';

use PHPUnit\Framework\TestCase;

class ExistsTest extends TestCase
{
    public function test_create_test_sdk(): void
    {
        $testsdk = SolardemoSDK::test(null, null);
        $this->assertNotNull($testsdk);
    }
}

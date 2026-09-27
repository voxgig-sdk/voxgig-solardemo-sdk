<?php
declare(strict_types=1);

// VoxgigSolardemo SDK exists test

require_once __DIR__ . '/../voxgigsolardemo_sdk.php';

use PHPUnit\Framework\TestCase;

class ExistsTest extends TestCase
{
    public function test_create_test_sdk(): void
    {
        $testsdk = VoxgigSolardemoSDK::test(null, null);
        $this->assertNotNull($testsdk);
    }
}

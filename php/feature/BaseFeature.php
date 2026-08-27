<?php
declare(strict_types=1);

// Solardemo SDK base feature

class SolardemoBaseFeature
{
    public string $version;
    public string $name;
    public bool $active;

    // Positions this feature when added via the client `extend` option:
    // "__before__" / "__after__" / "__replace__" name an already-added
    // feature (mirrors the ts feature `_options`). Declared so setting it
    // on an extension instance avoids the dynamic-property deprecation.
    public ?array $_options = null;

    public function __construct()
    {
        $this->version = '0.0.1';
        $this->name = 'base';
        $this->active = true;
    }

    public function get_version(): string { return $this->version; }
    public function get_name(): string { return $this->name; }
    public function get_active(): bool { return $this->active; }

    public function init(SolardemoContext $ctx, array $options): void {}
    public function PostConstruct(SolardemoContext $ctx): void {}
    public function PostConstructEntity(SolardemoContext $ctx): void {}
    public function SetData(SolardemoContext $ctx): void {}
    public function GetData(SolardemoContext $ctx): void {}
    public function GetMatch(SolardemoContext $ctx): void {}
    public function SetMatch(SolardemoContext $ctx): void {}
    public function PrePoint(SolardemoContext $ctx): void {}
    public function PreSpec(SolardemoContext $ctx): void {}
    public function PreRequest(SolardemoContext $ctx): void {}
    public function PreResponse(SolardemoContext $ctx): void {}
    public function PreResult(SolardemoContext $ctx): void {}
    public function PreDone(SolardemoContext $ctx): void {}
    public function PreUnexpected(SolardemoContext $ctx): void {}
}

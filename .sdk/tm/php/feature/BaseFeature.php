<?php
declare(strict_types=1);

// VoxgigSolardemo SDK base feature

class VoxgigSolardemoBaseFeature
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

    public function init(VoxgigSolardemoContext $ctx, array $options): void {}
    public function PostConstruct(VoxgigSolardemoContext $ctx): void {}
    public function PostConstructEntity(VoxgigSolardemoContext $ctx): void {}
    public function SetData(VoxgigSolardemoContext $ctx): void {}
    public function GetData(VoxgigSolardemoContext $ctx): void {}
    public function GetMatch(VoxgigSolardemoContext $ctx): void {}
    public function SetMatch(VoxgigSolardemoContext $ctx): void {}
    public function PrePoint(VoxgigSolardemoContext $ctx): void {}
    public function PreSpec(VoxgigSolardemoContext $ctx): void {}
    public function PreRequest(VoxgigSolardemoContext $ctx): void {}
    public function PreResponse(VoxgigSolardemoContext $ctx): void {}
    public function PreResult(VoxgigSolardemoContext $ctx): void {}
    public function PreDone(VoxgigSolardemoContext $ctx): void {}
    public function PreUnexpected(VoxgigSolardemoContext $ctx): void {}
}

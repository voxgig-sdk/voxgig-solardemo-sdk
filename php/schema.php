<?php
declare(strict_types=1);

// VoxgigSolardemo PHP SDK: generated schemas. Do not edit.
//
// Generated from the model: `main.kit.optspec` and each feature's
// `config.options` for OPTSPEC; entity `fields{}.type` for ENTITYSPEC.

class VoxgigSolardemoSchema
{
    private const OPTSPEC_DATA = '{"allow":{"method":"GET,PUT,POST,PATCH,DELETE,OPTIONS","op":"create,update,patch,load,list,remove,command,direct,graphql"},"apikey":"","auth":{"basic":false,"in":"","name":"","prefix":""},"base":"http://localhost:8000","clean":{"active":true,"hint":"0","keys":"key,secret,token,password,passwd,authorization,cookie,credential,signature","mask":"[redacted]","min":"4","values":""},"entity":{"`$CHILD`":{"`$OPEN`":true,"active":false,"alias":{}}},"extend":"`$ANY`","headers":{"`$CHILD`":"`$STRING`"},"prefix":"","secret":"","server":{"`$CHILD`":""},"suffix":"","system":{"fetch":"`$ANY`"},"test":{"active":false,"entity":{"`$OPEN`":true}},"utility":{},"feature":{"`$CHILD`":{"`$OPEN`":true,"active":false},"debug":["`$NOF`",{"min":1},{"`$OPEN`":true,"active":["`$NOF`",{"min":1},"`$BOOLEAN`","`$NIL`"],"max":["`$NOF`",{"min":1},"`$NUMBER`","`$NIL`"],"redact":["`$NOF`",{"min":1},"`$LIST`","`$NIL`"],"now":["`$NOF`",{"min":1},"`$FUNCTION`","`$NIL`"],"onEntry":["`$NOF`",{"min":1},"`$FUNCTION`","`$NIL`"]},"`$NIL`"],"idempotency":["`$NOF`",{"min":1},{"`$OPEN`":true,"active":["`$NOF`",{"min":1},"`$BOOLEAN`","`$NIL`"],"header":["`$NOF`",{"min":1},"`$STRING`",["`$EXACT`",""],"`$NIL`"],"methods":["`$NOF`",{"min":1},"`$LIST`","`$NIL`"],"ops":["`$NOF`",{"min":1},"`$LIST`","`$NIL`"],"keygen":["`$NOF`",{"min":1},"`$FUNCTION`","`$NIL`"]},"`$NIL`"],"metrics":["`$NOF`",{"min":1},{"`$OPEN`":true,"active":["`$NOF`",{"min":1},"`$BOOLEAN`","`$NIL`"],"now":["`$NOF`",{"min":1},"`$FUNCTION`","`$NIL`"]},"`$NIL`"],"paging":["`$NOF`",{"min":1},{"`$OPEN`":true,"active":["`$NOF`",{"min":1},"`$BOOLEAN`","`$NIL`"],"afterVar":["`$NOF`",{"min":1},"`$STRING`",["`$EXACT`",""],"`$NIL`"],"cursorParam":["`$NOF`",{"min":1},"`$STRING`",["`$EXACT`",""],"`$NIL`"],"firstVar":["`$NOF`",{"min":1},"`$STRING`",["`$EXACT`",""],"`$NIL`"],"limitParam":["`$NOF`",{"min":1},"`$STRING`",["`$EXACT`",""],"`$NIL`"],"pageParam":["`$NOF`",{"min":1},"`$STRING`",["`$EXACT`",""],"`$NIL`"],"startPage":["`$NOF`",{"min":1},"`$NUMBER`","`$NIL`"],"limit":["`$NOF`",{"min":1},"`$NUMBER`","`$NIL`"],"ops":["`$NOF`",{"min":1},"`$LIST`","`$NIL`"]},"`$NIL`"],"ratelimit":["`$NOF`",{"min":1},{"`$OPEN`":true,"active":["`$NOF`",{"min":1},"`$BOOLEAN`","`$NIL`"],"burst":["`$NOF`",{"min":1},"`$NUMBER`","`$NIL`"],"rate":["`$NOF`",{"min":1},"`$NUMBER`","`$NIL`"],"now":["`$NOF`",{"min":1},"`$FUNCTION`","`$NIL`"],"sleep":["`$NOF`",{"min":1},"`$FUNCTION`","`$NIL`"]},"`$NIL`"],"retry":["`$NOF`",{"min":1},{"`$OPEN`":true,"active":["`$NOF`",{"min":1},"`$BOOLEAN`","`$NIL`"],"factor":["`$NOF`",{"min":1},"`$NUMBER`","`$NIL`"],"maxDelay":["`$NOF`",{"min":1},"`$NUMBER`","`$NIL`"],"minDelay":["`$NOF`",{"min":1},"`$NUMBER`","`$NIL`"],"retries":["`$NOF`",{"min":1},"`$NUMBER`","`$NIL`"],"statuses":["`$NOF`",{"min":1},"`$LIST`","`$NIL`"],"jitter":["`$NOF`",{"min":1},"`$BOOLEAN`","`$NIL`"],"sleep":["`$NOF`",{"min":1},"`$FUNCTION`","`$NIL`"]},"`$NIL`"],"secrets":["`$NOF`",{"min":1},{"`$OPEN`":true,"active":["`$NOF`",{"min":1},"`$BOOLEAN`","`$NIL`"],"cache":["`$NOF`",{"min":1},"`$BOOLEAN`","`$NIL`"],"exchange":["`$NOF`",{"min":1},"`$MAP`","`$NIL`"],"name":["`$NOF`",{"min":1},"`$STRING`",["`$EXACT`",""],"`$NIL`"],"providers":["`$NOF`",{"min":1},"`$LIST`","`$NIL`"]},"`$NIL`"],"test":["`$NOF`",{"min":1},{"`$OPEN`":true,"active":["`$NOF`",{"min":1},"`$BOOLEAN`","`$NIL`"],"entity":["`$NOF`",{"min":1},"`$MAP`","`$NIL`"],"net":["`$NOF`",{"min":1},"`$MAP`","`$NIL`"]},"`$NIL`"],"timeout":["`$NOF`",{"min":1},{"`$OPEN`":true,"active":["`$NOF`",{"min":1},"`$BOOLEAN`","`$NIL`"],"ms":["`$NOF`",{"min":1},"`$NUMBER`","`$NIL`"],"clearTimer":["`$NOF`",{"min":1},"`$FUNCTION`","`$NIL`"],"now":["`$NOF`",{"min":1},"`$FUNCTION`","`$NIL`"],"setTimer":["`$NOF`",{"min":1},"`$FUNCTION`","`$NIL`"]},"`$NIL`"]}}';

    private const ENTITYSPEC_DATA = '{}';

    // A UNION, not ?array. schema_decode hands back an empty stdClass for an
    // EMPTY map - that is the whole point of decoding without the assoc flag,
    // since php cannot otherwise tell an empty map from an empty list - and
    // the entity specs are empty for a project with no entities, and whenever
    // the validate feature is inactive, which is the default. Typed ?array,
    // the first call to entityspec() threw a TypeError instead of handing
    // back the empty map every other target returns.
    private static array|\stdClass|null $optspec = null;

    private static array|\stdClass|null $entityspec = null;

    // Decoded ONCE, on first use. The spec is read on every client
    // construction and never mutated, so decoding per call would be pure
    // waste — and sharing the array is safe for the same reason:
    // make_options validates AGAINST it and writes into the options, never
    // into the spec. (php arrays are copy-on-write, so a caller that did
    // write would get its own copy rather than corrupt this one.)
    public static function optspec(): array|\stdClass
    {
        if (self::$optspec === null) {
            self::$optspec = self::schema_decode(json_decode(self::OPTSPEC_DATA));
        }
        return self::$optspec;
    }

    public static function entityspec(): array|\stdClass
    {
        if (self::$entityspec === null) {
            self::$entityspec = self::schema_decode(json_decode(self::ENTITYSPEC_DATA));
        }
        return self::$entityspec;
    }

    /**
     * Decode WITHOUT the assoc flag, then convert — for the one reason
     * config.php decodes the same way.
     *
     * php has a single array type, so json_decode with the assoc flag
     * renders an empty object and an empty list identically. Struct tells a
     * map from a list, so every empty map in the spec — utility, a feature's
     * rates, the OPEN-only entity template — arrived as an empty LIST and
     * was rejected with "Expected map, but found no value". Decoding to
     * stdClass keeps the distinction long enough to preserve it.
     *
     * config.php patches its two known empty maps by hand afterwards; the
     * spec has too many to enumerate and would gain one whenever a feature
     * declares a map option, so this restores every one of them by shape.
     */
    private static function schema_decode(mixed $v): mixed
    {
        if ($v instanceof \stdClass) {
            $vars = get_object_vars($v);
            if (count($vars) === 0) {
                return (object)[];
            }
            $out = [];
            foreach ($vars as $k => $c) {
                $out[$k] = self::schema_decode($c);
            }
            return $out;
        }
        if (is_array($v)) {
            return array_map([self::class, 'schema_decode'], $v);
        }
        return $v;
    }
}

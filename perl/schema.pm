# VoxgigSolardemo SDK: generated schemas. Do not edit.
#
# Built from the model: `main.kit.optspec` and each feature's
# `config.options` for the option spec; entity `fields{}.type` for the
# entity specs.

use strict;
use warnings;

use File::Basename ();
use Cwd ();

my $__dir;
BEGIN { $__dir = File::Basename::dirname(Cwd::abs_path(__FILE__)) }
require(Cwd::abs_path("$__dir/lib/Voxgig/Struct.pm"));

package VoxgigSolardemoSchema;

my $OPTSPEC_JSON = <<'END_OPTSPEC_JSON';
{
  "allow": {
    "method": "GET,PUT,POST,PATCH,DELETE,OPTIONS",
    "op": "create,update,load,list,remove,command,direct,graphql"
  },
  "apikey": "",
  "auth": {
    "basic": false,
    "in": "",
    "name": "",
    "prefix": ""
  },
  "base": "http://localhost:8000",
  "clean": {
    "keys": "key,token,id"
  },
  "entity": {
    "`$CHILD`": {
      "`$OPEN`": true,
      "active": false,
      "alias": {}
    }
  },
  "extend": "`$ANY`",
  "headers": {
    "`$CHILD`": "`$STRING`"
  },
  "prefix": "",
  "secret": "",
  "server": {
    "`$CHILD`": ""
  },
  "suffix": "",
  "system": {
    "fetch": "`$ANY`"
  },
  "test": {
    "active": false,
    "entity": {
      "`$OPEN`": true
    }
  },
  "utility": {},
  "feature": {
    "`$CHILD`": {
      "`$OPEN`": true,
      "active": false
    },
    "debug": [
      "`$ONE`",
      {
        "`$OPEN`": true,
        "active": [
          "`$ONE`",
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "max": [
          "`$ONE`",
          "`$NUMBER`",
          "`$NIL`"
        ],
        "redact": [
          "`$ONE`",
          "`$LIST`",
          "`$NIL`"
        ],
        "now": [
          "`$ONE`",
          "`$FUNCTION`",
          "`$NIL`"
        ],
        "onEntry": [
          "`$ONE`",
          "`$FUNCTION`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "idempotency": [
      "`$ONE`",
      {
        "`$OPEN`": true,
        "active": [
          "`$ONE`",
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "header": [
          "`$ONE`",
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "methods": [
          "`$ONE`",
          "`$LIST`",
          "`$NIL`"
        ],
        "ops": [
          "`$ONE`",
          "`$LIST`",
          "`$NIL`"
        ],
        "keygen": [
          "`$ONE`",
          "`$FUNCTION`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "metrics": [
      "`$ONE`",
      {
        "`$OPEN`": true,
        "active": [
          "`$ONE`",
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "now": [
          "`$ONE`",
          "`$FUNCTION`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "paging": [
      "`$ONE`",
      {
        "`$OPEN`": true,
        "active": [
          "`$ONE`",
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "afterVar": [
          "`$ONE`",
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "cursorParam": [
          "`$ONE`",
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "firstVar": [
          "`$ONE`",
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "limitParam": [
          "`$ONE`",
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "pageParam": [
          "`$ONE`",
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "startPage": [
          "`$ONE`",
          "`$NUMBER`",
          "`$NIL`"
        ],
        "limit": [
          "`$ONE`",
          "`$NUMBER`",
          "`$NIL`"
        ],
        "ops": [
          "`$ONE`",
          "`$LIST`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "ratelimit": [
      "`$ONE`",
      {
        "`$OPEN`": true,
        "active": [
          "`$ONE`",
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "burst": [
          "`$ONE`",
          "`$NUMBER`",
          "`$NIL`"
        ],
        "rate": [
          "`$ONE`",
          "`$NUMBER`",
          "`$NIL`"
        ],
        "now": [
          "`$ONE`",
          "`$FUNCTION`",
          "`$NIL`"
        ],
        "sleep": [
          "`$ONE`",
          "`$FUNCTION`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "retry": [
      "`$ONE`",
      {
        "`$OPEN`": true,
        "active": [
          "`$ONE`",
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "factor": [
          "`$ONE`",
          "`$NUMBER`",
          "`$NIL`"
        ],
        "maxDelay": [
          "`$ONE`",
          "`$NUMBER`",
          "`$NIL`"
        ],
        "minDelay": [
          "`$ONE`",
          "`$NUMBER`",
          "`$NIL`"
        ],
        "retries": [
          "`$ONE`",
          "`$NUMBER`",
          "`$NIL`"
        ],
        "statuses": [
          "`$ONE`",
          "`$LIST`",
          "`$NIL`"
        ],
        "jitter": [
          "`$ONE`",
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "sleep": [
          "`$ONE`",
          "`$FUNCTION`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "secrets": [
      "`$ONE`",
      {
        "`$OPEN`": true,
        "active": [
          "`$ONE`",
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "cache": [
          "`$ONE`",
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "exchange": [
          "`$ONE`",
          "`$MAP`",
          "`$NIL`"
        ],
        "name": [
          "`$ONE`",
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "providers": [
          "`$ONE`",
          "`$LIST`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "test": [
      "`$ONE`",
      {
        "`$OPEN`": true,
        "active": [
          "`$ONE`",
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "entity": [
          "`$ONE`",
          "`$MAP`",
          "`$NIL`"
        ],
        "net": [
          "`$ONE`",
          "`$MAP`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "timeout": [
      "`$ONE`",
      {
        "`$OPEN`": true,
        "active": [
          "`$ONE`",
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "ms": [
          "`$ONE`",
          "`$NUMBER`",
          "`$NIL`"
        ],
        "clearTimer": [
          "`$ONE`",
          "`$FUNCTION`",
          "`$NIL`"
        ],
        "setTimer": [
          "`$ONE`",
          "`$FUNCTION`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ]
  }
}
END_OPTSPEC_JSON

my $ENTITYSPEC_JSON = <<'END_ENTITYSPEC_JSON';
{}
END_ENTITYSPEC_JSON

sub make_optspec {
  return Voxgig::Struct::parse_json($OPTSPEC_JSON);
}

sub make_entityspec {
  return Voxgig::Struct::parse_json($ENTITYSPEC_JSON);
}

# SHARED SPECS, the shape VoxgigSolardemoConfig::shared_config uses and for
# the same reasons: the spec is read on every client construction and never
# mutated, so a per-call parse would be pure waste.
#
# The returned structures are SHARED: treat them as read-only. make_options
# validates AGAINST the spec and writes into the options, never into the spec.
my $SHARED_OPTSPEC;
my $SHARED_ENTITYSPEC;

sub optspec {
  $SHARED_OPTSPEC = make_optspec() unless defined $SHARED_OPTSPEC;
  return $SHARED_OPTSPEC;
}

sub entityspec {
  $SHARED_ENTITYSPEC = make_entityspec() unless defined $SHARED_ENTITYSPEC;
  return $SHARED_ENTITYSPEC;
}

1;

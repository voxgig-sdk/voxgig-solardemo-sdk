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
    "op": "create,update,patch,load,list,remove,command,direct,graphql"
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
    "active": true,
    "hint": "0",
    "keys": "key,secret,token,password,passwd,authorization,cookie,credential,signature",
    "mask": "[redacted]",
    "min": "4",
    "values": ""
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
      "`$NOF`",
      {
        "min": 1
      },
      {
        "`$OPEN`": true,
        "active": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "max": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$NUMBER`",
          "`$NIL`"
        ],
        "redact": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$LIST`",
          "`$NIL`"
        ],
        "now": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$FUNCTION`",
          "`$NIL`"
        ],
        "onEntry": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$FUNCTION`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "idempotency": [
      "`$NOF`",
      {
        "min": 1
      },
      {
        "`$OPEN`": true,
        "active": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "header": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "methods": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$LIST`",
          "`$NIL`"
        ],
        "ops": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$LIST`",
          "`$NIL`"
        ],
        "keygen": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$FUNCTION`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "metrics": [
      "`$NOF`",
      {
        "min": 1
      },
      {
        "`$OPEN`": true,
        "active": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "now": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$FUNCTION`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "paging": [
      "`$NOF`",
      {
        "min": 1
      },
      {
        "`$OPEN`": true,
        "active": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "afterVar": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "cursorParam": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "firstVar": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "limitParam": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "pageParam": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "startPage": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$NUMBER`",
          "`$NIL`"
        ],
        "limit": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$NUMBER`",
          "`$NIL`"
        ],
        "ops": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$LIST`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "ratelimit": [
      "`$NOF`",
      {
        "min": 1
      },
      {
        "`$OPEN`": true,
        "active": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "burst": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$NUMBER`",
          "`$NIL`"
        ],
        "rate": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$NUMBER`",
          "`$NIL`"
        ],
        "now": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$FUNCTION`",
          "`$NIL`"
        ],
        "sleep": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$FUNCTION`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "retry": [
      "`$NOF`",
      {
        "min": 1
      },
      {
        "`$OPEN`": true,
        "active": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "factor": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$NUMBER`",
          "`$NIL`"
        ],
        "maxDelay": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$NUMBER`",
          "`$NIL`"
        ],
        "minDelay": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$NUMBER`",
          "`$NIL`"
        ],
        "retries": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$NUMBER`",
          "`$NIL`"
        ],
        "statuses": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$LIST`",
          "`$NIL`"
        ],
        "jitter": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "sleep": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$FUNCTION`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "secrets": [
      "`$NOF`",
      {
        "min": 1
      },
      {
        "`$OPEN`": true,
        "active": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "cache": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "exchange": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$MAP`",
          "`$NIL`"
        ],
        "name": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$STRING`",
          [
            "`$EXACT`",
            ""
          ],
          "`$NIL`"
        ],
        "providers": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$LIST`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "test": [
      "`$NOF`",
      {
        "min": 1
      },
      {
        "`$OPEN`": true,
        "active": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "entity": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$MAP`",
          "`$NIL`"
        ],
        "net": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$MAP`",
          "`$NIL`"
        ]
      },
      "`$NIL`"
    ],
    "timeout": [
      "`$NOF`",
      {
        "min": 1
      },
      {
        "`$OPEN`": true,
        "active": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$BOOLEAN`",
          "`$NIL`"
        ],
        "ms": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$NUMBER`",
          "`$NIL`"
        ],
        "clearTimer": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$FUNCTION`",
          "`$NIL`"
        ],
        "now": [
          "`$NOF`",
          {
            "min": 1
          },
          "`$FUNCTION`",
          "`$NIL`"
        ],
        "setTimer": [
          "`$NOF`",
          {
            "min": 1
          },
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

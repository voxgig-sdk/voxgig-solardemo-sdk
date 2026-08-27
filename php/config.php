<?php
declare(strict_types=1);

// Solardemo SDK configuration

class SolardemoConfig
{
    /** @var array<string,mixed>|null */
    private static ?array $shared_config = null;

    /**
     * Return the process-wide config, built once on first use. The SDK reads
     * the config on every request and never writes to it, so one instance is
     * shared by every client rather than rebuilt per client.
     *
     * PHP arrays are copy-on-write, so callers that do mutate the result get
     * their own copy and cannot disturb the shared one.
     */
    public static function shared_config(): array
    {
        if (self::$shared_config === null) {
            self::$shared_config = self::make_config();
        }
        return self::$shared_config;
    }

    /**
     * Build a fresh, fully materialised config array. Every call rebuilds the
     * whole structure, so prefer shared_config unless you need a private copy.
     */
    public static function make_config(): array
    {
        return [
            "main" => [
                "name" => "Solardemo",
                "slug" => "solardemo",
                "version" => "0.1.0",
                "target" => "php",
            ],
            "feature" => [
                "test" => [
          'options' => [
            'active' => false,
          ],
          'transport' => 'base',
        ],
            ],
            "options" => [
                "base" => "http://localhost:8901",
                "headers" => [
          'content-type' => 'application/json',
        ],
                "entity" => [
                    "moon" => [],
                    "planet" => [],
                ],
            ],
            "entity" => [
        'moon' => [
          'fields' => [
            [
              'name' => 'diameter',
              'req' => true,
              'type' => '`$NUMBER`',
            ],
            [
              'name' => 'id',
              'req' => true,
              'type' => '`$STRING`',
            ],
            [
              'name' => 'kind',
              'req' => true,
              'type' => '`$STRING`',
            ],
            [
              'name' => 'name',
              'req' => true,
              'type' => '`$STRING`',
            ],
            [
              'name' => 'planet_id',
              'req' => true,
              'type' => '`$STRING`',
            ],
          ],
          'name' => 'moon',
          'op' => [
            'create' => [
              'input' => 'data',
              'name' => 'create',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'kind' => 'param',
                        'name' => 'planet_id',
                        'orig' => 'planet_id',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'POST',
                  'orig' => '/api/planet/{planet_id}/moon',
                  'parts' => [
                    'api',
                    'planet',
                    '{planet_id}',
                    'moon',
                  ],
                  'select' => [
                    'exist' => [
                      'planet_id',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                ],
              ],
            ],
            'list' => [
              'input' => 'data',
              'name' => 'list',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'kind' => 'param',
                        'name' => 'planet_id',
                        'orig' => 'planet_id',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'GET',
                  'orig' => '/api/planet/{planet_id}/moon',
                  'parts' => [
                    'api',
                    'planet',
                    '{planet_id}',
                    'moon',
                  ],
                  'select' => [
                    'exist' => [
                      'planet_id',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                ],
              ],
            ],
            'load' => [
              'input' => 'data',
              'name' => 'load',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'kind' => 'param',
                        'name' => 'id',
                        'orig' => 'moon_id',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                      [
                        'kind' => 'param',
                        'name' => 'planet_id',
                        'orig' => 'planet_id',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'GET',
                  'orig' => '/api/planet/{planet_id}/moon/{moon_id}',
                  'parts' => [
                    'api',
                    'planet',
                    '{planet_id}',
                    'moon',
                    '{id}',
                  ],
                  'rename' => [
                    'param' => [
                      'moon_id' => 'id',
                    ],
                  ],
                  'select' => [
                    'exist' => [
                      'id',
                      'planet_id',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                ],
              ],
            ],
            'remove' => [
              'input' => 'data',
              'name' => 'remove',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'kind' => 'param',
                        'name' => 'id',
                        'orig' => 'moon_id',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                      [
                        'kind' => 'param',
                        'name' => 'planet_id',
                        'orig' => 'planet_id',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'DELETE',
                  'orig' => '/api/planet/{planet_id}/moon/{moon_id}',
                  'parts' => [
                    'api',
                    'planet',
                    '{planet_id}',
                    'moon',
                    '{id}',
                  ],
                  'rename' => [
                    'param' => [
                      'moon_id' => 'id',
                    ],
                  ],
                  'select' => [
                    'exist' => [
                      'id',
                      'planet_id',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                ],
              ],
            ],
            'update' => [
              'input' => 'data',
              'name' => 'update',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'kind' => 'param',
                        'name' => 'id',
                        'orig' => 'moon_id',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                      [
                        'kind' => 'param',
                        'name' => 'planet_id',
                        'orig' => 'planet_id',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'PUT',
                  'orig' => '/api/planet/{planet_id}/moon/{moon_id}',
                  'parts' => [
                    'api',
                    'planet',
                    '{planet_id}',
                    'moon',
                    '{id}',
                  ],
                  'rename' => [
                    'param' => [
                      'moon_id' => 'id',
                    ],
                  ],
                  'select' => [
                    'exist' => [
                      'id',
                      'planet_id',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                ],
              ],
            ],
          ],
          'relations' => [
            'ancestors' => [
              [
                'planet',
              ],
            ],
          ],
        ],
        'planet' => [
          'fields' => [
            [
              'name' => 'diameter',
              'req' => true,
              'type' => '`$NUMBER`',
            ],
            [
              'name' => 'forbid',
              'type' => '`$BOOLEAN`',
            ],
            [
              'name' => 'id',
              'req' => true,
              'type' => '`$STRING`',
            ],
            [
              'name' => 'kind',
              'req' => true,
              'type' => '`$STRING`',
            ],
            [
              'name' => 'name',
              'req' => true,
              'type' => '`$STRING`',
            ],
            [
              'name' => 'ok',
              'type' => '`$BOOLEAN`',
            ],
            [
              'name' => 'start',
              'type' => '`$BOOLEAN`',
            ],
            [
              'name' => 'state',
              'type' => '`$STRING`',
            ],
            [
              'name' => 'stop',
              'type' => '`$BOOLEAN`',
            ],
            [
              'name' => 'why',
              'type' => '`$STRING`',
            ],
          ],
          'name' => 'planet',
          'op' => [
            'create' => [
              'input' => 'data',
              'name' => 'create',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'kind' => 'param',
                        'name' => 'id',
                        'orig' => 'planet_id',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'POST',
                  'orig' => '/api/planet/{planet_id}/forbid',
                  'parts' => [
                    'api',
                    'planet',
                    '{id}',
                    'forbid',
                  ],
                  'rename' => [
                    'param' => [
                      'planet_id' => 'id',
                    ],
                  ],
                  'select' => [
                    '$action' => 'forbid',
                    'exist' => [
                      'id',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                ],
                [
                  'args' => [
                    'params' => [
                      [
                        'kind' => 'param',
                        'name' => 'id',
                        'orig' => 'planet_id',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'POST',
                  'orig' => '/api/planet/{planet_id}/terraform',
                  'parts' => [
                    'api',
                    'planet',
                    '{id}',
                    'terraform',
                  ],
                  'rename' => [
                    'param' => [
                      'planet_id' => 'id',
                    ],
                  ],
                  'select' => [
                    '$action' => 'terraform',
                    'exist' => [
                      'id',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                ],
                [
                  'args' => [],
                  'kind' => 'http',
                  'method' => 'POST',
                  'orig' => '/api/planet',
                  'parts' => [
                    'api',
                    'planet',
                  ],
                  'select' => [],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                ],
              ],
            ],
            'list' => [
              'input' => 'data',
              'name' => 'list',
              'points' => [
                [
                  'args' => [],
                  'kind' => 'http',
                  'method' => 'GET',
                  'orig' => '/api/planet',
                  'parts' => [
                    'api',
                    'planet',
                  ],
                  'select' => [],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                ],
              ],
            ],
            'load' => [
              'input' => 'data',
              'name' => 'load',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'kind' => 'param',
                        'name' => 'id',
                        'orig' => 'planet_id',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'GET',
                  'orig' => '/api/planet/{planet_id}',
                  'parts' => [
                    'api',
                    'planet',
                    '{id}',
                  ],
                  'rename' => [
                    'param' => [
                      'planet_id' => 'id',
                    ],
                  ],
                  'select' => [
                    'exist' => [
                      'id',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                ],
              ],
            ],
            'remove' => [
              'input' => 'data',
              'name' => 'remove',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'kind' => 'param',
                        'name' => 'id',
                        'orig' => 'planet_id',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'DELETE',
                  'orig' => '/api/planet/{planet_id}',
                  'parts' => [
                    'api',
                    'planet',
                    '{id}',
                  ],
                  'rename' => [
                    'param' => [
                      'planet_id' => 'id',
                    ],
                  ],
                  'select' => [
                    'exist' => [
                      'id',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                ],
              ],
            ],
            'update' => [
              'input' => 'data',
              'name' => 'update',
              'points' => [
                [
                  'args' => [
                    'params' => [
                      [
                        'kind' => 'param',
                        'name' => 'id',
                        'orig' => 'planet_id',
                        'reqd' => true,
                        'type' => '`$STRING`',
                      ],
                    ],
                  ],
                  'kind' => 'http',
                  'method' => 'PUT',
                  'orig' => '/api/planet/{planet_id}',
                  'parts' => [
                    'api',
                    'planet',
                    '{id}',
                  ],
                  'rename' => [
                    'param' => [
                      'planet_id' => 'id',
                    ],
                  ],
                  'select' => [
                    'exist' => [
                      'id',
                    ],
                  ],
                  'transform' => [
                    'req' => '`reqdata`',
                    'res' => '`body`',
                  ],
                ],
              ],
            ],
          ],
          'relations' => [
            'ancestors' => [],
          ],
        ],
      ],
        ];
    }


    public static function make_feature(string $name)
    {
        require_once __DIR__ . '/features.php';
        return SolardemoFeatures::make_feature($name);
    }
}

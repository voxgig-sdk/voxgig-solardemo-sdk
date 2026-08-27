import 'feature/base/BaseFeature.dart';
import 'feature/test/TestFeature.dart';


// ignore: non_constant_identifier_names
final Map<String, BaseFeature Function()> FEATURE_CLASS = {
    'test': () => TestFeature(),

};

class Config {
  BaseFeature makeFeature(String fn) {
    final fc = FEATURE_CLASS[fn];
    if (null == fc) {
      // TODO: errors etc
      throw StateError('Unknown feature: ' + fn);
    }
    return fc();
  }

  // False for a feature added at runtime via options.extend (station's
  // adopt path) - the constructor uses this to skip makeFeature for names
  // no generated class backs.
  bool hasFeature(String fn) => null != FEATURE_CLASS[fn];

  final Map<String, dynamic> main = <String, dynamic>{
    'name': 'Solardemo',
        'slug': 'solardemo',
    'version': '0.1.0',
    'target': 'dart',

  };

  final Map<String, dynamic> feature = <String, dynamic>{
        'test': <String, dynamic>{
      'options': <String, dynamic>{
        'active': false,
      },
      'transport': 'base',
    },

  };

  // Rendered whole from the canonical config definition rather than assembled
  // slot by slot. Assembling it here meant `options.server` - the OpenAPI
  // server-variable defaults - was simply absent from this branch, so a
  // templated server URL produced a different config either side of the
  // threshold.
  final Map<String, dynamic> options = <String, dynamic>{
    'base': 'http://localhost:8901',
    'headers': <String, dynamic>{
      'content-type': 'application/json',
    },
    'entity': <String, dynamic>{
      'moon': <String, dynamic>{},
      'planet': <String, dynamic>{},
    },
  };

  final Map<String, dynamic> entity = <String, dynamic>{
    'moon': <String, dynamic>{
      'fields': <dynamic>[
        <String, dynamic>{
          'name': 'diameter',
          'req': true,
          'type': '`\$NUMBER`',
        },
        <String, dynamic>{
          'name': 'id',
          'req': true,
          'type': '`\$STRING`',
        },
        <String, dynamic>{
          'name': 'kind',
          'req': true,
          'type': '`\$STRING`',
        },
        <String, dynamic>{
          'name': 'name',
          'req': true,
          'type': '`\$STRING`',
        },
        <String, dynamic>{
          'name': 'planet_id',
          'req': true,
          'type': '`\$STRING`',
        },
      ],
      'name': 'moon',
      'op': <String, dynamic>{
        'create': <String, dynamic>{
          'input': 'data',
          'name': 'create',
          'points': <dynamic>[
            <String, dynamic>{
              'args': <String, dynamic>{
                'params': <dynamic>[
                  <String, dynamic>{
                    'kind': 'param',
                    'name': 'planet_id',
                    'orig': 'planet_id',
                    'reqd': true,
                    'type': '`\$STRING`',
                  },
                ],
              },
              'kind': 'http',
              'method': 'POST',
              'orig': '/api/planet/{planet_id}/moon',
              'parts': <dynamic>[
                'api',
                'planet',
                '{planet_id}',
                'moon',
              ],
              'select': <String, dynamic>{
                'exist': <dynamic>[
                  'planet_id',
                ],
              },
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
            },
          ],
        },
        'list': <String, dynamic>{
          'input': 'data',
          'name': 'list',
          'points': <dynamic>[
            <String, dynamic>{
              'args': <String, dynamic>{
                'params': <dynamic>[
                  <String, dynamic>{
                    'kind': 'param',
                    'name': 'planet_id',
                    'orig': 'planet_id',
                    'reqd': true,
                    'type': '`\$STRING`',
                  },
                ],
              },
              'kind': 'http',
              'method': 'GET',
              'orig': '/api/planet/{planet_id}/moon',
              'parts': <dynamic>[
                'api',
                'planet',
                '{planet_id}',
                'moon',
              ],
              'select': <String, dynamic>{
                'exist': <dynamic>[
                  'planet_id',
                ],
              },
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
            },
          ],
        },
        'load': <String, dynamic>{
          'input': 'data',
          'name': 'load',
          'points': <dynamic>[
            <String, dynamic>{
              'args': <String, dynamic>{
                'params': <dynamic>[
                  <String, dynamic>{
                    'kind': 'param',
                    'name': 'id',
                    'orig': 'moon_id',
                    'reqd': true,
                    'type': '`\$STRING`',
                  },
                  <String, dynamic>{
                    'kind': 'param',
                    'name': 'planet_id',
                    'orig': 'planet_id',
                    'reqd': true,
                    'type': '`\$STRING`',
                  },
                ],
              },
              'kind': 'http',
              'method': 'GET',
              'orig': '/api/planet/{planet_id}/moon/{moon_id}',
              'parts': <dynamic>[
                'api',
                'planet',
                '{planet_id}',
                'moon',
                '{id}',
              ],
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'moon_id': 'id',
                },
              },
              'select': <String, dynamic>{
                'exist': <dynamic>[
                  'id',
                  'planet_id',
                ],
              },
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
            },
          ],
        },
        'remove': <String, dynamic>{
          'input': 'data',
          'name': 'remove',
          'points': <dynamic>[
            <String, dynamic>{
              'args': <String, dynamic>{
                'params': <dynamic>[
                  <String, dynamic>{
                    'kind': 'param',
                    'name': 'id',
                    'orig': 'moon_id',
                    'reqd': true,
                    'type': '`\$STRING`',
                  },
                  <String, dynamic>{
                    'kind': 'param',
                    'name': 'planet_id',
                    'orig': 'planet_id',
                    'reqd': true,
                    'type': '`\$STRING`',
                  },
                ],
              },
              'kind': 'http',
              'method': 'DELETE',
              'orig': '/api/planet/{planet_id}/moon/{moon_id}',
              'parts': <dynamic>[
                'api',
                'planet',
                '{planet_id}',
                'moon',
                '{id}',
              ],
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'moon_id': 'id',
                },
              },
              'select': <String, dynamic>{
                'exist': <dynamic>[
                  'id',
                  'planet_id',
                ],
              },
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
            },
          ],
        },
        'update': <String, dynamic>{
          'input': 'data',
          'name': 'update',
          'points': <dynamic>[
            <String, dynamic>{
              'args': <String, dynamic>{
                'params': <dynamic>[
                  <String, dynamic>{
                    'kind': 'param',
                    'name': 'id',
                    'orig': 'moon_id',
                    'reqd': true,
                    'type': '`\$STRING`',
                  },
                  <String, dynamic>{
                    'kind': 'param',
                    'name': 'planet_id',
                    'orig': 'planet_id',
                    'reqd': true,
                    'type': '`\$STRING`',
                  },
                ],
              },
              'kind': 'http',
              'method': 'PUT',
              'orig': '/api/planet/{planet_id}/moon/{moon_id}',
              'parts': <dynamic>[
                'api',
                'planet',
                '{planet_id}',
                'moon',
                '{id}',
              ],
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'moon_id': 'id',
                },
              },
              'select': <String, dynamic>{
                'exist': <dynamic>[
                  'id',
                  'planet_id',
                ],
              },
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
            },
          ],
        },
      },
      'relations': <String, dynamic>{
        'ancestors': <dynamic>[
          <dynamic>[
            'planet',
          ],
        ],
      },
    },
    'planet': <String, dynamic>{
      'fields': <dynamic>[
        <String, dynamic>{
          'name': 'diameter',
          'req': true,
          'type': '`\$NUMBER`',
        },
        <String, dynamic>{
          'name': 'forbid',
          'type': '`\$BOOLEAN`',
        },
        <String, dynamic>{
          'name': 'id',
          'req': true,
          'type': '`\$STRING`',
        },
        <String, dynamic>{
          'name': 'kind',
          'req': true,
          'type': '`\$STRING`',
        },
        <String, dynamic>{
          'name': 'name',
          'req': true,
          'type': '`\$STRING`',
        },
        <String, dynamic>{
          'name': 'ok',
          'type': '`\$BOOLEAN`',
        },
        <String, dynamic>{
          'name': 'start',
          'type': '`\$BOOLEAN`',
        },
        <String, dynamic>{
          'name': 'state',
          'type': '`\$STRING`',
        },
        <String, dynamic>{
          'name': 'stop',
          'type': '`\$BOOLEAN`',
        },
        <String, dynamic>{
          'name': 'why',
          'type': '`\$STRING`',
        },
      ],
      'name': 'planet',
      'op': <String, dynamic>{
        'create': <String, dynamic>{
          'input': 'data',
          'name': 'create',
          'points': <dynamic>[
            <String, dynamic>{
              'args': <String, dynamic>{
                'params': <dynamic>[
                  <String, dynamic>{
                    'kind': 'param',
                    'name': 'id',
                    'orig': 'planet_id',
                    'reqd': true,
                    'type': '`\$STRING`',
                  },
                ],
              },
              'kind': 'http',
              'method': 'POST',
              'orig': '/api/planet/{planet_id}/forbid',
              'parts': <dynamic>[
                'api',
                'planet',
                '{id}',
                'forbid',
              ],
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'planet_id': 'id',
                },
              },
              'select': <String, dynamic>{
                '\$action': 'forbid',
                'exist': <dynamic>[
                  'id',
                ],
              },
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
            },
            <String, dynamic>{
              'args': <String, dynamic>{
                'params': <dynamic>[
                  <String, dynamic>{
                    'kind': 'param',
                    'name': 'id',
                    'orig': 'planet_id',
                    'reqd': true,
                    'type': '`\$STRING`',
                  },
                ],
              },
              'kind': 'http',
              'method': 'POST',
              'orig': '/api/planet/{planet_id}/terraform',
              'parts': <dynamic>[
                'api',
                'planet',
                '{id}',
                'terraform',
              ],
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'planet_id': 'id',
                },
              },
              'select': <String, dynamic>{
                '\$action': 'terraform',
                'exist': <dynamic>[
                  'id',
                ],
              },
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
            },
            <String, dynamic>{
              'args': <String, dynamic>{},
              'kind': 'http',
              'method': 'POST',
              'orig': '/api/planet',
              'parts': <dynamic>[
                'api',
                'planet',
              ],
              'select': <String, dynamic>{},
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
            },
          ],
        },
        'list': <String, dynamic>{
          'input': 'data',
          'name': 'list',
          'points': <dynamic>[
            <String, dynamic>{
              'args': <String, dynamic>{},
              'kind': 'http',
              'method': 'GET',
              'orig': '/api/planet',
              'parts': <dynamic>[
                'api',
                'planet',
              ],
              'select': <String, dynamic>{},
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
            },
          ],
        },
        'load': <String, dynamic>{
          'input': 'data',
          'name': 'load',
          'points': <dynamic>[
            <String, dynamic>{
              'args': <String, dynamic>{
                'params': <dynamic>[
                  <String, dynamic>{
                    'kind': 'param',
                    'name': 'id',
                    'orig': 'planet_id',
                    'reqd': true,
                    'type': '`\$STRING`',
                  },
                ],
              },
              'kind': 'http',
              'method': 'GET',
              'orig': '/api/planet/{planet_id}',
              'parts': <dynamic>[
                'api',
                'planet',
                '{id}',
              ],
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'planet_id': 'id',
                },
              },
              'select': <String, dynamic>{
                'exist': <dynamic>[
                  'id',
                ],
              },
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
            },
          ],
        },
        'remove': <String, dynamic>{
          'input': 'data',
          'name': 'remove',
          'points': <dynamic>[
            <String, dynamic>{
              'args': <String, dynamic>{
                'params': <dynamic>[
                  <String, dynamic>{
                    'kind': 'param',
                    'name': 'id',
                    'orig': 'planet_id',
                    'reqd': true,
                    'type': '`\$STRING`',
                  },
                ],
              },
              'kind': 'http',
              'method': 'DELETE',
              'orig': '/api/planet/{planet_id}',
              'parts': <dynamic>[
                'api',
                'planet',
                '{id}',
              ],
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'planet_id': 'id',
                },
              },
              'select': <String, dynamic>{
                'exist': <dynamic>[
                  'id',
                ],
              },
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
            },
          ],
        },
        'update': <String, dynamic>{
          'input': 'data',
          'name': 'update',
          'points': <dynamic>[
            <String, dynamic>{
              'args': <String, dynamic>{
                'params': <dynamic>[
                  <String, dynamic>{
                    'kind': 'param',
                    'name': 'id',
                    'orig': 'planet_id',
                    'reqd': true,
                    'type': '`\$STRING`',
                  },
                ],
              },
              'kind': 'http',
              'method': 'PUT',
              'orig': '/api/planet/{planet_id}',
              'parts': <dynamic>[
                'api',
                'planet',
                '{id}',
              ],
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'planet_id': 'id',
                },
              },
              'select': <String, dynamic>{
                'exist': <dynamic>[
                  'id',
                ],
              },
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
            },
          ],
        },
      },
      'relations': <String, dynamic>{
        'ancestors': <dynamic>[],
      },
    },
  };

  // The pipeline context carries the config as a plain map.
  Map<String, dynamic> toMap() => <String, dynamic>{
        'main': main,
        'feature': feature,
        'options': options,
        'entity': entity,
      };
}

final config = Config();

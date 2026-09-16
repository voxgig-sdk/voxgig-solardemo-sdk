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
          'format': 'float',
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
              'contract': <String, dynamic>{
                'id': 'POST /api/planet/{planet_id}/moon',
                'json': '{"parameters":[{"in":"path","name":"planet_id","required":true,"schema":{"type":"string"}}],"protocol":"http","requestBody":{"content":{"application/json":{"schema":{"properties":{"diameter":{"format":"float","type":"number"},"id":{"type":"string"},"kind":{"type":"string"},"name":{"type":"string"},"planet_id":{"type":"string"}},"required":["id","name","planet_id","kind","diameter"],"type":"object"}}},"required":true},"responses":{"201":{"content":{"application/json":{"schema":{"properties":{"diameter":{"format":"float","type":"number"},"id":{"type":"string"},"kind":{"type":"string"},"name":{"type":"string"},"planet_id":{"type":"string"}},"required":["id","name","planet_id","kind","diameter"],"type":"object"}}},"description":"Created"}},"securitySource":"unspecified"}',
                'source': 'openapi3',
                'version': 1,
              },
              'kind': 'http',
              'method': 'POST',
              'orig': '/api/planet/{planet_id}/moon',
              'segments': <dynamic>[
                <String, dynamic>{
                  'lit': 'api',
                },
                <String, dynamic>{
                  'lit': 'planet',
                },
                <String, dynamic>{
                  'var': 'planet_id',
                },
                <String, dynamic>{
                  'lit': 'moon',
                },
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
              'parts': <dynamic>[
                'api',
                'planet',
                '{planet_id}',
                'moon',
              ],
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
              'contract': <String, dynamic>{
                'id': 'GET /api/planet/{planet_id}/moon',
                'json': '{"parameters":[{"in":"path","name":"planet_id","required":true,"schema":{"type":"string"}}],"protocol":"http","responses":{"200":{"content":{"application/json":{"schema":{"items":{"properties":{"diameter":{"format":"float","type":"number"},"id":{"type":"string"},"kind":{"type":"string"},"name":{"type":"string"},"planet_id":{"type":"string"}},"required":["id","name","planet_id","kind","diameter"],"type":"object"},"type":"array"}}},"description":"OK"}},"securitySource":"unspecified"}',
                'source': 'openapi3',
                'version': 1,
              },
              'kind': 'http',
              'method': 'GET',
              'orig': '/api/planet/{planet_id}/moon',
              'segments': <dynamic>[
                <String, dynamic>{
                  'lit': 'api',
                },
                <String, dynamic>{
                  'lit': 'planet',
                },
                <String, dynamic>{
                  'var': 'planet_id',
                },
                <String, dynamic>{
                  'lit': 'moon',
                },
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
              'parts': <dynamic>[
                'api',
                'planet',
                '{planet_id}',
                'moon',
              ],
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
              'contract': <String, dynamic>{
                'id': 'GET /api/planet/{planet_id}/moon/{moon_id}',
                'json': '{"parameters":[{"in":"path","name":"planet_id","required":true,"schema":{"type":"string"}},{"in":"path","name":"moon_id","required":true,"schema":{"type":"string"}}],"protocol":"http","responses":{"200":{"content":{"application/json":{"schema":{"properties":{"diameter":{"format":"float","type":"number"},"id":{"type":"string"},"kind":{"type":"string"},"name":{"type":"string"},"planet_id":{"type":"string"}},"required":["id","name","planet_id","kind","diameter"],"type":"object"}}},"description":"OK"}},"securitySource":"unspecified"}',
                'source': 'openapi3',
                'version': 1,
              },
              'kind': 'http',
              'method': 'GET',
              'orig': '/api/planet/{planet_id}/moon/{moon_id}',
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'moon_id': 'id',
                },
              },
              'segments': <dynamic>[
                <String, dynamic>{
                  'lit': 'api',
                },
                <String, dynamic>{
                  'lit': 'planet',
                },
                <String, dynamic>{
                  'var': 'planet_id',
                },
                <String, dynamic>{
                  'lit': 'moon',
                },
                <String, dynamic>{
                  'var': 'id',
                },
              ],
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
              'parts': <dynamic>[
                'api',
                'planet',
                '{planet_id}',
                'moon',
                '{id}',
              ],
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
              'contract': <String, dynamic>{
                'id': 'DELETE /api/planet/{planet_id}/moon/{moon_id}',
                'json': '{"parameters":[{"in":"path","name":"planet_id","required":true,"schema":{"type":"string"}},{"in":"path","name":"moon_id","required":true,"schema":{"type":"string"}}],"protocol":"http","responses":{"204":{"description":"No Content"}},"securitySource":"unspecified"}',
                'source': 'openapi3',
                'version': 1,
              },
              'kind': 'http',
              'method': 'DELETE',
              'orig': '/api/planet/{planet_id}/moon/{moon_id}',
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'moon_id': 'id',
                },
              },
              'segments': <dynamic>[
                <String, dynamic>{
                  'lit': 'api',
                },
                <String, dynamic>{
                  'lit': 'planet',
                },
                <String, dynamic>{
                  'var': 'planet_id',
                },
                <String, dynamic>{
                  'lit': 'moon',
                },
                <String, dynamic>{
                  'var': 'id',
                },
              ],
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
              'parts': <dynamic>[
                'api',
                'planet',
                '{planet_id}',
                'moon',
                '{id}',
              ],
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
              'contract': <String, dynamic>{
                'id': 'PUT /api/planet/{planet_id}/moon/{moon_id}',
                'json': '{"parameters":[{"in":"path","name":"planet_id","required":true,"schema":{"type":"string"}},{"in":"path","name":"moon_id","required":true,"schema":{"type":"string"}}],"protocol":"http","requestBody":{"content":{"application/json":{"schema":{"properties":{"diameter":{"format":"float","type":"number"},"id":{"type":"string"},"kind":{"type":"string"},"name":{"type":"string"},"planet_id":{"type":"string"}},"required":["id","name","planet_id","kind","diameter"],"type":"object"}}},"required":true},"responses":{"200":{"content":{"application/json":{"schema":{"properties":{"diameter":{"format":"float","type":"number"},"id":{"type":"string"},"kind":{"type":"string"},"name":{"type":"string"},"planet_id":{"type":"string"}},"required":["id","name","planet_id","kind","diameter"],"type":"object"}}},"description":"OK"}},"securitySource":"unspecified"}',
                'source': 'openapi3',
                'version': 1,
              },
              'kind': 'http',
              'method': 'PUT',
              'orig': '/api/planet/{planet_id}/moon/{moon_id}',
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'moon_id': 'id',
                },
              },
              'segments': <dynamic>[
                <String, dynamic>{
                  'lit': 'api',
                },
                <String, dynamic>{
                  'lit': 'planet',
                },
                <String, dynamic>{
                  'var': 'planet_id',
                },
                <String, dynamic>{
                  'lit': 'moon',
                },
                <String, dynamic>{
                  'var': 'id',
                },
              ],
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
              'parts': <dynamic>[
                'api',
                'planet',
                '{planet_id}',
                'moon',
                '{id}',
              ],
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
          'format': 'float',
          'name': 'diameter',
          'req': true,
          'type': '`\$NUMBER`',
        },
        <String, dynamic>{
          'name': 'forbidReason',
          'readOnly': true,
          'short': 'Why the planet is forbidden, carried from the forbid action\'s `why`.',
          'type': '`\$STRING`',
        },
        <String, dynamic>{
          'name': 'forbidState',
          'readOnly': true,
          'short': 'Set by the forbid action, and absent until it first runs.',
          'type': '`\$STRING`',
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
          'name': 'terraformState',
          'readOnly': true,
          'short': 'Set by the terraform action, and absent until it first runs.',
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
              'contract': <String, dynamic>{
                'id': 'POST /api/planet/{planet_id}/forbid',
                'json': '{"parameters":[{"in":"path","name":"planet_id","required":true,"schema":{"type":"string"}}],"protocol":"http","requestBody":{"content":{"application/json":{"schema":{"properties":{"forbid":{"type":"boolean"},"why":{"type":"string"}},"type":"object"}}},"required":true},"responses":{"200":{"content":{"application/json":{"schema":{"properties":{"ok":{"type":"boolean"},"state":{"type":"string"}},"type":"object"}}},"description":"OK"}},"securitySource":"unspecified"}',
                'source': 'openapi3',
                'version': 1,
              },
              'kind': 'http',
              'method': 'POST',
              'orig': '/api/planet/{planet_id}/forbid',
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'planet_id': 'id',
                },
              },
              'segments': <dynamic>[
                <String, dynamic>{
                  'lit': 'api',
                },
                <String, dynamic>{
                  'lit': 'planet',
                },
                <String, dynamic>{
                  'var': 'id',
                },
                <String, dynamic>{
                  'lit': 'forbid',
                },
              ],
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
              'parts': <dynamic>[
                'api',
                'planet',
                '{id}',
                'forbid',
              ],
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
              'contract': <String, dynamic>{
                'id': 'POST /api/planet/{planet_id}/terraform',
                'json': '{"parameters":[{"in":"path","name":"planet_id","required":true,"schema":{"type":"string"}}],"protocol":"http","requestBody":{"content":{"application/json":{"schema":{"properties":{"start":{"type":"boolean"},"stop":{"type":"boolean"}},"type":"object"}}},"required":true},"responses":{"200":{"content":{"application/json":{"schema":{"properties":{"ok":{"type":"boolean"},"state":{"type":"string"}},"type":"object"}}},"description":"OK"}},"securitySource":"unspecified"}',
                'source': 'openapi3',
                'version': 1,
              },
              'kind': 'http',
              'method': 'POST',
              'orig': '/api/planet/{planet_id}/terraform',
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'planet_id': 'id',
                },
              },
              'segments': <dynamic>[
                <String, dynamic>{
                  'lit': 'api',
                },
                <String, dynamic>{
                  'lit': 'planet',
                },
                <String, dynamic>{
                  'var': 'id',
                },
                <String, dynamic>{
                  'lit': 'terraform',
                },
              ],
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
              'parts': <dynamic>[
                'api',
                'planet',
                '{id}',
                'terraform',
              ],
            },
            <String, dynamic>{
              'args': <String, dynamic>{},
              'contract': <String, dynamic>{
                'id': 'POST /api/planet',
                'json': '{"parameters":[],"protocol":"http","requestBody":{"content":{"application/json":{"schema":{"properties":{"diameter":{"format":"float","type":"number"},"forbidReason":{"description":"Why the planet is forbidden, carried from the forbid action\'s `why`. Absent while the planet is allowed.","readOnly":true,"type":"string"},"forbidState":{"description":"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.","readOnly":true,"type":"string"},"id":{"type":"string"},"kind":{"type":"string"},"name":{"type":"string"},"terraformState":{"description":"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.","readOnly":true,"type":"string"}},"required":["id","name","kind","diameter"],"type":"object"}}},"required":true},"responses":{"201":{"content":{"application/json":{"schema":{"properties":{"diameter":{"format":"float","type":"number"},"forbidReason":{"description":"Why the planet is forbidden, carried from the forbid action\'s `why`. Absent while the planet is allowed.","readOnly":true,"type":"string"},"forbidState":{"description":"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.","readOnly":true,"type":"string"},"id":{"type":"string"},"kind":{"type":"string"},"name":{"type":"string"},"terraformState":{"description":"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.","readOnly":true,"type":"string"}},"required":["id","name","kind","diameter"],"type":"object"}}},"description":"Created"}},"securitySource":"unspecified"}',
                'source': 'openapi3',
                'version': 1,
              },
              'kind': 'http',
              'method': 'POST',
              'orig': '/api/planet',
              'segments': <dynamic>[
                <String, dynamic>{
                  'lit': 'api',
                },
                <String, dynamic>{
                  'lit': 'planet',
                },
              ],
              'select': <String, dynamic>{},
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
              'parts': <dynamic>[
                'api',
                'planet',
              ],
            },
          ],
        },
        'list': <String, dynamic>{
          'input': 'data',
          'name': 'list',
          'points': <dynamic>[
            <String, dynamic>{
              'args': <String, dynamic>{},
              'contract': <String, dynamic>{
                'id': 'GET /api/planet',
                'json': '{"parameters":[],"protocol":"http","responses":{"200":{"content":{"application/json":{"schema":{"items":{"properties":{"diameter":{"format":"float","type":"number"},"forbidReason":{"description":"Why the planet is forbidden, carried from the forbid action\'s `why`. Absent while the planet is allowed.","readOnly":true,"type":"string"},"forbidState":{"description":"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.","readOnly":true,"type":"string"},"id":{"type":"string"},"kind":{"type":"string"},"name":{"type":"string"},"terraformState":{"description":"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.","readOnly":true,"type":"string"}},"required":["id","name","kind","diameter"],"type":"object"},"type":"array"}}},"description":"OK"}},"securitySource":"unspecified"}',
                'source': 'openapi3',
                'version': 1,
              },
              'kind': 'http',
              'method': 'GET',
              'orig': '/api/planet',
              'segments': <dynamic>[
                <String, dynamic>{
                  'lit': 'api',
                },
                <String, dynamic>{
                  'lit': 'planet',
                },
              ],
              'select': <String, dynamic>{},
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
              'parts': <dynamic>[
                'api',
                'planet',
              ],
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
              'contract': <String, dynamic>{
                'id': 'GET /api/planet/{planet_id}',
                'json': '{"parameters":[{"in":"path","name":"planet_id","required":true,"schema":{"type":"string"}}],"protocol":"http","responses":{"200":{"content":{"application/json":{"schema":{"properties":{"diameter":{"format":"float","type":"number"},"forbidReason":{"description":"Why the planet is forbidden, carried from the forbid action\'s `why`. Absent while the planet is allowed.","readOnly":true,"type":"string"},"forbidState":{"description":"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.","readOnly":true,"type":"string"},"id":{"type":"string"},"kind":{"type":"string"},"name":{"type":"string"},"terraformState":{"description":"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.","readOnly":true,"type":"string"}},"required":["id","name","kind","diameter"],"type":"object"}}},"description":"OK"}},"securitySource":"unspecified"}',
                'source': 'openapi3',
                'version': 1,
              },
              'kind': 'http',
              'method': 'GET',
              'orig': '/api/planet/{planet_id}',
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'planet_id': 'id',
                },
              },
              'segments': <dynamic>[
                <String, dynamic>{
                  'lit': 'api',
                },
                <String, dynamic>{
                  'lit': 'planet',
                },
                <String, dynamic>{
                  'var': 'id',
                },
              ],
              'select': <String, dynamic>{
                'exist': <dynamic>[
                  'id',
                ],
              },
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
              'parts': <dynamic>[
                'api',
                'planet',
                '{id}',
              ],
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
              'contract': <String, dynamic>{
                'id': 'DELETE /api/planet/{planet_id}',
                'json': '{"parameters":[{"in":"path","name":"planet_id","required":true,"schema":{"type":"string"}}],"protocol":"http","responses":{"204":{"description":"No Content"}},"securitySource":"unspecified"}',
                'source': 'openapi3',
                'version': 1,
              },
              'kind': 'http',
              'method': 'DELETE',
              'orig': '/api/planet/{planet_id}',
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'planet_id': 'id',
                },
              },
              'segments': <dynamic>[
                <String, dynamic>{
                  'lit': 'api',
                },
                <String, dynamic>{
                  'lit': 'planet',
                },
                <String, dynamic>{
                  'var': 'id',
                },
              ],
              'select': <String, dynamic>{
                'exist': <dynamic>[
                  'id',
                ],
              },
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
              'parts': <dynamic>[
                'api',
                'planet',
                '{id}',
              ],
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
              'contract': <String, dynamic>{
                'id': 'PUT /api/planet/{planet_id}',
                'json': '{"parameters":[{"in":"path","name":"planet_id","required":true,"schema":{"type":"string"}}],"protocol":"http","requestBody":{"content":{"application/json":{"schema":{"properties":{"diameter":{"format":"float","type":"number"},"forbidReason":{"description":"Why the planet is forbidden, carried from the forbid action\'s `why`. Absent while the planet is allowed.","readOnly":true,"type":"string"},"forbidState":{"description":"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.","readOnly":true,"type":"string"},"id":{"type":"string"},"kind":{"type":"string"},"name":{"type":"string"},"terraformState":{"description":"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.","readOnly":true,"type":"string"}},"required":["id","name","kind","diameter"],"type":"object"}}},"required":true},"responses":{"200":{"content":{"application/json":{"schema":{"properties":{"diameter":{"format":"float","type":"number"},"forbidReason":{"description":"Why the planet is forbidden, carried from the forbid action\'s `why`. Absent while the planet is allowed.","readOnly":true,"type":"string"},"forbidState":{"description":"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.","readOnly":true,"type":"string"},"id":{"type":"string"},"kind":{"type":"string"},"name":{"type":"string"},"terraformState":{"description":"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.","readOnly":true,"type":"string"}},"required":["id","name","kind","diameter"],"type":"object"}}},"description":"OK"}},"securitySource":"unspecified"}',
                'source': 'openapi3',
                'version': 1,
              },
              'kind': 'http',
              'method': 'PUT',
              'orig': '/api/planet/{planet_id}',
              'rename': <String, dynamic>{
                'param': <String, dynamic>{
                  'planet_id': 'id',
                },
              },
              'segments': <dynamic>[
                <String, dynamic>{
                  'lit': 'api',
                },
                <String, dynamic>{
                  'lit': 'planet',
                },
                <String, dynamic>{
                  'var': 'id',
                },
              ],
              'select': <String, dynamic>{
                'exist': <dynamic>[
                  'id',
                ],
              },
              'transform': <String, dynamic>{
                'req': '`reqdata`',
                'res': '`body`',
              },
              'parts': <dynamic>[
                'api',
                'planet',
                '{id}',
              ],
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

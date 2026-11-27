// VoxgigSolardemo Dart SDK: the client option spec. Generated; do not edit.
//
// From the model's `main.kit.optspec`; makeOptions validates the options
// against it.

Map<String, dynamic> makeOptspec() => <String, dynamic>{
  'allow': <String, dynamic>{
    'method': 'GET,PUT,POST,PATCH,DELETE,OPTIONS',
    'op': 'create,update,patch,load,list,remove,command,direct,graphql',
  },
  'apikey': '',
  'auth': <String, dynamic>{
    'basic': false,
    'in': '',
    'name': '',
    'prefix': '',
  },
  'base': 'http://localhost:8000',
  'clean': <String, dynamic>{
    'active': true,
    'hint': '0',
    'keys': 'key,secret,token,password,passwd,authorization,cookie,credential,signature',
    'mask': '[redacted]',
    'min': '4',
    'values': '',
  },
  'entity': <String, dynamic>{
    '`\$CHILD`': <String, dynamic>{
      '`\$OPEN`': true,
      'active': false,
      'alias': <String, dynamic>{},
    },
  },
  'extend': '`\$ANY`',
  'headers': <String, dynamic>{
    '`\$CHILD`': '`\$STRING`',
  },
  'prefix': '',
  'secret': '',
  'server': <String, dynamic>{
    '`\$CHILD`': '',
  },
  'suffix': '',
  'system': <String, dynamic>{
    'fetch': '`\$ANY`',
  },
  'test': <String, dynamic>{
    'active': false,
    'entity': <String, dynamic>{
      '`\$OPEN`': true,
    },
  },
  'utility': <String, dynamic>{},
  'feature': <String, dynamic>{
    '`\$CHILD`': <String, dynamic>{
      '`\$OPEN`': true,
      'active': false,
    },
  },
};

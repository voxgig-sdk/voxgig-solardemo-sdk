// Typed models for the Solardemo SDK.
//
// GENERATED from the API model: main.kit.entity.<e>.fields[] and per-op
// params (op.<name>.points[].args.params[]). Field/param types come from the
// canonical type sentinels (source of truth: @voxgig/apidef VALID_CANON).
// Do not edit by hand.
//
// The operation pipeline passes plain maps; these classes are the typed,
// convertible view: `Solardemo.fromMap(ent.data())` / `model.toMap()`.

class Moon {
  /// NUMBER (required at the API)
  num? diameter;
  /// STRING (required at the API)
  String? id;
  /// STRING (required at the API)
  String? kind;
  /// STRING (required at the API)
  String? name;
  /// STRING (required at the API)
  String? planet_id;

  Moon({
    this.diameter,
    this.id,
    this.kind,
    this.name,
    this.planet_id,
  });

  factory Moon.fromMap(Map<String, dynamic> m) => Moon(
        diameter: m['diameter'] is num ? m['diameter'] : null,
        id: m['id'] is String ? m['id'] : null,
        kind: m['kind'] is String ? m['kind'] : null,
        name: m['name'] is String ? m['name'] : null,
        planet_id: m['planet_id'] is String ? m['planet_id'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != diameter) {
      m['diameter'] = diameter;
    }
    if (null != id) {
      m['id'] = id;
    }
    if (null != kind) {
      m['kind'] = kind;
    }
    if (null != name) {
      m['name'] = name;
    }
    if (null != planet_id) {
      m['planet_id'] = planet_id;
    }
    return m;
  }
}

class MoonLoadMatch {
  /// STRING (required at the API)
  String? id;
  /// STRING (required at the API)
  String? planet_id;

  MoonLoadMatch({
    this.id,
    this.planet_id,
  });

  factory MoonLoadMatch.fromMap(Map<String, dynamic> m) => MoonLoadMatch(
        id: m['id'] is String ? m['id'] : null,
        planet_id: m['planet_id'] is String ? m['planet_id'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != id) {
      m['id'] = id;
    }
    if (null != planet_id) {
      m['planet_id'] = planet_id;
    }
    return m;
  }
}

class MoonListMatch {
  /// STRING (required at the API)
  String? planet_id;

  MoonListMatch({
    this.planet_id,
  });

  factory MoonListMatch.fromMap(Map<String, dynamic> m) => MoonListMatch(
        planet_id: m['planet_id'] is String ? m['planet_id'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != planet_id) {
      m['planet_id'] = planet_id;
    }
    return m;
  }
}

class MoonCreateData {
  /// STRING (required at the API)
  String? planet_id;
  /// NUMBER (required at the API)
  num? diameter;
  /// STRING (required at the API)
  String? id;
  /// STRING (required at the API)
  String? kind;
  /// STRING (required at the API)
  String? name;

  MoonCreateData({
    this.planet_id,
    this.diameter,
    this.id,
    this.kind,
    this.name,
  });

  factory MoonCreateData.fromMap(Map<String, dynamic> m) => MoonCreateData(
        planet_id: m['planet_id'] is String ? m['planet_id'] : null,
        diameter: m['diameter'] is num ? m['diameter'] : null,
        id: m['id'] is String ? m['id'] : null,
        kind: m['kind'] is String ? m['kind'] : null,
        name: m['name'] is String ? m['name'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != planet_id) {
      m['planet_id'] = planet_id;
    }
    if (null != diameter) {
      m['diameter'] = diameter;
    }
    if (null != id) {
      m['id'] = id;
    }
    if (null != kind) {
      m['kind'] = kind;
    }
    if (null != name) {
      m['name'] = name;
    }
    return m;
  }
}

class MoonUpdateData {
  /// STRING (required at the API)
  String? id;
  /// STRING (required at the API)
  String? planet_id;
  /// NUMBER
  num? diameter;
  /// STRING
  String? kind;
  /// STRING
  String? name;

  MoonUpdateData({
    this.id,
    this.planet_id,
    this.diameter,
    this.kind,
    this.name,
  });

  factory MoonUpdateData.fromMap(Map<String, dynamic> m) => MoonUpdateData(
        id: m['id'] is String ? m['id'] : null,
        planet_id: m['planet_id'] is String ? m['planet_id'] : null,
        diameter: m['diameter'] is num ? m['diameter'] : null,
        kind: m['kind'] is String ? m['kind'] : null,
        name: m['name'] is String ? m['name'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != id) {
      m['id'] = id;
    }
    if (null != planet_id) {
      m['planet_id'] = planet_id;
    }
    if (null != diameter) {
      m['diameter'] = diameter;
    }
    if (null != kind) {
      m['kind'] = kind;
    }
    if (null != name) {
      m['name'] = name;
    }
    return m;
  }
}

class MoonRemoveMatch {
  /// STRING (required at the API)
  String? id;
  /// STRING (required at the API)
  String? planet_id;

  MoonRemoveMatch({
    this.id,
    this.planet_id,
  });

  factory MoonRemoveMatch.fromMap(Map<String, dynamic> m) => MoonRemoveMatch(
        id: m['id'] is String ? m['id'] : null,
        planet_id: m['planet_id'] is String ? m['planet_id'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != id) {
      m['id'] = id;
    }
    if (null != planet_id) {
      m['planet_id'] = planet_id;
    }
    return m;
  }
}

class Planet {
  /// NUMBER (required at the API)
  num? diameter;
  /// BOOLEAN
  bool? forbid;
  /// STRING (required at the API)
  String? id;
  /// STRING (required at the API)
  String? kind;
  /// STRING (required at the API)
  String? name;
  /// BOOLEAN
  bool? ok;
  /// BOOLEAN
  bool? start;
  /// STRING
  String? state;
  /// BOOLEAN
  bool? stop;
  /// STRING
  String? why;

  Planet({
    this.diameter,
    this.forbid,
    this.id,
    this.kind,
    this.name,
    this.ok,
    this.start,
    this.state,
    this.stop,
    this.why,
  });

  factory Planet.fromMap(Map<String, dynamic> m) => Planet(
        diameter: m['diameter'] is num ? m['diameter'] : null,
        forbid: m['forbid'] is bool ? m['forbid'] : null,
        id: m['id'] is String ? m['id'] : null,
        kind: m['kind'] is String ? m['kind'] : null,
        name: m['name'] is String ? m['name'] : null,
        ok: m['ok'] is bool ? m['ok'] : null,
        start: m['start'] is bool ? m['start'] : null,
        state: m['state'] is String ? m['state'] : null,
        stop: m['stop'] is bool ? m['stop'] : null,
        why: m['why'] is String ? m['why'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != diameter) {
      m['diameter'] = diameter;
    }
    if (null != forbid) {
      m['forbid'] = forbid;
    }
    if (null != id) {
      m['id'] = id;
    }
    if (null != kind) {
      m['kind'] = kind;
    }
    if (null != name) {
      m['name'] = name;
    }
    if (null != ok) {
      m['ok'] = ok;
    }
    if (null != start) {
      m['start'] = start;
    }
    if (null != state) {
      m['state'] = state;
    }
    if (null != stop) {
      m['stop'] = stop;
    }
    if (null != why) {
      m['why'] = why;
    }
    return m;
  }
}

class PlanetLoadMatch {
  /// STRING (required at the API)
  String? id;

  PlanetLoadMatch({
    this.id,
  });

  factory PlanetLoadMatch.fromMap(Map<String, dynamic> m) => PlanetLoadMatch(
        id: m['id'] is String ? m['id'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != id) {
      m['id'] = id;
    }
    return m;
  }
}

class PlanetListMatch {
  /// NUMBER
  num? diameter;
  /// BOOLEAN
  bool? forbid;
  /// STRING
  String? id;
  /// STRING
  String? kind;
  /// STRING
  String? name;
  /// BOOLEAN
  bool? ok;
  /// BOOLEAN
  bool? start;
  /// STRING
  String? state;
  /// BOOLEAN
  bool? stop;
  /// STRING
  String? why;

  PlanetListMatch({
    this.diameter,
    this.forbid,
    this.id,
    this.kind,
    this.name,
    this.ok,
    this.start,
    this.state,
    this.stop,
    this.why,
  });

  factory PlanetListMatch.fromMap(Map<String, dynamic> m) => PlanetListMatch(
        diameter: m['diameter'] is num ? m['diameter'] : null,
        forbid: m['forbid'] is bool ? m['forbid'] : null,
        id: m['id'] is String ? m['id'] : null,
        kind: m['kind'] is String ? m['kind'] : null,
        name: m['name'] is String ? m['name'] : null,
        ok: m['ok'] is bool ? m['ok'] : null,
        start: m['start'] is bool ? m['start'] : null,
        state: m['state'] is String ? m['state'] : null,
        stop: m['stop'] is bool ? m['stop'] : null,
        why: m['why'] is String ? m['why'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != diameter) {
      m['diameter'] = diameter;
    }
    if (null != forbid) {
      m['forbid'] = forbid;
    }
    if (null != id) {
      m['id'] = id;
    }
    if (null != kind) {
      m['kind'] = kind;
    }
    if (null != name) {
      m['name'] = name;
    }
    if (null != ok) {
      m['ok'] = ok;
    }
    if (null != start) {
      m['start'] = start;
    }
    if (null != state) {
      m['state'] = state;
    }
    if (null != stop) {
      m['stop'] = stop;
    }
    if (null != why) {
      m['why'] = why;
    }
    return m;
  }
}

class PlanetCreateData {
  /// NUMBER (required at the API)
  num? diameter;
  /// BOOLEAN
  bool? forbid;
  /// STRING (required at the API)
  String? id;
  /// STRING (required at the API)
  String? kind;
  /// STRING (required at the API)
  String? name;
  /// BOOLEAN
  bool? ok;
  /// BOOLEAN
  bool? start;
  /// STRING
  String? state;
  /// BOOLEAN
  bool? stop;
  /// STRING
  String? why;

  PlanetCreateData({
    this.diameter,
    this.forbid,
    this.id,
    this.kind,
    this.name,
    this.ok,
    this.start,
    this.state,
    this.stop,
    this.why,
  });

  factory PlanetCreateData.fromMap(Map<String, dynamic> m) => PlanetCreateData(
        diameter: m['diameter'] is num ? m['diameter'] : null,
        forbid: m['forbid'] is bool ? m['forbid'] : null,
        id: m['id'] is String ? m['id'] : null,
        kind: m['kind'] is String ? m['kind'] : null,
        name: m['name'] is String ? m['name'] : null,
        ok: m['ok'] is bool ? m['ok'] : null,
        start: m['start'] is bool ? m['start'] : null,
        state: m['state'] is String ? m['state'] : null,
        stop: m['stop'] is bool ? m['stop'] : null,
        why: m['why'] is String ? m['why'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != diameter) {
      m['diameter'] = diameter;
    }
    if (null != forbid) {
      m['forbid'] = forbid;
    }
    if (null != id) {
      m['id'] = id;
    }
    if (null != kind) {
      m['kind'] = kind;
    }
    if (null != name) {
      m['name'] = name;
    }
    if (null != ok) {
      m['ok'] = ok;
    }
    if (null != start) {
      m['start'] = start;
    }
    if (null != state) {
      m['state'] = state;
    }
    if (null != stop) {
      m['stop'] = stop;
    }
    if (null != why) {
      m['why'] = why;
    }
    return m;
  }
}

class PlanetUpdateData {
  /// STRING (required at the API)
  String? id;
  /// NUMBER
  num? diameter;
  /// BOOLEAN
  bool? forbid;
  /// STRING
  String? kind;
  /// STRING
  String? name;
  /// BOOLEAN
  bool? ok;
  /// BOOLEAN
  bool? start;
  /// STRING
  String? state;
  /// BOOLEAN
  bool? stop;
  /// STRING
  String? why;

  PlanetUpdateData({
    this.id,
    this.diameter,
    this.forbid,
    this.kind,
    this.name,
    this.ok,
    this.start,
    this.state,
    this.stop,
    this.why,
  });

  factory PlanetUpdateData.fromMap(Map<String, dynamic> m) => PlanetUpdateData(
        id: m['id'] is String ? m['id'] : null,
        diameter: m['diameter'] is num ? m['diameter'] : null,
        forbid: m['forbid'] is bool ? m['forbid'] : null,
        kind: m['kind'] is String ? m['kind'] : null,
        name: m['name'] is String ? m['name'] : null,
        ok: m['ok'] is bool ? m['ok'] : null,
        start: m['start'] is bool ? m['start'] : null,
        state: m['state'] is String ? m['state'] : null,
        stop: m['stop'] is bool ? m['stop'] : null,
        why: m['why'] is String ? m['why'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != id) {
      m['id'] = id;
    }
    if (null != diameter) {
      m['diameter'] = diameter;
    }
    if (null != forbid) {
      m['forbid'] = forbid;
    }
    if (null != kind) {
      m['kind'] = kind;
    }
    if (null != name) {
      m['name'] = name;
    }
    if (null != ok) {
      m['ok'] = ok;
    }
    if (null != start) {
      m['start'] = start;
    }
    if (null != state) {
      m['state'] = state;
    }
    if (null != stop) {
      m['stop'] = stop;
    }
    if (null != why) {
      m['why'] = why;
    }
    return m;
  }
}

class PlanetRemoveMatch {
  /// STRING (required at the API)
  String? id;

  PlanetRemoveMatch({
    this.id,
  });

  factory PlanetRemoveMatch.fromMap(Map<String, dynamic> m) => PlanetRemoveMatch(
        id: m['id'] is String ? m['id'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != id) {
      m['id'] = id;
    }
    return m;
  }
}


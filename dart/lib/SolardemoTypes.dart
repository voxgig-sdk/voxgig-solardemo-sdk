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
  /// STRING
  String? forbidReason;
  /// STRING
  String? forbidState;
  /// STRING (required at the API)
  String? id;
  /// STRING (required at the API)
  String? kind;
  /// STRING (required at the API)
  String? name;
  /// STRING
  String? terraformState;

  Planet({
    this.diameter,
    this.forbidReason,
    this.forbidState,
    this.id,
    this.kind,
    this.name,
    this.terraformState,
  });

  factory Planet.fromMap(Map<String, dynamic> m) => Planet(
        diameter: m['diameter'] is num ? m['diameter'] : null,
        forbidReason: m['forbidReason'] is String ? m['forbidReason'] : null,
        forbidState: m['forbidState'] is String ? m['forbidState'] : null,
        id: m['id'] is String ? m['id'] : null,
        kind: m['kind'] is String ? m['kind'] : null,
        name: m['name'] is String ? m['name'] : null,
        terraformState: m['terraformState'] is String ? m['terraformState'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != diameter) {
      m['diameter'] = diameter;
    }
    if (null != forbidReason) {
      m['forbidReason'] = forbidReason;
    }
    if (null != forbidState) {
      m['forbidState'] = forbidState;
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
    if (null != terraformState) {
      m['terraformState'] = terraformState;
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
  /// STRING
  String? forbidReason;
  /// STRING
  String? forbidState;
  /// STRING
  String? id;
  /// STRING
  String? kind;
  /// STRING
  String? name;
  /// STRING
  String? terraformState;

  PlanetListMatch({
    this.diameter,
    this.forbidReason,
    this.forbidState,
    this.id,
    this.kind,
    this.name,
    this.terraformState,
  });

  factory PlanetListMatch.fromMap(Map<String, dynamic> m) => PlanetListMatch(
        diameter: m['diameter'] is num ? m['diameter'] : null,
        forbidReason: m['forbidReason'] is String ? m['forbidReason'] : null,
        forbidState: m['forbidState'] is String ? m['forbidState'] : null,
        id: m['id'] is String ? m['id'] : null,
        kind: m['kind'] is String ? m['kind'] : null,
        name: m['name'] is String ? m['name'] : null,
        terraformState: m['terraformState'] is String ? m['terraformState'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != diameter) {
      m['diameter'] = diameter;
    }
    if (null != forbidReason) {
      m['forbidReason'] = forbidReason;
    }
    if (null != forbidState) {
      m['forbidState'] = forbidState;
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
    if (null != terraformState) {
      m['terraformState'] = terraformState;
    }
    return m;
  }
}

class PlanetCreateData {
  /// NUMBER (required at the API)
  num? diameter;
  /// STRING
  String? forbidReason;
  /// STRING
  String? forbidState;
  /// STRING (required at the API)
  String? id;
  /// STRING (required at the API)
  String? kind;
  /// STRING (required at the API)
  String? name;
  /// STRING
  String? terraformState;

  PlanetCreateData({
    this.diameter,
    this.forbidReason,
    this.forbidState,
    this.id,
    this.kind,
    this.name,
    this.terraformState,
  });

  factory PlanetCreateData.fromMap(Map<String, dynamic> m) => PlanetCreateData(
        diameter: m['diameter'] is num ? m['diameter'] : null,
        forbidReason: m['forbidReason'] is String ? m['forbidReason'] : null,
        forbidState: m['forbidState'] is String ? m['forbidState'] : null,
        id: m['id'] is String ? m['id'] : null,
        kind: m['kind'] is String ? m['kind'] : null,
        name: m['name'] is String ? m['name'] : null,
        terraformState: m['terraformState'] is String ? m['terraformState'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != diameter) {
      m['diameter'] = diameter;
    }
    if (null != forbidReason) {
      m['forbidReason'] = forbidReason;
    }
    if (null != forbidState) {
      m['forbidState'] = forbidState;
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
    if (null != terraformState) {
      m['terraformState'] = terraformState;
    }
    return m;
  }
}

class PlanetUpdateData {
  /// STRING (required at the API)
  String? id;
  /// NUMBER
  num? diameter;
  /// STRING
  String? forbidReason;
  /// STRING
  String? forbidState;
  /// STRING
  String? kind;
  /// STRING
  String? name;
  /// STRING
  String? terraformState;

  PlanetUpdateData({
    this.id,
    this.diameter,
    this.forbidReason,
    this.forbidState,
    this.kind,
    this.name,
    this.terraformState,
  });

  factory PlanetUpdateData.fromMap(Map<String, dynamic> m) => PlanetUpdateData(
        id: m['id'] is String ? m['id'] : null,
        diameter: m['diameter'] is num ? m['diameter'] : null,
        forbidReason: m['forbidReason'] is String ? m['forbidReason'] : null,
        forbidState: m['forbidState'] is String ? m['forbidState'] : null,
        kind: m['kind'] is String ? m['kind'] : null,
        name: m['name'] is String ? m['name'] : null,
        terraformState: m['terraformState'] is String ? m['terraformState'] : null,
      );

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{};
    if (null != id) {
      m['id'] = id;
    }
    if (null != diameter) {
      m['diameter'] = diameter;
    }
    if (null != forbidReason) {
      m['forbidReason'] = forbidReason;
    }
    if (null != forbidState) {
      m['forbidState'] = forbidState;
    }
    if (null != kind) {
      m['kind'] = kind;
    }
    if (null != name) {
      m['name'] = name;
    }
    if (null != terraformState) {
      m['terraformState'] = terraformState;
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


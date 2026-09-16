(* Generated API configuration (mirrors go core/config.go).
 *
 * make_config () — the embedded API model as a voxgig struct value.
 * make_feature name — the N-feature-safe factory the client uses. *)

open Voxgig_struct
open Sdk_types
open Sdk_helpers
open Sdk_features

let make_config () : value =
  (jo [
    ("main", (jo [
      ("name", (Str "Solardemo"));
      ("slug", (Str "solardemo"));
      ("version", (Str "0.1.0"));
      ("target", (Str "ocaml")) ]));
    ("feature", (jo [
      ("test", (jo [
        ("options", (jo [
          ("active", (Bool false)) ]));
        ("transport", (Str "base")) ])) ]));
    ("options", (jo [
      ("base", (Str "http://localhost:8901"));
      ("headers", (jo [
        ("content-type", (Str "application/json")) ]));
      ("entity", (jo [
        ("moon", (empty_map ()));
        ("planet", (empty_map ())) ])) ]));
    ("entity", (jo [
      ("moon", (jo [
        ("fields", (ja [
          (jo [
            ("format", (Str "float"));
            ("name", (Str "diameter"));
            ("req", (Bool true));
            ("type", (Str "`$NUMBER`")) ]);
          (jo [
            ("name", (Str "id"));
            ("req", (Bool true));
            ("type", (Str "`$STRING`")) ]);
          (jo [
            ("name", (Str "kind"));
            ("req", (Bool true));
            ("type", (Str "`$STRING`")) ]);
          (jo [
            ("name", (Str "name"));
            ("req", (Bool true));
            ("type", (Str "`$STRING`")) ]);
          (jo [
            ("name", (Str "planet_id"));
            ("req", (Bool true));
            ("type", (Str "`$STRING`")) ]) ]));
        ("name", (Str "moon"));
        ("op", (jo [
          ("create", (jo [
            ("input", (Str "data"));
            ("name", (Str "create"));
            ("points", (ja [
              (jo [
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "planet_id"));
                      ("orig", (Str "planet_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]) ])) ]));
                ("contract", (jo [
                  ("id", (Str "POST /api/planet/{planet_id}/moon"));
                  ("json", (Str "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"201\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"Created\"}},\"securitySource\":\"unspecified\"}"));
                  ("source", (Str "openapi3"));
                  ("version", (Num (1.))) ]));
                ("kind", (Str "http"));
                ("method", (Str "POST"));
                ("orig", (Str "/api/planet/{planet_id}/moon"));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "planet_id")) ]);
                  (jo [
                    ("lit", (Str "moon")) ]) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "planet_id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon") ])) ]) ])) ]));
          ("list", (jo [
            ("input", (Str "data"));
            ("name", (Str "list"));
            ("points", (ja [
              (jo [
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "planet_id"));
                      ("orig", (Str "planet_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]) ])) ]));
                ("contract", (jo [
                  ("id", (Str "GET /api/planet/{planet_id}/moon"));
                  ("json", (Str "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"items\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"},\"type\":\"array\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}"));
                  ("source", (Str "openapi3"));
                  ("version", (Num (1.))) ]));
                ("kind", (Str "http"));
                ("method", (Str "GET"));
                ("orig", (Str "/api/planet/{planet_id}/moon"));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "planet_id")) ]);
                  (jo [
                    ("lit", (Str "moon")) ]) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "planet_id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon") ])) ]) ])) ]));
          ("load", (jo [
            ("input", (Str "data"));
            ("name", (Str "load"));
            ("points", (ja [
              (jo [
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "id"));
                      ("orig", (Str "moon_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]);
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "planet_id"));
                      ("orig", (Str "planet_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]) ])) ]));
                ("contract", (jo [
                  ("id", (Str "GET /api/planet/{planet_id}/moon/{moon_id}"));
                  ("json", (Str "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}},{\"in\":\"path\",\"name\":\"moon_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}"));
                  ("source", (Str "openapi3"));
                  ("version", (Num (1.))) ]));
                ("kind", (Str "http"));
                ("method", (Str "GET"));
                ("orig", (Str "/api/planet/{planet_id}/moon/{moon_id}"));
                ("rename", (jo [
                  ("param", (jo [
                    ("moon_id", (Str "id")) ])) ]));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "planet_id")) ]);
                  (jo [
                    ("lit", (Str "moon")) ]);
                  (jo [
                    ("var", (Str "id")) ]) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id");
                    (Str "planet_id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon");
                  (Str "{id}") ])) ]) ])) ]));
          ("remove", (jo [
            ("input", (Str "data"));
            ("name", (Str "remove"));
            ("points", (ja [
              (jo [
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "id"));
                      ("orig", (Str "moon_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]);
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "planet_id"));
                      ("orig", (Str "planet_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]) ])) ]));
                ("contract", (jo [
                  ("id", (Str "DELETE /api/planet/{planet_id}/moon/{moon_id}"));
                  ("json", (Str "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}},{\"in\":\"path\",\"name\":\"moon_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"204\":{\"description\":\"No Content\"}},\"securitySource\":\"unspecified\"}"));
                  ("source", (Str "openapi3"));
                  ("version", (Num (1.))) ]));
                ("kind", (Str "http"));
                ("method", (Str "DELETE"));
                ("orig", (Str "/api/planet/{planet_id}/moon/{moon_id}"));
                ("rename", (jo [
                  ("param", (jo [
                    ("moon_id", (Str "id")) ])) ]));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "planet_id")) ]);
                  (jo [
                    ("lit", (Str "moon")) ]);
                  (jo [
                    ("var", (Str "id")) ]) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id");
                    (Str "planet_id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon");
                  (Str "{id}") ])) ]) ])) ]));
          ("update", (jo [
            ("input", (Str "data"));
            ("name", (Str "update"));
            ("points", (ja [
              (jo [
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "id"));
                      ("orig", (Str "moon_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]);
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "planet_id"));
                      ("orig", (Str "planet_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]) ])) ]));
                ("contract", (jo [
                  ("id", (Str "PUT /api/planet/{planet_id}/moon/{moon_id}"));
                  ("json", (Str "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}},{\"in\":\"path\",\"name\":\"moon_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}"));
                  ("source", (Str "openapi3"));
                  ("version", (Num (1.))) ]));
                ("kind", (Str "http"));
                ("method", (Str "PUT"));
                ("orig", (Str "/api/planet/{planet_id}/moon/{moon_id}"));
                ("rename", (jo [
                  ("param", (jo [
                    ("moon_id", (Str "id")) ])) ]));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "planet_id")) ]);
                  (jo [
                    ("lit", (Str "moon")) ]);
                  (jo [
                    ("var", (Str "id")) ]) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id");
                    (Str "planet_id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon");
                  (Str "{id}") ])) ]) ])) ])) ]));
        ("relations", (jo [
          ("ancestors", (ja [
            (ja [
              (Str "planet") ]) ])) ])) ]));
      ("planet", (jo [
        ("fields", (ja [
          (jo [
            ("format", (Str "float"));
            ("name", (Str "diameter"));
            ("req", (Bool true));
            ("type", (Str "`$NUMBER`")) ]);
          (jo [
            ("name", (Str "forbidReason"));
            ("readOnly", (Bool true));
            ("short", (Str "Why the planet is forbidden, carried from the forbid action's `why`."));
            ("type", (Str "`$STRING`")) ]);
          (jo [
            ("name", (Str "forbidState"));
            ("readOnly", (Bool true));
            ("short", (Str "Set by the forbid action, and absent until it first runs."));
            ("type", (Str "`$STRING`")) ]);
          (jo [
            ("name", (Str "id"));
            ("req", (Bool true));
            ("type", (Str "`$STRING`")) ]);
          (jo [
            ("name", (Str "kind"));
            ("req", (Bool true));
            ("type", (Str "`$STRING`")) ]);
          (jo [
            ("name", (Str "name"));
            ("req", (Bool true));
            ("type", (Str "`$STRING`")) ]);
          (jo [
            ("name", (Str "terraformState"));
            ("readOnly", (Bool true));
            ("short", (Str "Set by the terraform action, and absent until it first runs."));
            ("type", (Str "`$STRING`")) ]) ]));
        ("name", (Str "planet"));
        ("op", (jo [
          ("create", (jo [
            ("input", (Str "data"));
            ("name", (Str "create"));
            ("points", (ja [
              (jo [
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "id"));
                      ("orig", (Str "planet_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]) ])) ]));
                ("contract", (jo [
                  ("id", (Str "POST /api/planet/{planet_id}/forbid"));
                  ("json", (Str "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"forbid\":{\"type\":\"boolean\"},\"why\":{\"type\":\"string\"}},\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"ok\":{\"type\":\"boolean\"},\"state\":{\"type\":\"string\"}},\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}"));
                  ("source", (Str "openapi3"));
                  ("version", (Num (1.))) ]));
                ("kind", (Str "http"));
                ("method", (Str "POST"));
                ("orig", (Str "/api/planet/{planet_id}/forbid"));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "id")) ]);
                  (jo [
                    ("lit", (Str "forbid")) ]) ]));
                ("select", (jo [
                  ("$action", (Str "forbid"));
                  ("exist", (ja [
                    (Str "id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}");
                  (Str "forbid") ])) ]);
              (jo [
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "id"));
                      ("orig", (Str "planet_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]) ])) ]));
                ("contract", (jo [
                  ("id", (Str "POST /api/planet/{planet_id}/terraform"));
                  ("json", (Str "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"start\":{\"type\":\"boolean\"},\"stop\":{\"type\":\"boolean\"}},\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"ok\":{\"type\":\"boolean\"},\"state\":{\"type\":\"string\"}},\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}"));
                  ("source", (Str "openapi3"));
                  ("version", (Num (1.))) ]));
                ("kind", (Str "http"));
                ("method", (Str "POST"));
                ("orig", (Str "/api/planet/{planet_id}/terraform"));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "id")) ]);
                  (jo [
                    ("lit", (Str "terraform")) ]) ]));
                ("select", (jo [
                  ("$action", (Str "terraform"));
                  ("exist", (ja [
                    (Str "id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}");
                  (Str "terraform") ])) ]);
              (jo [
                ("args", (empty_map ()));
                ("contract", (jo [
                  ("id", (Str "POST /api/planet"));
                  ("json", (Str "{\"parameters\":[],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"201\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"Created\"}},\"securitySource\":\"unspecified\"}"));
                  ("source", (Str "openapi3"));
                  ("version", (Num (1.))) ]));
                ("kind", (Str "http"));
                ("method", (Str "POST"));
                ("orig", (Str "/api/planet"));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]) ]));
                ("select", (empty_map ()));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet") ])) ]) ])) ]));
          ("list", (jo [
            ("input", (Str "data"));
            ("name", (Str "list"));
            ("points", (ja [
              (jo [
                ("args", (empty_map ()));
                ("contract", (jo [
                  ("id", (Str "GET /api/planet"));
                  ("json", (Str "{\"parameters\":[],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"items\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"},\"type\":\"array\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}"));
                  ("source", (Str "openapi3"));
                  ("version", (Num (1.))) ]));
                ("kind", (Str "http"));
                ("method", (Str "GET"));
                ("orig", (Str "/api/planet"));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]) ]));
                ("select", (empty_map ()));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet") ])) ]) ])) ]));
          ("load", (jo [
            ("input", (Str "data"));
            ("name", (Str "load"));
            ("points", (ja [
              (jo [
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "id"));
                      ("orig", (Str "planet_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]) ])) ]));
                ("contract", (jo [
                  ("id", (Str "GET /api/planet/{planet_id}"));
                  ("json", (Str "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}"));
                  ("source", (Str "openapi3"));
                  ("version", (Num (1.))) ]));
                ("kind", (Str "http"));
                ("method", (Str "GET"));
                ("orig", (Str "/api/planet/{planet_id}"));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "id")) ]) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}") ])) ]) ])) ]));
          ("remove", (jo [
            ("input", (Str "data"));
            ("name", (Str "remove"));
            ("points", (ja [
              (jo [
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "id"));
                      ("orig", (Str "planet_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]) ])) ]));
                ("contract", (jo [
                  ("id", (Str "DELETE /api/planet/{planet_id}"));
                  ("json", (Str "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"204\":{\"description\":\"No Content\"}},\"securitySource\":\"unspecified\"}"));
                  ("source", (Str "openapi3"));
                  ("version", (Num (1.))) ]));
                ("kind", (Str "http"));
                ("method", (Str "DELETE"));
                ("orig", (Str "/api/planet/{planet_id}"));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "id")) ]) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}") ])) ]) ])) ]));
          ("update", (jo [
            ("input", (Str "data"));
            ("name", (Str "update"));
            ("points", (ja [
              (jo [
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "id"));
                      ("orig", (Str "planet_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]) ])) ]));
                ("contract", (jo [
                  ("id", (Str "PUT /api/planet/{planet_id}"));
                  ("json", (Str "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}"));
                  ("source", (Str "openapi3"));
                  ("version", (Num (1.))) ]));
                ("kind", (Str "http"));
                ("method", (Str "PUT"));
                ("orig", (Str "/api/planet/{planet_id}"));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "id")) ]) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}") ])) ]) ])) ])) ]));
        ("relations", (jo [
          ("ancestors", (empty_list ())) ])) ])) ])) ])

let make_feature (name : string) : feature =
  match name with
  | "test" -> test_feature ()
  | _ -> base_feature ()

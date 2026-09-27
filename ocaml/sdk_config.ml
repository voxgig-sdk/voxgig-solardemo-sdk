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
      ("name", (Str "VoxgigSolardemo"));
      ("slug", (Str "voxgig-solardemo"));
      ("version", (Str "0.1.0"));
      ("target", (Str "ocaml")) ]));
    ("feature", (jo [
      ("debug", (jo [
        ("options", (jo [
          ("active", (Bool false));
          ("max", (Num (100.)));
          ("redact", (ja [
            (Str "authorization");
            (Str "cookie");
            (Str "set-cookie");
            (Str "api-key");
            (Str "apikey");
            (Str "x-api-key");
            (Str "idempotency-key") ])) ]));
        ("optspec", (jo [
          ("now", (Str "`$FUNCTION`"));
          ("onEntry", (Str "`$FUNCTION`")) ]));
        ("strict", (Bool false));
        ("transport", (Str "none")) ]));
      ("idempotency", (jo [
        ("options", (jo [
          ("active", (Bool false));
          ("header", (Str "Idempotency-Key"));
          ("methods", (ja [
            (Str "POST");
            (Str "PUT");
            (Str "PATCH");
            (Str "DELETE") ]));
          ("ops", (ja [
            (Str "create");
            (Str "update");
            (Str "remove") ])) ]));
        ("optspec", (jo [
          ("keygen", (Str "`$FUNCTION`")) ]));
        ("strict", (Bool false));
        ("transport", (Str "none")) ]));
      ("metrics", (jo [
        ("options", (jo [
          ("active", (Bool false)) ]));
        ("optspec", (jo [
          ("now", (Str "`$FUNCTION`")) ]));
        ("strict", (Bool false));
        ("transport", (Str "none")) ]));
      ("paging", (jo [
        ("options", (jo [
          ("active", (Bool false));
          ("afterVar", (Str "after"));
          ("cursorParam", (Str "cursor"));
          ("firstVar", (Str "first"));
          ("limitParam", (Str "limit"));
          ("pageParam", (Str "page"));
          ("startPage", (Num (1.))) ]));
        ("optspec", (jo [
          ("limit", (Str "`$NUMBER`"));
          ("ops", (Str "`$LIST`")) ]));
        ("strict", (Bool false));
        ("transport", (Str "none")) ]));
      ("ratelimit", (jo [
        ("options", (jo [
          ("active", (Bool false));
          ("burst", (Num (5.)));
          ("rate", (Num (5.))) ]));
        ("optspec", (jo [
          ("now", (Str "`$FUNCTION`"));
          ("sleep", (Str "`$FUNCTION`")) ]));
        ("strict", (Bool false));
        ("transport", (Str "wrap")) ]));
      ("retry", (jo [
        ("options", (jo [
          ("active", (Bool false));
          ("factor", (Num (2.)));
          ("maxDelay", (Num (2000.)));
          ("minDelay", (Num (50.)));
          ("retries", (Num (2.)));
          ("statuses", (ja [
            (Num (408.));
            (Num (425.));
            (Num (429.));
            (Num (500.));
            (Num (502.));
            (Num (503.));
            (Num (504.)) ])) ]));
        ("optspec", (jo [
          ("jitter", (Str "`$BOOLEAN`"));
          ("sleep", (Str "`$FUNCTION`")) ]));
        ("strict", (Bool false));
        ("transport", (Str "wrap")) ]));
      ("secrets", (jo [
        ("options", (jo [
          ("active", (Bool false));
          ("cache", (Bool true));
          ("exchange", (jo [
            ("active", (Bool false));
            ("method", (Str "POST"));
            ("path", (Str "auth/token"));
            ("refresh", (Str ""));
            ("request", (Str "refresh_token"));
            ("response", (Str "access_token"));
            ("retries", (Num (1.)));
            ("statuses", (ja [
              (Num (401.)) ])) ]));
          ("name", (Str "apikey"));
          ("providers", (empty_list ())) ]));
        ("optspec", (empty_map ()));
        ("strict", (Bool false));
        ("transport", (Str "wrap")) ]));
      ("test", (jo [
        ("options", (jo [
          ("active", (Bool false)) ]));
        ("optspec", (jo [
          ("entity", (Str "`$MAP`"));
          ("net", (Str "`$MAP`")) ]));
        ("strict", (Bool false));
        ("transport", (Str "base")) ]));
      ("timeout", (jo [
        ("options", (jo [
          ("active", (Bool false));
          ("ms", (Num (30000.))) ]));
        ("optspec", (jo [
          ("clearTimer", (Str "`$FUNCTION`"));
          ("setTimer", (Str "`$FUNCTION`")) ]));
        ("strict", (Bool false));
        ("transport", (Str "wrap")) ])) ]));
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
            ("name", (Str "diameter"));
            ("title", (Str "Diameter"));
            ("type", (Str "`$NUMBER`"));
            ("req", (Bool true));
            ("format", (Str "float")) ]);
          (jo [
            ("name", (Str "id"));
            ("title", (Str "Id"));
            ("type", (Str "`$STRING`"));
            ("req", (Bool true)) ]);
          (jo [
            ("name", (Str "kind"));
            ("title", (Str "Kind"));
            ("type", (Str "`$STRING`"));
            ("req", (Bool true)) ]);
          (jo [
            ("name", (Str "name"));
            ("title", (Str "Name"));
            ("type", (Str "`$STRING`"));
            ("req", (Bool true)) ]);
          (jo [
            ("name", (Str "planet_id"));
            ("title", (Str "Planet Id"));
            ("type", (Str "`$STRING`"));
            ("req", (Bool true)) ]) ]));
        ("id", (jo [
          ("field", (Str "id"));
          ("name", (Str "id")) ]));
        ("name", (Str "moon"));
        ("op", (jo [
          ("create", (jo [
            ("input", (Str "data"));
            ("name", (Str "create"));
            ("points", (ja [
              (jo [
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
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon") ]));
                ("rename", (empty_map ()));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("name", (Str "planet_id"));
                      ("orig", (Str "planet_id"));
                      ("type", (Str "`$STRING`"));
                      ("kind", (Str "param"));
                      ("reqd", (Bool true)) ]) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "planet_id") ])) ])) ]) ])) ]));
          ("list", (jo [
            ("input", (Str "data"));
            ("name", (Str "list"));
            ("points", (ja [
              (jo [
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
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon") ]));
                ("rename", (empty_map ()));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("name", (Str "planet_id"));
                      ("orig", (Str "planet_id"));
                      ("type", (Str "`$STRING`"));
                      ("kind", (Str "param"));
                      ("reqd", (Bool true)) ]) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "planet_id") ])) ])) ]) ])) ]));
          ("load", (jo [
            ("input", (Str "data"));
            ("name", (Str "load"));
            ("points", (ja [
              (jo [
                ("kind", (Str "http"));
                ("method", (Str "GET"));
                ("orig", (Str "/api/planet/{planet_id}/moon/{moon_id}"));
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
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon");
                  (Str "{id}") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("moon_id", (Str "id")) ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("name", (Str "id"));
                      ("orig", (Str "moon_id"));
                      ("type", (Str "`$STRING`"));
                      ("kind", (Str "param"));
                      ("reqd", (Bool true)) ]);
                    (jo [
                      ("name", (Str "planet_id"));
                      ("orig", (Str "planet_id"));
                      ("type", (Str "`$STRING`"));
                      ("kind", (Str "param"));
                      ("reqd", (Bool true)) ]) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id");
                    (Str "planet_id") ])) ])) ]) ])) ]));
          ("remove", (jo [
            ("input", (Str "data"));
            ("name", (Str "remove"));
            ("points", (ja [
              (jo [
                ("kind", (Str "http"));
                ("method", (Str "DELETE"));
                ("orig", (Str "/api/planet/{planet_id}/moon/{moon_id}"));
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
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon");
                  (Str "{id}") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("moon_id", (Str "id")) ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("name", (Str "id"));
                      ("orig", (Str "moon_id"));
                      ("type", (Str "`$STRING`"));
                      ("kind", (Str "param"));
                      ("reqd", (Bool true)) ]);
                    (jo [
                      ("name", (Str "planet_id"));
                      ("orig", (Str "planet_id"));
                      ("type", (Str "`$STRING`"));
                      ("kind", (Str "param"));
                      ("reqd", (Bool true)) ]) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id");
                    (Str "planet_id") ])) ])) ]) ])) ]));
          ("update", (jo [
            ("input", (Str "data"));
            ("name", (Str "update"));
            ("points", (ja [
              (jo [
                ("kind", (Str "http"));
                ("method", (Str "PUT"));
                ("orig", (Str "/api/planet/{planet_id}/moon/{moon_id}"));
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
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon");
                  (Str "{id}") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("moon_id", (Str "id")) ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("name", (Str "id"));
                      ("orig", (Str "moon_id"));
                      ("type", (Str "`$STRING`"));
                      ("kind", (Str "param"));
                      ("reqd", (Bool true)) ]);
                    (jo [
                      ("name", (Str "planet_id"));
                      ("orig", (Str "planet_id"));
                      ("type", (Str "`$STRING`"));
                      ("kind", (Str "param"));
                      ("reqd", (Bool true)) ]) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id");
                    (Str "planet_id") ])) ])) ]) ])) ])) ]));
        ("relations", (jo [
          ("ancestors", (ja [
            (ja [
              (Str "$.main.kit.entity.planet") ]) ])) ])) ]));
      ("planet", (jo [
        ("fields", (ja [
          (jo [
            ("name", (Str "diameter"));
            ("title", (Str "Diameter"));
            ("type", (Str "`$NUMBER`"));
            ("req", (Bool true));
            ("format", (Str "float")) ]);
          (jo [
            ("name", (Str "forbidReason"));
            ("title", (Str "Forbid Reason"));
            ("type", (Str "`$STRING`"));
            ("short", (Str "Why the planet is forbidden, carried from the forbid action's `why`."));
            ("readOnly", (Bool true)) ]);
          (jo [
            ("name", (Str "forbidState"));
            ("title", (Str "Forbid State"));
            ("type", (Str "`$STRING`"));
            ("short", (Str "Set by the forbid action, and absent until it first runs."));
            ("readOnly", (Bool true)) ]);
          (jo [
            ("name", (Str "id"));
            ("title", (Str "Id"));
            ("type", (Str "`$STRING`"));
            ("req", (Bool true)) ]);
          (jo [
            ("name", (Str "kind"));
            ("title", (Str "Kind"));
            ("type", (Str "`$STRING`"));
            ("req", (Bool true)) ]);
          (jo [
            ("name", (Str "name"));
            ("title", (Str "Name"));
            ("type", (Str "`$STRING`"));
            ("req", (Bool true)) ]);
          (jo [
            ("name", (Str "terraformState"));
            ("title", (Str "Terraform State"));
            ("type", (Str "`$STRING`"));
            ("short", (Str "Set by the terraform action, and absent until it first runs."));
            ("readOnly", (Bool true)) ]) ]));
        ("id", (jo [
          ("field", (Str "id"));
          ("name", (Str "id")) ]));
        ("name", (Str "planet"));
        ("op", (jo [
          ("create", (jo [
            ("input", (Str "data"));
            ("name", (Str "create"));
            ("points", (ja [
              (jo [
                ("kind", (Str "http"));
                ("method", (Str "POST"));
                ("orig", (Str "/api/planet/{planet_id}/forbid"));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "id")) ]);
                  (jo [
                    ("lit", (Str "forbid")) ]) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}");
                  (Str "forbid") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("name", (Str "id"));
                      ("orig", (Str "planet_id"));
                      ("type", (Str "`$STRING`"));
                      ("kind", (Str "param"));
                      ("reqd", (Bool true)) ]) ])) ]));
                ("select", (jo [
                  ("$action", (Str "forbid"));
                  ("exist", (ja [
                    (Str "id") ])) ])) ]);
              (jo [
                ("kind", (Str "http"));
                ("method", (Str "POST"));
                ("orig", (Str "/api/planet/{planet_id}/terraform"));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "id")) ]);
                  (jo [
                    ("lit", (Str "terraform")) ]) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}");
                  (Str "terraform") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("name", (Str "id"));
                      ("orig", (Str "planet_id"));
                      ("type", (Str "`$STRING`"));
                      ("kind", (Str "param"));
                      ("reqd", (Bool true)) ]) ])) ]));
                ("select", (jo [
                  ("$action", (Str "terraform"));
                  ("exist", (ja [
                    (Str "id") ])) ])) ]);
              (jo [
                ("kind", (Str "http"));
                ("method", (Str "POST"));
                ("orig", (Str "/api/planet"));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet") ]));
                ("rename", (empty_map ()));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("args", (empty_map ()));
                ("select", (empty_map ())) ]) ])) ]));
          ("list", (jo [
            ("input", (Str "data"));
            ("name", (Str "list"));
            ("points", (ja [
              (jo [
                ("kind", (Str "http"));
                ("method", (Str "GET"));
                ("orig", (Str "/api/planet"));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet") ]));
                ("rename", (empty_map ()));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("args", (empty_map ()));
                ("select", (empty_map ())) ]) ])) ]));
          ("load", (jo [
            ("input", (Str "data"));
            ("name", (Str "load"));
            ("points", (ja [
              (jo [
                ("kind", (Str "http"));
                ("method", (Str "GET"));
                ("orig", (Str "/api/planet/{planet_id}"));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "id")) ]) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("name", (Str "id"));
                      ("orig", (Str "planet_id"));
                      ("type", (Str "`$STRING`"));
                      ("kind", (Str "param"));
                      ("reqd", (Bool true)) ]) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id") ])) ])) ]) ])) ]));
          ("remove", (jo [
            ("input", (Str "data"));
            ("name", (Str "remove"));
            ("points", (ja [
              (jo [
                ("kind", (Str "http"));
                ("method", (Str "DELETE"));
                ("orig", (Str "/api/planet/{planet_id}"));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "id")) ]) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("name", (Str "id"));
                      ("orig", (Str "planet_id"));
                      ("type", (Str "`$STRING`"));
                      ("kind", (Str "param"));
                      ("reqd", (Bool true)) ]) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id") ])) ])) ]) ])) ]));
          ("update", (jo [
            ("input", (Str "data"));
            ("name", (Str "update"));
            ("points", (ja [
              (jo [
                ("kind", (Str "http"));
                ("method", (Str "PUT"));
                ("orig", (Str "/api/planet/{planet_id}"));
                ("segments", (ja [
                  (jo [
                    ("lit", (Str "api")) ]);
                  (jo [
                    ("lit", (Str "planet")) ]);
                  (jo [
                    ("var", (Str "id")) ]) ]));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ]));
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("name", (Str "id"));
                      ("orig", (Str "planet_id"));
                      ("type", (Str "`$STRING`"));
                      ("kind", (Str "param"));
                      ("reqd", (Bool true)) ]) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id") ])) ])) ]) ])) ])) ]));
        ("relations", (jo [
          ("ancestors", (empty_list ())) ])) ])) ])) ])

(* The plugin definitions the model selected for the secrets feature's
 * provider chain: none - the chain can name the four built-in kinds (env, memory, dotenv, file) and a custom provider, and nothing else.
 * Built, not held: every call is a fresh list, so two chains never share
 * a definition. *)
let feature_plugins (name : string) : Defs.definition list =
  match name with
  | "secrets" -> []
  | _ -> []

let make_feature (name : string) : feature =
  match name with
  | "debug" -> debug_feature ()
  | "idempotency" -> idempotency_feature ()
  | "metrics" -> metrics_feature ()
  | "paging" -> paging_feature ()
  | "ratelimit" -> ratelimit_feature ()
  | "retry" -> retry_feature ()
  | "test" -> test_feature ()
  | "timeout" -> timeout_feature ()
  | "secrets" -> Secrets_feature.make ~plugins:(feature_plugins "secrets") ()
  | _ -> base_feature ()

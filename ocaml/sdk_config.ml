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
                ("kind", (Str "http"));
                ("method", (Str "POST"));
                ("orig", (Str "/api/planet/{planet_id}/moon"));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon") ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "planet_id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ])) ]) ])) ]));
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
                ("kind", (Str "http"));
                ("method", (Str "GET"));
                ("orig", (Str "/api/planet/{planet_id}/moon"));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon") ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "planet_id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ])) ]) ])) ]));
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
                ("kind", (Str "http"));
                ("method", (Str "GET"));
                ("orig", (Str "/api/planet/{planet_id}/moon/{moon_id}"));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon");
                  (Str "{id}") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("moon_id", (Str "id")) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id");
                    (Str "planet_id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ])) ]) ])) ]));
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
                ("kind", (Str "http"));
                ("method", (Str "DELETE"));
                ("orig", (Str "/api/planet/{planet_id}/moon/{moon_id}"));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon");
                  (Str "{id}") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("moon_id", (Str "id")) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id");
                    (Str "planet_id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ])) ]) ])) ]));
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
                ("kind", (Str "http"));
                ("method", (Str "PUT"));
                ("orig", (Str "/api/planet/{planet_id}/moon/{moon_id}"));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{planet_id}");
                  (Str "moon");
                  (Str "{id}") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("moon_id", (Str "id")) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id");
                    (Str "planet_id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ])) ]) ])) ])) ]));
        ("relations", (jo [
          ("ancestors", (ja [
            (ja [
              (Str "planet") ]) ])) ])) ]));
      ("planet", (jo [
        ("fields", (ja [
          (jo [
            ("name", (Str "diameter"));
            ("req", (Bool true));
            ("type", (Str "`$NUMBER`")) ]);
          (jo [
            ("name", (Str "forbid"));
            ("type", (Str "`$BOOLEAN`")) ]);
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
            ("name", (Str "ok"));
            ("type", (Str "`$BOOLEAN`")) ]);
          (jo [
            ("name", (Str "start"));
            ("type", (Str "`$BOOLEAN`")) ]);
          (jo [
            ("name", (Str "state"));
            ("type", (Str "`$STRING`")) ]);
          (jo [
            ("name", (Str "stop"));
            ("type", (Str "`$BOOLEAN`")) ]);
          (jo [
            ("name", (Str "why"));
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
                ("kind", (Str "http"));
                ("method", (Str "POST"));
                ("orig", (Str "/api/planet/{planet_id}/forbid"));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}");
                  (Str "forbid") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("select", (jo [
                  ("$action", (Str "forbid"));
                  ("exist", (ja [
                    (Str "id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ])) ]);
              (jo [
                ("args", (jo [
                  ("params", (ja [
                    (jo [
                      ("kind", (Str "param"));
                      ("name", (Str "id"));
                      ("orig", (Str "planet_id"));
                      ("reqd", (Bool true));
                      ("type", (Str "`$STRING`")) ]) ])) ]));
                ("kind", (Str "http"));
                ("method", (Str "POST"));
                ("orig", (Str "/api/planet/{planet_id}/terraform"));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}");
                  (Str "terraform") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("select", (jo [
                  ("$action", (Str "terraform"));
                  ("exist", (ja [
                    (Str "id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ])) ]);
              (jo [
                ("args", (empty_map ()));
                ("kind", (Str "http"));
                ("method", (Str "POST"));
                ("orig", (Str "/api/planet"));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet") ]));
                ("select", (empty_map ()));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ])) ]) ])) ]));
          ("list", (jo [
            ("input", (Str "data"));
            ("name", (Str "list"));
            ("points", (ja [
              (jo [
                ("args", (empty_map ()));
                ("kind", (Str "http"));
                ("method", (Str "GET"));
                ("orig", (Str "/api/planet"));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet") ]));
                ("select", (empty_map ()));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ])) ]) ])) ]));
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
                ("kind", (Str "http"));
                ("method", (Str "GET"));
                ("orig", (Str "/api/planet/{planet_id}"));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ])) ]) ])) ]));
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
                ("kind", (Str "http"));
                ("method", (Str "DELETE"));
                ("orig", (Str "/api/planet/{planet_id}"));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ])) ]) ])) ]));
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
                ("kind", (Str "http"));
                ("method", (Str "PUT"));
                ("orig", (Str "/api/planet/{planet_id}"));
                ("parts", (ja [
                  (Str "api");
                  (Str "planet");
                  (Str "{id}") ]));
                ("rename", (jo [
                  ("param", (jo [
                    ("planet_id", (Str "id")) ])) ]));
                ("select", (jo [
                  ("exist", (ja [
                    (Str "id") ])) ]));
                ("transform", (jo [
                  ("req", (Str "`reqdata`"));
                  ("res", (Str "`body`")) ])) ]) ])) ])) ]));
        ("relations", (jo [
          ("ancestors", (empty_list ())) ])) ])) ])) ])

let make_feature (name : string) : feature =
  match name with
  | "test" -> test_feature ()
  | _ -> base_feature ()

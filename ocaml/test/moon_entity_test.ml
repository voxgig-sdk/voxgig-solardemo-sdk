(* Generated moon entity test. *)

open Voxgig_struct
open Sdk_types
open Sdk_helpers
open Testutil

let () =
  test "moon.entity_instance" (fun () ->
      let client = Sdk_client.test () in
      let ent = Sdk_client.moon client Noval in
      check_str "name" ent.e_name "moon")

let () =
  test "moon.validate" (fun () ->
      if Harness.has_feature "validate" then begin
        let client = Sdk_client.test_with Noval
            (jo [("feature", jo [("validate", jo [("active", Bool true)])])]) in
        let ent = Sdk_client.moon client Noval in
        let err = (try ignore (ent.e_list (jo [("planet_id", Num 1.)]) Noval); None with e -> Some e) in
        check_str "validate refuses an invalid request"
          (match err with Some (Sdk_error_exc er) -> er.err_code | _ -> "<no SDK error>") "validate_failed"
      end)

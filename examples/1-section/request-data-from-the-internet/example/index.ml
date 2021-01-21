[@@@part "0"]

open Mithril
open Fut.Result_syntax

module User = struct
  type t = Jv.t

  let first_name t = Jv.get t "firstName" |> Jv.to_string

  let last_name t = Jv.get t "lastName" |> Jv.to_string

  let id t = Jv.get t "id" |> Jv.to_int

  let of_list = List.map (fun t -> first_name t ^ " " ^ last_name t)
end

[@@@part "1"]

let users, add_user =
  let (lst : User.t list ref) = ref [] in
  let add_user t =
    lst := List.sort (fun a b -> Int.compare (User.id a) (User.id b)) (t :: !lst)
  in
  (lst, add_user)

[@@@part "2"]

let user_xhr =
  let fetch_users () =
    let url = "http://rem-rest-api.herokuapp.com/api/users" in
    let opts = M.Request.opts ~method_:"GET" ~with_credentials:true url in
    let+ data = M.Request.make opts in
    Jv.get data "data" |> Jv.to_list (fun x -> x) |> List.iter add_user
  in
  let attr = [| Attr.attr "onclick" (Jv.repr fetch_users) |] |> Attr.v in
  let view _ =
    M.v "div"
      ~children:
        (`Vnodes
          [
            M.(v "button" ~attr ~children:(`String "Get Users"));
            M.(
              v "p"
                ~children:(`String (String.concat ", " (User.of_list !users))));
          ])
  in
  Component.v view

[@@@part "3"]

let () =
  let body = Brr.(Document.body G.document) in
  M.(mount body user_xhr)

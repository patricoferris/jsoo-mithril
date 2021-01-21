open Mithril
open Fut.Result_syntax

[@@@part "0"]

(* See https://mithril.js.org/index.html#xhr *)
let count_xhr =
  let count = ref 0 in
  let increment () =
    let url = "http://rem-rest-api.herokuapp.com/api/tutorial/1" in
    let body = Jv.obj [| ("count", Jv.of_int (!count + 1)) |] in
    let opts = M.Request.opts ~method_:"PUT" ~body ~with_credentials:true url in
    let+ data = M.Request.make opts in
    Brr.Console.log [ data ];
    count := Jv.get data "count" |> Jv.to_int
  in
  let attr = [| Attr.attr "onclick" (Jv.repr increment) |] |> Attr.v in
  let view _ =
    M.(v "button" ~attr ~children:(`String (string_of_int !count ^ " clicks")))
  in
  Component.v view

[@@@part "1"]

let () =
  let body = Brr.(Document.body G.document) in
  M.(mount body count_xhr)

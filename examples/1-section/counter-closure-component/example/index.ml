open Mithril

[@@@part "0"]

type counter = { mutable counter : int }

[@@@part "1"]

let count =
  let state = { counter = 0 } in
  let increment () = state.counter <- state.counter + 1 in
  let on_click = Attr.attr "onclick" (Jv.repr increment) in
  let attr = Attr.v [| on_click |] in
  let view _ =
    M.(
      v "button" ~attr
        ~children:(`String (string_of_int state.counter ^ " clicks")))
  in
  Component.v view

[@@@part "2"]

let () =
  let body = Brr.(Document.body G.document) in
  M.(mount body count)

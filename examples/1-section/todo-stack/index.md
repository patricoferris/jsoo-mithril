---
title: Todo Stack
description: Build a simple todo app with more complex state management
authors:
- Patrick Ferris
date: 2021-01-20 18:12:00 +00:00
toc: false
resources: []

---


The Todo Stack is a very simple todo list. There's nothing really new here that hasn't already been covered. You can [play around with the app](./example) all you want. Here is the entire source code. 

<!-- $MDX file=./example/index.ml -->
```ocaml
open Mithril
open Brr

module Date = struct
  type t = Jv.t

  let date = Jv.get Jv.global "Date"

  let now () =
    let d = Jv.new' date [||] in
    let date = Jv.call d "toLocaleDateString" [||] |> Jv.to_string in
    let time = Jv.call d "toLocaleTimeString" [||] |> Jv.to_string in
    date ^ " " ^ time
end

(* A nice, typed OCaml representation of a todo item *)
module Todo = struct
  type t = { text : string; mutable completed : bool; created : string }

  let v text =
    Brr.Console.log [ Date.now () ];
    { text; completed = false; created = Date.now () }

  let toggle t = t.completed <- not t.completed

  let equal = Stdlib.( = )
end

let choose a b c = if a then b else c

let todos, add_todo, remove_todo =
  let t = ref [] in
  let add e =
    let open Ev in
    let event = of_jv e in
    let code = Keyboard.key (as_type event) |> Jstr.to_string in
    let target = Ev.target event |> Ev.target_to_jv in
    match (code, Jv.find target "value") with
    | "Enter", Some s when Jv.is_some s ->
        (* Update state *)
        t := Todo.v (Jv.to_string s) :: !t;
        (* Set target's value to none *)
        Jv.set target "value" Jv.null
    | _ -> ()
  in
  let remove todo =
    t := List.filter (fun todo' -> not (Todo.equal todo todo')) !t
  in
  (t, add, remove)

let todos =
  let key = Attr.(v [| attr "onkeypress" (Jv.repr add_todo) |]) in
  let todo t =
    let remove =
      Attr.(v [| attr "onclick" (Jv.repr (fun () -> remove_todo t)) |])
    in
    let toggle =
      Attr.(v [| attr "onclick" (Jv.repr (fun () -> Todo.toggle t)) |])
    in
    M.v
      ("div.todo" ^ choose t.completed ".completed" "")
      ~children:
        (`Vnodes
          [
            M.v "p" ~children:(`String t.text);
            M.v "p" ~children:(`String t.created);
            M.v "button.remove" ~attr:remove ~children:(`String "Remove");
            M.v "button.complete" ~attr:toggle
              ~children:(`String (choose t.completed "Uncomplete" "Complete"));
          ])
  in
  let input =
    M.(
      v ~attr:key "input#new-todo[placeholder='What's to be done?'][autofocus]")
  in
  let view _ =
    M.(
      v "div.main"
        ~children:
          (`Vnodes
            [
              v "h1" ~children:(`String "Todo Stack");
              input;
              v "div.todo-list" ~children:(`Vnodes (List.map todo !todos));
            ]))
  in
  Component.v view

let () =
  let body = Brr.(Document.body G.document) in
  M.(mount body todos)
```

A nice extension would be to try and add `Brr`'s bindings to the *Local Storage* API to persist the state of the app.

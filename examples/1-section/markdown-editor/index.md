---
title: Markdown Editor
description: Reuse OCaml code because you can
authors:
- Patrick Ferris
date: 2021-01-21 19:39:47 +00:00
toc: false
resources: []
---

The small markdown editor app is a good example of the power you can leverage by choosing to use `js_of_ocaml`. The app uses [omd](https://github.com/ocaml/omd), a pure OCaml markdown parser to take the user's markdown and render HTML.

We first create some global state and a function to update that state.

<!-- $MDX file=./example/index.ml,part=0 -->
```ocaml
let markdown, update =
  let content = ref "" in
  let update t = content := t in
  (content, update)
```

Then we create the component that will show us the Markdown parsed to HTML. Note we use `M.trust` to embed the HTML. This is just an example, but you need to be sure you know what you are doing when embedding HTML into your site. We also run `Omd` on it to parse and transform it to HTML.

<!-- $MDX file=./example/index.ml,part=1 -->
```ocaml
let markdown_viewer =
  let view _ =
    M.v "div.markdown"
      ~children:(`Vnodes [ M.trust Omd.(of_string !markdown |> to_html) ])
  in
  Component.v view
```

The text editor is just a `div` with `contenteditable` set to `true`. It listens for any keystrokes by adding `onkeyup` to the attributes and running `key_press` which extracts the `innerText` from the event target and calling `update` with the new text.

<!-- $MDX file=./example/index.ml,part=2 -->
```ocaml
let text_editor =
  let key_press e =
    let open Ev in
    let event = of_jv e in
    let target = Ev.target event |> Ev.target_to_jv in
    match Jv.find target "innerText" with
    | Some t -> update (t |> Jv.to_string)
    | None -> ()
  in
  let attr =
    Attr.(
      v
        [|
          attr "contenteditable" @@ Jv.of_bool true;
          Attr.attr "onkeyup" (Jv.repr key_press);
        |])
  in
  let view _ = M.v ~attr "div.text-editor" in
  Component.v view
```

After that it's a simple case of bringing the different UI components together with a nice title.

<!-- $MDX file=./example/index.ml,part=3 -->
```ocaml
let main =
  let title = M.(v "h1.title" ~children:(`String "Omd-itor")) in
  let view _ =
    let body =
      M.(
        v "main"
          ~children:(`Vnodes [ v_comp text_editor; v_comp markdown_viewer ]))
    in
    M.(v "div.content" ~children:(`Vnodes [ title; body ]))
  in
  Component.v view
```

And finally mounting it to the body of our document.

<!-- $MDX file=./example/index.ml,part=4 -->
```ocaml
let () =
  let body = Document.body G.document in
  M.mount body main
```

The dune file just adds the `Omd` library we all know and love. 

<!-- $MDX file=./example/dune -->
```
(executable
 (name index)
 (modes js)
 (libraries brr js_of_ocaml omd mithril))
```

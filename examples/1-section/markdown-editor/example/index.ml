open Mithril
open Brr

let markdown, update =
  let content = ref "" in
  let update t = content := t in
  (content, update)

let markdown_viewer =
  let view _ =
    M.v "div.markdown"
      ~children:(`Vnodes [ M.trust Omd.(of_string !markdown |> to_html) ])
  in
  Component.v view

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

let () =
  let body = Document.body G.document in
  M.mount body main

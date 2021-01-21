open Mithril
open Brr

let () =
  let body = Document.body G.document in
  let hello_world = M.(v "h1" ~children:(`String "Hello World!")) in
  M.render body [ hello_world ]

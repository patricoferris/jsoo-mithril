open Mithril

(* Example expanded on https://mithril.js.org/route.html *)

let home =
  let view _ =
    M.(
      v "div"
        ~children:
          (`Vnodes
            [
              v
                ~attr:Attr.(v [| attr "href" (Jv.of_string "#!/page-two") |])
                ~children:(`String "Go to page two!") "a";
            ]))
  in
  Component.v view

let page_two =
  let view _ = M.(v "div" ~children:(`String "Page Two!")) in
  Component.v view

let () =
  let body = Brr.(Document.body G.document) in
  let open Route in
  let routes =
    Routes
      [
        Route.mk_route ~path:"/home" ~component:home;
        Route.mk_route ~path:"/page-two" ~component:page_two;
      ]
  in
  M.(route body "/home" routes)

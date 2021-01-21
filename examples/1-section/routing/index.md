---
title: Routing
description: Multiple pages in a single page app
authors:
- Patrick Ferris
date: 2021-01-21 00:12:18 +00:00
toc: false
resources: []
---

Whilst single-page apps are great (and currently quite popular). It's also nice to segment content into pages. Mithril allows you to do this via the routing capabilities it provides. And as you guessed it, in the basic workflow, it just revolves around telling Mithril what component should be shown for what page.

First we create a simple `home` component with a link to a second page. The `#!` in the path is common for single page applications.

<!-- $MDX file=./example/index.ml,part=0 -->
```ocaml
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
```

Then a simple `page_two` component.

<!-- $MDX file=./example/index.ml,part=1 -->
```ocaml
let page_two =
  let view _ = M.(v "div" ~children:(`String "Page Two!")) in
  Component.v view
```

Finally we describe the collection of routes using the variant constructor `Routes` and providing a list of routes and mount it to the page using the `M.route` function.


<!-- $MDX file=./example/index.ml,part=2 -->
```ocaml
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
```

---
title: Hello World
description: The simplest app possible
authors:
- Patrick Ferris
date: 2021-01-20 18:09:15 +00:00
toc: false
resources: []
---


"Hello World" is meant to showcase software using the simplest example possible. For JS frameworks this simply means generating the text `hello world` in your browser. Let's have a look: 

<!-- $MDX file=./example/index.ml -->
```ocaml
open Mithril
open Brr

let () =
  let body = Document.body G.document in
  let hello_world = M.(v "h1" ~children:(`String "Hello World!")) in
  M.render body [ hello_world ]
```

[The Hello World example is running here](./example).

First we open `Mithril` and `Brr` to expose those modules so we don't have to write long things like `Brr.Document.body`. 

Then we have our **main** function. It uses the built-in functionality of `Brr` to get the body element of the DOM. Next we use two Mithril functions. 

<!-- $MDX version<4.06 -->
```ocaml
val v : ?⁠attr:Attr.t -> ?⁠children:Children.t -> string -> Vnode.t
val render : Brr.El.t -> Vnode.t list -> unit
```

From their signatures we can see `v` needs only a `string` but with some optional arguments. This is the `m()` function of Mithril. The string is the *CSS selector* and in the "Hello World" example it is an `h1` tag. 

The optional `children` parameter takes a `Children.t` which is: 

<!-- $MDX version<4.06 -->
```ocaml
type t = [
  | `Vnodes of Vnode.t list
  | `String of string
  | `Number of float
  | `Bool of bool
]
```

This function returns a virtual DOM node (`Vnode.t`) which is exactly what the `render` function needs (well a list of them to be precise). It also needs a place to render them, which is described by a `Brr.El.t` (a DOM element).

This is all compiled with the following dune file. 

<!-- $MDX file=./example/dune -->
```
(executable
 (name index)
 (modes js)
 (libraries brr js_of_ocaml mithril))
```

And an HTML page that brings in the Mithril library. 

<!-- $MDX file=./example/index.html -->
```
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>OCaml x Mithril</title>
  <script src="https://unpkg.com/mithril/mithril.js"></script>
</head>

<body>
  <script src="index.bc.js"></script>
</body>

</html>
```

---
title: Counter closure component
description: Make a simple counter where the state is managed by a closure
authors:
- Patrick Ferris
date: 2021-01-20 18:10:41 +00:00
toc: false
resources: []

---

Managing state can be challenging. The Mithril docs have [a whole section devoted to component state](https://mithril.js.org/components.html#state). In this small tutorial we'll build a simple, incremental counter using the "closure component". 

## Closures

Closures are like functions with some internal state -- or probably more precisely [lexically scoped name binding](https://en.wikipedia.org/wiki/Closure_(computer_programming)). In OCaml they appear all over the place thanks to first-class functions and their ease of creation thanks to let-bindings.

```ocaml
# let f x = 
    let c = 1 in 
    x + c 
val f : int -> int = <fun>
# f 10
- : int = 11
```

Here the local variable `c` is contained inside the function `f`. This "state" is private to the function. It's not very stateful thought, that's because in OCaml must value are immutable by default. You need to create a mutable reference in order to change a value like you would see in Javascript. 

```ocaml
# let f =
  let mut = ref 0 in
  fun t ->
    mut := !mut + t;
    !mut
val f : int -> int = <fun>
# f 1 
- : int = 1
# f 1
- : int = 2
```

It's important to notice the declaration of the `int ref` is before the function. The reference (`mut`) is now lexically scoped inside of `f` and is what the function body refers to. You will also notice are function is no longer pure! It has side-effects. Closure components can be thought of as value like `f` but that return a component.

## The Counter

The [running example can be found here](./example).

First things first, this isn't JS so let's make some types to represent our state. 

<!-- $MDX file=./example/index.ml,part=0 -->
```ocaml
type counter = { mutable counter : int }
```

The counter is a record with a mutable field called... **counter**. We're nearly done! All we have to do now is define our component with the state "stored" in it as a closure. 

<!-- $MDX file=./example/index.ml,part=1 -->
```ocaml
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
```

The first line after `let count` initialises our state to `0`. Then we define our increment function. This is going to allow us to update the state which in turn (because it will be called on an event) will trigger Mithril to redraw our DOM. The `increment` function changes our state.

We then form the function we want to run in the "execution context of an event handler defined in a Mithril view" ([which triggers a redraw](https://mithril.js.org/redraw.html)). We build this using the `Attr` module which under the hood is just build a Javascript object. Something like: 

```
let attr = {
  onclick: () => state.counter += 1
}
```

The last thing we do is create the `view` function which is defined to be a `Vnode.t -> Vnode.t` but we don't care about the first argument so we safely ignore it. We create our component using `M.v` as a "button" passing in our `attr` value and rendering a `` `String`` as the child which uses the state to display the counter.

<!-- $MDX file=./example/index.ml,part=2 -->
```ocaml
let () =
  let body = Brr.(Document.body G.document) in
  M.(mount body count)
```

Last but certainly not least we `mount` the `count` component to the `body`. It's important to `mount` it rather than `render` it as we want it to update!


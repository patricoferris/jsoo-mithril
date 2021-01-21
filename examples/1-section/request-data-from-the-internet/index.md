---
title: Request data from the internet
description: Use the XHR capabilities to get information from the web
authors:
- Patrick Ferris
date: 2021-01-20 18:11:21 +00:00
toc: false
resources: []
---

The data we want to display on our website can't always be known statically. Take, for example, a weather app. This information is constantly changing and needs refreshing (perhaps by a user clicking on a button).

[XHR](https://en.wikipedia.org/wiki/XMLHttpRequest#:~:text=XMLHttpRequest%20(XHR)%20is%20an%20API,by%20the%20browser's%20JavaScript%20environment.) or XMLHttpRequest is an API provided by the browser's Javascript environment exposing methods for making requests between websites to servers. Mithril has built-in functionality for making requests and re-rendering components as that data changes.

[REM](https://rem-rest-api.herokuapp.com/) is a service we can use to make requests to show how it works. We will query the `/api/users` end-point to get the small set of users. First we will open some libraries and describe our `User`. 

## REM User Example

[Full example is running here](./example).

<!-- $MDX file=./example/index.ml,part=0 -->
```ocaml
open Mithril
open Fut.Result_syntax

module User = struct
  type t = Jv.t

  let first_name t = Jv.get t "firstName" |> Jv.to_string

  let last_name t = Jv.get t "lastName" |> Jv.to_string

  let id t = Jv.get t "id" |> Jv.to_int

  let of_list = List.map (fun t -> first_name t ^ " " ^ last_name t)
end
```

`Fut.Result_syntax` is part of [Brr](https://erratique.ch/software/brr). It provides a *monadic* syntax for working with Javascript promises, we'll be using that later.

The underlying data-type for our user (`User.t`) is just a Javascript value and we provide (not very safe but more concise) accessors for the various bits of information.

Next we define some state.

<!-- $MDX file=./example/index.ml,part=1 -->
```ocaml
let users, add_user =
  let (lst : User.t list ref) = ref [] in
  let add_user t =
    lst := List.sort (fun a b -> Int.compare (User.id a) (User.id b)) (t :: !lst)
  in
  (lst, add_user)
```

This is initialised once (when the page loads). And provides a reference to a list of users and a function, `add_user`, for pushing a new user to the list. The list is automatically resorted by `id` (again there are more efficient implementations but we ar striving for simplicity here).

Now we define the main `user_xhr` component.

<!-- $MDX file=./example/index.ml,part=2 -->
```ocaml
let user_xhr =
  let fetch_users () =
    let url = "http://rem-rest-api.herokuapp.com/api/users" in
    let opts = M.Request.opts ~method_:"GET" ~with_credentials:true url in
    let+ data = M.Request.make opts in
    Jv.get data "data" |> Jv.to_list (fun x -> x) |> List.iter add_user
  in
  let attr = [| Attr.attr "onclick" (Jv.repr fetch_users) |] |> Attr.v in
  let view _ =
    M.v "div"
      ~children:
        (`Vnodes
          [
            M.(v "button" ~attr ~children:(`String "Get Users"));
            M.(
              v "p"
                ~children:(`String (String.concat ", " (User.of_list !users))));
          ])
  in
  Component.v view
```

It has a `button` for fetching users and a `paragraph` for displaying them. This is code is meant to just show you how it works not be useful. Clicking the button multiple times will just keep adding to the list of users. 

The most interesting part of this is the `fetch_users` function. It uses the `M.Request` module for preparing and sending the `GET` request to the end-point.

`M.Request.opts` is used to form the options for the function with only the `url` (a string) being required. `M.Request.make` makes the request and returns a promise which resolves to an error or a `Jv.t`. The `let+ data = M.Request.make opts` syntax unwraps the promise and the error binding `data` to the `Jv.t`. 

No error handling has been implemented here -- that's a good reader exercise ;)

Finally we mount the component to the body.

<!-- $MDX file=./example/index.ml,part=3 -->
```ocaml
let () =
  let body = Brr.(Document.body G.document) in
  M.(mount body user_xhr)
```

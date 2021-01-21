module Resolver = struct
  type t = Jv.t

  include (Jv.Id : Jv.CONV with type t := t)

  type opts

  type on_match = string -> string -> string -> (Component.t, Jv.t) Fut.result

  type render = Vnode.t -> Vnode.t array

  let opts ?on_match ?render () =
    match (on_match, render) with
    | None, None ->
        Error
          (`Msg "Must specify either on_match, render or both but not neither")
    | _ ->
        let o = Jv.obj [||] in
        Jv.set_if_some o "onmatch" (Option.map Jv.repr on_match);
        Jv.set_if_some o "render" (Option.map Jv.repr render);
        Ok o
end

type r = string * Component.t

let mk_route ~path ~component = (path, component)

type t = Routes of r list | Resolver of Resolver.t

let to_jv = function
  | Routes rs ->
      let o = Jv.obj [||] in
      List.iter (fun (k, v) -> Jv.set o k (Component.to_jv v)) rs;
      o
  | _ -> failwith "AHHHH!"

(** {2 Static members} *)

type set_opts

let set_opts ?params ?options path =
  let o = Jv.obj [||] in
  Jv.set_if_some o "params" params;
  Jv.set_if_some o "options" options;
  Jv.Jstr.set o "path" (Jstr.of_string path);
  o

type route = Brr.El.t -> string -> t -> unit

let route root default_route roots =
  let routes = to_jv roots in
  Jv.call G.m "route"
    [| Brr.El.to_jv root; Jv.of_string default_route; routes |]
  |> ignore

let set _set_opts = Jv.call G.m "render" [||] |> ignore

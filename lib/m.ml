type t = Jv.t

(** The global Mithril object *)
let m = G.m

module Children = struct
  type t =
    [ `Vnodes of Vnode.t list
    | `String of string
    | `Number of float
    | `Bool of bool ]

  let to_jv = function
    | `Vnodes vs -> Jv.of_list Vnode.to_jv vs
    | `String s -> Jv.of_string s
    | `Number f -> Jv.of_float f
    | `Bool b -> Jv.of_bool b
end

let v ?attr ?children sel =
  let attr = Option.map Attr.to_jv attr |> Option.to_list in
  let children = Option.to_list (Option.map Children.to_jv children) in
  let opts = attr @ children |> Array.of_list in
  Jv.new' m (Array.concat [ [| Jv.of_string sel |]; opts ]) |> Vnode.of_jv

let v_comp ?attr ?children sel =
  let attr = Option.map Attr.to_jv attr |> Option.to_list in
  let children = Option.to_list (Option.map Children.to_jv children) in
  let opts = attr @ children |> Array.of_list in
  Jv.new' m (Array.concat [ [| Component.to_jv sel |]; opts ]) |> Vnode.of_jv

let render elt vnodes =
  Jv.call m "render" [| Brr.El.to_jv elt; Jv.of_list Vnode.to_jv vnodes |]
  |> ignore

let mount elt component =
  Jv.call m "mount" [| Brr.El.to_jv elt; Component.to_jv component |] |> ignore

let mount_vnode elt (component : unit -> Jv.t) =
  Jv.call m "mount" [| Brr.El.to_jv elt; Jv.repr component |] |> ignore

let redraw () = Jv.call m "redraw" [||] |> ignore

let route = Route.route

module Request = struct
  type opts = Jv.t

  let opts ?method_ ?params ?body ?async ?user ?password ?with_credentials
      ?timeout ?response_type ?config ?headers ?type_ ?serialize ?deserialize
      ?extract ?background s =
    let str = Option.map Jstr.of_string in
    let o = Jv.obj [||] in
    Jv.Jstr.set_if_some o "method" (str method_);
    Jv.set_if_some o "params" params;
    Jv.set_if_some o "body" body;
    Jv.Bool.set_if_some o "async" async;
    Jv.Jstr.set_if_some o "user" (str user);
    Jv.Jstr.set_if_some o "password" (str password);
    Jv.Bool.set_if_some o "withCredentials" with_credentials;
    Jv.Int.set_if_some o "timeout" timeout;
    Jv.Jstr.set_if_some o "responseType" (str response_type);
    Jv.set_if_some o "config" (Option.map Jv.repr config);
    Jv.set_if_some o "headers" headers;
    Jv.set_if_some o "type" (Option.map Jv.repr type_);
    Jv.set_if_some o "serialize" (Option.map Jv.repr serialize);
    Jv.set_if_some o "deserialize" (Option.map Jv.repr deserialize);
    Jv.set_if_some o "extract" (Option.map Jv.repr extract);
    Jv.Jstr.set o "url" (Jstr.of_string s);
    Jv.Bool.set_if_some o "background" background;
    o

  let make opts =
    Fut.of_promise ~ok:(fun x -> x) @@ Jv.call m "request" [| opts |]
end

module Jsonp = struct
  type opts = Jv.t

  let opts ?params ?type_ ?callback_name ?callback_key ?background ~url =
    let o = Jv.obj [||] in
    Jv.set_if_some o "params" params;
    Jv.set_if_some o "type" type_;
    Jv.Jstr.set_if_some o "callbackName"
      (Option.map Jstr.of_string callback_name);
    Jv.Jstr.set_if_some o "callbackKey" (Option.map Jstr.of_string callback_key);
    Jv.Bool.set_if_some o "background" background;
    Jv.Jstr.set o "url" (Jstr.of_string url);
    o

  let v opts = Fut.of_promise ~ok:(fun x -> x) @@ Jv.call m "jsonp" [| opts |]
end

let parse_query_string str = Jv.call m "parseQueryString" [| Jv.of_string str |]

let build_query_string t = Jv.call m "buildQueryString" [| t |] |> Jv.to_string

module Pathname = struct
  type t = Jv.t

  let v ~path ~params =
    Jv.call m "buildPathname" [| Jv.of_string path; params |] |> Jv.to_string

  let path t = Option.map Jv.to_string @@ Jv.find t "path"

  let path_exn t = Jv.get t "path" |> Jv.to_string

  let params t = Jv.find t "params"

  let params_exn t = Jv.get t "params"

  let of_string s = Jv.call m "parsePathname" [| Jv.of_string s |]
end

let trust html = Jv.call m "trust" [| Jv.of_string html |] |> Vnode.of_jv

let fragment ?attrs ?children () =
  let attr = Option.map Attr.to_jv attrs |> Option.to_list in
  let children = Option.to_list (Option.map Children.to_jv children) in
  let opts = attr @ children |> Array.of_list in
  Jv.call m "fragment" opts |> Vnode.of_jv

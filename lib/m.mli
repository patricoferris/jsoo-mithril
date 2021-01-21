open Brr

type t
(** The main mithril object *)

val m : t
(** The global [m] object *)

(** The [Children] module tries to provide the flexibility of the Javascript API
    but in a type-safe manner by specifying exactly what can and cannot be
    passed to the Vnode generating function. *)
module Children : sig
  type t =
    [ `Vnodes of Vnode.t list
    | `String of string
    | `Number of float
    | `Bool of bool ]
  (** Types of children that can be passed to {!M.v} *)

  val to_jv : t -> Jv.t
end

val v : ?attr:Attr.t -> ?children:Children.t -> string -> Vnode.t
(** [v sel] generates a vnode from a CSS selector [sel] *)

val v_comp : ?attr:Attr.t -> ?children:Children.t -> Component.t -> Vnode.t
(** [v comp] generates a vnode from a {!Component} [comp] *)

val render : El.t -> Vnode.t list -> unit
(** [render elt nodes] renders [nodes] onto [elt] *)

val mount : El.t -> Component.t -> unit
(** [mount elt comp] activates the component, enabling it to auto redraw on
    events. See {!Component} *)

val mount_vnode : El.t -> (unit -> Jv.t) -> unit

val redraw : unit -> unit
(** [redraw ()] explicitly redraws the DOM. *)

val route : Route.route

module Request : sig
  type opts

  val opts :
    ?method_:string ->
    ?params:Jv.t ->
    ?body:Jv.t ->
    ?async:bool ->
    ?user:string ->
    ?password:string ->
    ?with_credentials:bool ->
    ?timeout:int ->
    ?response_type:string ->
    ?config:Jv.t ->
    ?headers:Jv.t ->
    ?type_:(Jv.t -> Jv.t) ->
    ?serialize:(Jv.t -> Jstr.t) ->
    ?deserialize:(Jv.t -> Jv.t) ->
    ?extract:(Jv.t -> Jv.t) ->
    ?background:bool ->
    string ->
    opts
  (** {{:https://mithril.js.org/request.html} See the Mithril docs for what
      these do}. *)

  val make : opts -> Jv.t Fut.or_error
  (** [request opts] make an XHR request --
      {{:https://mithril.js.org/request.html} see the docs for more info}. *)
end

module Jsonp : sig
  type opts

  val opts :
    ?params:Jv.t ->
    ?type_:Jv.t ->
    ?callback_name:string ->
    ?callback_key:string ->
    ?background:bool ->
    url:string ->
    opts
  (** {{:https://mithril.js.org/jsonp.html} See the docs} for more information
      about what these configuration parameters allow you to do. *)

  val v : opts -> Jv.t Fut.or_error
  (** [v opts] makes a JSON-P request to the [url] specified in [opts].
      {{:https://mithril.js.org/jsonp.html} More information about this
      functions} and {{:https://en.wikipedia.org/wiki/JSONP} some information
      about JSON-P}. *)
end

val parse_query_string : string -> Jv.t
(** Takes a query string such as ["a=1&b=2"] and returns an object
    [{a : 1; b : 2}] *)

val build_query_string : Jv.t -> string
(** The inverse of parsing -- takes an object [{a : 1; b : 2}] and produces a
    string ["a=1&b=2"] *)

module Pathname : sig
  type t

  val v : path:string -> params:Jv.t -> string
  (** Builds a pathname from a path template.
      {{:https://mithril.js.org/buildPathname.html} See the docs} for more
      information. *)

  val path : t -> string option

  val path_exn : t -> string

  val params : t -> Jv.t option

  val params_exn : t -> Jv.t

  val of_string : string -> t
  (** This is the {{:https://mithril.js.org/parsePathname.html} parsePathname}
      function. *)
end

val trust : string -> Vnode.t
(** [trust html] turns an HTML or SVG string into unescaped HTML of SVG --
    {{:https://mithril.js.org/trust.html} the docs come with some warnings about
    this}. By default Mithril escapes all values in order to prevent cross-site
    scripting (XSS) injections.

    [trust] creates a {!Vnode.t} from "trusted" HTML (or SVG) text -- this can
    be useful say if you use ocaml-omd to generate an HTML string from Markdown
    and want to embed it directly in your site. *)

val fragment : ?attrs:Attr.t -> ?children:Children.t -> unit -> Vnode.t
(** [fragment] allows you to attache lifecycle methods to a frgament vnode. A
    fragment {!Vnode} represents a list of DOM elements.
    {{:https://mithril.js.org/fragment.html} More information about fragments in
    the docs}.*)

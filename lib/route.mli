module Resolver : sig
  type t

  val to_jv : t -> Jv.t

  type opts

  type on_match = string -> string -> string -> (Component.t, Jv.t) Fut.result

  type render = Vnode.t -> Vnode.t array

  val opts :
    ?on_match:on_match ->
    ?render:render ->
    unit ->
    (t, [ `Msg of string ]) result
  (** Must have on_match and/or render -- you cannot have it be empty *)
end

type r
(** A simple route *)

val mk_route : path:string -> component:Component.t -> r
(** Generate a route *)

type t = Routes of r list | Resolver of Resolver.t

(** There are two types of routes available to pass to {!M.route} -- a simple
    "hashmap" if you like of route paths and components to render. Or the more
    complicated {{:https://mithril.js.org/route.html#routeresolver}
    RouteResolver} *)

val to_jv : t -> Jv.t
(** Convert to JS object *)

type route = Brr.El.t -> string -> t -> unit

val route : route
(** Mithril's route function -- {{:https://mithril.js.org/route.html} m.route} *)

(** {2 Static members} *)

type set_opts

val set_opts : ?params:Jv.t -> ?options:Jv.t -> string -> Jv.t

val set : set_opts -> unit
(** Redirects to a matching route, or to the default route if no matching routes
    can be found. {{:https://mithril.js.org/route.html#mrouteset} See docs}. *)

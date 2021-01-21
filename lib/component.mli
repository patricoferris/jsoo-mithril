type t
(** Mithril component type *)

include Jv.CONV with type t := t

type view = Vnode.t -> Vnode.t
(** View functions for components *)

val to_jv : t -> Jv.t

val v : view -> t

(** Lifecycle Method *)
module Lifecycle : sig
  val on_init : (Vnode.t -> unit) -> Attr.attr
  (** [on_init f] invokes [f] before the virtual DOM engine touches the vnode.
      See {{:https://mithril.js.org/lifecycle-methods.html#oninit} Mithril
      docs}. *)

  val on_create : (Vnode.t -> unit) -> Attr.attr
  (** [on_create f] invokes [f] when the vnode is attached to the document. See
      {{:https://mithril.js.org/lifecycle-methods.html#oncreate} Mithril docs}. *)

  val on_update : (Vnode.t -> unit) -> Attr.attr
  (** [on_update f] invokes [f] when the vnode is updated. See
      {{:https://mithril.js.org/lifecycle-methods.html#onupdate} Mithril docs}. *)

  val on_before_remove : (Vnode.t -> unit) -> Attr.attr
  (** [on_before_remove f] invokes [f] just before the node is removed from the
      document. See
      {{:https://mithril.js.org/lifecycle-methods.html#onbeforeremove} Mithril
      docs}. *)

  val on_remove : (Vnode.t -> unit) -> Attr.attr
  (** [on_remove f] invokes [f] when the node is removed from the document. See
      {{:https://mithril.js.org/lifecycle-methods.html#onremove} Mithril docs}. *)

  val on_before_update : (vnode:Vnode.t -> old:Vnode.t -> unit) -> Attr.attr
  (** [on_before_update f] invokes [f] before a vnode is diffed in an update.
      See {{:https://mithril.js.org/lifecycle-methods.html#onbeforeupdate}
      Mithril docs}. *)
end

type t
(** The type of virtual DOM nodes *)

val of_jv : Jv.t -> t

val to_jv : t -> Jv.t

type tag =
  | String of Jstr.t
  | Obj of Jv.t
      (** Virtual DOM tags see {{:https://mithril.js.org/vnodes.html#structure}
          mithril vnode docs}. *)

(** {1 Properties} *)

val tag : t -> tag

val key : t -> Jv.t option

val attrs : t -> Jv.t option

val attrs_exn : t -> Jv.t

val children : t -> Jv.t option

val text : t -> Jv.t option

val dom : t -> Jv.t option

val dom_size : t -> int option

val state : t -> Jv.t option

val state_exn : t -> Jv.t

val events : t -> Jv.t option

val instance : t -> Jv.t option

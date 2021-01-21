type t
(** The DOM attributes as an object *)

type attr = Jstr.t * Jv.t
(** DOM attribute name *)

val attr : string -> Jv.t -> attr
(** [attr s f] makes and attribute called [s] with value [f] *)

val v : attr array -> t
(** [v attrs] creates an object of attributes to pass to {!M.v} *)

include Jv.CONV with type t := t

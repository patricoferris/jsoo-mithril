type t = Jv.t

type attr = Jstr.t * Jv.t

let attr s f = (Jstr.v s, f)

let v (attrs : attr array) = Jv.obj' attrs

include (Jv.Id : Jv.CONV with type t := t)

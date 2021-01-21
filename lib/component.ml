type t = Jv.t

type view = Vnode.t -> Vnode.t

let v (view : view) = Jv.obj [| ("view", Jv.repr view) |]

include (Jv.Id : Jv.CONV with type t := t)

module Lifecycle = struct
  let on_init f =
    let f' t = f (Vnode.of_jv t) in
    Attr.attr "oninit" (Jv.repr f')

  let on_create f =
    let f' t = f (Vnode.of_jv t) in
    Attr.attr "oncreate" (Jv.repr f')

  let on_update f =
    let f' t = f (Vnode.of_jv t) in
    Attr.attr "onupdate" (Jv.repr f')

  let on_before_remove f =
    let f' t = f (Vnode.of_jv t) in
    Attr.attr "onbeforeupdate" (Jv.repr f')

  let on_remove f =
    let f' t = f (Vnode.of_jv t) in
    Attr.attr "onremove" (Jv.repr f')

  let on_before_update f =
    let f' t t' = f ~vnode:(Vnode.of_jv t) ~old:(Vnode.of_jv t') in
    Attr.attr "onbeforeupdate" (Jv.repr f')
end

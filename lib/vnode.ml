type t = Jv.t
(** The type of virtual DOM nodes *)

include (Jv.Id : Jv.CONV with type t := t)

type tag =
  | String of Jstr.t
  | Obj of Jv.t
      (** Virtual DOM tags see {{:https://mithril.js.org/vnodes.html#structure}
          mithril vnode docs}. *)

(** {1 Properties} *)

let tag t =
  let tag = Jv.get t "tag" in
  match Jv.find tag "view" with
  | None -> String (Jv.to_jstr tag)
  | Some _ -> Obj tag

let key t = Jv.find t "key"

let attrs t = Jv.find t "attrs"

let attrs_exn t = Jv.get t "attrs"

let children t = Jv.find t "children"

let text t = Jv.find t "text"

let dom t = Jv.find t "dom"

let dom_size t = Jv.find t "domSize" |> Option.map Jv.to_int

let state t = Jv.find t "state"

let state_exn t = Jv.get t "state"

let events t = Jv.find t "events"

let instance t = Jv.find t "instance"

let m =
  let v = Jv.get Jv.global "m" in
  match Jv.is_some v with
  | true -> v
  | false ->
      failwith
        "No global Mithril object found -- are you sure you have correctly \
         require MithrilJS?"

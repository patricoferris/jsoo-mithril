---
title: jsoo-mithril
description: OCaml binding using Js_of_ocaml for Mithril.js
---

# Jsoo Mithril

Welcome to the docs for `jsoo-mithril`: Js_of_ocaml bindings for the light-weight, small footprint javascript framework [Mithril](https://mithril.js.org/index.html).

The bindings were created using the incredible FFI tools provided by [brr](https://erratique.ch/software/brr) and expect you to use that package to help right idiomatic OCaml. 

There are two sources of documentation for you: 

  - The [API](./api/mithril) for use during development 
  - The [tutorials](./tutorials) to help explain the important aspects of the library

If you are at all curious how these docs are generated they use a little tool I wrote called [sesame-doc](https://github.com/patricoferris/sesame/tree/main/sesame-doc) which uses a little static site generator I wrote called [sesame](https://github.com/patricoferris/sesame). It's Markdown based which means all the examples you see are actually tested in CI or come from files that are built as part of the CI process.
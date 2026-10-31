// Typstのすゝめ 展示パネル。内容は ../typst-susume/susume.typ(A0 ポスター)から。キーカラーは Typst の青緑。
#import "../template.typ": *
#show: setup

#let src = ```typ
#show: setup

#panel(
  number: "05", category: "POSTER", title: "Typstのすゝめ",
  specs: ("COST: FREE", "RECOMPILE: 0.01 SEC", "INSTALL: NO"),
  accent: rgb("#239DAD"),
  abstract-text: [図表番号の手直しも、数式のボタン探しも要らない。
    文章をテキストで書いてPDFにするだけの組版ソフト「Typst」を、
    実験レポート向けに紹介します。],
  how-to: ("OPEN — typst.app を開く", "SETUP — 先頭に2行書く",
           "WRITE — 本文を書く"),
)
```


#panel(
  number: "05", category: "POSTER", title: "Typstのすゝめ",
  subtitle: "Wordで実験レポートを書いている人へ", subtitle-bold: true,
  specs: ("COST: FREE", "RECOMPILE: 0.01 SEC", "INSTALL: NO"), spec-size: 22pt,
  accent: rgb("#239DAD"),
  // タイトル・サブタイトルはポスター(typst-susume/common.typ)と同じ原ノ味ゴシック
  title-font: ("Harano Aji Gothic", "Noto Sans CJK JP"),
  abstract-size: 17pt,
  visual: align(left + horizon, block(fill: luma(240), width: 100%, height: 100%, inset: 14pt, text(size: 17pt, src))),
  visual-w: 760pt, visual-h: 248pt,
  visual-caption: "FIG 05. THIS PANEL'S SOURCE",
  abstract-text: [図表番号の手直しも、数式のボタン探しも要らない。文章をテキストで書いてPDFにするだけの組版ソフト「Typst」を、実験レポート向けに紹介します。],
  side-title: "HOW TO START",
  how-to: ("OPEN — typst.app を開く", "SETUP — 先頭に2行書く", "WRITE — 本文を書く"),
)

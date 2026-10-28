// タイトル長さの見本(英語 短/長・日本語 短/長)。ロゴ入りは panel-logo.typ(手元専用)。
#import "template.typ": *
#show: setup

#panel(
  number: "01",
  category: "EN SHORT",
  title: "TITLE",
  specs: ("TIME: -- MIN", "PLAYER: -", "DIFFICULTY: -"),
  accent: rgb("#FE430C"),
  abstract-text: [英語・短いタイトル。幅いっぱいに拡大される(上限 150pt)。],
  how-to: ("START — 操作を1行", "PLAY — 操作を1行", "CLEAR — 操作を1行"),
  visual-caption: "FIG 01. CAPTION",
)

#pagebreak()

#panel(
  number: "02",
  category: "EN LONG",
  title: "A VERY LONG ENGLISH TITLE",
  specs: ("TIME: -- MIN", "PLAYER: -", "DIFFICULTY: -"),
  accent: rgb("#B0DC01"),
  abstract-text: [英語・長いタイトル。幅に収まるよう自動で縮む。],
  how-to: ("START — 操作を1行", "PLAY — 操作を1行", "CLEAR — 操作を1行"),
  visual-caption: "FIG 02. CAPTION",
)

#pagebreak()

#panel(
  number: "03",
  category: "JA SHORT",
  title: "展示名",
  specs: ("TIME: -- MIN", "PLAYER: -", "DIFFICULTY: -"),
  accent: rgb("#5B3DB8"),
  abstract-text: [日本語・短いタイトル。上限 120pt、縦には伸ばさない。],
  how-to: ("START — 操作を1行", "PLAY — 操作を1行", "CLEAR — 操作を1行"),
  visual-caption: "FIG 03. CAPTION",
)

#pagebreak()

#panel(
  number: "04",
  category: "JA LONG",
  title: "とても長い日本語の展示名タイトル",
  specs: ("TIME: -- MIN", "PLAYER: -", "DIFFICULTY: -"),
  accent: rgb("#F2568A"),
  abstract-text: [日本語・長いタイトル。幅に収まるよう自動で縮む。],
  how-to: ("START — 操作を1行", "PLAY — 操作を1行", "CLEAR — 操作を1行"),
  visual-caption: "FIG 04. CAPTION",
)

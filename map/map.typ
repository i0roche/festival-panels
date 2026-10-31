// KCCT-navi(校内マップ ナビ)展示パネル。内容は https://github.com/i0roche/KCCT-navi の README から。
#import "../template.typ": *
#show: setup

#panel(
  number: "06", category: "EXPERIMENT", title: "KCCT-NAVI",
  specs: ("LANG: C#", "ROUTE: A*", "FLOOR: 1F-6F"),
  accent: rgb("#E09A00"),
  abstract-size: 17pt,
  abstract-text: [高専構内の建物・部屋を、最短経路で案内するデスクトップアプリです。部屋名やひらがなで検索すると、階をまたぐ道のりまで教えてくれます。],
  side-title: "TRY IT",
  how-to: ("SEARCH — 部屋を探す", "ROUTE — 最短経路を引く", "RAIN — 雨の日は濡れない道"),
  visual: image("app-screen-crop.png"), visual-w: 536pt, visual-h: 321pt,
  visual-caption: "FIG 06. APP SCREEN",
)

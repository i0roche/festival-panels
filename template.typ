// ===== 文化祭 展示パネル / Swiss typographic =====
// 3:4 縦(840×1120pt)。参考デザインを実測した比率に合わせてある。
// A3 に刷るなら下の page を paper: "a3" に変えれば比率はそのまま拡大されない点に注意。
#let ground = white   // 元: rgb("#F1EEE4")
#let ink    = rgb("#141414")
#let hair   = 2pt + ink

#let f-sans = "TeX Gyre Heros"
#let f-mono = "JetBrains Mono"
#let f-jp   = "Noto Sans CJK JP"
#let f-num  = f-mono   // 連番のフォント。元のゴシックに戻すなら f-sans

// ページとテキストの共通設定。使う側で `#show: setup` と書く。
#let setup(body) = {
  set page(width: 840pt, height: 1120pt, margin: (x: 39pt, y: 42pt), fill: ground)
  set text(font: (f-sans, f-jp), lang: "ja", fill: ink, size: 11pt)
  body
}

#let mono(size: 27pt, weight: "medium", tracking: 0pt, body) = text(
  font: f-mono, size: size, weight: weight, tracking: tracking,
  top-edge: "cap-height", bottom-edge: "baseline",
)[#body]

#let gro(size: 30pt, fill: ink, tracking: -0.03em, font: (f-sans, f-jp), body) = text(
  font: font, size: size, weight: "bold", tracking: tracking, fill: fill,
  top-edge: "cap-height", bottom-edge: "baseline",
)[#body]

#let jp(size: 16pt, weight: "regular", font: f-jp, body) = text(
  font: font, size: size, weight: weight,
)[#body]

// ハーフトーン風ドット(写真が無い時のプレースホルダ)
#let dots = tiling(size: (7pt, 7pt))[
  #place(center + horizon, circle(radius: 2.6pt, fill: ink))
]

// visual に渡す写真は make-visual.sh で「白黒ハーフトーン＋アクセント色の正方形(乗算)」
// に加工済みの画像を想定。未指定ならプレースホルダを表示する。
#let panel(
  number: "01",
  category: "CATEGORY",
  title: "TITLE",
  title-size: auto,       // auto: 英字 150pt / 日本語 120pt が上限
  logo: none,            // ロゴSVG(線色 LOGOCOLOR をアクセント色に置換して表示)
  logo-pad: 30pt,         // ロゴの上下の余白の合計。小さくするとロゴが大きくなる(幅は紙面いっぱいまで)
  spec-size: 27pt,             // スペック欄の文字サイズ(長い項目を入れる時だけ下げる)
  title-font: (f-sans, f-jp),  // タイトル・サブタイトル(subtitle-bold 時)のフォント
  body-font: f-jp,             // ABSTRACT・右カラムの説明文のフォント
  subtitle-bold: false,   // true: サブタイトルをタイトルと同じ太字ゴシックにする
  logo-dy: 0pt,           // ロゴ+サブタイトルの縦位置の微調整(負で上へ)
  subtitle: none,         // タイトル/ロゴの下に出すサブタイトル(アクセント色・字間広め。前後に「-」を自動で付ける)
  title-stretch: auto,    // 縦倍率。auto: 英字 130% / 日本語 100%(日本語は字が高いので伸ばさない)
  specs: ("TIME: --", "PLAYER: -", "DIFFICULTY: -"),
  accent: rgb("#FE430C"),
  abstract-text: [],
  how-to: (),            // "WORD — 説明" 形式の文字列、または (word, 説明) の配列
  visual: none,
  visual-caption: none,
  visual-w: 400pt,        // 写真枠の幅(ページ内幅が上限)
  visual-h: auto,         // 写真枠の高さ。auto: 248pt か、ブロックの高さ - 60pt の小さい方
  show-visual: true,      // false: 写真枠をなくし、その高さ分を下段(ABSTRACT / 右カラム)に回す
  abstract-size: 15pt,
  side-title: "HOW TO PLAY",  // 右カラムの見出し(展示なら "HOW IT WORKS" など)
  side-body: none,        // 指定すると how-to の代わりに自由な本文を右カラムに入れる
  side-size: 14pt,
) = layout(size => {
  let is-img = logo != none
  let cjk = type(title) == str and title.find(regex("[\u{3000}-\u{9fff}]")) != none
  let title-size = if title-size == auto { if cjk { 120pt } else { 150pt } } else { title-size }
  let title-stretch = if title-stretch == auto { if cjk { 100% } else { 130% } } else { title-stretch }
  let fitted = if is-img { 0pt } else {
    let m = measure(text(font: title-font, size: 100pt, weight: "bold",
                         tracking: -0.03em)[#title])
    calc.min(100pt * (size.width / m.width), title-size)
  }
  let sub-h    = if subtitle == none { 0pt } else { 32pt }
  let num-h    = 238pt
  let title-h  = 182pt
  let spec-h   = 64pt
  let bottom-h = 239pt  // show-visual: false の時だけ後で上書き
  let vis-h    = size.height - num-h - title-h - spec-h - bottom-h - 4 * 2pt
  if not show-visual {
    // 写真ブロックと罫線 1 本が消える分、下段を伸ばす
    bottom-h = size.height - num-h - title-h - spec-h - 3 * 2pt
    vis-h = 0pt
  }

  stack(
    // 1 連番 ＋ カテゴリ(縦線は紙面の 66%)
    block(width: 100%, height: num-h)[
      #grid(
        columns: (516pt, 1fr),
        block(width: 100%, height: 100%)[
          #align(left + top)[
            #text(font: f-num, size: 264pt, weight: "bold", fill: accent, tracking: -0.04em, top-edge: "cap-height", bottom-edge: "baseline")[#number]
          ]
        ],
        block(width: 100%, height: 100%, stroke: (left: hair))[
          #align(right + top)[#mono(size: 27pt)[#category]]
        ],
      )
    ],
    line(length: 100%, stroke: hair),

    // 2 タイトル
    block(width: 100%, height: title-h)[
      #align((if is-img { center } else { left }) + horizon, move(dy: logo-dy)[
        #set par(spacing: 0pt, leading: 0pt)
        #if is-img {
          // ロゴは背景なし・線をアクセント色にして中央寄せ(高さで収める)
          // 横長のロゴは幅いっぱい、縦長のロゴは高さで収める
          let img = image(bytes(read(logo).replace("LOGOCOLOR", accent.to-hex())), format: "svg")
          let m = measure(img)
          let max-h = title-h - logo-pad - sub-h
          image(bytes(read(logo).replace("LOGOCOLOR", accent.to-hex())), format: "svg",
                width: calc.min(size.width, (m.width / m.height) * max-h))
        } else { scale(y: title-stretch, reflow: true, gro(size: fitted, font: title-font)[#title]) }
        #if subtitle != none {
          set par(spacing: 0pt, leading: 0pt)
          // 文字タイトルは baseline 基準なので、p / y などの下に出る分を空ける
          v(4pt + if is-img { 0pt } else { fitted * 0.24 })
          let st = body => if subtitle-bold {
            text(font: title-font, size: 21pt, weight: "bold", fill: accent, tracking: 0.08em, body)
          } else {
            text(font: f-jp, size: 21pt, weight: "medium", fill: accent, tracking: 0.14em, body)
          }
          st[#"-" #subtitle #"-"]
        }
      ])
    ],
    line(length: 100%, stroke: hair),

    // 3 スペック(参考画像は中央列がやや広い)
    block(width: 100%, height: spec-h)[
      #grid(
        columns: (246pt, 1fr, 246pt),
        stroke: (x, y) => if x > 0 { (left: hair) },
        inset: 0pt,
        ..specs.map(s => block(width: 100%, height: 100%, inset: (x: 8pt))[
          #align(center + horizon)[#mono(size: spec-size)[#s]]
        ])
      )
    ],
    line(length: 100%, stroke: hair),

    // 4 ビジュアル(幅は紙面の 47.6%、高さ 248pt)
    ..if not show-visual { () } else { (block(width: 100%, height: vis-h)[
      #let box-h = if visual-h == auto { calc.min(248pt, vis-h - 60pt) } else { calc.min(visual-h, vis-h - 30pt) }
      #place(center + horizon)[
        #box(width: calc.min(visual-w, size.width), height: box-h)[
          #if visual != none {
            block(width: 100%, height: 100%, clip: true)[
              #set image(width: 100%, height: 100%, fit: "cover")
              #visual
            ]
          } else {
            rect(width: 100%, height: 100%, fill: none, stroke: none)[
              #rect(width: 100%, height: 100%, fill: dots, stroke: none)
              #place(center + horizon,
                     rect(width: box-h * 0.66, height: box-h * 0.66,
                          fill: accent.transparentize(20%), stroke: none))
              #place(center + horizon,
                     rect(fill: ground, inset: (x: 12pt, y: 8pt))[#mono(size: 18pt)[PHOTO]])
            ]
          }
        ]
      ]
      #if visual-caption != none {
        place(bottom + left, dy: -6pt)[#mono(size: 12pt, tracking: 0.4pt)[#visual-caption]]
      }
    ], line(length: 100%, stroke: hair)) },

    // 5 ABSTRACT / HOW TO PLAY(縦線は紙面の中央)
    block(width: 100%, height: bottom-h)[
      #grid(
        columns: (1fr, 1fr),
        block(width: 100%, height: 100%, inset: (top: 44pt, right: 40pt))[
          #set block(spacing: 0pt)
          #mono(size: 37pt)[ABSTRACT]
          #v(18pt)
          #block[
            #set par(spacing: 0.9em, leading: 0.8em, justify: true)
            #jp(size: abstract-size, font: body-font)[#abstract-text]
          ]
        ],
        block(width: 100%, height: 100%, stroke: (left: hair), inset: (top: 44pt, left: 40pt))[
          #set block(spacing: 0pt)
          #set par(spacing: 0pt)
          #mono(size: 37pt)[#side-title]
          #v(if side-body != none { 18pt } else { 26pt })
          #if side-body != none {
            set par(spacing: 0.9em, leading: 0.8em, justify: true)
            block(inset: (right: 0pt))[#jp(size: side-size, font: body-font)[#side-body]]
          }
          #for (i, it) in (if side-body != none { () } else { how-to }).enumerate() {
            let (word, desc) = if type(it) == str {
              let parts = it.split(" — ")
              (parts.at(0), parts.at(1, default: none))
            } else { it }
            block(below: 17pt)[
              #grid(
                columns: (auto, 1fr), column-gutter: 14pt, align: horizon,
                mono(size: 34pt)[#(i + 1). #word],
                if desc != none { jp(size: 14pt, font: body-font)[#desc] },
              )
            ]
          }
        ],
      )
    ],
  )
})


// ===== 詳細・プレイ方法・戦略ページ共通のヘッダ(連番・タイトル・カテゴリ)=====
#let page-head(number, title, category, accent) = grid(
  columns: (auto, 1fr, auto), column-gutter: 28pt, align: horizon,
  text(font: f-num, size: 96pt, weight: "bold", fill: accent, tracking: -0.04em,
       top-edge: "cap-height", bottom-edge: "baseline")[#number],
  gro(size: 40pt)[#title],
  mono(size: 22pt)[#category],
)

// ===== 詳細ページ(パネルに入りきらない説明用)=====
// panel() と同じ判型・罫線・アクセント色。本文中の `= 見出し` / `== 小見出し` が使える。
// 2 段組で、見出しは gro(太字ゴシック)、本文は jp。
#let detail(
  number: "01",
  category: "DETAIL",
  title: "TITLE",
  accent: rgb("#FE430C"),
  cols: 2,
  body-size: 19pt,
  body,
) = {
  // ヘッダ: 連番(アクセント色)+ タイトル + カテゴリ
  page-head(number, title, category, accent)
  v(14pt)
  line(length: 100%, stroke: hair)
  v(26pt)

  {
    set par(leading: 0.95em, spacing: 1.1em, justify: true)
    set text(font: f-jp, size: body-size)
    show heading.where(level: 1): it => block(above: 1.6em, below: 0.7em, breakable: false)[
      #grid(columns: (10pt, 1fr), column-gutter: 10pt, align: horizon,
        square(size: 10pt, fill: accent), gro(size: 24pt, tracking: 0pt)[#it.body])
    ]
    show heading.where(level: 2): it => block(above: 1.3em, below: 0.5em, breakable: false)[
      #gro(size: 17pt, tracking: 0pt)[#it.body]
    ]
    show strong: set text(weight: "bold")
    columns(cols, gutter: 40pt, body)
  }
}

// ===== プレイ方法ページ(画像 + 説明の縦並びステップ)=====
// detail() と同じヘッダ・罫線・アクセント色。steps は
//   (image: image("図.png"), focus: (x, y, w, h) か none, title: "見出し", body: "説明")
// の配列。focus は 480×320 画像上の座標で、その外側を暗くして黄色の枠で囲む。
#let spotlight(path, focus, width) = {
  let unit = width / 480
  block(width: width, height: width * 2 / 3, clip: true, above: 0pt, below: 0pt)[
    #if type(path) == str { image(path, width: width) } else { set image(width: width); path }
    #if focus != none {
      let (x, y, w, h) = focus
      for (mx, my, mw, mh) in (
        (0, 0, 480, y), (0, y + h, 480, 320 - y - h), (0, y, x, h), (x + w, y, 480 - x - w, h),
      ) {
        place(top + left, dx: mx * unit, dy: my * unit,
          rect(width: mw * unit, height: mh * unit, stroke: none, fill: black.transparentize(40%)))
      }
      for (spread, alpha, weight) in ((3pt, 88%, 4pt), (1.5pt, 72%, 3pt), (0pt, 0%, 2.5pt)) {
        place(top + left, dx: x * unit - spread, dy: y * unit - spread,
          rect(width: w * unit + 2 * spread, height: h * unit + 2 * spread,
               fill: none, stroke: weight + rgb("#ffe500").transparentize(alpha)))
      }
    }
  ]
}

#let howto(
  number: "01",
  category: "HOW TO PLAY",
  title: "TITLE",
  accent: rgb("#FE430C"),
  image-width: 290pt,
  steps: (),
) = {
  page-head(number, title, category, accent)
  v(14pt)
  line(length: 100%, stroke: hair)

  let n = steps.len()
  grid(
    columns: (image-width, 1fr), column-gutter: 0pt,
    rows: (image-width * 2 / 3 + 22pt,) * n,
    align: left + horizon,
    stroke: (x, y) => if y > 0 { (top: 1pt + ink) },
    ..steps.enumerate().map(((i, s)) => (
      pad(y: 11pt, spotlight(s.image, s.at("focus", default: none), image-width)),
      pad(left: 30pt, y: 11pt, grid(
        columns: (auto, 1fr), column-gutter: 22pt, align: horizon,
        mono(size: 56pt, weight: "bold")[#text(fill: accent)[#{ let t = str(i + 1); if t.len() < 2 { "0" + t } else { t } }]],
        block(stroke: (left: hair), inset: (left: 22pt, y: 4pt))[
          #gro(size: 26pt, tracking: 0pt)[#s.title]
          #v(8pt)
          #jp(size: 18pt)[#s.body]
        ],
      )),
    )).flatten(),
  )
}

// ===== 戦略ページ(図 + 見出し + 説明を並べる)=====
// sec-head: アクセント色の連番 + 縦罫線 + 見出し。
// fig-cap:  図(`image(...)` をそのまま渡す。幅は w に揃う)と、その下の見出し・説明。
#let sec-head(number, title, accent) = grid(
  columns: (auto, 1fr), column-gutter: 20pt, align: horizon,
  mono(size: 52pt, weight: "bold")[#text(fill: accent)[#number]],
  block(stroke: (left: hair), inset: (left: 20pt, y: 4pt))[#gro(size: 28pt, tracking: 0pt)[#title]],
)

#let fig-cap(img, title, body, w) = block(width: w, breakable: false)[
  #{ set image(width: 100%); img }
  #v(10pt)
  #gro(size: 21pt, tracking: 0pt)[#title]
  #v(4pt)
  #jp(size: 16pt)[#body]
]

// 見出しの下に、同じ幅の列を並べる。cols は (見出しを付けた) 列の配列。
#let strategy(
  number: "01",
  category: "STRATEGY",
  title: "TITLE",
  accent: rgb("#FE430C"),
  body,
) = {
  page-head(number, title, category, accent)
  v(14pt)
  line(length: 100%, stroke: hair)
  v(20pt)
  body
}

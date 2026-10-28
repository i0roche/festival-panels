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

#let gro(size: 30pt, fill: ink, tracking: -0.03em, body) = text(
  font: (f-sans, f-jp), size: size, weight: "bold", tracking: tracking, fill: fill,
  top-edge: "cap-height", bottom-edge: "baseline",
)[#body]

#let jp(size: 16pt, weight: "regular", body) = text(
  font: f-jp, size: size, weight: weight,
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
  title-stretch: auto,    // 縦倍率。auto: 英字 130% / 日本語 100%(日本語は字が高いので伸ばさない)
  specs: ("TIME: --", "PLAYER: -", "DIFFICULTY: -"),
  accent: rgb("#FE430C"),
  abstract-text: [],
  how-to: (),            // "WORD — 説明" 形式の文字列、または (word, 説明) の配列
  visual: none,
  visual-caption: none,
) = layout(size => {
  let is-img = logo != none
  let cjk = type(title) == str and title.find(regex("[\u{3000}-\u{9fff}]")) != none
  let title-size = if title-size == auto { if cjk { 120pt } else { 150pt } } else { title-size }
  let title-stretch = if title-stretch == auto { if cjk { 100% } else { 130% } } else { title-stretch }
  let fitted = if is-img { 0pt } else {
    let m = measure(text(font: (f-sans, f-jp), size: 100pt, weight: "bold",
                         tracking: -0.03em)[#title])
    calc.min(100pt * (size.width / m.width), title-size)
  }
  let num-h    = 238pt
  let title-h  = 182pt
  let spec-h   = 64pt
  let bottom-h = 239pt
  let vis-h    = size.height - num-h - title-h - spec-h - bottom-h - 4 * 2pt

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
      #align((if is-img { center } else { left }) + horizon)[
        #if is-img {
          // ロゴは背景なし・線をアクセント色にして中央寄せ(高さで収める)
          // 横長のロゴは幅いっぱい、縦長のロゴは高さで収める
          let img = image(bytes(read(logo).replace("LOGOCOLOR", accent.to-hex())), format: "svg")
          let m = measure(img)
          let max-h = title-h - 30pt
          image(bytes(read(logo).replace("LOGOCOLOR", accent.to-hex())), format: "svg",
                width: calc.min(size.width, (m.width / m.height) * max-h))
        } else { scale(y: title-stretch, reflow: true, gro(size: fitted)[#title]) }
      ]
    ],
    line(length: 100%, stroke: hair),

    // 3 スペック(参考画像は中央列がやや広い)
    block(width: 100%, height: spec-h)[
      #grid(
        columns: (246pt, 1fr, 246pt),
        stroke: (x, y) => if x > 0 { (left: hair) },
        inset: 0pt,
        ..specs.enumerate().map(((i, s)) => {
          let al = (left, center, right).at(i)
          let pad = (
            (left: 0pt, right: 18pt),
            (left: 18pt, right: 18pt),
            (left: 18pt, right: 0pt),
          ).at(i)
          block(width: 100%, height: 100%, inset: pad)[
            #align(al + horizon)[#mono(size: 27pt)[#s]]
          ]
        })
      )
    ],
    line(length: 100%, stroke: hair),

    // 4 ビジュアル(幅は紙面の 47.6%、高さ 248pt)
    block(width: 100%, height: vis-h)[
      #let box-h = calc.min(248pt, vis-h - 60pt)
      #place(center + horizon)[
        #box(width: 400pt, height: box-h)[
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
    ],
    line(length: 100%, stroke: hair),

    // 5 ABSTRACT / HOW TO PLAY(縦線は紙面の中央)
    block(width: 100%, height: bottom-h)[
      #grid(
        columns: (1fr, 1fr),
        block(width: 100%, height: 100%, inset: (top: 44pt, right: 40pt))[
          #set block(spacing: 0pt)
          #set par(spacing: 0pt, leading: 0.8em, justify: true)
          #mono(size: 37pt)[ABSTRACT]
          #v(18pt)
          #jp(size: 15pt)[#abstract-text]
        ],
        block(width: 100%, height: 100%, stroke: (left: hair), inset: (top: 44pt, left: 40pt))[
          #set block(spacing: 0pt)
          #set par(spacing: 0pt)
          #mono(size: 37pt)[HOW TO PLAY]
          #v(26pt)
          #for (i, it) in how-to.enumerate() {
            let (word, desc) = if type(it) == str {
              let parts = it.split(" — ")
              (parts.at(0), parts.at(1, default: none))
            } else { it }
            block(below: 17pt)[
              #grid(
                columns: (auto, 1fr), column-gutter: 14pt, align: horizon,
                mono(size: 34pt)[#(i + 1). #word],
                if desc != none { jp(size: 14pt)[#desc] },
              )
            ]
          }
        ],
      )
    ],
  )
})


require('./lib')
require('io/console')

# In real life situations we'd adjust the document to fit the width we've
#  detected. In the case of this example we're hardcoding the width, and
#  later using the detected width only to truncate in order to avoid jaggy
#  wrapping.
WIDTH = 96
COLUMN_WIDTH = 30

### Style definitions

# General
SUBTLE    = LipGloss.adaptive_color(light: "#D9DCCF", dark: "#383838")
HIGHLIGHT = LipGloss.adaptive_color(light: "#874BFD", dark: "#7D56F4")
SPECIAL   = LipGloss.adaptive_color(light: "#43BF6D", dark: "#73F59F")

DIVIDER = LipGloss.style(
  padding: [0, 1],
  foreground: SUBTLE
).render("•")

URL = LipGloss.style(foreground: SPECIAL)

# Tabs

ACTIVE_TAB_BORDER = LipGloss.border(
  top:          "─",
  bottom:       " ",
  left:         "│",
  right:        "│",
  top_reft:     "╭",
  top_right:    "╮",
  bottom_reft:  "┘",
  bottom_right: "└",
)

TAB_BORDER = LipGloss.border(
  top:          "─",
  bottom:       "─",
  left:         "│",
  right:        "│",
  top_left:     "╭",
  top_right:    "╮",
  bottom_left:  "┴",
  bottom_right: "┴",
)

TAB = LipGloss.style(
  border: [TAB_BORDER, true],
  border_foreground: HIGHLIGHT,
  padding: [0, 1],
)

ACTIVE_TAB = TAB.extend(
  border: [ACTIVE_TAB_BORDER, true],
)

TAB_GAP = TAB.extend(
  border_top: false,
  border_left: false,
  border_right: false,
)

# Title

TITLE_STYLE = LipGloss.style(
  margin_left: 1,
  margin_right: 5,
  padding: [0, 1],
  italic: true,
  foreground: LipGloss.color("#FFF7DB"),
  # TODO ?
  string: 'Lip Gloss',
)

DESC_STYLE = LipGloss.style(
  margin_top: 1,
)

INFO_STYLE = LipGloss.style(
  border_style: LipGloss::NORMAL_BORDER,
  border_top: true,
  border_forground: SUBTLE,
)

# Dialog.

DIALOG_BOX_STYLE = LipGLoss.style(
  border: LipGloss.RoundedBorder(),
  borderForeground: LipGloss.Color("#874BFD"),
  padding: [1, 0],
  border_top: true,
  border_left: true,
  border_right: true,
  border_bottom: true,
)

BUTTON_STYLE = LipGloss.style(
  foreground: LipGloss.color("#FFF7DB"),
  background: LipGloss.color("#888B7E"),
  padding: [0, 3],
  margin_top: 1,
)

ACTIVE_BUTTON_STYLE = BUTTON_STYLE.extend(
  background: LipGloss.color("#F25D94"),
  margin_right: 2,
  underline: true,
)

# List

LIST = LipGloss.style(
  border: [LipGloss::NORMALBORDER, false, true, false, false],
  border_foreground: SUBTLE,
  margin_right: 2,
  height: 8,
  width: COLUMN_WIDTH + 1,
)

LIST_HEADER = LipGloss.style(
  border_style: LipGloss::NORMAL_BORDER,
  border_bottom: true,
  border_foreground: SUBTLE,
  margin_right: 2,
)

LIST_ITEM = LipGloss.style(padding_left: 2)

CHECK_MARK = LipGloss.style(
  foreground: SPECIAL,
  padding_right: 1,
).render("✓")

def list_done(s)
  CHECK_MARK + LipGloss.style(
    strikethrough: true,
    foreground: LipGloss.adaptive_color(light: "#969B86", dark: "#696969"),
  ).render(s)
end

# Paragraphs/History

HISTORY_STYLE = LipGloss.style(
  align: LipGloss::LEFT,
  foreground: LipGloss.color("#FAFAFA"),
  background: HIGHLIGHT,
  margin: [1, 3, 0, 0],
  padding: [1, 2],
  height: 19,
  width: COLUMN_WIDTH,
)

# Status Bar

STATUS_NUGGET = LipGloss.style(
  foreground: LipGloss.color("#FFFDF5"),
  padding: [0, 1],
)

STATUS_BAR_STYLE = LipGloss.style(
  foreground: LipGloss.adaptive_color(light: "#343433", dark: "#C1C6B2"),
  background: LipGloss.adaptive_color(light: "#D9DCCF", dark: "#353533"),
)

STATUS_STYLE = STATUS_BAR_STYLE.extend(
  foreground: LipGloss.color("#FFFDF5"),
  background: LipGloss.color("#FF5F87"),
  padding: [0, 1],
  margin_right: 1,
)

ENCODING_STYLE = STATUS_NUGGET.extend(
  background: LipGloss.color("#A550DF"),
  align: LipGloss::RIGHT,
)

STATUS_TEXT = STATUS_BAR_STYLE.extend

FISH_CAKE_STYLE = STATUS_NUGGET.extend(
  background: LipGloss.Color("#6124DF"),
)

# Page

DOC_STYLE = LipGloss.style(
  padding: [1, 2, 1, 2],
)

physical_width = IO.console.winsize[1]

doc = +''

begin
  row = LipGloss.join_horizontal(
    LipGloss::TOP,
    ACTIVE_TAB.render('Lip Gloss'),
    TAB.render('Blush'),
    TAB.render('Eye Shadow'),
    TAB.render('Mascara'),
    TAB.render('Foundation'),
  )
  gap = TAB_GAP.render(
    ' ' * [0, width - LipGloss.width(row) - 2].max
  )
  row = LipGloss.join_horizontal(LipGloss::BOTTOM, row, gap)
  doc << row << "\n\n"
end

def color_grid(x_steps, y_steps)
  x0y0 = LipGloss.colorful("#F25D94")
  x1y0 = LipGloss.colorful("#EDFF82")
  x0y1 = LipGloss.colorful("#643AFF")
  x1y1 = LipGloss.colorful("#14F9D5")

  x0 = []
  x0 = y_steps.times.map { |i| x0y0.blend_luv(x0y1, i.to_f / y_steps.to_f) }
  x1 = y_steps.times.map { |i| x1y0.blend_luv(x1y1, i.to_f / y_steps.to_f) }

  y_steps.times.map do |x|
    y0 = x0[x]
    x_steps.times.map do |y|
      y0.blend_luv(x1[x], y.to_f / x_steps.to_f).hex
    end
  end
end

# Title
begin
  colors = color_grid(1, 5)
  title = +''

  colors.each.with_index do |v, i|
    offset = 2
    c = LipGloss.Color(v[0])
    # fmt.Fprint(&title, titleStyle.Copy().MarginLeft(i*offset).Background(c))
    title << TITLE_STYLE.extend(margin_left: i * offset, background: c).render
    title << "\n" if i < colors.size - 1
  end

  desc = LipGloss.join_vertical(
    LipGloss::LEFT,
    DESC_STYLE.render("Style Definitions for Nice Terminal Layouts"),
    INFO_STYLE.render("From Charm#{DIVIDER}#{URL.render("https://github.com/charmbracelet/lipgloss")}"),
  )

  row = LipGloss.join_horizontal(LipGloss::TOP, title, desc)
  doc << row << "\n\n"
end

# Dialog
begin
  ok_button = ACTIVE_BUTTON_STYLE.render("Yes")
  cancel_button = BUTTON_STYLE.render("Maybe")

  question = LipGloss.style(width: 50, align: LipGloss::CENTER).render("Are you sure you want to eat marmalade?")
  buttons = LipGloss.join_horizontal(LipGloss::TOP, ok_button, cancel_button)
  ui = LipGloss.join_vertical(LipGloss::CENTER, question, buttons)

  dialog = LipGloss.place(WIDTH, 9,
    LipGloss::CENTER, LipGloss::CENTER,
    DIALOG_BOX_STYLE.render(ui),
    LipGloss.with_whitespace_chars("猫咪"),
    LipGloss.with_whitespace_foreground(SUBTLE),
  )

  doc << dialog << "\n\n"
end

# Color grid
begin
  colors = +''
  color_grid(14, 8).each do |x|
    x.each do |y|
      colors << LipGloss.style(background: LipGloss.color(y)).render('  ')
    end
    colors << "\n"
  end

  lists = LipGloss.join_horizontal(
    LipGloss::TOP,
    LIST.render(
      LipGloss.join_vertical(
        LipGloss::LEFT,
        LIST_HEADER.render("Citrus Fruits to Try"),
        LIST_DONE.render("Grapefruit"),
        LIST_DONE.render("Yuzu"),
        LIST_ITEM.render("Citron"),
        LIST_ITEM.render("Kumquat"),
        LIST_ITEM.render("Pomelo"),
      ),
    ),
    LIST.extend(width: COLUMN_WIDTH).render(
      LipGloss.join_vertical(
        LipGloss.Left,
        LIST_HEAER.render("Actual Lip Gloss Vendors"),
        LIST_ITEM.render("Glossier"),
        LIST_ITEM.render("Claire‘s Boutique"),
        LIST_DONE.render("Nyx"),
        LIST_ITEM.render("Mac"),
        LIST_DONE.render("Milk"),
      ),
    ),
  )

  doc << LipGloss.join_horizontal(LipGloss::TOP, lists, colors)
end

# Marmalade history
begin
  history_a = "The Romans learned from the Greeks that quinces slowly cooked with honey would “set” when cool. The Apicius gives a recipe for preserving whole quinces, stems and leaves attached, in a bath of honey diluted with defrutum: Roman marmalade. Preserves of quince and lemon appear (along with rose, apple, plum and pear) in the Book of ceremonies of the Byzantine Emperor Constantine VII Porphyrogennetos."
  history_a = "Medieval quince preserves, which went by the French name cotignac, produced in a clear version and a fruit pulp version, began to lose their medieval seasoning of spices in the 16th century. In the 17th century, La Varenne provided recipes for both thick and clear cotignac."
  history_a = "In 1524, Henry VIII, King of England, received a “box of marmalade” from Mr. Hull of Exeter. This was probably marmelada, a solid quince paste from Portugal, still made and sold in southern Europe today. It became a favourite treat of Anne Boleyn and her ladies in waiting."

  doc << LipGloss.join_horizontal(
    LipGloss::TOP,
    HISTORY_STYLE.extend(align: LipGloss::RIGHT).render(history_a),
    HISTORY_STYLE.extend(align: LipGloss::CENTER).render(history_b),
    HISTORY_STYLE.extend(margin_right: 0).render(history_c),
  )

  doc << "\n\n"
end

# Status bar
begin
  status_key = STATUS_STYLE.render("STATUS")
  encoding = ENCODING_STYLE.render("UTF-8")
  fish_cake = FISH_CAKE_STYLE.render("🍥 Fish Cake")
  status_val = STATUS_TEXT.extend(
    width: width - LipGloss.width(status_key) - LipGloss.width(encoding) - LipGloss.width(fish_cake),
  ).render("Ravishing")

  bar = LipGloss.join_horizontal(
    LipGloss::TOP,
    status_key,
    status_val,
    encoding,
    fish_cake,
  )

  doc << STATUS_BAR_STYLE.extend(width: width).render(bar)
end

doc_style = LipGloss.style(padding: [1, 2, 1, 2])
if physical_width > 0
  doc_style = doc_style.extend(max_width: physical_width)
end

puts(doc_style.render(doc))

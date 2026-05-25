local core = require("snippetlib.core")
local conditions = require("snippetlib.conditions")
local typst = require("snippetlib.typst")
local matrix = require("snippetlib.matrix")

local s = core.s
local t = core.t
local i = core.i
local fmta = core.fmta

local in_typst_math = conditions.typst_mathzone

local typst_snippets = {}

core.append(typst_snippets, {
  s({ trig = "mk", dscr = "inline math" }, fmta("$<> $<>", { i(1), i(0) })),
  s({ trig = "dm", dscr = "display math" }, { t({ "$", "\t" }), i(0), t({ "", "$" }) }),
})

core.append(
  typst_snippets,
  typst.greek(in_typst_math),
  {
    core.autosnip({ trig = "txt", dscr = "Text in math" }, {
      t('text("'),
      i(1),
      t('")'),
      i(0),
    }, { condition = in_typst_math }),
  },
  typst.scripts(in_typst_math),
  {
    core.autosnip({ trig = "djf", dscr = "Definite integral" }, {
      t("integral_("),
      i(1),
      t(")^("),
      i(2),
      t(") "),
      i(0),
      t(" dd("),
      i(3),
      t(")"),
    }, { condition = in_typst_math }),
  },
  typst.fonts(in_typst_math),
  typst.operators(in_typst_math),
  typst.matrix(matrix.typst, in_typst_math),
  typst.angle(in_typst_math)
)

return typst_snippets

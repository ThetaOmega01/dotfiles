local core = require("snippetlib.core")
local conditions = require("snippetlib.conditions")
local latex = require("snippetlib.latex")
local matrix = require("snippetlib.matrix")

local s = core.s
local t = core.t
local i = core.i
local fmta = core.fmta

local in_mathzone = conditions.markdown_mathzone

local snippets = {}

core.append(snippets, {
  s("mk", fmta([[$<>$<>]], { i(1), i(0) })),

  s("dm", {
    t("$$"),
    t({ "", "\t" }),
    i(0),
    t({ "", "$$" }),
  }),

  core.math("djf", {
    t("\\int_{"),
    i(1),
    t("}^{"),
    i(2),
    t("} "),
    i(0),
    t(" \\mathrm{d}{"),
    i(3, "x"),
    t("}"),
  }, in_mathzone),

  core.math("varlimsup", {
    t("\\varlimsup_{"),
    i(1, "n"),
    t("\\to "),
    i(2, "\\infty"),
    t("}{"),
    i(0),
    t("} "),
  }, in_mathzone),

  core.math("varliminf", {
    t("\\varliminf_{"),
    i(1, "n"),
    t("\\to "),
    i(2, "\\infty"),
    t("}{"),
    i(0),
    t("} "),
  }, in_mathzone),

  core.math("sum", {
    t("\\sum_{"),
    i(1),
    t("}^{"),
    i(2),
    t("} "),
    i(0),
  }, in_mathzone),

  core.math("prod", {
    t("\\prod_{"),
    i(1),
    t("}^{"),
    i(2),
    t("} "),
    i(0),
  }, in_mathzone),
})

core.append(
  snippets,
  latex.angle_and_colors(in_mathzone),
  latex.calculus_and_linear(in_mathzone),
  latex.regex(in_mathzone, matrix.latex, {
    matrix_context = {
      trig = "([0-9])([0-9])([bBpvV]?)mat",
      name = "[bBpvV]matrix",
      dscr = "matrices",
      regTrig = true,
    },
  }),
  latex.relation_symbols(in_mathzone),
  latex.taylor_fraction(in_mathzone),
  latex.greek(in_mathzone),
  latex.delimiters(in_mathzone),
  latex.math_symbols(in_mathzone),
  latex.utilities(in_mathzone),
  { latex.begin_environment() }
)

return snippets

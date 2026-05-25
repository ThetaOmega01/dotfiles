local core = require("snippetlib.core")
local conditions = require("snippetlib.conditions")
local latex = require("snippetlib.latex")
local matrix = require("snippetlib.matrix")

local s = core.s
local t = core.t
local i = core.i
local rep = core.rep

local in_mathzone = conditions.tex_mathzone

local snippets = {}

core.append(snippets, {
  s("mk", {
    t("$ "),
    i(1),
    t(" $"),
    i(0),
  }),

  s("dm", {
    t("\\["),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\]" }),
  }),

  s("Def", {
    t("\\begin{definition}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{definition}" }),
  }),

  s("thm", {
    t("\\begin{theorem}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{theorem}" }),
  }),

  s("lthm", {
    t("\\begin{theorem}\\label{thm:"),
    i(1),
    t("}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{theorem}" }),
  }),

  s("lma", {
    t("\\begin{lemma}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{lemma}" }),
  }),

  s("prf", {
    t("\\begin{proof}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{proof}" }),
  }),

  s("eg", {
    t("\\begin{example}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{example}" }),
  }),

  s("note", {
    t("\\begin{note}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{note}" }),
  }),

  s("rmk", {
    t("\\begin{remark}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{remark}" }),
  }),

  s("law", {
    t("\\begin{law}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{law}" }),
  }),

  s("iff", {
    t("if and only if "),
  }),

  s("sieee", {
    t("\\begin{IEEEeqnarray*}{rCl}"),
    t({ "", "\t" }),
    i(1),
    t(" & = & "),
    i(2),
    t({ "", "\\\\" }),
    t({ "", "\t" }),
    t("& = & "),
    i(3),
    t({ "", "\\\\" }),
    t({ "", "\t" }),
    t("& = & "),
    i(4),
    t({ "", "\\end{IEEEeqnarray*}" }),
  }),

  s("ieee", {
    t("\\begin{IEEEeqnarray}{rCl}"),
    t({ "", "\t" }),
    i(1),
    t(" & = & "),
    i(2),
    t({ "", "\\\\" }),
    t({ "", "\t" }),
    t("& = & "),
    i(3),
    t({ "", "\\\\" }),
    t({ "", "\t" }),
    t("& = & "),
    i(4),
    t({ "", "\\end{IEEEeqnarray}" }),
  }),

  s("num", {
    t("\\IEEEyesnumber "),
  }),

  s("col", {
    t("\\begin{corollary}"),
    t({ "", "\t\t" }),
    i(0),
    t({ "", "\\end{corollary}" }),
  }),

  s("lcol", {
    t("\\begin{corollary}\\label{col:"),
    i(1),
    t("}"),
    t({ "", "\t\t" }),
    i(0),
    t({ "", "\\end{corollary}" }),
  }),

  s("Framed", {
    t("\\begin{framed}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{framed}" }),
  }),

  s("prop", {
    t("\\begin{proposition}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{proposition}" }),
  }),

  core.math("jf", {
    t("\\int "),
    i(0),
    t(" \\dd{"),
    i(1, "x"),
    t("}"),
  }, in_mathzone),

  core.math("djf", {
    t("\\int_{"),
    i(1),
    t("}^{"),
    i(2),
    t("} "),
    i(0),
    t(" \\dd{"),
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

  s("BQUE", {
    t("\\begin{question}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{question}" }),
  }),

  s("BQP", {
    t("\\begin{questionparts}"),
    t({ "", "\t\\item " }),
    i(0),
    t({ "", "\\end{questionparts}" }),
  }),

  s("cmtque", {
    t("%%%%%%%%%% Q"),
    i(0),
  }),

  s("rd", {
    t("\\left\\lfloor "),
    i(0),
    t(" \\right\\rfloor"),
  }),

  s("Sec", {
    t("\\section{"),
    i(1),
    t("}"),
    t({ "", "" }),
    i(0),
  }),

  s("baled", {
    t("\\begin{aligned}"),
    t({ "", "\t " }),
    i(0),
    t({ "", "\\end{aligned}" }),
  }),

  core.math("uint", {
    t("\\uint{"),
    i(1),
    t("}{"),
    i(2),
    t("} "),
    i(0),
    t(" \\,\\mathrm{d}"),
    i(3, "x"),
  }, in_mathzone),

  core.math("lint", {
    t("\\lint{"),
    i(1),
    t("}{"),
    i(2),
    t("} "),
    i(0),
    t(" \\,\\mathrm{d}"),
    i(3, "x"),
  }, in_mathzone),
})

core.append(
  snippets,
  latex.angle_and_colors(in_mathzone),
  latex.calculus_and_linear(in_mathzone),
  latex.regex(in_mathzone, matrix.latex, {
    math_font_trig = "m(bf|bb|rm|cal|scr)",
    matrix_context = {
      trig = "([1-9])([1-9])([bBpvV]?)mat",
      name = "[bBpvV]matrix",
      trigEngine = "ecma",
      dscr = "matrices",
      docstring = {
        "\\begin{bmatrix}",
        "$1 & $2\\\\",
        "$3 & $4",
        "\\end{bmatrix}",
      },
    },
  }),
  latex.relation_symbols(in_mathzone),
  latex.taylor_fraction(in_mathzone),
  latex.greek(in_mathzone),
  latex.delimiters(in_mathzone),
  latex.math_symbols(in_mathzone),
  latex.utilities(in_mathzone, { text_snippet = true }),
  { latex.begin_environment() }
)

return snippets

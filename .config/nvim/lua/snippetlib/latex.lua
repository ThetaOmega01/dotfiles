local core = require("snippetlib.core")

local s = core.s
local t = core.t
local i = core.i
local f = core.f
local d = core.d
local fmta = core.fmta
local rep = core.rep

local M = {}

local function math(context, nodes, condition)
  return core.math(context, nodes, condition)
end

local function lit(context, text, condition)
  return core.literal(context, text, condition)
end

local function cap(index)
  return f(function(_, snip)
    return snip.captures[index]
  end)
end

function M.angle_and_colors(condition)
  return {
    math("lrang", {
      t("\\langle "),
      i(1),
      t(" \\rangle "),
      i(0),
    }, condition),

    s("color", {
      t("{\\color{"),
      i(1),
      t("}"),
      i(0),
      t("}"),
    }),

    s("red", {
      t("{\\color{red}"),
      i(0),
      t("}"),
    }),

    s("blue", {
      t("{\\color{blue}"),
      i(0),
      t("}"),
    }),

    s("violet", {
      t("{\\color{violet}"),
      i(0),
      t("}"),
    }),
  }
end

function M.calculus_and_linear(condition)
  return {
    math("lineint", {
      t("\\int_{"),
      i(1, "C"),
      t("} "),
      i(0),
      t(" \\cdot\\mathrm{d}\\mathbf{"),
      i(2, "r"),
      t("}"),
    }, condition),

    math("sint", {
      t("\\int_{"),
      i(1, "D"),
      t("} "),
      i(0),
      t(" \\,\\mathrm{d}"),
      i(2, "A"),
    }, condition),

    math("vint", {
      t("\\int_{"),
      i(1, "V"),
      t("} "),
      i(0),
      t(" \\,\\mathrm{d}"),
      i(2, "V"),
    }, condition),

    math({ trig = "trsp", dscr = "transpose" }, {
      i(1),
      t("^\\mathrm{T}"),
    }, condition),

    lit({ trig = "cmpl", dscr = "complement" }, "\\complement", condition),

    math({ trig = "matset", dscr = "Matrix set" }, {
      t("\\mathcal{M}_{"),
      i(1, "n"),
      t("\\times "),
      i(2, "n"),
      t("}(\\mathbb{"),
      i(3, "F"),
      t("})"),
    }, condition),

    math({ trig = "conj", dscr = "Conjugate" }, {
      i(1, "g"),
      i(2, "f"),
      rep(1),
      t("^{-1}"),
    }, condition),

    math({ trig = "rconj", dscr = "reverse conjugate" }, {
      i(1, "g"),
      t("^{-1}"),
      i(2, "f"),
      rep(1),
    }, condition),

    lit({ trig = "sbst", dscr = "subset" }, "\\subseteq", condition),
    lit({ trig = "rra", dscr = "Rightarrow" }, "\\Rightarrow", condition),
    lit({ trig = "ra", dscr = "rightarrow" }, "\\rightarrow", condition),
    lit({ trig = "lla", dscr = "Leftarrow" }, "\\Leftarrow", condition),
    lit({ trig = "la", dscr = "leftarrow" }, "\\leftarrow", condition),
    lit({ trig = "oo", dscr = "infinity" }, "\\infty", condition),
    lit({ trig = "eqiv", dscr = "equivalent" }, "\\Leftrightarrow", condition),

    math({ trig = "ovl", dscr = "overline" }, {
      t("\\overline{"),
      i(0),
      t("}"),
    }, condition),

    math({ trig = "udl", dscr = "underline" }, {
      t("\\underline{"),
      i(0),
      t("}"),
    }, condition),

    math({ trig = "ovb", dscr = "overbrace" }, {
      t("\\overbrace{"),
      i(0),
      t("}"),
    }, condition),

    math({ trig = "udb", dscr = "underbrace" }, {
      t("\\underbrace{"),
      i(0),
      t("}"),
    }, condition),

    math({ trig = "norm", dscr = "norm" }, {
      t("\\left\\| "),
      i(1),
      t(" \\right\\|"),
    }, condition),

    lit({ trig = "rq", dscr = "forall" }, "\\forall", condition),
    lit({ trig = "cz", dscr = "exists" }, "\\exists", condition),

    math({ trig = "oper", dscr = "operatorname" }, {
      t("\\operatorname{"),
      i(1),
      t("}"),
    }, condition),

    math({ trig = "binom", dscr = "binom" }, {
      t("\\binom{"),
      i(1),
      t("}{"),
      i(2),
      t("}"),
    }, condition),

    lit({ trig = "EQIV", dscr = "longarrow" }, "\\Longleftrightarrow", condition),
    lit({ trig = "sm", dscr = "set minus" }, "\\setminus", condition),

    math({ trig = "cn", dscr = "cn" }, {
      t("\\mathbb{C}^{"),
      i(1),
      t("}"),
    }, condition),

    math({ trig = "rn", dscr = "rn" }, {
      t("\\mathbb{R}^{"),
      i(1),
      t("}"),
    }, condition),

    math({ trig = "zn", dscr = "zn" }, {
      t("\\mathbb{Z}^{"),
      i(1),
      t("}"),
    }, condition),

    lit({ trig = "dra", dscr = "longra" }, "\\Longrightarrow", condition),
    lit({ trig = "dla", dscr = "longla" }, "\\Longleftarrow", condition),
    lit({ trig = "car", dscr = "curved arrow right" }, "\\curvearrowright", condition),

    math({ trig = "bos", dscr = "bold symb" }, {
      t("\\boldsymbol{"),
      i(1),
      t("}"),
    }, condition),

    lit({ trig = "indp", dscr = "independent" }, "\\independent", condition),
  }
end

function M.regex(condition, matrix_generator, opts)
  opts = opts or {}

  return {
    math(
      {
        trig = opts.math_font_trig or "m(bf|bb|cal|scr|rm)",
        trigEngine = "ecma",
        dscr = "math font",
      },
      fmta([[\math<>{<>}]], {
        cap(1),
        i(1),
      }),
      condition
    ),

    math(
      {
        trig = "(sin|cos|tan|csc|sec|cot|arcsin|arccos|arctan|sinh|cosh|tanh|log|ln)",
        trigEngine = "ecma",
        dscr = "trig/log functions",
      },
      fmta([[\<>]], {
        cap(1),
      }),
      condition
    ),

    math({ trig = "(or|and)", trigEngine = "ecma", dscr = "logical or/and" }, {
      f(function(_, snip)
        local capture = snip.captures[1]
        return "\\l" .. capture
      end),
    }, condition),

    math({
      trig = "(%a)(%d)",
      wordTrig = false,
      regTrig = true,
    }, {
      f(function(_, snip)
        local letter = snip.captures[1]
        local number = snip.captures[2]
        return string.format("%s_%s", letter, number)
      end),
    }, condition),

    math({
      trig = "(%a)_(%d%d)",
      wordTrig = false,
      regTrig = true,
    }, {
      f(function(_, snip)
        local letter = snip.captures[1]
        local number = snip.captures[2]
        return string.format("%s_{%s}", letter, number)
      end),
    }, condition),

    math(
      opts.matrix_context,
      fmta(
        [[
    \begin{<>}
    <>
    \end{<>}]],
        {
          f(function(_, snip)
            return snip.captures[3] .. "matrix"
          end),
          d(1, matrix_generator),
          f(function(_, snip)
            return snip.captures[3] .. "matrix"
          end),
        }
      ),
      condition
    ),

    math({ trig = "([a-zA-Z])bar", regTrig = true, dscr = "bar" }, {
      t("\\overline{"),
      cap(1),
      t("}"),
    }, condition),

    math({ trig = "(\\\\?\\w+)(,\\.|\\.,)  ", regTrig = true, dscr = "Vector postfix" }, {
      t("\\mathbf{"),
      cap(1),
      t("}"),
    }, condition),

    math({ trig = "bf([a-zA-Z])", regTrig = true, dscr = "bf characters" }, {
      f(function(_, snip)
        return "\\mathbf{" .. snip.captures[1] .. "}"
      end),
    }, condition),

    math({ trig = "bb([A-Z])", regTrig = true, dscr = "bb char" }, {
      f(function(_, snip)
        return "\\mathbb{" .. snip.captures[1] .. "}"
      end),
    }, condition),

    math({ trig = "mc([A-Z])", regTrig = true, dscr = "cal char" }, {
      f(function(_, snip)
        return "\\mathcal{" .. snip.captures[1] .. "}"
      end),
    }, condition),

    math({ trig = "rm([a-zA-Z])", regTrig = true, dscr = "rm characters" }, {
      f(function(_, snip)
        return "\\mathrm{" .. snip.captures[1] .. "}"
      end),
    }, condition),
  }
end

function M.relation_symbols(condition)
  return {
    lit({ trig = "=>", dscr = "implies" }, "\\implies", condition),
    lit({ trig = "=<", dscr = "implied by" }, "\\impliedby", condition),
    lit({ trig = "==", dscr = "iff" }, "\\iff", condition),
    lit({ trig = "!=", dscr = "not equals" }, "\\neq ", condition),
  }
end

function M.taylor_fraction(condition)
  return {
    s({ trig = "taylor", dscr = "taylor" }, {
      t("\\sum_{"),
      i(1, "k"),
      t("="),
      i(2, "0"),
      t("}^{"),
      i(3, "\\infty"),
      t("} "),
      i(4, "c_"),
      rep(1),
      t(" (x-a)^"),
      rep(1),
      t(" "),
      i(0),
    }),

    math({ trig = "@/", dscr = "Fraction" }, {
      t("\\frac{"),
      i(1),
      t("}{"),
      i(2),
      t("}"),
      i(0),
    }, condition),

    lit({ trig = "notin", dscr = "not in " }, "\\not\\in ", condition),
  }
end

function M.greek(condition)
  local rows = {
    { "@a", "alpha", "\\alpha" },
    { "@b", "beta", "\\beta" },
    { "@c", "chi", "\\chi" },
    { "@d", "delta", "\\delta" },
    { "@e", "epsilon", "\\epsilon" },
    { "@f", "phi", "\\phi" },
    { "@g", "gamma", "\\gamma" },
    { "@h", "eta", "\\eta" },
    { "@i", "iota", "\\iota" },
    { "@k", "kappa", "\\kappa" },
    { "@l", "lambda", "\\lambda" },
    { "@m", "mu", "\\mu" },
    { "@n", "nu", "\\nu" },
    { "@p", "pi", "\\pi" },
    { "@q", "theta", "\\theta" },
    { "@r", "rho", "\\rho" },
    { "@s", "sigma", "\\sigma" },
    { "@t", "tau", "\\tau" },
    { "@u", "upsilon", "\\upsilon" },
    { "@o", "omega", "\\omega" },
    { "@&", "wedge", "\\wedge" },
    { "@x", "xi", "\\xi" },
    { "@y", "psi", "\\psi" },
    { "@z", "zeta", "\\zeta" },
    { "@D", "Delta", "\\Delta" },
    { "@F", "Phi", "\\Phi" },
    { "@G", "Gamma", "\\Gamma" },
    { "@Q", "Theta", "\\Theta" },
    { "@L", "Lambda", "\\Lambda" },
    { "@X", "Xi", "\\Xi" },
    { "@Y", "Psi", "\\Psi" },
    { "@S", "Sigma", "\\Sigma" },
    { "@U", "Upsilon", "\\Upsilon" },
    { "@W", "Omega", "\\Omega" },
    { "@ve", "varepsilon", "\\varepsilon" },
    { "@vf", "varphi", "\\varphi" },
    { "@vs", "varsigma", "\\varsigma" },
    { "@vq", "vartheta", "\\vartheta" },
  }

  local snippets = {}
  for _, row in ipairs(rows) do
    table.insert(snippets, lit({ trig = row[1], dscr = row[2] }, row[3], condition))
  end
  return snippets
end

function M.delimiters(condition)
  return {
    math({ trig = "@()", dscr = "()" }, {
      t("\\left( "),
      i(1),
      t(" \\right)"),
    }, condition),

    math({ trig = "@{}", dscr = "{}" }, {
      t("\\left\\{ "),
      i(1),
      t(" \\right\\}"),
    }, condition),

    math({ trig = "@[]", dscr = "[]" }, {
      t("\\left[ "),
      i(1),
      t(" \\right]"),
    }, condition),
  }
end

function M.math_symbols(condition)
  return {
    lit({ trig = "@.", dscr = "cdot" }, "\\cdot", condition),
    lit({ trig = "@6", dscr = "partial" }, "\\partial", condition),

    math({ trig = "@^", dscr = "Hat" }, {
      t("\\Hat{"),
      i(1),
      t("}"),
    }, condition),

    lit({ trig = "@@", dscr = "circ" }, "\\circ", condition),
    lit({ trig = "@0", dscr = "^\\circ" }, "^\\circ", condition),
    lit({ trig = "@*", dscr = "times" }, "\\times", condition),

    math({ trig = "@2", dscr = "\\sqrt" }, {
      t("\\sqrt{"),
      i(1),
      t("}"),
    }, condition),

    lit({ trig = "cong", dscr = "\\cong" }, "\\cong", condition),
  }
end

function M.utilities(condition, opts)
  opts = opts or {}

  local snippets = {
    lit({ trig = "pf", wordTrig = false, dscr = "^2" }, "^2", condition),
    lit({ trig = "lf", wordTrig = false, dscr = "^3" }, "^3", condition),

    math({ trig = "**", wordTrig = false, dscr = "superscript" }, {
      t("^{"),
      i(1),
      t("}"),
      i(0),
    }, condition),

    math({ trig = "__", wordTrig = false, dscr = "subscript" }, {
      t("_{"),
      i(1),
      t("}"),
      i(0),
    }, condition),
  }

  if opts.text_snippet then
    table.insert(snippets, math({ trig = "tt", dscr = "\\text{}" }, fmta([[\text{<>}]], { i(1) }), condition))
  end

  core.append(snippets, {
    math({ trig = "~~", wordTrig = false, dscr = "~" }, {
      t("\\sim "),
    }, condition),

    math({ trig = "||", wordTrig = false, dscr = "mid" }, {
      t(" \\mid "),
    }, condition),
  })

  return snippets
end

function M.begin_environment()
  return s({ trig = "beg", dscr = "begin{} / end{}", snippetType = "autosnippet" }, {
    t("\\begin{"),
    i(1),
    t("}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{" }),
    rep(1),
    t("}"),
  })
end

return M

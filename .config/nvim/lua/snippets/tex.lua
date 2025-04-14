local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local conds = require("luasnip.extras.expand_conditions")

-- Helper functions
local function in_mathzone()
  return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

-- Matrix generator function
local function gen_matrix(nrow, ncol, index)
  local results = "\n"
  local order = 1
  for i = 0, nrow - 1 do
    results = results .. '    '
    for j = 0, ncol - 1 do
      if j == ncol - 1 then
        results = results .. " \\\\"
      else
        results = results .. " & "
      end
      order = order + 1
    end
    if index then
      results = results .. "\n"
    end
  end
  return results
end

-- Define the snippets
local snippets = {
  -- VSCode snippets from latex.json
  s("mk", {
    t("$ "),
    i(0),
    t(" $")
  }),

  s("dm", {
    t("\\["),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\]" })
  }),

  s("Def", {
    t("\\begin{definition}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{definition}" })
  }),

  s("thm", {
    t("\\begin{theorem}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{theorem}" })
  }),

  s("lthm", {
    t("\\begin{theorem}\\label{thm:"),
    i(1),
    t("}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{theorem}" })
  }),

  s("lma", {
    t("\\begin{lemma}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{lemma}" })
  }),

  s("prf", {
    t("\\begin{proof}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{proof}" })
  }),

  s("eg", {
    t("\\begin{example}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{example}" })
  }),

  s("note", {
    t("\\begin{note}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{note}" })
  }),

  s("rmk", {
    t("\\begin{remark}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{remark}" })
  }),

  s("law", {
    t("\\begin{law}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{law}" })
  }),

  s({ trig = "zwq", snippetType = "autosnippet" },
    {
      t("+\\infty "),
      i(0)
    },
    { condition = in_mathzone }
  ),

  s({ trig = "fwq", snippetType = "autosnippet" },
    {
      t("-\\infty "),
      i(0)
    },
    { condition = in_mathzone }
  ),

  s("iff", {
    t("if and only if ")
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
    t({ "", "\\end{IEEEeqnarray*}" })
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
    t({ "", "\\end{IEEEeqnarray}" })
  }),

  s("num", {
    t("\\IEEEyesnumber ")
  }),

  s("col", {
    t("\\begin{corollary}"),
    t({ "", "\t\t" }),
    i(0),
    t({ "", "\\end{corollary}" })
  }),

  s("lcol", {
    t("\\begin{corollary}\\label{col:"),
    i(1),
    t("}"),
    t({ "", "\t\t" }),
    i(0),
    t({ "", "\\end{corollary}" })
  }),

  s("Framed", {
    t("\\begin{framed}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{framed}" })
  }),

  s("prop", {
    t("\\begin{proposition}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{proposition}" })
  }),

  s({ trig = "jf", snippetType = "autosnippet" },
    {
      t("\\int "),
      i(0),
      t(" \\dd{"),
      i(1, "x"),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "djf", snippetType = "autosnippet" },
    {
      t("\\int_{"),
      i(1),
      t("}^{"),
      i(2),
      t("} "),
      i(0),
      t(" \\dd{"),
      i(3, "x"),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "varlimsup", snippetType = "autosnippet" },
    {
      t("\\varlimsup_{"),
      i(1, "n"),
      t("\\to "),
      i(2, "\\infty"),
      t("}{"),
      i(0),
      t("} ")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "varliminf", snippetType = "autosnippet" },
    {
      t("\\varliminf_{"),
      i(1, "n"),
      t("\\to "),
      i(2, "\\infty"),
      t("}{"),
      i(0),
      t("} ")
    },
    { condition = in_mathzone }
  ),

  s("BQUE", {
    t("\\begin{question}"),
    t({ "", "\t" }),
    i(0),
    t({ "", "\\end{question}" })
  }),

  s("BQP", {
    t("\\begin{questionparts}"),
    t({ "", "\t\\item " }),
    i(0),
    t({ "", "\\end{questionparts}" })
  }),

  s("cmtque", {
    t("%%%%%%%%%% Q"),
    i(0)
  }),

  s("rd", {
    t("\\left\\lfloor "),
    i(0),
    t(" \\right\\rfloor")
  }),

  s("Sec", {
    t("\\section{"),
    i(1),
    t("}"),
    t({ "", "" }),
    i(0)
  }),

  s(
    { trig = "he", snippetType = "autosnippet" },
    {
      t("\\sum_{"),
      i(1),
      t("}^{"),
      i(2),
      t("} "),
      i(0)
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "cheng", snippetType = "autosnippet" },
    {
      t("\\prod_{"),
      i(1),
      t("}^{"),
      i(2),
      t("} "),
      i(0)
    },
    { condition = in_mathzone }
  ),

  s("baled", {
    t("\\begin{aligned}"),
    t({ "", "\t " }),
    i(0),
    t({ "", "\\end{aligned}" })
  }),

  s(
    { trig = "uint", snippetType = "autosnippet" },
    {
      t("\\uint{"),
      i(1),
      t("}{"),
      i(2),
      t("} "),
      i(0),
      t(" \\,\\mathrm{d}"),
      i(3, "x")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "lint", snippetType = "autosnippet" },
    {
      t("\\lint{"),
      i(1),
      t("}{"),
      i(2),
      t("} "),
      i(0),
      t(" \\,\\mathrm{d}"),
      i(3, "x")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "lrang", snippetType = "autosnippet" },
    {
      t("\\langle "),
      i(1),
      t(" \\rangle "),
      i(0)
    },
    { condition = in_mathzone }
  ),

  s("color", {
    t("{\\color{"),
    i(1),
    t("}"),
    i(0),
    t("}")
  }),

  s("red", {
    t("{\\color{red}"),
    i(0),
    t("}")
  }),

  s("blue", {
    t("{\\color{blue}"),
    i(0),
    t("}")
  }),

  s("violet", {
    t("{\\color{violet}"),
    i(0),
    t("}")
  }),

  s(
    { trig = "lineint", snippetType = "autosnippet" },
    {
      t("\\int_{"),
      i(1, "C"),
      t("} "),
      i(0),
      t(" \\cdot\\mathrm{d}\\mathbf{"),
      i(2, "r"),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "sint", snippetType = "autosnippet" },
    {
      t("\\int_{"),
      i(1, "D"),
      t("} "),
      i(0),
      t(" \\,\\mathrm{d}"),
      i(2, "A")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "vint", snippetType = "autosnippet" },
    {
      t("\\int_{"),
      i(1, "V"),
      t("} "),
      i(0),
      t(" \\,\\mathrm{d}"),
      i(2, "V")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "trsp", dscr = "transpose", snippetType = "autosnippet" },
    {
      i(1),
      t("^\\mathrm{T}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "cmpl", dscr = "complement", snippetType = "autosnippet" },
    {
      t("\\complement")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "matset", dscr = "Matrix set", snippetType = "autosnippet" },
    {
      t("\\mathcal{M}_{"),
      i(1, "n"),
      t("\\times "),
      i(2, "n"),
      t("}(\\mathbb{"),
      i(3, "F"),
      t("})")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "conj", dscr = "Conjugate", snippetType = "autosnippet" },
    {
      i(1, "g"),
      i(2, "f"),
      rep(1),
      t("^{-1}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "rconj", dscr = "reverse conjugate", snippetType = "autosnippet" },
    {
      i(1, "g"),
      t("^{-1}"),
      i(2, "f"),
      rep(1)
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "sbst", dscr = "subset", snippetType = "autosnippet" },
    {
      t("\\subseteq")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "rra", dscr = "Rightarrow", snippetType = "autosnippet" },
    {
      t("\\Rightarrow")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "ra", dscr = "rightarrow", snippetType = "autosnippet" },
    {
      t("\\rightarrow")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "lla", dscr = "Leftarrow", snippetType = "autosnippet" },
    {
      t("\\Leftarrow")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "la", dscr = "leftarrow", snippetType = "autosnippet" },
    {
      t("\\leftarrow")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "wq", dscr = "infinity", snippetType = "autosnippet" },
    {
      t("\\infty")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "eqiv", dscr = "equivalent", snippetType = "autosnippet" },
    {
      t("\\Leftrightarrow")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "ovl", dscr = "overline", snippetType = "autosnippet" },
    {
      t("\\overline{"),
      i(0),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "udl", dscr = "underline", snippetType = "autosnippet" },
    {
      t("\\underline{"),
      i(0),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "ovb", dscr = "overbrace", snippetType = "autosnippet" },
    {
      t("\\overbrace{"),
      i(0),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "udb", dscr = "underbrace", snippetType = "autosnippet" },
    {
      t("\\underbrace{"),
      i(0),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "norm", dscr = "norm", snippetType = "autosnippet" },
    {
      t("\\left\\| "),
      i(1),
      t(" \\right\\|")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "rq", dscr = "forall", snippetType = "autosnippet" },
    {
      t("\\forall")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "cz", dscr = "exists", snippetType = "autosnippet" },
    {
      t("\\exists")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "oper", dscr = "operatorname", snippetType = "autosnippet" },
    {
      t("\\operatorname{"),
      i(1),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "binom", dscr = "binom", snippetType = "autosnippet" },
    {
      t("\\binom{"),
      i(1),
      t("}{"),
      i(2),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "EQIV", dscr = "longarrow", snippetType = "autosnippet" },
    {
      t("\\Longleftrightarrow")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "sm", dscr = "set minus", snippetType = "autosnippet" },
    {
      t("\\setminus")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "cn", dscr = "cn", snippetType = "autosnippet" },
    {
      t("\\mathbb{C}^{"),
      i(1),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "rn", dscr = "rn", snippetType = "autosnippet" },
    {
      t("\\mathbb{R}^{"),
      i(1),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "zn", dscr = "zn", snippetType = "autosnippet" },
    {
      t("\\mathbb{Z}^{"),
      i(1),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "dra", dscr = "longra", snippetType = "autosnippet" },
    {
      t("\\Longrightarrow")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "dla", dscr = "longla", snippetType = "autosnippet" },
    {
      t("\\Longleftarrow")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "car", dscr = "curved arrow right", snippetType = "autosnippet" },
    {
      t("\\curvearrowright")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "bos", dscr = "bold symb", snippetType = "autosnippet" },
    {
      t("\\boldsymbol{"),
      i(1),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "indp", dscr = "independent", snippetType = "autosnippet" },
    {
      t("\\independent")
    },
    { condition = in_mathzone }
  ),

  -- Regex-based snippets
  s(
    { trig = "m(bf|rm|bb|scr|cal)", regTrig = true, dscr = "math font", snippetType = "autosnippet" },
    {
      f(function(_, snip)
        local capture = snip.captures[1]
        return "\\math" .. capture .. "{"
      end),
      i(1),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "(or|and)", regTrig = true, dscr = "logical or/and", snippetType = "autosnippet" },
    {
      f(function(_, snip)
        local capture = snip.captures[1]
        return "\\l" .. capture
      end)
    },
    { condition = in_mathzone }
  ),

  s({
      trig = "(%a)(%d)",
      regTrig = true,
      snippetType = "autosnippet",
    },
    {
      f(function(_, snip)
        local letter = snip.captures[1]
        local number = snip.captures[2]
        return string.format("%s_%s", letter, number)
      end)
    }, { condition = in_mathzone }),

  -- Second snippet: single letter followed by 2 digits
  s({

      trig = "(%a)_(%d%d)", -- Letter followed by 2
      regTrig = true,
      snippetType = "autosnippet",
    },
    {
      f(function(_, snip)
        local letter = snip.captures[1]

        local number = snip.captures[2]

        return string.format("%s_{%s}", letter, number)
      end)
    }, { condition = in_mathzone }),

  s(
    { trig = "([1-9])([1-9])(bm|pm|m|vm)at", regTrig = true, dscr = "matrix", snippetType = "autosnippet" },
    {
      f(function(_, snip)
        local rows = tonumber(snip.captures[1])
        local cols = tonumber(snip.captures[2])
        local mtype = snip.captures[3]
        return "\\begin{" .. mtype .. "atrix}" .. gen_matrix(rows, cols, true) .. "\\end{" .. mtype .. "atrix}"
      end),
      i(0)
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "([a-zA-Z])bar", regTrig = true, dscr = "bar", snippetType = "autosnippet" },
    {
      t("\\overline{"),
      f(function(_, snip) return snip.captures[1] end),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "(\\\\?\\w+)(,\\.|\\.,)  ", regTrig = true, dscr = "Vector postfix", snippetType = "autosnippet" },
    {
      t("\\mathbf{"),
      f(function(_, snip) return snip.captures[1] end),
      t("}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "bf([a-zA-Z])", regTrig = true, dscr = "bf characters", snippetType = "autosnippet" },
    {
      f(function(_, snip)
        return "\\mathbf{" .. snip.captures[1] .. "}"
      end)
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "bb([A-Z])", regTrig = true, dscr = "bb char", snippetType = "autosnippet" },
    {
      f(function(_, snip)
        return "\\mathbb{" .. snip.captures[1] .. "}"
      end)
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "mc([A-Z])", regTrig = true, dscr = "cal char", snippetType = "autosnippet" },
    {
      f(function(_, snip)
        return "\\mathcal{" .. snip.captures[1] .. "}"
      end)
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "rm([a-zA-Z])", regTrig = true, dscr = "rm characters", snippetType = "autosnippet" },
    {
      f(function(_, snip)
        return "\\mathrm{" .. snip.captures[1] .. "}"
      end)
    },
    { condition = in_mathzone }
  ),

  -- Math symbols

  s(
    { trig = "=>", dscr = "implies", snippetType = "autosnippet" },
    {
      t("\\implies")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "=<", dscr = "implied by", snippetType = "autosnippet" },
    {
      t("\\impliedby")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "==", dscr = "iff", snippetType = "autosnippet" },
    {
      t("\\iff")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "!=", dscr = "not equals", snippetType = "autosnippet" },
    {
      t("\\neq ")
    },
    { condition = in_mathzone }
  ),

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
    i(0)
  }),

  s(
    { trig = "@/", dscr = "Fraction", snippetType = "autosnippet" },
    {
      t("\\frac{"),
      i(1),
      t("}{"),
      i(2),
      t("}"),
      i(0)
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "notin", dscr = "not in ", snippetType = "autosnippet" },
    {
      t("\\not\\in ")
    },
    { condition = in_mathzone }
  ),

  -- Greek letters
  s({ trig = "@a", dscr = "alpha", snippetType = "autosnippet" }, { t("\\alpha") }, { condition = in_mathzone }),
  s({ trig = "@b", dscr = "beta", snippetType = "autosnippet" }, { t("\\beta") }, { condition = in_mathzone }),
  s({ trig = "@c", dscr = "chi", snippetType = "autosnippet" }, { t("\\chi") }, { condition = in_mathzone }),
  s({ trig = "@d", dscr = "delta", snippetType = "autosnippet" }, { t("\\delta") }, { condition = in_mathzone }),
  s({ trig = "@e", dscr = "epsilon", snippetType = "autosnippet" }, { t("\\epsilon") }, { condition = in_mathzone }),
  s({ trig = "@f", dscr = "phi", snippetType = "autosnippet" }, { t("\\phi") }, { condition = in_mathzone }),
  s({ trig = "@g", dscr = "gamma", snippetType = "autosnippet" }, { t("\\gamma") }, { condition = in_mathzone }),
  s({ trig = "@h", dscr = "eta", snippetType = "autosnippet" }, { t("\\eta") }, { condition = in_mathzone }),
  s({ trig = "@i", dscr = "iota", snippetType = "autosnippet" }, { t("\\iota") }, { condition = in_mathzone }),
  s({ trig = "@k", dscr = "kappa", snippetType = "autosnippet" }, { t("\\kappa") }, { condition = in_mathzone }),
  s({ trig = "@l", dscr = "lambda", snippetType = "autosnippet" }, { t("\\lambda") }, { condition = in_mathzone }),
  s({ trig = "@m", dscr = "mu", snippetType = "autosnippet" }, { t("\\mu") }, { condition = in_mathzone }),
  s({ trig = "@n", dscr = "nu", snippetType = "autosnippet" }, { t("\\nu") }, { condition = in_mathzone }),
  s({ trig = "@p", dscr = "pi", snippetType = "autosnippet" }, { t("\\pi") }, { condition = in_mathzone }),
  s({ trig = "@q", dscr = "theta", snippetType = "autosnippet" }, { t("\\theta") }, { condition = in_mathzone }),
  s({ trig = "@r", dscr = "rho", snippetType = "autosnippet" }, { t("\\rho") }, { condition = in_mathzone }),
  s({ trig = "@s", dscr = "sigma", snippetType = "autosnippet" }, { t("\\sigma") }, { condition = in_mathzone }),
  s({ trig = "@t", dscr = "tau", snippetType = "autosnippet" }, { t("\\tau") }, { condition = in_mathzone }),
  s({ trig = "@u", dscr = "upsilon", snippetType = "autosnippet" }, { t("\\upsilon") }, { condition = in_mathzone }),
  s({ trig = "@o", dscr = "omega", snippetType = "autosnippet" }, { t("\\omega") }, { condition = in_mathzone }),
  s({ trig = "@&", dscr = "wedge", snippetType = "autosnippet" }, { t("\\wedge") }, { condition = in_mathzone }),
  s({ trig = "@x", dscr = "xi", snippetType = "autosnippet" }, { t("\\xi") }, { condition = in_mathzone }),
  s({ trig = "@y", dscr = "psi", snippetType = "autosnippet" }, { t("\\psi") }, { condition = in_mathzone }),
  s({ trig = "@z", dscr = "zeta", snippetType = "autosnippet" }, { t("\\zeta") }, { condition = in_mathzone }),

  -- Capital Greek letters
  s({ trig = "@D", dscr = "Delta", snippetType = "autosnippet" }, { t("\\Delta") }, { condition = in_mathzone }),
  s({ trig = "@F", dscr = "Phi", snippetType = "autosnippet" }, { t("\\Phi") }, { condition = in_mathzone }),
  s({ trig = "@G", dscr = "Gamma", snippetType = "autosnippet" }, { t("\\Gamma") }, { condition = in_mathzone }),
  s({ trig = "@Q", dscr = "Theta", snippetType = "autosnippet" }, { t("\\Theta") }, { condition = in_mathzone }),
  s({ trig = "@L", dscr = "Lambda", snippetType = "autosnippet" }, { t("\\Lambda") }, { condition = in_mathzone }),
  s({ trig = "@X", dscr = "Xi", snippetType = "autosnippet" }, { t("\\Xi") }, { condition = in_mathzone }),
  s({ trig = "@Y", dscr = "Psi", snippetType = "autosnippet" }, { t("\\Psi") }, { condition = in_mathzone }),
  s({ trig = "@S", dscr = "Sigma", snippetType = "autosnippet" }, { t("\\Sigma") }, { condition = in_mathzone }),
  s({ trig = "@U", dscr = "Upsilon", snippetType = "autosnippet" }, { t("\\Upsilon") }, { condition = in_mathzone }),
  s({ trig = "@W", dscr = "Omega", snippetType = "autosnippet" }, { t("\\Omega") }, { condition = in_mathzone }),

  -- Variants
  s({ trig = "@ve", dscr = "varepsilon", snippetType = "autosnippet" }, { t("\\varepsilon") },
    { condition = in_mathzone }),
  s({ trig = "@vf", dscr = "varphi", snippetType = "autosnippet" }, { t("\\varphi") }, { condition = in_mathzone }),
  s({ trig = "@vs", dscr = "varsigma", snippetType = "autosnippet" }, { t("\\varsigma") }, { condition = in_mathzone }),
  s({ trig = "@vq", dscr = "vartheta", snippetType = "autosnippet" }, { t("\\vartheta") }, { condition = in_mathzone }),

  -- Delimiters
  s(
    { trig = "@(", dscr = "()", snippetType = "autosnippet" },
    {
      t("\\left( "),
      i(1),
      t(" \\right)")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "@{", dscr = "{}", snippetType = "autosnippet" },
    {
      t("\\left\\{ "),
      i(1),
      t(" \\right\\}")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "@[", dscr = "[]", snippetType = "autosnippet" },
    {
      t("\\left[ "),
      i(1),
      t(" \\right]")
    },
    { condition = in_mathzone }
  ),

  -- Symbols
  s({ trig = "@.", dscr = "cdot", snippetType = "autosnippet" }, { t("\\cdot") }, { condition = in_mathzone }),
  s({ trig = "@8", dscr = "infty", snippetType = "autosnippet" }, { t("\\infty") }, { condition = in_mathzone }),
  s({ trig = "@6", dscr = "partial", snippetType = "autosnippet" }, { t("\\partial") }, { condition = in_mathzone }),
  s(
    { trig = "@^", dscr = "Hat", snippetType = "autosnippet" },
    {
      t("\\Hat{"),
      i(1),
      t("}")
    },
    { condition = in_mathzone }
  ),
  s({ trig = "@@", dscr = "circ", snippetType = "autosnippet" }, { t("\\circ") }, { condition = in_mathzone }),
  s({ trig = "@0", dscr = "^\\circ", snippetType = "autosnippet" }, { t("^\\circ") }, { condition = in_mathzone }),
  s({ trig = "@*", dscr = "times", snippetType = "autosnippet" }, { t("\\times") }, { condition = in_mathzone }),
  s(
    { trig = "@2", dscr = "\\sqrt", snippetType = "autosnippet" },
    {
      t("\\sqrt{"),
      i(1),
      t("}")
    },
    { condition = in_mathzone }
  ),
  s({ trig = "cong", dscr = "\\cong", snippetType = "autosnippet" }, { t("\\cong") }, { condition = in_mathzone }),

  -- Additional math utility snippets
  s({ trig = "pf", wordTrig = false, dscr = "^2", snippetType = "autosnippet" }, { t("^2") }, { condition = in_mathzone }),
  s({ trig = "lf", wordTrig = false, dscr = "^3", snippetType = "autosnippet" }, { t("^3") }, { condition = in_mathzone }),
  s(
    { trig = "**", wordTrig = false, dscr = "superscript", snippetType = "autosnippet" },
    {
      t("^{"),
      i(1),
      t("}"),
      i(0)
    },
    { condition = in_mathzone }
  ),

  -- Functions with priority
  s(
    {
      trig = "(?<!\\\\)(arcsin|arccos|arctan|arccot|arccsc|arcsec|pi|zeta|int)",
      regTrig = true,
      dscr = "math functions",
      snippetType = "autosnippet"
    },
    {
      f(function(_, snip) return "\\" .. snip.captures[1] end)
    },
    {
      condition = in_mathzone,
      priority = 200
    }
  ),

  s(
    {
      trig = "(?<!\\\\)(sin|cos|tan|arccot|cot|csc|ln|log|exp|star|perp)",
      regTrig = true,
      dscr = "math functions",
      snippetType = "autosnippet"
    },
    {
      f(function(_, snip) return "\\" .. snip.captures[1] end)
    },
    {
      condition = in_mathzone,
      priority = 100
    }
  ),

  s(
    {
      trig = "(?<!\\\\)(arcsin|arccos|arctan|arccot|arccsc|arcsec|pi|zeta|int|cap|cup)",
      regTrig = true,
      dscr = "math functions",
      snippetType = "autosnippet"
    },
    {
      f(function(_, snip) return "\\" .. snip.captures[1] end)
    },
    {
      condition = in_mathzone,
      priority = 200
    }
  ),
  s(
    { trig = "__", wordTrig = false, dscr = "subscript", snippetType = "autosnippet" },
    {
      t("_{"),
      i(1),
      t("}"),
      i(0)
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "~~", wordTrig = false, dscr = "~", snippetType = "autosnippet" },
    {
      t("\\sim ")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "||", wordTrig = false, dscr = "mid", snippetType = "autosnippet" },
    {
      t(" \\mid ")
    },
    { condition = in_mathzone }
  ),

  s(
    { trig = "beg", dscr = "begin{} / end{}", snippetType = "autosnippet" },
    {
      t("\\begin{"),
      i(1),
      t("}"),
      t({ "", "\t" }),
      i(0),
      t({ "", "\\end{" }),
      rep(1),
      t("}")
    }
  ),
}

return snippets

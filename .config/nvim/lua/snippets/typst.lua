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

local typst_snippets = {
  s({ trig = "mk", dscr = "inline math" }, { t('$'), i(0), t('$') }),
  s({ trig = "dm", dscr = "display math" }, { t('$ '), i(0), t(' $') }),
  -- Greek letters (with autosnippet)
  s({ trig = "@a", dscr = "alpha", snippetType = "autosnippet" }, { t("alpha") }),
  s({ trig = "@b", dscr = "beta", snippetType = "autosnippet" }, { t("beta") }),
  s({ trig = "@c", dscr = "chi", snippetType = "autosnippet" }, { t("chi") }),
  s({ trig = "@d", dscr = "delta", snippetType = "autosnippet" }, { t("delta") }),
  s({ trig = "@e", dscr = "epsilon", snippetType = "autosnippet" }, { t("epsilon") }),
  s({ trig = "@f", dscr = "phi", snippetType = "autosnippet" }, { t("phi") }),
  s({ trig = "@g", dscr = "gamma", snippetType = "autosnippet" }, { t("gamma") }),
  s({ trig = "@h", dscr = "eta", snippetType = "autosnippet" }, { t("eta") }),
  s({ trig = "@i", dscr = "iota", snippetType = "autosnippet" }, { t("iota") }),
  s({ trig = "@k", dscr = "kappa", snippetType = "autosnippet" }, { t("kappa") }),
  s({ trig = "@l", dscr = "lambda", snippetType = "autosnippet" }, { t("lambda") }),
  s({ trig = "@m", dscr = "mu", snippetType = "autosnippet" }, { t("mu") }),
  s({ trig = "@n", dscr = "nu", snippetType = "autosnippet" }, { t("nu") }),
  s({ trig = "@p", dscr = "pi", snippetType = "autosnippet" }, { t("pi") }),
  s({ trig = "@q", dscr = "theta", snippetType = "autosnippet" }, { t("theta") }),
  s({ trig = "@r", dscr = "rho", snippetType = "autosnippet" }, { t("rho") }),
  s({ trig = "@s", dscr = "sigma", snippetType = "autosnippet" }, { t("sigma") }),
  s({ trig = "@t", dscr = "tau", snippetType = "autosnippet" }, { t("tau") }),
  s({ trig = "@u", dscr = "upsilon", snippetType = "autosnippet" }, { t("upsilon") }),
  s({ trig = "@o", dscr = "omega", snippetType = "autosnippet" }, { t("omega") }),
  s({ trig = "@&", dscr = "wedge", snippetType = "autosnippet" }, { t("wedge") }),
  s({ trig = "@x", dscr = "xi", snippetType = "autosnippet" }, { t("xi") }),
  s({ trig = "@y", dscr = "psi", snippetType = "autosnippet" }, { t("psi") }),
  s({ trig = "@z", dscr = "zeta", snippetType = "autosnippet" }, { t("zeta") }),

  -- Capital Greek letters (with autosnippet)
  s({ trig = "@D", dscr = "Delta", snippetType = "autosnippet" }, { t("Delta") }),
  s({ trig = "@F", dscr = "Phi", snippetType = "autosnippet" }, { t("Phi") }),
  s({ trig = "@G", dscr = "Gamma", snippetType = "autosnippet" }, { t("Gamma") }),
  s({ trig = "@Q", dscr = "Theta", snippetType = "autosnippet" }, { t("Theta") }),
  s({ trig = "@L", dscr = "Lambda", snippetType = "autosnippet" }, { t("Lambda") }),
  s({ trig = "@X", dscr = "Xi", snippetType = "autosnippet" }, { t("Xi") }),
  s({ trig = "@Y", dscr = "Psi", snippetType = "autosnippet" }, { t("Psi") }),
  s({ trig = "@S", dscr = "Sigma", snippetType = "autosnippet" }, { t("Sigma") }),
  s({ trig = "@U", dscr = "Upsilon", snippetType = "autosnippet" }, { t("Upsilon") }),
  s({ trig = "@W", dscr = "Omega", snippetType = "autosnippet" }, { t("Omega") }),

  -- Variant letters (with autosnippet)
  s({ trig = "@ve", dscr = "varepsilon", snippetType = "autosnippet" }, { t("epsilon.alt") }),
  s({ trig = "@vf", dscr = "varphi", snippetType = "autosnippet" }, { t("phi.alt") }),
  s({ trig = "@vs", dscr = "varsigma", snippetType = "autosnippet" }, { t("sigma.alt") }),
  s({ trig = "@vq", dscr = "vartheta", snippetType = "autosnippet" }, { t("theta.alt") }),

  -- Roman letters (with autosnippet)
  s({ trig = "ee", dscr = "Roman e", snippetType = "autosnippet" }, { t("upright(e)") }),
  s({ trig = "ii", dscr = "Roman i", snippetType = "autosnippet" }, { t("upright(i)") }),

  -- Text in math
  s({ trig = "txt", dscr = "Text in math", snippetType = "autosnippet" }, {
    t('text("'), i(1), t('")'), i(0)
  }),

  -- Auto subscript (with autosnippet since it had wA in the hsnips file)
  s({ trig = "([A-Za-z])(\\d)", regTrig = true, dscr = "Auto subscript", snippetType = "autosnippet" }, {
    f(function(_, snip) return snip.captures[1] end),
    t("_"),
    f(function(_, snip) return snip.captures[2] end),
  }),

  -- Subscript and superscript (with autosnippet since they had iA in the hsnips file)
  s({ trig = "__", dscr = "Subscript", snippetType = "autosnippet" }, {
    t("_("), i(1), t(")"), i(0)
  }),

  s({ trig = "**", dscr = "Superscript", snippetType = "autosnippet" }, {
    t("^("), i(1), t(")"), i(0)
  }),

  -- Definite integral (with autosnippet since it had iA in the hsnips file)
  s({ trig = "djf", dscr = "Definite integral", snippetType = "autosnippet" }, {
    t("integral_("), i(1), t(")^("), i(2), t(") "), i(0), t(" dd("), i(3), t(")")
  }),

  -- Bold characters (with autosnippet since it had iA in the hsnips file)
  s({ trig = "bf([a-zA-Z])", regTrig = true, dscr = "Bold character", snippetType = "autosnippet" }, {
    t("bold("),
    f(function(_, snip) return snip.captures[1] end),
    t(")"),
  }),

  -- Calligraphic characters (with autosnippet since it had iA in the hsnips file)
  s({ trig = "mc([A-Z])", regTrig = true, dscr = "Calligraphic character", snippetType = "autosnippet" }, {
    t("cal("),
    f(function(_, snip) return snip.captures[1] end),
    t(")"),
  }),

  -- Roman characters (with autosnippet since it had iA in the hsnips file)
  s({ trig = "rm([a-zA-Z])", regTrig = true, dscr = "Roman character", snippetType = "autosnippet" }, {
    t("upright("),
    f(function(_, snip) return snip.captures[1] end),
    t(")"),
  }),

  -- Operators and symbols (with autosnippet since they had iA in the hsnips file)
  s({ trig = "pm", dscr = "Plus-minus", snippetType = "autosnippet" }, { t("plus.minus"), i(0) }),
  s({ trig = "mp", dscr = "Minus-plus", snippetType = "autosnippet" }, { t("minus.plus"), i(0) }),

  -- Fraction (with autosnippet since it had iA in the hsnips file)
  s({ trig = "@/", dscr = "Fraction", snippetType = "autosnippet" }, {
    t("("), i(1), t(")/("), i(2), t(")"), i(0)
  }),

  -- Upright (with autosnippet since it had iA in the hsnips file)
  s({ trig = "ur", dscr = "Upright", snippetType = "autosnippet" }, {
    t("upright("), i(1), t(")"), i(0)
  }),

  -- Integral (with autosnippet since it had iA in the hsnips file)
  s({ trig = "jf", dscr = "Integral", snippetType = "autosnippet" }, { t("integral") }),

  -- Underbrace (with autosnippet since it had iA in the hsnips file)
  s({ trig = "udb", dscr = "Underbrace", snippetType = "autosnippet" }, {
    t("underbrace("), i(0), t(")")
  }),

  -- Quantifiers (with autosnippet since they had iA in the hsnips file)
  s({ trig = "rq", dscr = "Forall", snippetType = "autosnippet" }, { t("forall") }),
  s({ trig = "cz", dscr = "Exists", snippetType = "autosnippet" }, { t("exists") }),
  s({ trig = "wo", dscr = "Without", snippetType = "autosnippet" }, { t("without") }),

  -- Limit (with autosnippet since it had iA in the hsnips file)
  s({ trig = "lim", dscr = "Limit", snippetType = "autosnippet" }, {
    t("lim_("), i(1, "n"), t(" -> "), i(2, "oo"), t(")"), i(0)
  }),

  -- Product (with autosnippet since it had iA in the hsnips file)
  s({ trig = "prod", dscr = "Product", snippetType = "autosnippet" }, { t("product") }),

  -- Differential (with autosnippet since it had iA in the hsnips file)
  s({ trig = "dd", dscr = "Differential", snippetType = "autosnippet" }, {
    t("dd("), i(1), t(")"), i(0)
  }),

  -- Tilde (with autosnippet since it had iA in the hsnips file)
  s({ trig = "~~", dscr = "Tilde", snippetType = "autosnippet" }, { t("tilde") }),

  -- Display (with autosnippet since it had iA in the hsnips file)
  s({ trig = "disp", dscr = "Display", snippetType = "autosnippet" }, {
    t("display("), i(0), t(")")
  }),

  -- Matrix (with autosnippet for "A" marker in the hsnips file)
  s({ trig = "Bmat", dscr = "Bmatrix", snippetType = "autosnippet" }, {
    t('mat(delim: "{",'), i(0), t(")")
  }),
}

return typst_snippets

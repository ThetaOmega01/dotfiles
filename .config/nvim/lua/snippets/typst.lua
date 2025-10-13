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
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local conds = require("luasnip.extras.expand_conditions")

local function in_typst_math()
  local node = vim.treesitter.get_node({
    bufnr = 0,
    ignore_injections = false,
    include_anonymous = false,
  })

  while node do
    if node:type() == "math" then
      return true
    end
    node = node:parent()
  end
  return false
end

-- Matrix generator function
local generate_matrix = function(snip)
  local rows = tonumber(snip.captures[1])
  local cols = tonumber(snip.captures[2])
  local nodes = {}
  local ins_indx = 1
  for j = 1, rows do
    table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
    ins_indx = ins_indx + 1
    for k = 2, cols do
      table.insert(nodes, t(" , "))
      table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
      ins_indx = ins_indx + 1
    end
    table.insert(nodes, t({ ";", "" }))
  end
  -- fix last node.
  nodes[#nodes] = t("")
  return sn(nil, nodes)
end

local typst_snippets = {
  s({ trig = "mk", dscr = "inline math" }, { t("$"), i(1), t(" $"), i(0) }),
  s({ trig = "dm", dscr = "display math" }, { t("$ "), i(0), t(" $") }),
  -- Greek letters (with autosnippet)
  s({ trig = "@a", dscr = "alpha", snippetType = "autosnippet" }, { t("alpha") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@b", dscr = "beta", snippetType = "autosnippet" }, { t("beta") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@c", dscr = "chi", snippetType = "autosnippet" }, { t("chi") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@d", dscr = "delta", snippetType = "autosnippet" }, { t("delta") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@e", dscr = "epsilon", snippetType = "autosnippet" }, { t("epsilon") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@f", dscr = "phi", snippetType = "autosnippet" }, { t("phi") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@g", dscr = "gamma", snippetType = "autosnippet" }, { t("gamma") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@h", dscr = "eta", snippetType = "autosnippet" }, { t("eta") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@i", dscr = "iota", snippetType = "autosnippet" }, { t("iota") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@k", dscr = "kappa", snippetType = "autosnippet" }, { t("kappa") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@l", dscr = "lambda", snippetType = "autosnippet" }, { t("lambda") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@m", dscr = "mu", snippetType = "autosnippet" }, { t("mu") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@n", dscr = "nu", snippetType = "autosnippet" }, { t("nu") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@p", dscr = "pi", snippetType = "autosnippet" }, { t("pi") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@q", dscr = "theta", snippetType = "autosnippet" }, { t("theta") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@r", dscr = "rho", snippetType = "autosnippet" }, { t("rho") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@s", dscr = "sigma", snippetType = "autosnippet" }, { t("sigma") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@t", dscr = "tau", snippetType = "autosnippet" }, { t("tau") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@u", dscr = "upsilon", snippetType = "autosnippet" }, { t("upsilon") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@o", dscr = "omega", snippetType = "autosnippet" }, { t("omega") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@&", dscr = "wedge", snippetType = "autosnippet" }, { t("wedge") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@x", dscr = "xi", snippetType = "autosnippet" }, { t("xi") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@y", dscr = "psi", snippetType = "autosnippet" }, { t("psi") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@z", dscr = "zeta", snippetType = "autosnippet" }, { t("zeta") }, {
    condition = function()
      return in_typst_math()
    end,
  }),

  -- Capital Greek letters (with autosnippet)
  s({ trig = "@D", dscr = "Delta", snippetType = "autosnippet" }, { t("Delta") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@F", dscr = "Phi", snippetType = "autosnippet" }, { t("Phi") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@G", dscr = "Gamma", snippetType = "autosnippet" }, { t("Gamma") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@Q", dscr = "Theta", snippetType = "autosnippet" }, { t("Theta") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@L", dscr = "Lambda", snippetType = "autosnippet" }, { t("Lambda") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@X", dscr = "Xi", snippetType = "autosnippet" }, { t("Xi") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@Y", dscr = "Psi", snippetType = "autosnippet" }, { t("Psi") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@S", dscr = "Sigma", snippetType = "autosnippet" }, { t("Sigma") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@U", dscr = "Upsilon", snippetType = "autosnippet" }, { t("Upsilon") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@W", dscr = "Omega", snippetType = "autosnippet" }, { t("Omega") }, {
    condition = function()
      return in_typst_math()
    end,
  }),

  -- Variant letters (with autosnippet)
  s({ trig = "@ve", dscr = "varepsilon", snippetType = "autosnippet" }, { t("epsilon.alt") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@vf", dscr = "varphi", snippetType = "autosnippet" }, { t("phi.alt") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@vs", dscr = "varsigma", snippetType = "autosnippet" }, { t("sigma.alt") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "@vq", dscr = "vartheta", snippetType = "autosnippet" }, { t("theta.alt") }, {
    condition = function()
      return in_typst_math()
    end,
  }),

  -- Roman letters (with autosnippet)
  s({ trig = "ee", dscr = "Roman e", snippetType = "autosnippet" }, { t("upright(e)") }, {
    condition = function()
      return in_typst_math()
    end,
  }),
  s({ trig = "ii", dscr = "Roman i", snippetType = "autosnippet" }, { t("upright(i)") }, {
    condition = function()
      return in_typst_math()
    end,
  }),

  -- Text in math
  s({ trig = "txt", dscr = "Text in math", snippetType = "autosnippet" }, {
    t('text("'),
    i(1),
    t('")'),
    i(0),
  }),

  s({
    trig = "([a-zA-Z])([0-9])",
    dscr = "Subscript with letter and number",
    regTrig = true,
    snippetType = "autosnippet",
  }, {
    f(function(_, snip)
      local letter = snip.captures[1]
      local number = snip.captures[2]
      return string.format("%s_%s", letter, number)
    end, {}),
  }, {
    condition = function()
      return in_typst_math()
    end,
  }),

  s({ trig = "__", wordTrig = false, dscr = "Subscript", snippetType = "autosnippet" }, {
    t("_("),
    i(1),
    t(")"),
    i(0),
  }),

  s({ trig = "**", wordTrig = false, dscr = "Superscript", snippetType = "autosnippet" }, {
    t("^("),
    i(1),
    t(")"),
    i(0),
  }),

  -- Definite integral (with autosnippet)
  s({ trig = "djf", dscr = "Definite integral", snippetType = "autosnippet" }, {
    t("integral_("),
    i(1),
    t(")^("),
    i(2),
    t(") "),
    i(0),
    t(" dd("),
    i(3),
    t(")"),
  }),

  -- Bold characters (with autosnippet)
  s({ trig = "b([a-zA-Z0-9])", regTrig = true, dscr = "Bold character", snippetType = "autosnippet" }, {
    t("bold("),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t(")"),
  }, {
    condition = function()
      return in_typst_math()
    end,
  }),

  -- Bold and upright characters (with autosnippet)
  s({ trig = "ub([a-zA-Z0-9])", regTrig = true, dscr = "Bold character(upright)", snippetType = "autosnippet" }, {
    t("upright(bold("),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t("))"),
  }, {
    condition = function()
      return in_typst_math()
    end,
  }),

  -- Calligraphic characters (with autosnippet)
  s({ trig = "mc([A-Z])", regTrig = true, dscr = "Calligraphic character", snippetType = "autosnippet" }, {
    t("cal("),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t(")"),
  }),

  -- Roman characters (with autosnippet)
  s({ trig = "rm([a-zA-Z])", regTrig = true, dscr = "Roman character", snippetType = "autosnippet" }, {
    t("upright("),
    f(function(_, snip)
      return snip.captures[1]
    end),
    t(")"),
  }),

  -- Operators and symbols (with autosnippet)
  s({ trig = "pm", dscr = "Plus-minus", snippetType = "autosnippet" }, { t("plus.minus"), i(0) }),
  s({ trig = "mp", dscr = "Minus-plus", snippetType = "autosnippet" }, { t("minus.plus"), i(0) }),

  -- Fraction (with autosnippet)
  s({ trig = "@/", dscr = "Fraction", snippetType = "autosnippet" }, {
    t("("),
    i(1),
    t(")/("),
    i(2),
    t(")"),
    i(0),
  }),

  -- Upright (with autosnippet)
  s({ trig = "ur", dscr = "Upright", snippetType = "autosnippet" }, {
    t("upright("),
    i(1),
    t(")"),
    i(0),
  }),

  -- Integral (with autosnippet)
  s({ trig = "jf", dscr = "Integral", snippetType = "autosnippet" }, { t("integral") }),

  -- Underbrace (with autosnippet)
  s({ trig = "udb", dscr = "Underbrace", snippetType = "autosnippet" }, {
    t("underbrace("),
    i(0),
    t(")"),
  }),

  -- Quantifiers (with autosnippet)
  s({ trig = "rq", dscr = "Forall", snippetType = "autosnippet" }, { t("forall") }),
  s({ trig = "cz", dscr = "Exists", snippetType = "autosnippet" }, { t("exists") }),
  s({ trig = "wo", dscr = "Without", snippetType = "autosnippet" }, { t("without") }, {
    condition = function()
      return in_typst_math()
    end,
  }),

  -- Limit (with autosnippet)
  s({ trig = "lim", dscr = "Limit", snippetType = "autosnippet" }, {
    t("lim_("),
    i(1, "n"),
    t(" -> "),
    i(2, "oo"),
    t(")"),
    i(0),
  }, {
    condition = function()
      return in_typst_math()
    end,
  }),

  -- Product (with autosnippet)
  s({ trig = "prod", dscr = "Product", snippetType = "autosnippet" }, { t("product") }),

  -- Differential (with autosnippet)
  s({ trig = "dd", dscr = "Differential", snippetType = "autosnippet" }, {
    t("dd("),
    i(1),
    t(")"),
    i(0),
  }),

  -- Tilde (with autosnippet)
  s({ trig = "~~", dscr = "Tilde", snippetType = "autosnippet" }, { t("tilde") }),

  -- Display (with autosnippet)
  s({ trig = "disp", dscr = "Display", snippetType = "autosnippet" }, {
    t("display("),
    i(0),
    t(")"),
  }, {
    condition = function()
      return in_typst_math()
    end,
  }),

  -- Matrix (with autosnippet for "A" marker in the  file)
  s({ trig = "Bmat", dscr = "Bmatrix", snippetType = "autosnippet" }, {
    t('mat(delim: "{",'),
    i(0),
    t(")"),
  }),

  s(
    { trig = "mat(%d+)x(%d+)", regTrig = true, dscr = "matrix", snippetType = "autosnippet", hidden = true },
    fmta(
      [[
      mat(
      <>)
      ]],
      {
        d(1, generate_matrix),
      }
    ),
    {
      condition = in_typst_math,
    }
  ),

  s({ trig = "lrang", descr = "Left and right angle brackets", snippetType = "autosnippet" }, {
    t("angle.l "),
    i(1),
    t(" angle.r"),
    i(0),
  }, {
    condition = function()
      return in_typst_math()
    end,
  }),
}

return typst_snippets

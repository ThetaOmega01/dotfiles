local core = require("snippetlib.core")

local s = core.s
local t = core.t
local i = core.i
local f = core.f
local d = core.d
local fmta = core.fmta

local M = {}

local function autosnip(context, nodes, condition)
  local opts = condition and { condition = condition } or nil
  return core.autosnip(context, nodes, opts)
end

local function lit(context, text, condition)
  return autosnip(context, { t(text) }, condition)
end

local function literal_rows(rows, condition)
  local snippets = {}
  for _, row in ipairs(rows) do
    table.insert(snippets, lit({ trig = row[1], dscr = row[2] }, row[3], condition))
  end
  return snippets
end

function M.greek(condition)
  return literal_rows({
    { "@a", "alpha", "alpha" },
    { "@b", "beta", "beta" },
    { "@c", "chi", "chi" },
    { "@d", "delta", "delta" },
    { "@e", "epsilon", "epsilon" },
    { "@f", "phi", "phi" },
    { "@g", "gamma", "gamma" },
    { "@h", "eta", "eta" },
    { "@i", "iota", "iota" },
    { "@k", "kappa", "kappa" },
    { "@l", "lambda", "lambda" },
    { "@m", "mu", "mu" },
    { "@n", "nu", "nu" },
    { "@p", "pi", "pi" },
    { "@q", "theta", "theta" },
    { "@r", "rho", "rho" },
    { "@s", "sigma", "sigma" },
    { "@t", "tau", "tau" },
    { "@u", "upsilon", "upsilon" },
    { "@o", "omega", "omega" },
    { "@&", "wedge", "wedge" },
    { "@x", "xi", "xi" },
    { "@y", "psi", "psi" },
    { "@z", "zeta", "zeta" },
    { "@D", "Delta", "Delta" },
    { "@F", "Phi", "Phi" },
    { "@G", "Gamma", "Gamma" },
    { "@Q", "Theta", "Theta" },
    { "@L", "Lambda", "Lambda" },
    { "@X", "Xi", "Xi" },
    { "@Y", "Psi", "Psi" },
    { "@S", "Sigma", "Sigma" },
    { "@U", "Upsilon", "Upsilon" },
    { "@W", "Omega", "Omega" },
    { "@ve", "varepsilon", "epsilon.alt" },
    { "@vf", "varphi", "phi.alt" },
    { "@vs", "varsigma", "sigma.alt" },
    { "@vq", "vartheta", "theta.alt" },
    { "ee", "Roman e", "upright(e)" },
    { "ii", "Roman i", "upright(i)" },
  }, condition)
end

function M.scripts(condition)
  return {
    autosnip({
      trig = "([a-zA-Z])([0-9])",
      dscr = "Subscript with letter and number",
      regTrig = true,
    }, {
      f(function(_, snip)
        local letter = snip.captures[1]
        local number = snip.captures[2]
        return string.format("%s_%s", letter, number)
      end, {}),
    }, condition),

    autosnip({ trig = "__", wordTrig = false, dscr = "Subscript" }, {
      t("_("),
      i(1),
      t(")"),
      i(0),
    }, condition),

    autosnip({ trig = "**", wordTrig = false, dscr = "Superscript" }, {
      t("^("),
      i(1),
      t(")"),
      i(0),
    }, condition),
  }
end

function M.fonts(condition)
  return {
    autosnip({ trig = "b([a-zA-Z0-9])", regTrig = true, dscr = "Bold character" }, {
      t("bold("),
      f(function(_, snip)
        return snip.captures[1]
      end),
      t(")"),
    }, condition),

    autosnip({ trig = "ub([a-zA-Z0-9])", regTrig = true, dscr = "Bold character(upright)" }, {
      t("upright(bold("),
      f(function(_, snip)
        return snip.captures[1]
      end),
      t("))"),
    }, condition),

    autosnip({ trig = "mc([A-Z])", regTrig = true, dscr = "Calligraphic character" }, {
      t("cal("),
      f(function(_, snip)
        return snip.captures[1]
      end),
      t(")"),
    }, condition),

    autosnip({ trig = "rm([a-zA-Z])", regTrig = true, dscr = "Roman character" }, {
      t("upright("),
      f(function(_, snip)
        return snip.captures[1]
      end),
      t(")"),
    }, condition),
  }
end

function M.operators(condition)
  return {
    autosnip({ trig = "pm", dscr = "Plus-minus" }, { t("plus.minus"), i(0) }, condition),
    autosnip({ trig = "mp", dscr = "Minus-plus" }, { t("minus.plus"), i(0) }, condition),

    autosnip({ trig = "@/", dscr = "Fraction" }, {
      t("("),
      i(1),
      t(")/("),
      i(2),
      t(")"),
      i(0),
    }, condition),

    autosnip({ trig = "ur", dscr = "Upright" }, {
      t("upright("),
      i(1),
      t(")"),
      i(0),
    }, condition),

    lit({ trig = "jf", dscr = "Integral" }, "integral", condition),

    autosnip({ trig = "udb", dscr = "Underbrace" }, {
      t("underbrace("),
      i(0),
      t(")"),
    }, condition),

    lit({ trig = "rq", dscr = "Forall" }, "forall", condition),
    lit({ trig = "cz", dscr = "Exists" }, "exists", condition),
    lit({ trig = "wo", dscr = "Without" }, "without", condition),

    autosnip({ trig = "lim", dscr = "Limit" }, {
      t("lim_("),
      i(1, "n"),
      t(" -> "),
      i(2, "oo"),
      t(")"),
      i(0),
    }, condition),

    lit({ trig = "prod", dscr = "Product" }, "product", condition),

    autosnip({ trig = "dd", dscr = "Differential" }, {
      t("dd("),
      i(1),
      t(")"),
      i(0),
    }, condition),

    lit({ trig = "~~", dscr = "Tilde" }, "tilde", condition),

    autosnip({ trig = "disp", dscr = "Display" }, {
      t("display("),
      i(0),
      t(")"),
    }, condition),
  }
end

function M.matrix(matrix_generator, condition)
  return {
    autosnip({ trig = "Bmat", dscr = "Bmatrix" }, {
      t('mat(delim: "{",'),
      i(0),
      t(")"),
    }, condition),

    autosnip(
      { trig = "mat(%d+)x(%d+)", regTrig = true, dscr = "matrix", hidden = true },
      fmta(
        [[
      mat(
      <>)
      ]],
        {
          d(1, matrix_generator),
        }
      ),
      condition
    ),
  }
end

function M.angle(condition)
  return {
    autosnip({ trig = "lrang", dscr = "Left and right angle brackets" }, {
      t("angle.l "),
      i(1),
      t(" angle.r"),
      i(0),
    }, condition),
  }
end

return M

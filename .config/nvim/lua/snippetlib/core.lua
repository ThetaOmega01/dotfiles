local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt")
local extras = require("luasnip.extras")

local M = {
	ls = ls,
	s = ls.snippet,
	sn = ls.snippet_node,
	t = ls.text_node,
	i = ls.insert_node,
	f = ls.function_node,
	c = ls.choice_node,
	d = ls.dynamic_node,
	r = ls.restore_node,
	fmt = fmt.fmt,
	fmta = fmt.fmta,
	rep = extras.rep,
}

local function copy_context(context)
	if type(context) == "string" then
		return { trig = context }
	end

	local out = {}
	for key, value in pairs(context) do
		out[key] = value
	end
	return out
end

function M.autosnip(context, nodes, opts)
	local ctx = copy_context(context)
	ctx.snippetType = ctx.snippetType or "autosnippet"
	return M.s(ctx, nodes, opts)
end

function M.math(context, nodes, condition)
	return M.autosnip(context, nodes, { condition = condition })
end

function M.literal(context, text, condition)
	return M.math(context, { M.t(text) }, condition)
end

function M.append(target, ...)
	for _, source in ipairs({ ... }) do
		vim.list_extend(target, source)
	end
	return target
end

return M

local M = {}

function M.markdown_mathzone()
	local node = vim.treesitter.get_node({
		bufnr = 0,
		ignore_injections = false,
		include_anonymous = false,
	})

	while node do
		if node:type() == "inline_formula" or node:type() == "displayed_equation" then
			return true
		end
		node = node:parent()
	end
	return false
end

function M.tex_mathzone()
	return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end

function M.typst_mathzone()
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

return M

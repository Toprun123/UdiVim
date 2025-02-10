local M = {}

local function highlight_todo_items()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i, line in ipairs(lines) do
		if line:match("^✔ ") then
			vim.api.nvim_buf_add_highlight(0, -1, "TodoDoneHighlight", i - 1, 0, 3)
			vim.api.nvim_buf_add_highlight(0, -1, "TodoDone", i - 1, 3, -1)
		elseif line:match("^● ") then
			vim.api.nvim_buf_add_highlight(0, -1, "TodoPendingHighlight", i - 1, 0, 3)
			vim.api.nvim_buf_add_highlight(0, -1, "TodoPending", i - 1, 3, -1)
		elseif line:match("^⚠ ") then
			vim.api.nvim_buf_add_highlight(0, -1, "TodoImportantHighlight", i - 1, 0, 3)
			vim.api.nvim_buf_add_highlight(0, -1, "TodoImportant", i - 1, 3, -1)
		else
			vim.api.nvim_buf_add_highlight(0, -1, "Normal", i - 1, 0, -1)
		end
	end
end

local function replace_task_symbols()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i, line in ipairs(lines) do
		if line:match("^x ") then
			vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, 1, { "✔" })
		elseif line:match("^- ") then
			vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, 1, { "●" })
		elseif line:match("^! ") then
			vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, 1, { "⚠" })
		end
	end
end

function M.setup()
	vim.api.nvim_set_hl(0, "TodoDoneHighlight", { fg = "#00FF00", bold = true })
	vim.api.nvim_set_hl(0, "TodoPendingHighlight", { fg = "#FFFF00", bold = true })
	vim.api.nvim_set_hl(0, "TodoImportantHighlight", { fg = "#FF0000", bold = true })
	vim.api.nvim_set_hl(0, "TodoDone", { link = "Comment" })
	vim.api.nvim_set_hl(0, "TodoPending", { link = "Identifier" })
	vim.api.nvim_set_hl(0, "TodoImportant", { link = "Error" })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		pattern = "*.udi",
		callback = function()
			vim.bo.filetype = "udi"
			vim.opt_local.conceallevel = 2
		end,
	})
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "udi",
		callback = function()
			replace_task_symbols()
			highlight_todo_items()
		end,
	})
	vim.api.nvim_create_autocmd("TextChangedI", {
		pattern = "*.udi",
		callback = function()
			replace_task_symbols()
			highlight_todo_items()
		end,
	})
end

function M.toggle_todo()
	local line = vim.api.nvim_get_current_line()
	if line:match("^✔ ") then
		vim.api.nvim_set_current_line("●" .. line:sub(4))
	elseif line:match("^● ") then
		vim.api.nvim_set_current_line("✔" .. line:sub(4))
	elseif line:match("^⚠ ") then
		vim.api.nvim_set_current_line("✔" .. line:sub(4))
	end
	highlight_todo_items()
end

vim.api.nvim_set_keymap("n", "<leader>t", ":lua require('udivim').toggle_todo()<CR>", { noremap = true, silent = true })

return M

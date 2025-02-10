local M = {}

local function highlight_todo_items()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
	for i, line in ipairs(lines) do
		if line:match("^        @") then
			if line:match("") then
				local idx = string.find(line, "")
				vim.api.nvim_buf_add_highlight(0, -1, "TodoDoneTopic", i - 1, 8, idx - 2)
				vim.api.nvim_buf_add_highlight(0, -1, "TodoDoneTopic", i - 1, idx + 3, -1)
				vim.api.nvim_buf_add_highlight(0, -1, "TodoDoneHighlight", i - 1, idx - 1, idx + 3)
			elseif line:match("") then
				local idx = string.find(line, "")
				vim.api.nvim_buf_add_highlight(0, -1, "TodoPendingTopic", i - 1, 8, idx - 2)
				vim.api.nvim_buf_add_highlight(0, -1, "TodoPendingTopic", i - 1, idx + 3, -1)
				vim.api.nvim_buf_add_highlight(0, -1, "TodoPendingHighlight", i - 1, idx - 1, idx + 3)
			elseif line:match("") then
				local idx = string.find(line, "")
				vim.api.nvim_buf_add_highlight(0, -1, "TodoImportantTopic", i - 1, 8, idx - 2)
				vim.api.nvim_buf_add_highlight(0, -1, "TodoImportantTopic", i - 1, idx + 3, -1)
				vim.api.nvim_buf_add_highlight(0, -1, "TodoImportantHighlight", i - 1, idx - 1, idx + 3)
			else
				vim.api.nvim_buf_add_highlight(0, -1, "Identifier", i - 1, 0, -1)
			end
		elseif line:match("^    #") then
			vim.api.nvim_buf_add_highlight(0, -1, "Topic", i - 1, 4, -1)
		elseif line:match("^*") then
			vim.api.nvim_buf_add_highlight(0, -1, "TopicHead", i - 1, 0, -1)
		else
			if line:match("") then
				local idx = string.find(line, "")
				vim.api.nvim_buf_add_highlight(0, -1, "TodoDone", i - 1, 0, idx - 1)
				vim.api.nvim_buf_add_highlight(0, -1, "TodoDone", i - 1, idx + 2, -1)
				vim.api.nvim_buf_add_highlight(0, -1, "TodoDoneHighlight", i - 1, idx - 1, idx + 2)
			elseif line:match("") then
				local idx = string.find(line, "")
				vim.api.nvim_buf_add_highlight(0, -1, "TodoDone", i - 1, 0, idx - 1)
				vim.api.nvim_buf_add_highlight(0, -1, "TodoPending", i - 1, idx + 2, -1)
				vim.api.nvim_buf_add_highlight(0, -1, "TodoPendingHighlight", i - 1, idx - 1, idx + 2)
			elseif line:match("") then
				local idx = string.find(line, "")
				vim.api.nvim_buf_add_highlight(0, -1, "TodoDone", i - 1, 0, idx - 1)
				vim.api.nvim_buf_add_highlight(0, -1, "TodoImportant", i - 1, idx + 2, -1)
				vim.api.nvim_buf_add_highlight(0, -1, "TodoImportantHighlight", i - 1, idx - 1, idx + 2)
			else
				vim.api.nvim_buf_add_highlight(0, -1, "Identifier", i - 1, 0, -1)
			end
		end
	end
end

local function right(val)
	local current_pos = vim.api.nvim_win_get_cursor(0)
	local new_pos
	if val == nil then
		new_pos = { current_pos[1], current_pos[2] + 1 }
	elseif val == -1 then
		local line = vim.api.nvim_buf_get_lines(0, current_pos[1] - 1, current_pos[1], false)[1]
		local end_of_line = #line
		new_pos = { current_pos[1], end_of_line }
	else
		new_pos = { current_pos[1], val }
	end
	vim.api.nvim_win_set_cursor(0, new_pos)
end

local function replace_task_symbols()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i, line in ipairs(lines) do
		if line:match("%[x%]") then
			local idx = string.find(line, "%[x%]")
			vim.api.nvim_buf_set_text(0, i - 1, idx - 1, i - 1, idx + 2, { "" })
			right()
		elseif line:match("%[%-%]") then
			local idx = string.find(line, "%[%-%]")
			vim.api.nvim_buf_set_text(0, i - 1, idx - 1, i - 1, idx + 2, { "" })
			right()
		elseif line:match("%[!%]") then
			local idx = string.find(line, "%[!%]")
			vim.api.nvim_buf_set_text(0, i - 1, idx - 1, i - 1, idx + 2, { "" })
			right()
		end
	end
end

local function handle_inp()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i, line in ipairs(lines) do
		if line:match("^%s*#") then
			if not line:match("^    # ") then
				local idx = string.find(line, "#")
				if not line:match("^%s*# ") then
					vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "    # " })
				else
					vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "    #" })
				end
				right(-1)
			end
		elseif line:match("^%s*%*") then
			if not line:match("^* ") then
				local idx = string.find(line, "*")
				if not line:match("^%s*%* ") then
					vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "* " })
				else
					vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "*" })
				end
				right(-1)
			end
		elseif line:match("^%s*%@") then
			if not line:match("^        @") then
				local idx = string.find(line, "@")
				if not line:match("^        @ ") then
					vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "        @ " })
				else
					vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "        @" })
				end
				right(-1)
			end
			if not line:match("[]") then
				local current_pos = vim.api.nvim_win_get_cursor(0)
				local line2 = vim.api.nvim_buf_get_lines(0, current_pos[1] - 1, current_pos[1], false)[1]
				local end_of_line = #line2
				if string.sub(line2, -2) == "  " then
					vim.api.nvim_buf_set_text(0, i - 1, end_of_line, i - 1, end_of_line, { "" })
				elseif string.sub(line2, -2) == " " then
					vim.api.nvim_buf_set_text(0, i - 1, end_of_line, i - 1, end_of_line, { " " })
				else
					vim.api.nvim_buf_set_text(0, i - 1, end_of_line, i - 1, end_of_line, { "  " })
				end
				right(end_of_line)
			end
		elseif line:match("^%s*;") then
			if not line:match("^            ;[]") then
				local idx = string.find(line, ";")
				vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "            ;  " })
				right(-1)
			end
		end
	end
end

function M.setup()
	vim.api.nvim_set_hl(0, "TodoDoneHighlight", { fg = "#00FF00", bold = true })
	vim.api.nvim_set_hl(0, "TodoPendingHighlight", { fg = "#FFFF00", bold = true })
	vim.api.nvim_set_hl(0, "TodoImportantHighlight", { fg = "#FF0000", bold = true })
	vim.api.nvim_set_hl(0, "TodoDoneTopic", { fg = "#000000", bg = "#00FF00", bold = true })
	vim.api.nvim_set_hl(0, "TodoPendingTopic", { fg = "#000000", bg = "#FFFF00", bold = true })
	vim.api.nvim_set_hl(0, "TodoImportantTopic", { fg = "#000000", bg = "#FF0000", bold = true })
	vim.api.nvim_set_hl(0, "TodoDone", { link = "Comment" })
	vim.api.nvim_set_hl(0, "TodoPending", { link = "Identifier" })
	vim.api.nvim_set_hl(0, "TodoImportant", { link = "Error" })
	vim.api.nvim_set_hl(0, "Topic", { fg = "#000000", bg = "#FFFFFF", bold = true })
	vim.api.nvim_set_hl(0, "TopicHead", { fg = "#000000", bg = "#FFFFFF", bold = true })
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		pattern = "*.udi",
		callback = function()
			vim.bo.filetype = "udi"
			vim.opt_local.conceallevel = 2
			local buf = vim.api.nvim_get_current_buf()
			vim.api.nvim_buf_set_keymap(
				buf,
				"n",
				"<leader>t",
				":lua require('udivim').toggle_todo()<CR>",
				{ noremap = true, silent = true }
			)
			vim.api.nvim_buf_set_keymap(
				buf,
				"n",
				"",
				":lua require('udivim').toggle_imp()<CR>",
				{ noremap = true, silent = true }
			)
		end,
	})
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "udi",
		callback = function()
			vim.bo.tabstop = 4
			vim.bo.shiftwidth = 4
			vim.bo.expandtab = true
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.require('udivim').fold()"
			vim.opt_local.foldlevel = 99
			replace_task_symbols()
			highlight_todo_items()
		end,
	})
	vim.api.nvim_create_autocmd("TextChangedI", {
		pattern = "*.udi",
		callback = function()
			local current_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			local prev_content = vim.b.prev_content or {}
			local current_text = table.concat(current_content, "\n")
			local prev_text = table.concat(prev_content, "\n")
			if #current_text > #prev_text then
				handle_inp()
			end
			replace_task_symbols()
			highlight_todo_items()
			vim.b.prev_content = current_content
		end,
	})
end

function M.fold()
	local lnum = vim.v.lnum
	local line = vim.fn.getline(vim.v.lnum)
	local indent_level = vim.fn.indent(vim.v.lnum)
	if line:match("^%s*$") then
		indent_level = vim.fn.indent(lnum - 1)
	end
	return math.floor(indent_level / 4)
end

function M.toggle_todo()
	local line = vim.api.nvim_get_current_line()
	local pos = vim.api.nvim_win_get_cursor(0)
	local i = pos[1]
	if line:match("") then
		local idx = string.find(line, "")
		vim.api.nvim_buf_set_text(0, i - 1, idx - 1, i - 1, idx + 2, { "" })
	elseif line:match("") then
		local idx = string.find(line, "")
		vim.api.nvim_buf_set_text(0, i - 1, idx - 1, i - 1, idx + 2, { "" })
	elseif line:match("") then
		local idx = string.find(line, "")
		vim.api.nvim_buf_set_text(0, i - 1, idx - 1, i - 1, idx + 2, { "" })
	end
	highlight_todo_items()
end

function M.toggle_imp()
	local line = vim.api.nvim_get_current_line()
	local pos = vim.api.nvim_win_get_cursor(0)
	local i = pos[1]
	if line:match("") then
		local idx = string.find(line, "")
		vim.api.nvim_buf_set_text(0, i - 1, idx - 1, i - 1, idx + 2, { "" })
	elseif line:match("") then
		local idx = string.find(line, "")
		vim.api.nvim_buf_set_text(0, i - 1, idx - 1, i - 1, idx + 2, { "" })
	elseif line:match("") then
		local idx = string.find(line, "")
		vim.api.nvim_buf_set_text(0, i - 1, idx - 1, i - 1, idx + 2, { "" })
	end
	highlight_todo_items()
end

return M

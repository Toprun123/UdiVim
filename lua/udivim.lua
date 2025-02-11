local M = {}

local colors = {
	w = "#ffffff",
	k = "#000000",
	r = "#ff0000",
	g = "#00ff00",
	b = "#0000ff",
	c = "#00ffff",
	y = "#ffff00",
	m = "#ff00ff",
}

local function define_color(name, color_fg, color_bg, bold)
	if bold == nil then
		bold = true
	end
	vim.api.nvim_set_hl(0, name, { fg = colors[color_fg], bg = colors[color_bg], bold = bold })
end

local function highlight_todo_items()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local ns_id = vim.api.nvim_create_namespace("udivim_namespace")
	vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
	for i, line in ipairs(lines) do
		if line:match("^%s*@") then
			local idx2 = string.find(line, "@")
			if line:match("") then
				local idx = string.find(line, "")
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx2 - 1, { end_col = idx - 2, hl_group = "fgkbgg" })
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 4, { end_col = #line, hl_group = "fgkbgg" })
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 1, { end_col = idx + 3, hl_group = "fgg" })
			elseif line:match("") then
				local idx = string.find(line, "")
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx2 - 1, { end_col = idx - 2, hl_group = "fgkbgy" })
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 4, { end_col = #line, hl_group = "fgkbgy" })
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 1, { end_col = idx + 3, hl_group = "fgy" })
			elseif line:match("") then
				local idx = string.find(line, "")
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx2 - 1, { end_col = idx - 2, hl_group = "fgkbgr" })
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 4, { end_col = #line, hl_group = "fgkbgr" })
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 1, { end_col = idx + 3, hl_group = "fgr" })
			else
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, { end_col = #line, hl_group = "Identifier" })
			end
		elseif line:match("^%s*#") then
			local idx = string.find(line, "#")
			vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 1, { end_col = #line, hl_group = "fgkbgw" })
		elseif line:match("^%s*%*") then
			local idx = string.find(line, "%*")
			vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 1, { end_col = #line, hl_group = "fgkbgw" })
		elseif line:match("^%s*==*$") then
			local idx = string.find(line, "=")
			vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 1, { end_col = #line, hl_group = "Comment" })
		elseif line:match("^%s*%-%-") then
			local idx = string.find(line, "%-")
			vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 1, { end_col = #line, hl_group = "Comment" })
		else
			if line:match("") then
				local idx = string.find(line, "")
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, { end_col = idx - 1, hl_group = "Comment" })
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 2, { end_col = #line, hl_group = "Comment" })
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 1, { end_col = idx + 2, hl_group = "fgg" })
			elseif line:match("") then
				local idx = string.find(line, "")
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, { end_col = idx - 1, hl_group = "Comment" })
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 2, { end_col = #line, hl_group = "Identifier" })
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 1, { end_col = idx + 2, hl_group = "fgy" })
			elseif line:match("") then
				local idx = string.find(line, "")
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, { end_col = idx - 1, hl_group = "Comment" })
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 2, { end_col = #line, hl_group = "Error" })
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 1, { end_col = idx + 2, hl_group = "fgr" })
			else
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, { end_col = #line, hl_group = "Identifier" })
			end
		end
		for match in line:gmatch("`(.-)`") do
			match = match:gsub("([^%w])", "%%%1")
			local start_idx, end_idx = line:find("`" .. match .. "`")
			while start_idx do
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, start_idx - 1, { end_col = end_idx, hl_group = "String" })
				start_idx, end_idx = line:find("`" .. match .. "`", end_idx + 1)
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
			if not line:match("^%s*# ") then
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
			if not line:match("^%s*@ []") then
				local idx = string.find(line, "@")
				vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "        @    " })
				right(-1)
			end
		elseif line:match("^%s*;") then
			if not line:match("^%s*;[]") then
				local idx = string.find(line, ";")
				vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "            ;  " })
				right(-1)
			end
		elseif line:match(" =$") then
			local idx = string.find(line, "=")
			vim.api.nvim_buf_set_text(
				0,
				i - 1,
				idx - 1,
				i - 1,
				idx + 0,
				{ "==================================================" }
			)
			right(-1)
		elseif line:match(" %-$") then
			local idx = string.find(line, "%-")
			vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "                -- " })
			right(-1)
		end
	end
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
		vim.api.nvim_buf_set_text(0, i - 1, idx - 1, i - 1, idx + 2, { "" })
	elseif line:match("") then
		local idx = string.find(line, "")
		vim.api.nvim_buf_set_text(0, i - 1, idx - 1, i - 1, idx + 2, { "" })
	elseif line:match("") then
		local idx = string.find(line, "")
		vim.api.nvim_buf_set_text(0, i - 1, idx - 1, i - 1, idx + 2, { "" })
	end
	highlight_todo_items()
end

function M.setup()
	local define_grps = {
		["fgg"] = { "g" },
		["fgy"] = { "y" },
		["fgr"] = { "r" },
		["fgkbgg"] = { "k", "g" },
		["fgkbgy"] = { "k", "y" },
		["fgkbgr"] = { "k", "r" },
		["fgkbgw"] = { "k", "w" },
	}
	for name, color in pairs(define_grps) do
		define_color(name, color[1], color[2])
	end
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		pattern = "*.udi",
		callback = function()
			vim.bo.filetype = "udi"
			vim.opt_local.conceallevel = 2
			local buf = vim.api.nvim_get_current_buf()
			vim.api.nvim_buf_set_keymap(
				buf,
				"n",
				"<End>",
				":lua require('udivim').toggle_todo()<CR>",
				{ noremap = true, silent = true }
			)
			vim.api.nvim_buf_set_keymap(
				buf,
				"i",
				"<End>",
				"<C-o>:lua require('udivim').toggle_todo()<CR>",
				{ noremap = true, silent = true }
			)
			vim.api.nvim_buf_set_keymap(
				buf,
				"n",
				"<Home>",
				":lua require('udivim').toggle_imp()<CR>",
				{ noremap = true, silent = true }
			)
			vim.api.nvim_buf_set_keymap(
				buf,
				"i",
				"<Home>",
				"<C-o>:lua require('udivim').toggle_imp()<CR>",
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
			vim.opt_local.foldmethod = "indent"
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

return M

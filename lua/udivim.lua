local M = {}

local colors = {
	w = "#d6e0f5",
	k = "#0a0b11",
	e = "#3b415e",
	r = "#ff4f78",
	g = "#b0e57c",
	b = "#89b4fa",
	c = "#8cdcff",
	m = "#c5a3ff",
	y = "#f5c97f",
	t = "#be8c71",
	o = "#ff9e64",
	p = "#ff99c2",
}

local colors_s = "wkerbgcmytopd"
local types = "!x0%^%$"

local function define_color(name, color_fg, color_bg, bold, underline, italic)
	if bold == nil then
		bold = true
	end
	if underline == nil then
		underline = false
	end
	if italic == nil then
		italic = false
	end
	vim.api.nvim_set_hl(
		0,
		name,
		{ fg = colors[color_fg], bg = colors[color_bg], bold = bold, underline = underline, italic = italic }
	)
end

local function highlight_todo_items()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local ns_id = vim.api.nvim_create_namespace("udivim_namespace")
	local mode = vim.api.nvim_get_mode().mode
	local cursor = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
	for i, line in ipairs(lines) do
		local use_virt = true
		if mode:match("^i") and i == cursor then
			use_virt = false
		end
		if line:match("^%s*[" .. colors_s .. "]@[" .. types .. "]") then
			local idx2 = string.find(line, "@")
			local color_code = line:sub(idx2 - 1, idx2 - 1)
			if line:match("@x") then
				local idx = string.find(line, "x")
				local virt_text = use_virt and { { "  ", "fgg" } } or nil
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx2 - 2, {
					end_col = idx,
					hl_group = "fgg",
					virt_text = virt_text,
					virt_text_pos = "overlay",
				})
				if color_code == "d" then
					color_code = "g"
				end
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 0, {
					end_col = #line,
					hl_group = "fgkbg" .. color_code,
					virt_text_win_col = vim.api.nvim_strwidth(line),
					virt_text = { { " ", "fgkbg" .. color_code } },
				})
			elseif line:match("@0") then
				local idx = string.find(line, "0")
				local virt_text = use_virt and { { "  ", "fgy" } } or nil
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx2 - 2, {
					end_col = idx,
					hl_group = "fgy",
					virt_text = virt_text,
					virt_text_pos = "overlay",
				})
				if color_code == "d" then
					color_code = "y"
				end
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 0, {
					end_col = #line,
					hl_group = "fgkbg" .. color_code,
					virt_text_win_col = vim.api.nvim_strwidth(line),
					virt_text = { { " ", "fgkbg" .. color_code } },
				})
			elseif line:match("@!") then
				local idx = string.find(line, "!")
				local virt_text = use_virt and { { "  ", "fgr" } } or nil
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx2 - 2, {
					end_col = idx,
					hl_group = "fgr",
					virt_text = virt_text,
					virt_text_pos = "overlay",
				})
				if color_code == "d" then
					color_code = "r"
				end
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 0, {
					end_col = #line,
					hl_group = "fgkbg" .. color_code,
					virt_text_win_col = vim.api.nvim_strwidth(line),
					virt_text = { { " ", "fgkbg" .. color_code } },
				})
			elseif line:match("@%$") then
				local idx = string.find(line, "%$")
				local virt_text = use_virt and { { "  ", "fge" } } or nil
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx2 - 2, {
					end_col = idx,
					hl_group = "fge",
					virt_text = virt_text,
					virt_text_pos = "overlay",
				})
				if color_code == "d" then
					color_code = "e"
				end
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 0, {
					end_col = #line,
					hl_group = "fgkbg" .. color_code,
					virt_text_win_col = vim.api.nvim_strwidth(line),
					virt_text = { { " ", "fgkbg" .. color_code } },
				})
			elseif line:match("@%^") then
				local idx = string.find(line, "%^")
				local virt_text = use_virt and { { "  ", "fgp" } } or nil
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx2 - 2, {
					end_col = idx,
					hl_group = "fgp",
					virt_text = virt_text,
					virt_text_pos = "overlay",
				})
				if color_code == "d" then
					color_code = "p"
				end
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 0, {
					end_col = #line,
					hl_group = "fgkbg" .. color_code,
					virt_text_win_col = vim.api.nvim_strwidth(line),
					virt_text = { { " ", "fgkbg" .. color_code } },
				})
			else
				vim.api.nvim_buf_set_extmark(
					0,
					ns_id,
					i - 1,
					0,
					{ end_col = vim.api.nvim_strwidth(line), hl_group = "Identifier" }
				)
			end
		elseif line:match("^%s*[" .. colors_s .. "]# ") then
			local idx = string.find(line, "#")
			local color_code = line:sub(idx - 1, idx - 1)
			local virt_text = use_virt and { { "⟩ ", "fg" .. color_code } } or nil
			if color_code == "d" then
				color_code = "w"
			end
			vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 0, {
				end_col = #line,
				hl_group = "fgkbg" .. color_code,
				virt_text_win_col = vim.api.nvim_strwidth(line),
				virt_text = { { " ", "fgkbg" .. color_code } },
			})
			vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 2, {
				end_col = idx + 1,
				hl_group = "fg" .. color_code,
				virt_text_win_col = idx - 2,
				virt_text = virt_text,
			})
		elseif line:match("^%s*%*") then
			local idx = string.find(line, "%*")
			vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 1, {
				end_col = #line,
				hl_group = "fgkbgw",
				virt_text_win_col = vim.api.nvim_strwidth(line),
				virt_text = { { " ", "fgkbgw" } },
			})
		elseif line:match("^%s*==*$") then
			local idx = string.find(line, "=")
			vim.api.nvim_buf_set_extmark(
				0,
				ns_id,
				i - 1,
				idx - 1,
				{ end_col = vim.api.nvim_strwidth(line), hl_group = "Comment" }
			)
		elseif line:match("^%s*%-%>") then
			local idx = string.find(line, "%-")
			vim.api.nvim_buf_set_extmark(
				0,
				ns_id,
				i - 1,
				idx - 1,
				{ end_col = vim.api.nvim_strwidth(line), hl_group = "fgeu" }
			)
		elseif line:match("^%s*;[" .. types .. "] ") then
			if line:match("^%s*;x") then
				local idx = string.find(line, ";x")
				local virt_text = use_virt and { { " ", "fgg" } } or nil
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, {
					end_col = idx + 1,
					hl_group = "fgg",
					virt_text = virt_text,
					virt_text_win_col = idx - 1,
				})
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 2, { end_col = #line, hl_group = "Comment" })
			elseif line:match("^%s*;0") then
				local idx = string.find(line, ";0")
				local virt_text = use_virt and { { " ", "fgy" } } or nil
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, {
					end_col = idx + 1,
					hl_group = "fgy",
					virt_text = virt_text,
					virt_text_win_col = idx - 1,
				})
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 2, { end_col = #line, hl_group = "Identifier" })
			elseif line:match("^%s*;!") then
				local idx = string.find(line, ";!")
				local virt_text = use_virt and { { " ", "fgr" } } or nil
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, {
					end_col = idx + 1,
					hl_group = "fgr",
					virt_text = virt_text,
					virt_text_win_col = idx - 1,
				})
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 2, { end_col = #line, hl_group = "fgru" })
			elseif line:match("^%s*;%$") then
				local idx = string.find(line, ";%$")
				local virt_text = use_virt and { { " ", "fge" } } or nil
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, {
					end_col = idx + 1,
					hl_group = "fge",
					virt_text = virt_text,
					virt_text_win_col = idx - 1,
				})
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 2, { end_col = #line, hl_group = "fgeu" })
			elseif line:match("^%s*;%^") then
				local idx = string.find(line, ";%^")
				local virt_text = use_virt and { { " ", "fgp" } } or nil
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, 0, {
					end_col = idx + 1,
					hl_group = "fgp",
					virt_text = virt_text,
					virt_text_win_col = idx - 1,
				})
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx + 2, { end_col = #line, hl_group = "fgpi" })
			else
				local idx = string.find(line, ";")
				vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, idx - 1, { end_col = #line, hl_group = "Comment" })
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
		local end_of_line = vim.api.nvim_strwidth(line)
		new_pos = { current_pos[1], end_of_line }
	else
		new_pos = { current_pos[1], val }
	end
	vim.api.nvim_win_set_cursor(0, new_pos)
end

local function handle_inp()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i, line in ipairs(lines) do
		if line:match("^%s*#$") then
			local idx = string.find(line, "#")
			vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "    d# " })
			right(-1)
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
		elseif line:match("^%s*%@%s*$") then
			local idx = string.find(line, "@")
			vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "        d@0 " })
			right(-1)
		elseif line:match("^%s*;%s*$") then
			local idx = string.find(line, ";")
			vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "            ;0 " })
			right(-1)
		elseif line:match("^%s*%=$") then
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
		elseif line:match("^%s*%-$") then
			local idx = string.find(line, "%-")
			vim.api.nvim_buf_set_text(0, i - 1, 0, i - 1, idx + 0, { "                -> " })
			right(-1)
		end
	end
end

function M.toggle_todo()
	local line = vim.api.nvim_get_current_line()
	local pos = vim.api.nvim_win_get_cursor(0)
	local i = pos[1]
	if line:match("^%s*[" .. colors_s .. "]@[" .. types .. "]") then
		local match = line:match("[" .. colors_s .. "]@([" .. types .. "])")
		local idx = line:find("[" .. colors_s .. "]@([" .. types .. "])")
		if match == "x" then
			vim.api.nvim_buf_set_text(0, i - 1, idx + 1, i - 1, idx + 2, { "0" })
		else
			vim.api.nvim_buf_set_text(0, i - 1, idx + 1, i - 1, idx + 2, { "x" })
		end
	elseif line:match("^%s*;[" .. types .. "]") then
		local match = line:match(";([" .. types .. "]) ")
		local idx = line:find(";([" .. types .. "]) ")
		if match == "x" then
			vim.api.nvim_buf_set_text(0, i - 1, idx + 0, i - 1, idx + 1, { "0" })
		else
			vim.api.nvim_buf_set_text(0, i - 1, idx + 0, i - 1, idx + 1, { "x" })
		end
	end
	highlight_todo_items()
end

function M.toggle_imp()
	local line = vim.api.nvim_get_current_line()
	local pos = vim.api.nvim_win_get_cursor(0)
	local i = pos[1]
	if line:match("[" .. colors_s .. "]@[" .. types .. "]") then
		local match = line:match("[" .. colors_s .. "]@([" .. types .. "])")
		local idx = line:find("[" .. colors_s .. "]@([" .. types .. "])")
		if match == "!" then
			vim.api.nvim_buf_set_text(0, i - 1, idx + 1, i - 1, idx + 2, { "$" })
		elseif match == "0" then
			vim.api.nvim_buf_set_text(0, i - 1, idx + 1, i - 1, idx + 2, { "!" })
		elseif match == "^" then
			vim.api.nvim_buf_set_text(0, i - 1, idx + 1, i - 1, idx + 2, { "0" })
		elseif match == "$" then
			vim.api.nvim_buf_set_text(0, i - 1, idx + 1, i - 1, idx + 2, { "^" })
		elseif match == "x" then
			vim.api.nvim_buf_set_text(0, i - 1, idx + 1, i - 1, idx + 2, { "!" })
		end
	elseif line:match(";[" .. types .. "]") then
		local match = line:match(";([" .. types .. "]) ")
		local idx = line:find(";([" .. types .. "]) ")
		if match == "!" then
			vim.api.nvim_buf_set_text(0, i - 1, idx + 0, i - 1, idx + 1, { "$" })
		elseif match == "0" then
			vim.api.nvim_buf_set_text(0, i - 1, idx + 0, i - 1, idx + 1, { "!" })
		elseif match == "^" then
			vim.api.nvim_buf_set_text(0, i - 1, idx + 0, i - 1, idx + 1, { "0" })
		elseif match == "$" then
			vim.api.nvim_buf_set_text(0, i - 1, idx + 0, i - 1, idx + 1, { "^" })
		elseif match == "x" then
			vim.api.nvim_buf_set_text(0, i - 1, idx + 0, i - 1, idx + 1, { "!" })
		end
	end
	highlight_todo_items()
end

function M.setup()
	local define_grps = {}
	for key, _ in pairs(colors) do
		if key ~= "k" and key ~= "e" then
			define_grps["fg" .. key] = { key }
			define_grps["fgkbg" .. key] = { "k", key }
		end
	end
	for name, color in pairs(define_grps) do
		define_color(name, color[1], color[2])
		define_color(name .. "u", color[1], color[2], false, true)
		define_color(name .. "i", color[1], color[2], true, false, true)
	end
	define_color("fgk", "w", nil, true)
	define_color("fgkbgk", "w", "k")
	define_color("fge", "e", nil, true)
	define_color("fgkbge", "w", "e")
	define_color("fgkbgei", "w", "e", false, false, true)
	define_color("fgeu", "w", nil, false, false, true)
	define_color("fgpi", "p", nil, false, false, true)
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
			highlight_todo_items()
			vim.b.prev_content = current_content
		end,
	})
	vim.api.nvim_create_autocmd("TextChanged", {
		pattern = "*.udi",
		callback = function()
			highlight_todo_items()
		end,
	})
	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		callback = function()
			highlight_todo_items()
		end,
	})
end

return M

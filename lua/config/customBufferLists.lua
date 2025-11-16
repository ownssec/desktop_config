-- bufferlist.lua
-- Floating buffer list with numeric selection (1–9), no padding, and floating window moved upward.

local buffer_order = {}
local float_win = nil
local float_buf = nil

-- Helper: check if a value exists in a table
local function contains(tbl, val)
	for _, v in ipairs(tbl) do
		if v == val then
			return true
		end
	end
	return false
end

-- Helper: close floating window safely
local function close_float()
	if float_win and vim.api.nvim_win_is_valid(float_win) then
		vim.api.nvim_win_close(float_win, true)
	end
	float_win = nil
	float_buf = nil
end

-- Helper: create keymaps inside the floating buffer
local function set_buffer_keymaps(buf)
	local opts = { noremap = true, silent = true, buffer = buf }

	-- Number keys 1–9 to switch buffers
	for i = 1, 9 do
		vim.keymap.set("n", tostring(i), function()
			local bufnr = buffer_order[i]
			if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
				close_float()
				vim.api.nvim_set_current_buf(bufnr)
			else
				vim.notify("Invalid buffer number", vim.log.levels.WARN)
			end
		end, opts)
	end

	-- ESC or <CR> to close window
	vim.keymap.set("n", "<Esc>", close_float, opts)
	vim.keymap.set("n", "<CR>", close_float, opts)
end

-- Create floating window in the center but shifted upward
local function open_floating_window(lines)
	local width = 95

	-- No padding below / above list
	local height = math.min(#lines, 20)

	local ui = vim.api.nvim_list_uis()[1]

	-- Move window upward by X lines
	local offset_up = 10.5 -- adjust higher/lower anytime

	local row = math.max(0, math.floor((ui.height - height) / 2) - offset_up)
	local col = math.floor((ui.width - width) / 2)

	-- Create scratch buffer
	float_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)

	-- Create custom highlight group for gray border
	vim.api.nvim_set_hl(0, "BufferListBorder", { fg = "#808080", bg = "NONE" })
	vim.api.nvim_set_hl(0, "BufferListNormal", { bg = "NONE" })

	-- Open floating window
	local opts = {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
		title = "",
		title_pos = "center",
		noautocmd = true,
	}

	float_win = vim.api.nvim_open_win(float_buf, true, opts)

	-- Apply window highlights
	vim.api.nvim_win_set_hl_ns(float_win, 0)
	vim.api.nvim_win_set_option(float_win, "winhighlight", "Normal:BufferListNormal,FloatBorder:BufferListBorder")

	-- Buffer options
	vim.api.nvim_set_option_value("modifiable", false, { buf = float_buf })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = float_buf })
	vim.api.nvim_set_option_value("filetype", "bufferlist", { buf = float_buf })

	set_buffer_keymaps(float_buf)
end

-- Command to show numbered buffer list
vim.api.nvim_create_user_command("Buffer", function()
	-- Toggle off if already open
	if float_win and vim.api.nvim_win_is_valid(float_win) then
		close_float()
		return
	end

	local buffers = vim.fn.getbufinfo({ buflisted = 1 })

	-- Add new buffers to order
	for _, buf in ipairs(buffers) do
		if not contains(buffer_order, buf.bufnr) then
			table.insert(buffer_order, buf.bufnr)
		end
	end

	-- Remove closed buffers
	local valid_bufs = {}
	for _, buf in ipairs(buffers) do
		valid_bufs[buf.bufnr] = true
	end
	local new_order = {}
	for _, bufnr in ipairs(buffer_order) do
		if valid_bufs[bufnr] then
			table.insert(new_order, bufnr)
		end
	end
	buffer_order = new_order

	if #buffer_order == 0 then
		vim.notify("No open buffers", vim.log.levels.INFO)
		return
	end

	-- Collect display lines
	local lines = {}
	for i, bufnr in ipairs(buffer_order) do
		local bufinfo = vim.fn.getbufinfo(bufnr)[1]
		local fullpath = bufinfo.name ~= "" and vim.fn.fnamemodify(bufinfo.name, ":p") or nil
		local display_path

		if fullpath then
			local relative_path = vim.fn.fnamemodify(fullpath, ":~:.")
			local parts = vim.split(relative_path, "/")
			local start_index = math.max(1, #parts - 2)
			display_path = table.concat(parts, "/", start_index)
		else
			display_path = "[No Name]"
		end

		local formatted = string.format("%2d | %-60s", i, display_path)
		table.insert(lines, formatted)
	end

	open_floating_window(lines)
end, { range = false })

-- Show buffer list with <C-i> (toggle)
vim.keymap.set("n", "<C-i>", ":Buffer<CR>", { noremap = true, silent = true, desc = "Toggle buffer list" })

-- Delete all buffers except current
vim.keymap.set("n", "[ct", function()
	local current = vim.api.nvim_get_current_buf()
	local buffers = vim.api.nvim_list_bufs()
	for _, buf in ipairs(buffers) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
			if buf ~= current then
				vim.cmd("bdelete " .. buf)
			end
		end
	end
	buffer_order = { current }
end, { desc = "Delete all buffers except current" })

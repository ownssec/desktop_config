local leap = require("leap")

-- Set highlights
vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })

-- Default mappings are deprecated — manually set them instead:
leap.opts.safe_labels = {} -- Optional: disables auto labels if you want a minimalist look
leap.opts.highlight_unlabeled_phase_one_targets = true

-- Custom keymap for 'f' motion
vim.keymap.set({ "n", "x", "o" }, "f", function()
	leap.leap({ target_windows = { vim.api.nvim_get_current_win() } })
end, { desc = "Leap forward (custom f)" })

-- Optional: backward leap on 'F'
vim.keymap.set({ "n", "x", "o" }, "F", function()
	leap.leap({ backward = true, target_windows = { vim.api.nvim_get_current_win() } })
end, { desc = "Leap backward (custom F)" })

-- local leap = require("leap")
-- leap.set_default_keymaps(false)
-- vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
-- vim.keymap.set({ "n", "x", "o" }, "f", function()
-- 	leap.leap({ target_windows = { vim.api.nvim_get_current_win() } })
-- end, { desc = "Leap forward (custom f)" })

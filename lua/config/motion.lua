-- lua/configs/motion.lua

vim.g.EasyMotion_do_mapping = 0 -- Disable default mappings

vim.api.nvim_set_keymap("n", "f", "<Plug>(easymotion-s2)", {})

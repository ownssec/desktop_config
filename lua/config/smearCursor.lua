vim.o.guicursor = table.concat({
	"n-v-c:block",
	"i-ci-ve:ver25",
	"r-cr:hor20",
	"o:hor50",
	"sm:block-blinkwait175-blinkon150-blinkoff150",
}, ",")

require("smear_cursor").setup({
	-- never_draw_over_target = true,
	smear_between_buffers = true,
	smear_between_neighbor_lines = true,
	smear_insert_mode = true,
	stiffness = 0.9, -- 0.65     [0, 1]
	trailing_stiffness = 0.7, -- 0.5      [0, 1]
	stiffness_insert_mode = 0.8, -- 0.6      [0, 1]
	trailing_stiffness_insert_mode = 0.8, -- 0.6      [0, 1]
	damping = 0.65, -- 0.6      [0, 1]
	-- distance_stop_animating = 0.1,
	-- time_interval = 7,
	cursor_color = "#8c8888",
	-- damping = 0.5,
	-- never_draw_over_target = true,
	-- hide_target_hack = true,
	gamma = 1,
})

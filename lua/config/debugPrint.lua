require("debugprint").setup({
	opts = {
		keymaps = {
			visual = {
				variable_below = "g?v",
				variable_above = "g?V",
			},
		},
		commands = {
			toggle_comment_debug_prints = "ToggleCommentDebugPrints",
			delete_debug_prints = "DeleteDebugPrints",
			reset_debug_prints_counter = "ResetDebugPrintsCounter",
		},
	},
})

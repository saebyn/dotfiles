return {
	{
		"habamax/vim-godot",
		config = function()
			vim.g.expandtab = true
		end,
	},
	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			-- ---@type lspconfig.options
			servers = {
				gdscript = {}, -- NOTE: To change the port, you need to set the environment variable GDScript_Port to the correct port number.
			},
		},
	},

	-- add an nvim-dap configuration for gdscript and a DAP client adapter configuration for it.
	{
		"mfussenegger/nvim-dap",
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			dap.configurations.gdscript = {
				{
					type = "godot",
					request = "launch",
					name = "Launch scene",
					project = "${workspaceFolder}",
					launch_scene = true,
				},
			}
			dap.adapters.godot = {
				type = "server",
				host = "127.0.0.1",
				port = 6005,
			}
		end,
	},
	{ "skywind3000/asyncrun.vim" },
	{ "teatek/gdscript-extended-lsp.nvim", opts = { view_type = "floating", picker = "snacks" } },
	{
		"folke/snacks.nvim",
		opts = {
			picker = {
				sources = {
					explorer = {
						hidden = true, -- show hidden files
						ignored = false, -- don't show gitignored files
						exclude = { -- exclude specific patterns
							"*.uid", -- glob pattern for files ending with .uid
							"server.pipe", -- exact filename match
						},
					},
				},
			},
		},
	},
}

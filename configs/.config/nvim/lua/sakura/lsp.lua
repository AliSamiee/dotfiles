---@diagnostic disable: redefined-local
local present, mason = pcall(require, "mason")
if not present then
	vim.notify("mason not found.")
	return
end

mason.setup({
	ui = {
		border = "rounded",
	},
})

local present, mason_lsp_config = pcall(require, "mason-lspconfig")
if not present then
	vim.notify("mason-lspconfig not found.")
	return
end

local present, lsp_zero = pcall(require, "lsp-zero")
if not present then
	vim.notify("lsp-zero was not found.")
	return
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
	keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
	keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
end

lsp_zero.set_sign_icons({
	error = "",
	warn = "",
	hint = "󰌵",
	info = "",
})

lsp_zero.on_attach(function(client, bufnr)
	-- lsp.default_keymaps({buffer = bufnr})
	lsp_keymaps(bufnr)

	local illuminate_present, illuminate = pcall(require, "illuminate")
	if illuminate_present then
		illuminate.on_attach(client)
	end
end)

mason_lsp_config.setup({
	ensure_installed = {},
	handlers = {
		lsp_zero.default_setup,
		lua_ls = function()
			local lua_opts = lsp_zero.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(lua_opts)
		end,
	},
})

-- fix clangd offset encoding error
local present, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if present then
	require("lspconfig").clangd.setup({
		on_attach = on_attach,
		capabilities = cmp_nvim_lsp.default_capabilities(),
		cmd = {
			"clangd",
			"--offset-encoding=utf-16",
		},
	})
end

local present, null_ls = pcall(require, "null-ls")
if not present then
	vim.notify("null-ls not found.")
	return
end

-- local formatting = null_ls.builtins.formatting
-- local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	sources = {
		-- formatting.prettier.with {
		--     extra_filetypes = { "toml" },
		--     extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
		-- },
		-- formatting.black, -- .with { extra_args = { "--fast" } },
		-- formatting.stylua,
		-- formatting.google_java_format,
		-- diagnostics.flake8,
	},
})

local present, mason_null_ls = pcall(require, "mason-null-ls")
if not present then
	vim.notify("mason-null-ls not found.")
	return
end

mason_null_ls.setup({
	ensure_installed = nil,
	automatic_installation = true,
	handlers = {
		-- Here you can add functions to register sources.
		-- See https://github.com/jay-babu/mason-null-ls.nvim#handlers-usage
		--
		-- If left empty, mason-null-ls will  use a "default handler"
		-- to register all sources
	},
})

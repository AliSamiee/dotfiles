local present, null_ls = pcall(require, "null-ls")
if not present then
    vim.notify("null-ls not found.")
    return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
    debug = false,
    sources = {
        -- formatting.prettier.with {
        --     extra_filetypes = { "toml" },
        --     extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
        -- },
        formatting.black, -- .with { extra_args = { "--fast" } },
        formatting.stylua,
        -- formatting.google_java_format,
        diagnostics.flake8,
    },
}

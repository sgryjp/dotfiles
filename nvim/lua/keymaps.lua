-- Neovim specific keymappings

local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts["silent"] = true
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end
local function nmap(lhs, rhs, opts)
    map("n", lhs, rhs, opts)
end

-- Go to something
nmap("gD", ":lua vim.lsp.buf.declaration()<CR>", { desc = "Go to declaration" })
nmap("gd", ":lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
nmap("gy", ":lua vim.lsp.buf.type_definition()<CR>", { desc = "Go to type definition" })
nmap("gi", ":lua vim.lsp.buf.implementation()<CR>", { desc = "Go to implementation" })
nmap("gr", ":lua vim.lsp.buf.references()<CR>", { desc = "Go to references" })

-- Inspection
nmap("K", ":lua vim.lsp.buf.hover()<CR>", { desc = "Show hover" })

-- Refactoring (and formatting)
nmap([[\r]], ":lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })
nmap([[\a]], ":lua vim.lsp.buf.code_action()<CR>", { desc = "Exec code action" })
nmap([[\f]], ":lua require'conform'.format({lsp_fallback = true})<CR>", { desc = "Format document" })

-- Fuzzy finder and utility views
nmap("<Space>l", ":lopen<CR>", { desc = "Open location list window" })
nmap("<Space>q", ":copen<CR>", { desc = "Open quick fix window" })
nmap("<C-p>", ":lua MiniPick.builtin.files()<CR>", { desc = "Pick files" })
nmap("<Space>b", ":lua MiniPick.builtin.buffers()<CR>", { desc = "Pick a buffer" })
nmap("<Space>f", ":lua MiniPick.builtin.files()<CR>", { desc = "Pick a file" })
nmap("<Space>p", ":lua MiniPick.builtin.grep_live()<CR>", { desc = "Live grep" })
-- nmap("<Space>s", ":lua MiniExtra.pickers.lsp({ scope = 'document_symbol' })<CR>", { desc = "Pick a symbol (document)" })
nmap(
    "<Space>S",
    ":lua MiniExtra.pickers.lsp({ scope = 'workspace_symbol' })<CR>",
    { desc = "Pick a symbol (workspace)" }
)
nmap("<Space>d", ":lua MiniExtra.pickers.lsp({ scope = 'definition' })<CR>", { desc = "Pick a definition" })
nmap("<Space>r", ":lua MiniExtra.pickers.lsp({ scope = 'references' })<CR>", { desc = "Pick a reference" })
nmap("<Space>i", ":lua MiniExtra.pickers.lsp({ scope = 'implementation' })<CR>", { desc = "Pick a implementation" })
nmap("<Space>y", ":lua MiniExtra.pickers.lsp({ scope = 'type_definition' })<CR>", { desc = "Pick a type definition" })
nmap("<Space>g", ":lua MiniExtra.pickers.diagnostic()<CR>", { desc = "Pick a diagnostic" })

nmap("<Space>s", ":SymbolsOutline<CR>", { desc = "Open outline" })

-- File explorer (oil.nvim)
nmap("-", ":Oil<CR>")

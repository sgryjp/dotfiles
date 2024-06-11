-- Neovim specific keymappings

local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts["silent"] = true
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end
local function nmap(lhs, rhs, opts)
    map("n", lhs, rhs, opts)
end
local function vscode_nmap(lhs, rhs)
    map("n", lhs, string.format(":call VSCodeNotify('%s')<CR>", rhs))
end

-- Go to something
if vim.g.vscode then
    vscode_nmap("gD", "editor.action.revealDeclaration")
    vscode_nmap("gd", "editor.action.revealDefinition")
    vscode_nmap("gy", "editor.action.goToTypeDefinition")
    vscode_nmap("gi", "editor.action.goToImplementation")
    vscode_nmap("gr", "editor.action.goToReferences")
else
    nmap("gD", ":lua vim.lsp.buf.declaration()<CR>", { desc = "Go to declaration" })
    nmap("gd", ":lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
    nmap("gy", ":lua vim.lsp.buf.type_definition()<CR>", { desc = "Go to type definition" })
    nmap("gi", ":lua vim.lsp.buf.implementation()<CR>", { desc = "Go to implementation" })
    nmap("gr", ":lua vim.lsp.buf.references()<CR>", { desc = "Go to references" })
end

-- Inspection
if vim.g.vscode then
    vscode_nmap("K", "editor.action.showHover")
else
    nmap("K", ":lua vim.lsp.buf.hover()<CR>", { desc = "Show hover" })
end

-- Refactoring (and formatting)
if vim.g.vscode then
    vscode_nmap([[\r]], "editor.action.rename")
    vscode_nmap([[\a]], "editor.action.quickFix")
    vscode_nmap([[\f]], "editor.action.formatDocument")
else
    nmap([[\r]], ":lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })
    nmap([[\a]], ":lua vim.lsp.buf.code_action()<CR>", { desc = "Exec code action" })
    nmap([[\f]], ":lua require'conform'.format({lsp_fallback = true})<CR>", { desc = "Format document" })
end

-- Fuzzy finder and utility views
if vim.g.vscode then
    vscode_nmap("<Space>q", "workbench.actions.view.problems")
    vscode_nmap("<Space>f", "workbench.action.quickOpen")
    vscode_nmap("<Space>p", "workbench.action.findInFiles")
    vscode_nmap("<Space>s", "outline.focus")
else
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
    nmap(
        "<Space>y",
        ":lua MiniExtra.pickers.lsp({ scope = 'type_definition' })<CR>",
        { desc = "Pick a type definition" }
    )
    nmap("<Space>g", ":lua MiniExtra.pickers.diagnostic()<CR>", { desc = "Pick a diagnostic" })

    nmap("<Space>s", ":SymbolsOutline<CR>", { desc = "Open outline" })
end

-- File explorer (oil.nvim)
nmap("-", ":Oil<CR>")

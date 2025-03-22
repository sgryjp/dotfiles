-- Utility functions

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts["silent"] = true
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

local function nmap(lhs, rhs, opts) map("n", lhs, rhs, opts) end

local function tmap(lhs, rhs, opts) map("t", lhs, rhs, opts) end

local function vscode_nmap(lhs, rhs) map("n", lhs, string.format(":call VSCodeNotify('%s')<CR>", rhs)) end

--------------------------------------------------------------------------------

-- Close auxiliary windows by q or <C-[> in normal mode.
nmap("<C-[>", ":cclose<CR>:lclose<CR>:helpclose<CR>", { desc = "Close auxiliary windows" })
nmap("q", ":cclose<CR>:lclose<CR>:helpclose<CR>", { desc = "Close auxiliary windows" })

-- Buffer management
if not vim.g.vscode then
  nmap("]b", ":bnext<CR>", { desc = "Next buffer" })
  nmap("[b", ":bprevious<CR>", { desc = "Previous buffer" })
  nmap("\\q", ":lua MiniBufremove.delete()<CR>", { desc = "Delete buffer" })
end

-- Jump to previous or next something
if vim.g.vscode then
  vscode_nmap("[d", "editor.action.marker.prevInFiles")
  vscode_nmap("]d", "editor.action.marker.nextInFiles")
  vscode_nmap("[h", "workbench.action.editor.prevChange")
  vscode_nmap("]h", "workbench.action.editor.nextChange")
else
  nmap("]l", ":lnext<CR>", { desc = "Next location list item" })
  nmap("[l", ":lprevious<CR>", { desc = "Previous location list item" })
  nmap("]q", ":cnext<CR>", { desc = "Next quickfix item" })
  nmap("[q", ":cprevious<CR>", { desc = "Previous quickfix item" })
  nmap("]d", ":lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })
  nmap("[d", ":lua vim.diagnostic.goto_prev()<CR>", { desc = "Previous diagnostic" })
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

-- Auxiliary views
if vim.g.vscode then
  vscode_nmap("<Space>q", "workbench.actions.view.problems")
  vscode_nmap("<Space>f", "workbench.action.quickOpen")
  vscode_nmap("<Space>p", "workbench.action.findInFiles")
  vscode_nmap("<Space>s", "outline.focus")
else
  nmap("<Space>l", ":lopen<CR>", { desc = "Open location list window" })
  nmap("<Space>q", ":copen<CR>", { desc = "Open quick fix window" })
  nmap("<Space>h", ":lua MiniDiff.toggle_overlay()<CR>", { desc = "Toggle MiniDiff overlay" })

  nmap("<Space>e", ":lua Snacks.explorer()<CR>", { desc = "Pick files" })

  nmap("<C-p>", ":Telescope find_files<CR>", { desc = "Pick files" })
  nmap("<Space>b", ":Telescope buffers<CR>", { desc = "Pick a buffer" })
  nmap("<Space>f", ":Telescope find_files<CR>", { desc = "Pick a file" })
  nmap("<Space>p", ":Telescope live_grep<CR>", { desc = "Live grep" })
  -- nmap("<Space>s", ":Telescope lsp_document_symbols<CR>", { desc = "Pick a symbol (document)" })
  nmap("<Space>S", ":Telescope lsp_workspace_symbols<CR>", { desc = "Pick a symbol (workspace)" })
  nmap("<Space>d", ":Telescope lsp_definitions<CR>", { desc = "Pick a definition" })
  nmap("<Space>r", ":Telescope lsp_references<CR>", { desc = "Pick a reference" })
  nmap("<Space>i", ":Telescope lsp_implementations<CR>", { desc = "Pick a implementation" })
  nmap("<Space>y", ":Telescope lsp_type_definitions<CR>", { desc = "Pick a type definition" })
  nmap("<Space>g", ":Telescope diagnostics<CR>", { desc = "Pick a diagnostic" })

  nmap("<Space>s", ":AerialToggle<CR>", { desc = "Open outline" })
end

-- File explorer (oil.nvim)
nmap("-", ":Oil<CR>")

-- Moves between windows
nmap("<C-h>", "<C-w>h", { desc = "Focus left" })
nmap("<C-j>", "<C-w>j", { desc = "Focus down" })
nmap("<C-k>", "<C-w>k", { desc = "Focus up" })
nmap("<C-l>", "<C-w>l", { desc = "Focus right" })
tmap("<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
tmap("<C-[>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
tmap("<C-h>", "<C-\\><C-n><C-w>h", { desc = "Focus left" })
tmap("<C-j>", "<C-\\><C-n><C-w>j", { desc = "Focus down" })
tmap("<C-k>", "<C-\\><C-n><C-w>k", { desc = "Focus up" })
tmap("<C-l>", "<C-\\><C-n><C-w>l", { desc = "Focus right" })

-- Toggling
nmap("\\b", ':lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"<CR>', { desc = "Toggle dark/light" })
nmap("\\w", ":setlocal wrap!<CR>", { desc = "Toggle wrap" })

-- Move forward/backward till next non-wsp at same the column
-- https://vi.stackexchange.com/a/693
nmap("gJ", ":call search('\\%' . virtcol('.') . 'v\\S', 'W')<CR>", { desc = "Go down to next non-WSP" })
nmap("gK", ":call search('\\%' . virtcol('.') . 'v\\S', 'bW')<CR>", { desc = "Go up to previous non-WSP" })

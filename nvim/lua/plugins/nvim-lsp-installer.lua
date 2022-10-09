local ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not ok then
    return
end

lsp_installer.on_server_ready(function(server)
    server:setup {}
    vim.cmd("do User LspAttachBuffers")
end)

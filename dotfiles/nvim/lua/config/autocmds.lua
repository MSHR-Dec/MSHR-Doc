vim.opt.updatetime = 500

vim.api.nvim_set_hl(0, "LspReferenceText",  { bg = "#3b3f51" })
vim.api.nvim_set_hl(0, "LspReferenceRead",  { bg = "#2d4a3a" })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#4a2d3a" })

local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  group = group,
  callback = function()
    pcall(vim.lsp.buf.clear_references)
  end,
})

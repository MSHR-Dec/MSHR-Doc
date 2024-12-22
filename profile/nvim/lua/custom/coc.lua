vim.api.nvim_create_autocmd("User", {
  pattern = "CocNvimInit",
  callback = function()
    vim.keymap.set("n", "gh", "<cmd>call CocAction('doHover')<cr>")
    vim.keymap.set("n", "gf", "<cmd>call CocAction('format')<cr>")
    vim.keymap.set("n", "gr", "<Plug>(coc-references)")
    vim.keymap.set("n", "gd", "<Plug>(coc-definition)")
    vim.keymap.set("n", "gi", "<Plug>(coc-implementation)")
    vim.keymap.set("n", "gt", "<Plug>(coc-type-definition)")
    vim.keymap.set("n", "gn", "<Plug>(coc-rename)")
    vim.keymap.set("n", "ga", "<Plug>(coc-codeaction-cursor)")
    vim.keymap.set("n", "g]", "<cmd><C-u>CocNext<cr>")
    vim.keymap.set("n", "g[", "<cmd><C-u>CocPrev<cr>")

    local coc_group = vim.api.nvim_create_augroup("CocGroup", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      group = coc_group,
      command = "silent call CocActionAsync('highlight')",
    })
  end,
})

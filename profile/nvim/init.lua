require('common')
require('plugins')
require('appearances')
require('tools')
require('lsps')

local custom_path = vim.fn.stdpath('config') .. '/lua/custom.lua'
if vim.fn.filereadable(custom_path) == 1 then
  require('custom')
end

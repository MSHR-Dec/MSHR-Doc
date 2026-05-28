return {
  {
    "hashivim/vim-terraform",
    ft = { "terraform", "tf", "hcl" },
    init = function()
      vim.g.terraform_fmt_on_save = 1
    end,
  },
}

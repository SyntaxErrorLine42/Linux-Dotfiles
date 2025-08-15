-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "dark_horizon",

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}
vim.opt.clipboard = "" -- disables automatic system clipboard
vim.keymap.set({ "n", "v" }, "y", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "Y", '"+Y', { noremap = true, silent = true })
vim.keymap.set({ "n", "i", "v" }, "<C-a>", "<Esc>ggVG$", { noremap = true, silent = true, desc = "Select all" })
return M

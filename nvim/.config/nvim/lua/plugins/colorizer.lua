return {
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*", "!markdown", "!copilot-chat" },
    },
  },
}

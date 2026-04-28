return {
  {
    "Avi-D-coder/whisper.nvim",
    config = function()
      require('whisper').setup({
        binary_path = '/run/current-system/sw/bin/whisper-stream',
        model = 'large.en',
        step_ms = 4000,
        keybind = '<C-g>',
        manual_trigger_key = '<Space>',
      })
    end,
    keys = {
      { '<C-g>', mode = {'n', 'i', 'v'}, desc = 'Toggle speech-to-text' }
    },
  },
}

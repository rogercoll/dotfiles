return {
    {
        'navarasu/onedark.nvim',
        lazy = false,
        config = function()
          require('onedark').setup({ style = 'warmer' })
          require('onedark').load()
        end,
    }
}

local M = {}

function M.is_buffer_empty()
  -- Check whether the current buffer is empty
  return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

function M.has_width_gt(cols)
  -- Check if the windows width is greater than a given number of columns
  return vim.fn.winwidth(0) / 2 > cols
end

function M.map(type, key, value)
    vim.api.nvim_buf_set_keymap(0,type,key,value,{noremap = true, silent = true});
end

function M.map_allbuf(type, key, value)
    vim.api.nvim_set_keymap(type,key,value,{noremap = true, silent = true});
end


return M

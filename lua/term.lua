local vim = vim
local api =  vim.api
local M = {}

local function expand_command(command)
  return string.gsub(command, "%%", vim.fn.expand('%'))
end

function M.term_open()
  if M.buf_handle == nil or not api.nvim_buf_is_valid(M.buf_handle) then
    api.nvim_command('botright split new')
    api.nvim_win_set_height(0, api.nvim_get_var('term_default_height'))
    M.win_handle = api.nvim_tabpage_get_win(0)
    M.buf_handle = api.nvim_win_get_buf(0)
    M.jobID = api.nvim_call_function("termopen", {"$SHELL"})
    api.nvim_command('wincmd p')
  else
    api.nvim_command('botright split new')
    api.nvim_win_set_height(0, api.nvim_get_var('term_default_height'))
    M.win_handle = api.nvim_tabpage_get_win(0)
    api.nvim_set_current_buf(M.buf_handle)
    api.nvim_command('wincmd p')
  end
end

function M.term_close()
  api.nvim_win_close(M.win_handle, true)
end

function M.term_toggle()
  -- TODO
  if M.buf_handle == nil or not api.nvim_win_is_valid(M.win_handle) then
    M.term_open()
  else
    M.term_close()
  end
end

function M.term_send(command)
  if M.buf_handle == nil or not api.nvim_win_is_valid(M.win_handle) then
    M.term_open()
  end
  command = expand_command(command)
  api.nvim_call_function("chansend", {M.jobID, command.."\n"})
  api.nvim_set_current_win(M.win_handle)
  -- force scroll down
  api.nvim_command("normal G")
  api.nvim_command("wincmd p")
end

-- NOTE can't send "\<c-c>" currently through lua API
-- Use vimscript function instead
function M.term_kill()
  api.nvim_call_function("termnvim#term_kill", {M.jobID})
end

function M.term_focus()
  if M.buf_handle == nil or not api.nvim_win_is_valid(M.win_handle) then
    M.term_open()
  end
  api.nvim_set_current_win(M.win_handle)
  api.nvim_win_set_height(M.win_handle, api.nvim_get_var('term_focus_height'))
end

function M.term_unfocus()
  api.nvim_win_set_height(api.nvim_get_var('term_default_height'))
  api.nvim_command("wincmd p")
end

return M

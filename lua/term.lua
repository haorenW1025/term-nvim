local api =  vim.api
local M = {}

function M.term_open()
  if M.bufID == nil or not api.nvim_buf_is_valid(M.bufID) then
    api.nvim_command('botright split new') 
    api.nvim_win_set_height(0, 20)
    M.winID = api.nvim_call_function("winnr", {})
    M.bufID = api.nvim_call_function("bufnr", {"%"})
    M.jobID = api.nvim_call_function("termopen", {"/bin/zsh"})
    api.nvim_command('wincmd p')
  else
    api.nvim_command('botright split new')
    api.nvim_command('resize 20')
    M.winID = api.nvim_call_function("winnr", {})
    api.nvim_set_current_buf(M.bufID)
    api.nvim_command('wincmd p')
  end
end

function M.term_close()
  -- TODO
  api.nvim_command('wincmd b')
  api.nvim_command('close')
end

function M.term_toggle()
  -- TODO
  if M.bufID == nil or api.nvim_call_function("winbufnr", {M.winID}) == -1 then
    M.term_open() 
  else
    M.term_close()
  end
end

function M.term_send(command)
  -- TODO
  if M.bufID == nil or api.nvim_call_function("winbufnr", {M.winID}) == -1 then
    M.term_open()
  end
  api.nvim_call_function("chansend", {M.jobID, command.."\n"})
end

-- NOTE can't send "\<c-c>" currently through lua API
-- Use vimscript function instead
function M.term_kill()
  api.nvim_call_function("termnvim#term_kill", {M.jobID})
end

return M

return {
  onExit = function(obj)
    local notifs = {
      { content = obj.code,   msg = "Exited with code: ", level = vim.log.levels.INFO },
      { content = obj.stdout, msg = "Output:\n",          level = vim.log.levels.INFO },
      { content = obj.stderr, msg = "Errors:\n",          level = vim.log.levels.ERROR },
    }

    vim.schedule(function()
      vim.iter(notifs):each(function(notif)
        local content = notif.content
        if content and content ~= "" then
          vim.notify(notif.msg .. content, notif.level)
        end
      end)
    end)
  end
}

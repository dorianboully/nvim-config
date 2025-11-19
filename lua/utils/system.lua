return {
  onExit = function(out)
    local notifs = {
      { content = out.code,   msg = "Exited with code: ", level = vim.log.levels.INFO },
      { content = out.stdout, msg = "",                   level = vim.log.levels.INFO },
      { content = out.stderr, msg = "",                   level = vim.log.levels.ERROR },
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

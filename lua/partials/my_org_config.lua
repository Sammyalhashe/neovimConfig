if (vim.g.os == "Linux" and vim.g.wsl == true) then
    _org_base_directory = "/mnt/c/Users/sammy/"
    _org_default_notes_file = _org_base_directory .. 'Dropbox/Org/Orgzly/inbox.org'
else
    if vim.g.bb == true then
        _org_default_notes_file = '~/Desktop/what-ive-learned/README.org' 
    else
        _org_default_notes_file = '~/Dropbox/Org/Orgzly/inbox.org'
    end
    _org_default_notes_file = '~/Desktop/what-ive-learned/README.org' 
end
return {
  org_agenda_files = {'~/Dropbox/Org/Orgzly/inbox.org', '~/Dropbox/Org/Orgzly/notes.org', '~/Desktop/what-ive-learned/**/*' },
  org_default_notes_file = _org_default_notes_file,
  -- org_hide_leading_stars = true,
  org_todo_keywords = {'TODO(t)', 'OPTIMIZE(o)', 'WAITING(w)', 'DELEGATED(z)', '|', 'DONE(d)'},
  org_todo_keyword_faces = {
    WAITING = ':foreground blue :weight bold',
    DELEGATED = ':background #FFFFFF :slant italic :underline on',
    TODO = ':foreground red', -- overrides builtin color for `TODO` keyword
  },
  -- org_ellipsis = " ==="
  notifications = {
        enabled = true,
        cron_enabled = true,
        repeater_reminder_time = 5,
        deadline_warning_reminder_time = false,
        reminder_time = 10,
        deadline_reminder = true,
        scheduled_reminder = true,
        notifier = function(tasks)
          local result = {}
          for _, task in ipairs(tasks) do
            require('orgmode.utils').concat(result, {
              string.format('# %s (%s)', task.category, task.humanized_duration),
              string.format('%s %s %s', string.rep('*', task.level), task.todo, task.title),
              string.format('%s: <%s>', task.type, task.time:to_string())
            })
          end
          if not vim.tbl_isempty(result) then
            require('orgmode.notifications.notification_popup'):new({ content = result })
          end
        end,
        cron_notifier = function(tasks)
          for _, task in ipairs(tasks) do
            local title = string.format('%s (%s)', task.category, task.humanized_duration)
            local subtitle = string.format('%s %s %s', string.rep('*', task.level), task.todo, task.title)
            local date = string.format('%s: %s', task.type, task.time:to_string())
            -- Linux
            if vim.fn.executable('notify-send') == 1 then
              vim.loop.spawn('notify-send', { args = { string.format('%s\n%s\n%s', title, subtitle, date) }})
            end
            -- MacOS
            if vim.fn.executable('terminal-notifier') == 1 then
              vim.loop.spawn('terminal-notifier', { args = { '-title', title, '-subtitle', subtitle, '-message', date }})
            end
          end
        end
      },
    org_capture_templates = {
        w = {
            description = "Work",
            template = "* %^{TODO|FIX|OPTIMIZE} %n %?\n  %T",
            target = "~/Desktop/what-ive-learned/bb/todo.org"
        },

        p = {
            description = "Personal",
            template = "* %^{TODO|FIX|OPTIMIZE} %n %?\n  %T",
            target = "~/Desktop/what-ive-learned/personal/todo.org"
        }
    }

}

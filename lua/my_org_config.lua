--> NOTE: No need to check if org exists here, since this file should only be
--  included with orgmode.rc.lua.

local _org_default_notes_file = nil
local _org_base_directory = nil
if (vim.g.os == "Linux" and vim.g.wsl == true) then
    _org_base_directory = "/mnt/c/Users/sammy/"
    _org_default_notes_file = _org_base_directory .. 'Dropbox/Org/Orgzly/inbox.org'
else
    if vim.g.bb == true then
        _org_base_directory = "~/Desktop/what-ive-learned/"
        _org_default_notes_file = _org_base_directory .. 'README.org'
    else
        _org_base_directory = "~/Dropbox/Org/Orgzly/"
        _org_default_notes_file = _org_base_directory .. 'inbox.org'
    end
end

--> Command that will open my orgmode directory.
local dir_mappings = {}
dir_mappings["zshrc"] = "~/.zshrc"
dir_mappings["nvim"] = "~/.config/nvim/"
dir_mappings["org"] = _org_default_notes_file

function OpenOrg()
    vim.api.nvim_command("edit " .. dir_mappings["org"])
    vim.api.nvim_command("cd %:h")
end

local opts = {
}

vim.api.nvim_create_user_command("OpenOrg", OpenOrg, opts)

--> I want to create a sytem that lets me jounral in a specific directory.


return {
    org_agenda_files = { '~/Dropbox/Org/Orgzly/inbox.org', '~/Dropbox/Org/Orgzly/notes.org',
        '~/Desktop/what-ive-learned/**/*' },
    org_default_notes_file = _org_default_notes_file,
    -- org_hide_leading_stars = true,
    org_todo_keywords = { 'TODO(t)', 'OPTIMIZE(o)', 'WAITING(w)', 'DELEGATED(z)', '|', 'DONE(d)' },
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
                    vim.loop.spawn('notify-send', { args = { string.format('%s\n%s\n%s', title, subtitle, date) } })
                end
                -- MacOS
                if vim.fn.executable('terminal-notifier') == 1 then
                    vim.loop.spawn('terminal-notifier',
                        { args = { '-title', title, '-subtitle', subtitle, '-message', date } })
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
            target = _org_default_notes_file
        },
        j = {
            description = "Journal",
            template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
            target = _org_base_directory .. "journal/" .. os.date("%A_%B_%d_%Y") .. ".org"
        },
    }

}

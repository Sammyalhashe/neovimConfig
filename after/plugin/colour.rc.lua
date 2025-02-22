local utils = require "utils"

function readColorschemeFile()
    if not utils.file_exists("~/.colorscheme") then return {} end
    local lines = {}

    for line in io.lines(utils.expandFilePath("~/.colorscheme")) do
        lines[#lines + 1] = line
    end

    return lines
end

local res = readColorschemeFile()
local wanted = nil
if #res > 0 then
    wanted = res[1]
end

if wanted == nil then
    wanted = utils.valueOrDefault(vim.g.color, "carbonfox")
end
vim.o.background = utils.valueOrDefault(vim.g.background, "dark")

if utils.string_contains(wanted, "fox$") then
    local status, nightfox = pcall(require, "nightfox")
    if (not status) then return end

    nightfox.setup {
        options = {
            styles = {
                comments = "italic",
                keywords = "bold",
                types = "italic,bold",
            },
            dim_inactive = true,
        },
        specs = {},
        palettes = {
            all = {
                _green = "#90ee90",
            }
        },
        groups = {
            all = {
                debugPC = { bg = "palette._green" }
            },
        },
    }

    colorscheme = wanted
elseif utils.string_contains(wanted, "baby$") then
    local status, _ = pcall(require, "gruvbox-baby")
    if (not status) then return end

    colorscheme = wanted

    vim.g.gruvbox_baby_telescope_theme = 1
elseif utils.string_contains(wanted, "bones$") then
    vim.g.zenbones_solid_line_nr = true
    vim.g.zenbones_darken_comments = 45
    vim.g.zenbones_italic_comments = true
    colorscheme = wanted
else
    colorscheme = wanted
end

--> Autocmd that keeps wezterm and neovim in sync on unix
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("wezterm_colorscheme", { clear = true }),
  callback = function(args)
    local colorschemes = {
      ["carbonfox"] = "carbonfox",
      ["dayfox"] = "dayfox",
      ["dawnfox"] = "dawnfox",
      ["duskfox"] = "duskfox",
      ["terafox"] = "terafox",
      ["monokai-nighttasty"] = "monokai",
      ["gruvbox"] = "GruvboxDark",
      -- add more color schemes here ...
    }
    local colorscheme = colorschemes[args.match]
    if not colorscheme then
      return
    end
    -- Write the colorscheme to a file
    local wezterm_config_dir = "$HOME/.config/wezterm/colorscheme"

    if vim.g.wsl ~= 0 then
        --> NOTE A string can also be inside `[[]]` in lua
        local userprofile = vim.fn.system([[cmd.exe /C "echo %USERPROFILE%" 2>/dev/null | tr -d '\r']])
        local wezterm_path = vim.fn.system("wslpath " .. userprofile)
        --> NOTE Might need to change this. I currently edit in whatever the
        --> "root" is in powershell.
        wezterm_config_dir = wezterm_path
    end
    local filename = vim.fn.expand(wezterm_config_dir)
    assert(type(filename) == "string")
    local file = io.open(filename, "w")
    assert(file)
    file:write(colorscheme)
    file:close()
    vim.notify("Setting WezTerm color scheme to " .. colorscheme, vim.log.levels.INFO)
  end,
})



vim.cmd("colorscheme " .. colorscheme)

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


vim.cmd("colorscheme " .. colorscheme)

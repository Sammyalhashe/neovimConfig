local utils = require("utils")

local cmd = vim.cmd
local fn = vim.fn

--> Module level variables
local session_dir = "~/.sessions/"


local M = {}

function M.setup(opts)
    if opts.session_dir then
        session_dir = opts.session_dir
    end

    if opts.mappings then
        local mappings = opts.mappings
        
        for k, v in pairs(mappings) do
            if k == "chooseSession" then
                vim.keymap.set('n', v, M.chooseSession)
            elseif k == "saveSession" then
                vim.keymap.set('n', v, M.saveSession)
            elseif k == "deleteSession" then
                vim.keymap.set('n', v, M.deleteSession)
            end
        end


    end

    utils.mkdir(session_dir, "p")
end

--> local functions that depend on the setup state
local function overwriteSession(sessionName)
    cmd("mks! " .. utils.expandFilePath(session_dir) .. sessionName)
end

local function sessionExists(sessionName)
    return utils.file_exists(utils.expandFilePath(session_dir) .. sessionName)
end

local function getAllSessions()
    return fn.split(fn.glob(session_dir .. "*"))
end

local function openSession(sessionName)
    cmd.source(sessionName)
end

local function deleteSession(sessionName)
    fn.delete(sessionName)
end

local function buildSessionPrompt(sessions)
    local prompt = ""
    for i, session in pairs(sessions) do
        prompt = prompt .. "&" .. i .. " " .. session .. "\n"
    end
    return prompt
end

--> exposed module functions.
function M.chooseSession()
    local sessions = getAllSessions()
    local prompt = buildSessionPrompt(sessions)

    local res = fn.confirm("Selected the session to open: ", prompt)

    openSession(sessions[res])
end

function M.saveSession()
    local sessionName = fn.input("Enter the name of the session: ")

    local prompt = "&y\n&n\n"
    local res = fn.confirm("Confirm choice: " .. sessionName .. "?", prompt)

    if (res > 1) then
        return
    end

    overwriteSession(sessionName)
end

function M.deleteSession()
    local sessions = getAllSessions()
    local prompt = buildSessionPrompt(sessions)
    local res = fn.confirm("Choose the session to delete: ", prompt)

    local sessionName = sessions[res]
    local prompt = "&y\n&n\n"
    local res = fn.confirm("Confirm deletion: " .. sessionName .. "?", prompt)

    if (res > 1) then
        return
    end

    deleteSession(sessionName)
end

return M

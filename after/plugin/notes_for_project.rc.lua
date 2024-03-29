local status, notes_for_project = pcall(require, "notes_for_projects")
if not status then return end



notes_for_project.setup {
    mappings = {
        newNote = "\\q",
        openNote = "\\o"
    },
    default_notes_ext = "org",
    override_selector = require("notes_for_projects_telescope_ext"),
    default_notes_dir = vim.g.default_notes_dir,
    default_notes_project = vim.g.default_notes_project
}

# Sammy's Neovim Config

## Dependencies
- Latest version of neovim (or at least 0.5+)
- `clangd` for c++ lsp support.
- `pylsp` for python lsp support.
    - Run `python3 -m pip install python-lsp-server`

## Setup
- Clone this repo into `~/.config/nvim`
- Open neovim: `nvim`
    - Once open, it will download a plugin called `vim-plug`, let this run to completion.
    - As long as this downloads, you are golden, if any other errors occur don't worry.
- Close neovim and open it again.
- Once opened for the second time, if it errored out the first time, run the command `:PlugInstall`, this will install the plugins I use.
- Close and reopen one more time and you are set to use.

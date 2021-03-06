local nvim_lsp = require'lspconfig'
local configs = require'lspconfig/configs'
local utils = require'utils'
require'folds'
vim.lsp.set_log_level("error")

local get_diagnostics = function()
    local diags = vim.lsp.diagnostic.get_all()
    for k,v in pairs(diags) do
        for i in pairs(v) do
            print(i, v[i])
        end
    end
end

local custom_attach = function(client)
    utils.map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
    utils.map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
    utils.map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
    utils.map('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
    utils.map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
    utils.map('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
    utils.map('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
    utils.map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
    utils.map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
    utils.map('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>')
    utils.map('n','<leader>ac','<cmd>lua vim.lsp.buf.code_action()<CR>')
    utils.map('n','<leader>ee','<cmd>lua vim.diagnostic.open_float()<CR>')
    utils.map('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>')
    utils.map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
    utils.map('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
    utils.map('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
    utils.map('n','[q',':cnext<CR>')
    utils.map('n',']q',':cprev<CR>')
    utils.map('n',']g','<cmd>lua vim.lsp.diagnostic.goto_next({ enable_popup = true })<CR>')
    utils.map('n','[g','<cmd>lua vim.lsp.diagnostic.goto_prev({ enable_popup = true })<CR>')
    utils.map('n',']h',':ClangdSwitchSourceHeader<CR>')
end

vim.fn.sign_define("LspDiagnosticsSignError", {text = "", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", numhl = "LspDiagnosticsDefaultHint"})

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
 vim.lsp.diagnostic.on_publish_diagnostics, {
   -- Enable underline, use default values
   underline = true,
   -- Enable virtual text only on Warning or above, override spacing to 2
   virtual_text = {
     spacing = 2,
     severity_limit = "Warning",
   },
   signs = false,
 }
)

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
if (false) then
    local sumneko_root_path = "/Users/sammyalhashemi/Desktop/lua-language-server/"
    local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"
    require'lspconfig'.sumneko_lua.setup {
      cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
      on_attach=custom_attach,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = vim.split(package.path, ';'),
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
              [vim.fn.expand('$VIMRUNTIME/lua')] = true,
              [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            },
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    }
end

local servers = {'rls', 'clangd', 'tsserver', 'vimls', 'bashls', 'pylsp', 'hls', 'cmake'}
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, s in ipairs(servers) do
    if (s == "clangd") then
        if system_name == "Linux" then
            nvim_lsp[s].setup{
                on_attach=custom_attach,
                cmd = {"clangd", "--resource-dir=/opt/bb/lib/llvm-12.0/lib64/clang/12.0.1"},
                capabilities = capabilities,
            }
        else
            nvim_lsp[s].setup{on_attach=custom_attach, capabilities = capabilities,}
        end
    else
        nvim_lsp[s].setup{on_attach=custom_attach, capabilities = capabilities,}
    end
end

return {
    get_diagnostics = get_diagnostics,
}

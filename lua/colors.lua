local M = {}

M.ayu_dark, M.ayu_mirage = (function()
  local ayu_colors = {
    bg = {dark = '#0F1419', light = '#FAFAFA', mirage = '#212733'},
    comment = {dark = '#5C6773', light = '#ABB0B6', mirage = '#5C6773'},
    markup = {dark = '#F07178', light = '#F07178', mirage = '#F07178'},
    constant = {dark = '#FFEE99', light = '#A37ACC', mirage = '#D4BFFF'},
    operator = {dark = '#E7C547', light = '#E7C547', mirage = '#80D4FF'},
    tag = {dark = '#36A3D9', light = '#36A3D9', mirage = '#5CCFE6'},
    regexp = {dark = '#95E6CB', light = '#4CBF99', mirage = '#95E6CB'},
    string = {dark = '#B8CC52', light = '#86B300', mirage = '#BBE67E'},
    _function = {dark = '#FFB454', light = '#F29718', mirage = '#FFD57F'},
    special = {dark = '#E6B673', light = '#E6B673', mirage = '#FFC44C'},
    keyword = {dark = '#FF7733', light = '#FF7733', mirage = '#FFAE57'},
    error = {dark = '#FF3333', light = '#FF3333', mirage = '#FF3333'},
    accent = {dark = '#F29718', light = '#FF6A00', mirage = '#FFCC66'},
    panel = {dark = '#14191F', light = '#FFFFFF', mirage = '#272D38'},
    guide = {dark = '#2D3640', light = '#D9D8D7', mirage = '#3D4751'},
    line = {dark = '#151A1E', light = '#F3F3F3', mirage = '#242B38'},
    selection = {dark = '#253340', light = '#F0EEE4', mirage = '#343F4C'},
    fg = {dark = '#E6E1CF', light = '#5C6773', mirage = '#D9D7CE'},
    fg_idle = {dark = '#3E4B59', light = '#828C99', mirage = '#607080'},
  }

  local ayu_mappings = {
    bg = ayu_colors.selection,
    fg = ayu_colors.fg,
    normal = ayu_colors.string,
    insert = ayu_colors.tag,
    replace = ayu_colors.markup,
    visual = ayu_colors.special,
    command = ayu_colors.keyword,
    terminal = ayu_colors.regexp,
    lsp_active = ayu_colors.string,
    lsp_inactive = ayu_colors.fg_idle,
    illuminate = {dark = '#3E4B59', mirage = '#3E4B59'},
  }

  local ayu_dark, ayu_mirage = {}, {}
  for k, v in pairs(ayu_mappings) do
    ayu_dark[k] = v.dark
    ayu_mirage[k] = v.mirage
  end
  return ayu_dark, ayu_mirage
end)()

M.onedark = {
  bg = '#545862',
  fg = '#c8ccd4',
  normal = '#98c379',
  insert = '#61afef',
  replace = '#e06c75',
  visual = '#e5c07b',
  command = '#d19a66',
  terminal = '#56b6c2',
  lsp_active = '#98c379',
  lsp_inactive = '#e06c75',
  illuminate = {dark = '#3E4B59', mirage = '#3E4B59'},
}

-- local ayu_dark = {
--   bg = '#0F1419',
--   fg = '#E6E1CF',
--   normal = '#B8CC52',
--   insert = '#36A3D9',
--   replace = '#F07178',
--   visual = '#E6B673',
--   command = '#FF7733',
--   terminal = '#95E6CB',
-- }

-- local ayu_mirage = {
--   bg = '#0F1419',
--   fg = '#E6E1CF',
--   normal = '#B8CC52',
--   insert = '#36A3D9',
--   replace = '#F07178',
--   visual = '#E6B673',
--   command = '#FF7733',
--   terminal = '#95E6CB',
-- }

-- -- Gruvbox
-- local colors = {
--   dark0_hard = '#1d2021',
--   dark0 = '#282828',
--   dark0_soft = '#32302f',
--   dark1 = '#3c3836',
--   dark2 = '#504945',
--   dark3 = '#665c54',
--   dark4 = '#7c6f64',
--   dark4_256 = '#7c6f64',
--   gray_245 = '#928374',
--   gray_244 = '#928374',
--   light0_hard = '#f9f5d7',
--   light0 = '#fbf1c7',
--   light0_soft = '#f2e5bc',
--   light1 = '#ebdbb2',
--   light2 = '#d5c4a1',
--   light3 = '#bdae93',
--   light4 = '#a89984',
--   light4_256 = '#a89984',
--   bright_red = '#fb4934',
--   bright_green = '#b8bb26',
--   bright_yellow = '#fabd2f',
--   bright_blue = '#83a598',
--   bright_purple = '#d3869b',
--   bright_aqua = '#8ec07c',
--   bright_orange = '#fe8019',
--   neutral_red = '#cc241d',
--   neutral_green = '#98971a',
--   neutral_yellow = '#d79921',
--   neutral_blue = '#458588',
--   neutral_purple = '#b16286',
--   neutral_aqua = '#689d6a',
--   neutral_orange = '#d65d0e',
--   faded_red = '#9d0006',
--   faded_green = '#79740e',
--   faded_yellow = '#b57614',
--   faded_blue = '#076678',
--   faded_purple = '#8f3f71',
--   faded_aqua = '#427b58',
--   faded_orange = '#af3a03',
--   none = 'NONE',
-- }
-- colors.bg = vim.fn.synIDattr(vim.fn.hlID('StatusLine'), 'bg') -- Default background
-- colors.fg = colors.light0 -- Default foreground

function M.from_base16(name)
  local base64 = require('base16-colorscheme')
  local theme = base64.colorschemes[name]
  local base_indexes = {
    bg = 0x02,
    fg = 0x07,
    normal = 0x0B,
    insert = 0x0D,
    replace = 0x08,
    visual = 0x0A,
    command = 0x09,
    terminal = 0x0C,
    lsp_active = 0x0B,
    lsp_inactive = 0x08,
  }
  local colors = {}
  for key, index in pairs(base_indexes) do
    colors[key] = theme['base' .. string.format('%02X', index)]
  end
  return colors
end

function hex_to_rgb(hex)
  local hex_in_decimal = tonumber(string.sub(hex, 2), 16);
  local mask = 255;
  return {
    r = bit.band(bit.rshift(hex_in_decimal, 16), 255);
    g = bit.band(bit.rshift(hex_in_decimal, 8), 255);
    b = bit.band(hex_in_decimal, 255);
  }
end

M.hex_to_rgb = hex_to_rgb

function rgba_to_rgb(color_hex, background, alpha)
  -- Docs
  -- https://ciechanow.ski/alpha-compositing/
  local c = hex_to_rgb(color_hex);
  local bg = hex_to_rgb(background);
  local new_r = (1 - alpha) * bg.r + alpha * c.r;
  local new_g = (1 - alpha) * bg.g + alpha * c.g;
  local new_b = (1 - alpha) * bg.b + alpha * c.b;
  return string.format("#%02X%02X%02X", new_r, new_g, new_b);
end

M.rgba_to_rgb = rgba_to_rgb

function make_schema() 
  local colors = {
    none    = 'NONE';
    -- core colors
     orange = '#f79617';
     yellow = '#ffc24b';
     green  = '#84CE5C';
     cyan   = '#50EAFA';
     blue   = '#32b4ff';
     red    = '#ff3c41';
     teal   = '#23D4AC';
     purple = '#a884f3';

     gray0   = '#000111';
     gray1   = '#171831'; --base
     gray2   = '#31324B';
     gray3   = '#4A4B64';
     gray4   = '#64657E';
     gray5   = '#7D7E97';
     gray6   = '#9697B0';
     gray7   = '#B0B1CA';
     gray8   = '#CACBE4';
     gray9   = '#E3E4FD';
     gray10  = '#FCFDFF';

    --extended colors
    red1    = '#ff3b30';
    yellow1 = '#ffcc00';
    blue1   = '#5ac8fa';
  }

  colors.diag = {
    danger  = { fg = colors.red1;    bg = rgba_to_rgb(colors.red1, colors.gray1, 0.16) };
    warning = { fg = colors.yellow1; bg = rgba_to_rgb(colors.yellow1, colors.gray1, 0.16) };
    info    = { fg = colors.blue1;   bg = rgba_to_rgb(colors.blue1, colors.gray1, 0.16) };
    hint    = { fg = colors.blue1;   bg = rgba_to_rgb(colors.blue1, colors.gray1, 0.16) };
  };

  colors.bg            = colors.gray1;
  colors.bg_popup      = rgba_to_rgb(colors.purple, colors.bg, 0.2);
  colors.bg_popup_sel  = rgba_to_rgb(colors.purple, colors.bg_popup, 0.8);
  colors.bg_highlight  = rgba_to_rgb(colors.blue, colors.gray1, 0.3);
  colors.bg_visual     = rgba_to_rgb(colors.blue, colors.gray1, 0.4);
  colors.fg            = colors.gray9;
  colors.fg_disabled   = colors.gray4;
  colors.fg_invert     = colors.gray0;
  colors.fg_popup      = colors.gray9;

  return colors;
end

local schema = make_schema();

M.schema = schema

function M.highlight(group, color)
  local style = color.style and 'gui=' .. color.style or 'gui=NONE'
  local fg = color.fg and 'guifg=' .. color.fg or 'guifg=NONE'
  local bg = color.bg and 'guibg=' .. color.bg or 'guibg=NONE'
  local sp = color.sp and 'guisp=' .. color.sp or ''
  vim.api.nvim_command('highlight ' .. group .. ' ' .. style .. ' ' .. fg .. ' ' .. bg .. ' '.. sp)
end

function M.load_syntax()
  local syntax = {
    Normal                = { fg=schema.fg,       bg=schema.none };
    Terminal              = { fg=schema.fg,       bg=schema.none };
    SignColumn            = { fg=schema.fg,       bg=schema.none };
    FoldColumn            = { fg=schema.fg_disabled,    bg=schema.none };
    VertSplit             = { fg=schema.gray4,    bg=schema.none };
    Folded                = { fg=schema.gray3,     bg=schema.bg_highlight };
    EndOfBuffer           = { fg=schema.bg,       bg=schema.none};
    IncSearch             = { fg=schema.fg_invert,      bg=schema.orange  };
    Search                = {        bg=schema.bg_visual };
    Visual                = {        bg=schema.bg_visual};
    VisualNOS             = {        bg=schema.bg_visual};
    ColorColumn           = { fg=schema.none,     bg=schema.bg_highlight };
    Conceal               = { fg=schema.gray3,     bg=schema.none};
    Cursor                = { fg=schema.fg_invert,  bg=schema.gray7,        };
    lCursor               = { fg=schema.fg_invert,  bg=schema.gray7,        };
    CursorIM              = { fg=schema.fg_invert,  bg=schema.gray7,        };
    CursorColumn          = { fg=schema.none,     bg=schema.bg_highlight, style='underline' };
    CursorLine            = { fg=schema.none,     bg=schema.bg_highlight };
    LineNr                = { fg=schema.gray2,    bg=schema.none }; -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    CursorLineNr          = { fg=schema.orange,     bg=schema.none, style="bold" }; -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line. This is for current line.
    DiffAdd               = { fg=schema.fg_invert,    bg=schema.green };
    DiffChange            = { fg=schema.fg_invert,    bg=schema.yellow };
    DiffDelete            = { fg=schema.fg_invert,    bg=schema.red };
    DiffText              = { fg=schema.fg_invert,    bg=schema.fg };
    Directory             = { fg=schema.fg_disabled,      bg=schema.none};
    ErrorMsg              = { fg=schema.red,      bg=schema.none,         style='bold'};
    WarningMsg            = { fg=schema.yellow,   bg=schema.none,         style='bold'};
    ModeMsg               = { fg=schema.fg,       bg=schema.none,         style='bold'};
    MatchParen            = { fg=schema.orange,   bg=schema.none,         style='bold'};
    NonText               = { fg=schema.fg_disabled,      bg=schema.none };
    Whitespace            = { fg=schema.gray2,    bg=schema.none };
    SpecialKey            = { fg=schema.fg_disabled,      bg=schema.none };
    Pmenu                 = { fg=schema.fg_popup,       bg=schema.bg_popup };
    PmenuSel              = { fg=schema.fg_popup,       bg=schema.bg_popup_sel };-- Popup menu: selected item.
    PmenuSbar             = {                     bg=schema.bg_popup };-- Popup menu: scrollbar.
    PmenuThumb            = {                     bg=schema.bg_popup_sel };-- Popup menu: Thumb of the scrollbar.
    NormalFloat           = { fg=schema.fg,bg=schema.bg_popup };
    WildMenu              = { fg=schema.fg,       bg=schema.green };
    Question              = { fg=schema.yellow,   bg=schema.none };
    TabLineFill           = { fg=schema.none,     bg=schema.none };
    TabLineSel            = { fg=schema.blue,     bg=schema.none };
    StatusLine            = { fg=schema.fg,       bg=schema.none };-- status line of current window
    StatusLineNC          = { fg=schema.fg,       bg=schema.none };-- status lines of not-current windows
    SpellBad              = { fg=schema.red,      bg=schema.none,         style='undercurl'};
    SpellCap              = { fg=schema.blue,     bg=schema.none,         style='undercurl'};
    SpellLocal            = { fg=schema.cyan,     bg=schema.none,         style='undercurl'};
    SpellRare             = { fg=schema.purple,   bg=schema.none,         style='undercurl'};
    QuickFixLine          = { fg=schema.purple,   bg=schema.none,         style='bold' };
    Debug                 = { fg=schema.orange,   bg=schema.none };

    Boolean               = { fg=schema.orange,   bg=schema.none,         style='italic' };
    Number                = { fg=schema.purple,   bg=schema.none };
    Float                 = { fg=schema.purple,   bg=schema.none };
    PreProc               = { fg=schema.purple,   bg=schema.none };
    PreCondit             = { fg=schema.purple,   bg=schema.none };
    Include               = { fg=schema.purple,   bg=schema.none };
    Define                = { fg=schema.purple,   bg=schema.none };
    Conditional           = { fg=schema.purple,   bg=schema.none };
    Repeat                = { fg=schema.purple,   bg=schema.none };
    Keyword               = { fg=schema.red,      bg=schema.none };
    Typedef               = { fg=schema.red,      bg=schema.none };
    Exception             = { fg=schema.red,      bg=schema.none };
    Statement             = { fg=schema.red,      bg=schema.none };
    Error                 = { fg=schema.red,      bg=schema.none };
    StorageClass          = { fg=schema.orange,   bg=schema.none };
    Tag                   = { fg=schema.orange,   bg=schema.none };
    Label                 = { fg=schema.orange,   bg=schema.none };
    Structure             = { fg=schema.orange,   bg=schema.none };
    Operator              = { fg=schema.purple,   bg=schema.none };
    Title                 = { fg=schema.orange,   bg=schema.none,         style='bold'};
    Special               = { fg=schema.yellow,   bg=schema.none };
    SpecialChar           = { fg=schema.yellow,   bg=schema.none };
    Type                  = { fg=schema.teal,     bg=schema.none };
    Function              = { fg=schema.yellow,   bg=schema.none };
    String                = { fg=schema.green,    bg=schema.none };
    Character             = { fg=schema.green,    bg=schema.none };
    Constant              = { fg=schema.cyan,     bg=schema.none };
    Macro                 = { fg=schema.cyan,     bg=schema.none };
    Identifier            = { fg=schema.blue,     bg=schema.none };

    Comment               = { fg=schema.fg_disabled,    bg=schema.none,         style='italic'};
    SpecialComment        = { fg=schema.gray3,          bg=schema.none};
    Todo                  = { fg=schema.cyan,           bg=schema.none};
    Delimiter             = { fg=schema.fg,       bg=schema.none};
    Ignore                = { fg=schema.gray3,    bg=schema.none};
    Underlined            = { fg=schema.none,     bg=schema.none,         style='underline'};

    GitGutterAdd          = { fg=schema.green,    bg=schema.none};
    GitGutterChange       = { fg=schema.blue,     bg=schema.none};
    GitGutterDelete       = { fg=schema.red,      bg=schema.none};
    GitGutterChangeDelete = { fg=schema.purple,   bg=schema.none};

    NvimTreeFolderName    = { fg=schema.blue,     bg=schema.none};
    NvimTreeRootFolder    = { fg=schema.red,      bg=schema.none,         style='bold' };
    NvimTreeOpenedFolderName = { fg=schema.blue,     bg=schema.none,      style='bold' };

    TSParameter           = { fg=schema.fg,       bg=schema.none };

    -- LspReferenceRead      = { fg=schema.none,     bg=schema.bg_highlight, style='bold' };
    -- LspReferenceWrite     = { fg=schema.none,     bg=schema.bg_highlight, style='bold' };
    -- LspReferenceText      = { fg=schema.none,     bg=schema.bg_highlight, style='bold' };
    --
    -- LspDiagnosticsSignError               = { fg=schema.diag.danger.fg,   style='bold'};
    -- LspDiagnosticsSignWarning             = { fg=schema.diag.warning.fg,  style='bold'};
    -- LspDiagnosticsSignInformation         = { fg=schema.diag.info.fg,     style='bold'};
    -- LspDiagnosticsSignHint                = { fg=schema.diag.hint.fg,     style='bold'};
    --
    -- LspDiagnosticsVirtualTextError        = { fg=schema.diag.danger.fg,   bg=schema.diag.danger.bg,   style='bold'};
    -- LspDiagnosticsVirtualTextWarning      = { fg=schema.diag.warning.fg,  bg=schema.diag.warning.bg,  style='bold' };
    -- LspDiagnosticsVirtualTextInfomation   = { fg=schema.diag.info.fg,     bg=schema.diag.info.bg,     style='bold'};
    -- LspDiagnosticsVirtualTextHint         = { fg=schema.diag.hint.fg,     bg=schema.diag.hint.bg,     style='bold'};
    --
    -- LspDiagnosticsUnderlineError          = { fg=schema.diag.danger.fg,   bg=schema.diag.danger.bg,   style='undercurl,bold'};
    -- LspDiagnosticsUnderlineWarning        = { fg=schema.diag.warning.fg,  bg=schema.diag.warning.bg,  style='undercurl,bold'};
    -- LspDiagnosticsUnderlineInformation    = { fg=schema.diag.info.fg,     bg=schema.diag.info.bg,     style='undercurl,bold'};
    -- LspDiagnosticsUnderlineHint           = { fg=schema.diag.hint.fg,     bg=schema.diag.hint.bg,     style='undercurl,bold'};
    --
    -- LspDiagnosticsDefaultError          = { fg=schema.diag.danger.fg, };
    -- LspDiagnosticsDefaultWarning        = { fg=schema.diag.warning.fg,};
    -- LspDiagnosticsDefaultInformation    = { fg=schema.diag.info.fg,   };
    -- LspDiagnosticsDefaultHint           = { fg=schema.diag.hint.fg,   };

    CocErrorHighlight   = { fg=schema.diag.danger.fg,     bg=schema.diag.danger.bg,   style='undercurl,bold'};
    CocWarningHighlight = { fg=schema.diag.warning.fg,    bg=schema.diag.warning.bg,  style='undercurl,bold'};
    CocInfoHighlight    = { fg=schema.diag.info.fg,       bg=schema.diag.info.bg,     style='undercurl,bold'};
    CocHintHighlight    = { fg=schema.diag.hint.fg,       bg=schema.diag.hint.bg,     style='undercurl,bold'};

    CocHighlightRead      = { fg=schema.none,     bg=schema.bg_highlight, style='bold' };
    CocHighlightWrite     = { fg=schema.none,     bg=schema.bg_highlight, style='bold' };
    CocHighlightText      = { fg=schema.none,     bg=schema.bg_highlight, style='bold' };

    CocErrorSign      = { fg=schema.diag.danger.fg,   style='bold'};
    CocWarningSign    = { fg=schema.diag.warning.fg,  style='bold'};
    CocInfoSign       = { fg=schema.diag.info.fg,     style='bold'};
    CocHintSign       = { fg=schema.diag.hint.fg,     style='bold'};
  }
  return syntax
end

function M.setup()
  vim.api.nvim_command('hi clear')
  if vim.fn.exists('syntax_on') then
    vim.api.nvim_command('syntax reset')
  end
  vim.o.background = 'dark'
  vim.o.termguicolors = true

  local syntax = load_syntax()

  for group,colors in pairs(syntax) do
    highlight(group,colors)
  end
end

-- return {
--   hex_to_rgb = hex_to_rgb;
--   rgba_to_rgb = rgba_to_rgb;
--   schema = schema;
--   setup = setup;
-- }

return M

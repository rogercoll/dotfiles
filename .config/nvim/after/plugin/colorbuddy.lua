-- To get the current cursor identifier run :Inspect

require('colorbuddy').colorscheme 'mygruvbuddy'

local colorbuddy = require 'colorbuddy'
local Color = colorbuddy.Color
local Group = colorbuddy.Group
local c = colorbuddy.colors
local g = colorbuddy.groups
local s = colorbuddy.styles

Color.new('white', '#f2e5bc')
Color.new('red', '#cc6666')
Color.new('pink', '#fef601')
Color.new('green', '#99cc99')
Color.new('yellow', '#f0c674')
Color.new('blue', '#81a2be')
Color.new('aqua', '#8ec07c')
Color.new('cyan', '#8abeb7')
Color.new('purple', '#8e6fbd')
Color.new('violet', '#b294bb')
Color.new('orange', '#de935f')
Color.new('brown', '#a3685a')

Color.new('seagreen', '#698b69')
Color.new('turquoise', '#698b69')
Color.new('window', '#4d5057')
Color.new('comment', '#969896')

local background_string = '#111111'

Color.new('background', background_string)
Color.new('gray0', background_string)

-- UI
Group.new('Normal', c.superwhite, c.gray0)
Group.new('StatusLine', c.yellow, nil, nil)
Group.new('StatusLineNC', c.window, c.foreground, s.reverse)
Group.new('CursorLineNr', c.yellow, nil, nil)
Group.new('Folded', c.comment, c.background, nil)
Group.new('Comment', c.comment, nil, nil)

-- General
Group.new('@constant', c.orange, nil, s.none)
Group.new('@function', c.yellow, nil, s.none)
Group.new('@function.bracket', g.Normal, g.Normal)
Group.new('@keyword', c.violet, nil, s.none)
Group.new('@keyword.faded', g.nontext.fg:light(), nil, s.none)
Group.new('@property', c.blue)
Group.new('@variable', c.superwhite, nil)
Group.new('@variable.builtin', c.purple:light():light(), g.Normal)

-- LSP Highlighting
Group.new('@lsp.type.function', c.aqua, nil, nil)
Group.new('@lsp.type.variable', c.foreground, nil, nil)
Group.new('@lsp.type.struct', c.orange, nil, nil)
Group.new('@lsp.type.namespace', c.foreground, nil, nil)
Group.new('@lsp.type.enumMember', c.foreground, nil, nil)

-- Lua
Group.new('@function.call.lua', c.blue:dark(), nil, nil)

-- Rust
Group.new('@lsp.mod.constant.rust', c.red:dark(), nil, nil)
Group.new('@lsp.type.keyword.rust', c.pink:light(), nil, nil)
-- TRAITS
Group.new('@lsp.type.interface.rust', c.yellow, nil, nil)
Group.new('@lsp.mod.trait.rust', c.yellow, nil, nil)
-- Types
Group.new('@lsp.type.method.rust', c.orange, nil, nil)
Group.new('@lsp.type.enum.rust', c.orange, nil, nil)

-- Go
Group.new('@module.go', c.yellow, nil, nil)

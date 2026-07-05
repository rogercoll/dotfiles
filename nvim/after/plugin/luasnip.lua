-- See: https://www.youtube.com/watch?v=FmHhonPjvvA

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

-- RUST
ls.add_snippets("rust", {
  s("print", {
    t('println("{'),
    i(1),
    t('}")'),
  }),

  s("derive", fmt(
    [[
    #[derive({})]
    ]], {
      i(1)
    }
  ))

})

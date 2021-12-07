-- lua bar
local colors = {
  color1   = '#3B4252',
  color2   = '#0f1419',
  color3   = '#ffee99',
  color4   = '#e6e1cf',
  color5   = '#14191f',
  color13  = '#b8cc52',
  color10  = '#36a3d9',
  color8   = '#f07178',
  color9   = '#3e4b59',
}


local ltheme = {
  visual = {
    a = { fg = colors.color2, bg = colors.color3, gui = 'bold' },
    b = { fg = colors.color4, bg = colors.color1 },
  },
  replace = {
    a = { fg = colors.color4, bg = colors.color8, gui = 'bold' },
    b = { fg = colors.color4, bg = colors.color1 },
  },
  inactive = {
    c = { fg = colors.color4, bg = colors.color1 },
    a = { fg = colors.color4, bg = colors.color5, gui = 'bold' },
    b = { fg = colors.color4, bg = colors.color1 },
  },
  normal = {
    c = { fg = colors.color4, bg = colors.color1 },
    a = { fg = colors.color2, bg = colors.color10, gui = 'bold' },
    b = { fg = colors.color4, bg = colors.color1 },
  },
  insert = {
    a = { fg = colors.color2, bg = colors.color13, gui = 'bold' },
    b = { fg = colors.color4, bg = colors.color1 },
  },
}
require'lualine'.setup{
    options = { 
        theme = ltheme,
        always_divide_middle = true,
        component_separators = { left = '│', right = '│'},
    } 
}

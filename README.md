# Demo Plugin

demo repo for developing neovim plugin

---

## Neovim Structure

Buffer

Window

Tabpage

Augroup

Highlight Group


---

## Useful Neovim Tips

```neovim
:luafile ~/path/to/lua/file
:source
:runtime
```


```lua
--[[
vim.inspect
vim.regex
vim.api
vim.ui
vim.loop
vim.lsp
vim.treesitter
--]]

function _G.put(...)
  local obj = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(obj, vim.inspect(v))
  end
  print(table.concat(obj, "\n")
  return ...
end

vim.api.nvim_command("new") -- vim.cmd()
vim.api.nvim_replace_termcodes()
vim.api.nvim_set_option()
vim.api.nvim_get_option()
vim.api.nvim_buf_set_option()
vim.api.nvim_buf_get_option()
vim.api.nvim_win_set_option()
vim.api.nvim_win_get_option()

-- vim.fn
-- vim.keymap.set()
-- vim.keymap.del()

vim.api.nvim_create_user_command()
vim.api.nvim_del_user_command()
vim.api.nvim_buf_create_user_command()
vim.api.nvim_buf_del_user_command()
```

---

### API

Floating windows                                                 *api-floatwin*

Floating windows ("floats") are displayed on top of normal windows.  This is
useful to implement simple widgets, such as tooltips displayed next to the
cursor. Floats are fully functional windows supporting user editing, common
|api-window| calls, and most window options (except 'statusline').

Two ways to create a floating window:
- |nvim_open_win()| creates a new window (needs a buffer, see |nvim_create_buf()|)
- |nvim_win_set_config()| reconfigures a normal window into a float

To close it use |nvim_win_close()| or a command such as |:close|.

To check whether a window is floating, check whether the `relative` option in
its config is non-empty: >lua

    if vim.api.nvim_win_get_config(window_id).relative ~= '' then
      -- window with this window_id is floating
    end
<

Buffer text can be highlighted by typical mechanisms (syntax highlighting,
|api-highlights|). The |hl-NormalFloat| group highlights normal text;
'winhighlight' can be used as usual to override groups locally. Floats inherit
options from the current window; specify `style=minimal` in |nvim_open_win()|
to disable various visual features such as the 'number' column.

Other highlight groups specific to floating windows:
- |hl-FloatBorder| for window's border
- |hl-FloatTitle| for window's title

Currently, floating windows don't support some widgets like scrollbar.

The output of |:mksession| does not include commands for restoring floating
windows.

Example: create a float with scratch buffer: >vim

    let buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(buf, 0, -1, v:true, ["test", "text"])
    let opts = {'relative': 'cursor', 'width': 10, 'height': 2, 'col': 0,
        \ 'row': 1, 'anchor': 'NW', 'style': 'minimal'}
    let win = nvim_open_win(buf, 0, opts)
    " optional: change highlight, otherwise Pmenu is used
    call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')

---

tbl_deep_extend({behavior}, {...})                     *vim.tbl_deep_extend()*
    Merges recursively two or more map-like tables.

    Parameters: ~
      • {behavior}  (string) Decides what to do if a key is found in more than
                    one map:
                    • "error": raise an error
                    • "keep": use value from the leftmost map
                    • "force": use value from the rightmost map
      • {...}       (table) Two or more map-like tables

    Return: ~
        (table) Merged table

    See also: ~
      • |vim.tbl_extend()|

---

nvim_open_win({buffer}, {enter}, {*config})                  *nvim_open_win()*
  Open a new window.

    Currently this is used to open floating and external windows. Floats are
    windows that are drawn above the split layout, at some anchor position in
    some other window. Floats can be drawn internally or by external GUI with
    the |ui-multigrid| extension. External windows are only supported with
    multigrid GUIs, and are displayed as separate top-level windows.

    For a general overview of floats, see |api-floatwin|.

    Exactly one of `external` and `relative` must be specified. The `width`
    and `height` of the new window must be specified.

    With relative=editor (row=0,col=0) refers to the top-left corner of the
    screen-grid and (row=Lines-1,col=Columns-1) refers to the bottom-right
    corner. Fractional values are allowed, but the builtin implementation
    (used by non-multigrid UIs) will always round down to nearest integer.

    Out-of-bounds values, and configurations that make the float not fit
    inside the main editor, are allowed. The builtin implementation truncates
    values so floats are fully within the main screen grid. External GUIs
    could let floats hover outside of the main window like a tooltip, but this
    should not be used to specify arbitrary WM screen positions.

Example (Lua): window-relative float
```lua
vim.api.nvim_open_win(0, false,
  {relative='win', row=3, col=3, width=12, height=3})
```

Example (Lua): buffer-relative float (travels as buffer is scrolled)
```lua
vim.api.nvim_open_win(0, false,
  {relative='win', width=12, height=3, bufpos={100,10}})
```

    Attributes: ~
        not allowed when |textlock| is active

    Parameters: ~
      • {buffer}  Buffer to display, or 0 for current buffer
      • {enter}   Enter the window (make it the current window)
      • {config}  Map defining the window configuration. Keys:
                  • relative: Sets the window layout to "floating", placed at
                    (row,col) coordinates relative to:
                    • "editor" The global editor grid
                    • "win" Window given by the `win` field, or current
                      window.
                    • "cursor" Cursor position in current window.
                    • "mouse" Mouse position

                  • win: |window-ID| for relative="win".
                  • anchor: Decides which corner of the float to place at
                    (row,col):
                    • "NW" northwest (default)
                    • "NE" northeast
                    • "SW" southwest
                    • "SE" southeast

                  • width: Window width (in character cells). Minimum of 1.
                  • height: Window height (in character cells). Minimum of 1.
                  • bufpos: Places float relative to buffer text (only when
                    relative="win"). Takes a tuple of zero-indexed [line,
                    column]. `row` and `col` if given are applied relative to this position, else they
                    default to:
                    • `row=1` and `col=0` if `anchor` is "NW" or "NE"
                    • `row=0` and `col=0` if `anchor` is "SW" or "SE" (thus
                      like a tooltip near the buffer text).

                  • row: Row position in units of "screen cell height", may be
                    fractional.
                  • col: Column position in units of "screen cell width", may
                    be fractional.
                  • focusable: Enable focus by user actions (wincmds, mouse
                    events). Defaults to true. Non-focusable windows can be
                    entered by |nvim_set_current_win()|.
                  • external: GUI should display the window as an external
                    top-level window. Currently accepts no other positioning
                    configuration together with this.
                  • zindex: Stacking order. floats with higher `zindex` go on top on floats with lower indices. Must be larger
                    than zero. The following screen elements have hard-coded
                    z-indices:
                    • 100: insert completion popupmenu
                    • 200: message scrollback
                    • 250: cmdline completion popupmenu (when
                      wildoptions+=pum) The default value for floats are 50.
                      In general, values below 100 are recommended, unless
                      there is a good reason to overshadow builtin elements.

                  • style: Configure the appearance of the window. Currently
                    only takes one non-empty value:
                    • "minimal" Nvim will display the window with many UI
                      options disabled. This is useful when displaying a
                      temporary float where the text should not be edited.
                      Disables 'number', 'relativenumber', 'cursorline',
                      'cursorcolumn', 'foldcolumn', 'spell' and 'list'
                      options. 'signcolumn' is changed to `auto` and
                      'colorcolumn' is cleared. 'statuscolumn' is changed to
                      empty. The end-of-buffer region is hidden by setting
                      `eob` flag of 'fillchars' to a space char, and clearing
                      the |hl-EndOfBuffer| region in 'winhighlight'.
                  • border: Style of (optional) window border. This can either
                    be a string or an array. The string values are
                    • "none": No border (default).
                    • "single": A single line box.
                    • "double": A double line box.
                    • "rounded": Like "single", but with rounded corners ("╭"
                      etc.).
                    • "solid": Adds padding by a single whitespace cell.
                    • "shadow": A drop shadow effect by blending with the
                      background.
                    • If it is an array, it should have a length of eight or
                      any divisor of eight. The array will specifify the eight
                      chars building up the border in a clockwise fashion
                      starting with the top-left corner. As an example, the
                      double box style could be specified as [ "╔", "═" ,"╗",
                      "║", "╝", "═", "╚", "║" ]. If the number of chars are
                      less than eight, they will be repeated. Thus an ASCII
                      border could be specified as [ "/", "-", "\\", "|" ], or
                      all chars the same as [ "x" ]. An empty string can be
                      used to turn off a specific border, for instance, [ "",
                      "", "", ">", "", "", "", "<" ] will only make vertical
                      borders but not horizontal ones. By default,
                      `FloatBorder` highlight is used, which links to
                      `WinSeparator` when not defined. It could also be
                      specified by character: [ ["+", "MyCorner"], ["x",
                      "MyBorder"] ].

                  • title: Title (optional) in window border, String or list.
                    List is [text, highlight] tuples. if is string the default
                    highlight group is `FloatTitle`.
                  • title_pos: Title position must set with title option.
                    value can be of `left` `center` `right` default is left.
                  • noautocmd: If true then no buffer-related autocommand
                    events such as |BufEnter|, |BufLeave| or |BufWinEnter| may
                    fire from calling this function.

    Return: ~
        Window handle, or 0 on error

---

nvim_create_buf({listed}, {scratch})                       *nvim_create_buf()*
    Creates a new, empty, unnamed buffer.

    Parameters: ~
      • {listed}   Sets 'buflisted'
      • {scratch}  Creates a "throwaway" |scratch-buffer| for temporary work
                   (always 'nomodified'). Also sets 'nomodeline' on the
                   buffer.

    Return: ~
        Buffer handle, or 0 on error

    See also: ~
      • buf_open_scratch

---





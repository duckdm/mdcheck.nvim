A simple plugin to toggle checked states for checkboxes in markdown files.

# Installation

Example with lazy (and example config):
```lua
return {
  'duckdm/mdcheck.nvim',
  dev = true,
  opts = {
    --- Default opts
    --- Checkbox states
    states = {
        unchecked = "%[ %]",
        in_progress = "%[~%]",
        checked = "%[x%]"
    },
    --- If toggle should set checked instead of in progress from an unchecked state
    toggle_checked_directly = false,
  },
  config = function(_, opts)
    local mdcheck = require('mdcheck')
    mdcheck.setup(opts)

    vim.keymap.set("n", "<leader>h", function()
      if mdcheck.has_checkbox() then
        mdcheck.toggle()
      else
        mdcheck.create()
      end
    end, { desc = "Check markdown" })
  end
}
```

# Available commands

| Command | Description |
| --- | --- |
| `MdCheckToggle` | Toggle the checkbox under the cursor |
| `MdCheckCheck` | Check the checkbox under the cursor |
| `MdCheckInProgress` | Set the checkbox under the cursor to in progress |
| `MdCheckUncheck` | Set the checkbox under the cursor to unchecked |
| `MdCheckCreate` | Create a checkbox under the cursor |
| `MdCheckRemove` | Remove the checkbox under the cursor |

# Available methods

```lua
local mdcheck = require('mdcheck')

--- toggle the checkbox under the cursor
mdcheck.toggle()

--- check the checkbox under the cursor
mdcheck.check()

--- set the checkbox under the cursor to in progress
mdcheck.in_progress()

--- set the checkbox under the cursor to unchecked
mdcheck.uncheck()

--- create a checkbox under the cursor
mdcheck.create()

--- remove the checkbox under the cursor
mdcheck.remove()

--- check if the line under the cursor has a checkbox
mdcheck.has_checkbox()

```

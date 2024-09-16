---@class MdCheck
---@field config table
---@field states table
---@field new fun(self: MdCheck, setup_config: table): MdCheck
---@field has_checkbox fun(self: MdCheck): integer|nil
---@field toggle fun(self: MdCheck): MdCheck
---@field check fun(self: MdCheck): MdCheck
---@field in_progress fun(self: MdCheck): MdCheck
---@field uncheck fun(self: MdCheck): MdCheck
---@field create fun(self: MdCheck): MdCheck
---@field remove fun(self: MdCheck): MdCheck
---@field create_user_commands fun(self: MdCheck): MdCheck
local MdCheck = {}

--- Constructor
---@param setup_config table
---@return MdCheck
function MdCheck:new(setup_config)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    local config = setup_config or {}
    o.config = vim.tbl_deep_extend("force", {
        --- Checkbox states
        states = {
            unchecked = "%[ %]",
            in_progress = "%[~%]",
            checked = "%[x%]"
        },
        --- If toggle should set checked instead of in progress from an unchecked state
        toggle_checked_directly = false,
    }, config)
    o.states = o.config.states

    return o
end

--- Toggle checkbox status
---@return MdCheck
function MdCheck:toggle()

    local cl = vim.api.nvim_get_current_line()

    for _, state in pairs(self.states) do
        if cl:find(state) then
            if state == self.states.unchecked then
                if self.config.toggle_checked_directly then
                    self:check()
                else
                    self:in_progress()
                end
            elseif state == self.states.in_progress then
                self:check()
            elseif state == self.states.checked then
                self:uncheck()
            end
        end
    end

    return self
end

--- Check if line has checkbox
---@return boolean
function MdCheck:has_checkbox()
    local cl = vim.api.nvim_get_current_line()
    return cl:find(self.states.unchecked) or cl:find(self.states.in_progress) or cl:find(self.states.checked)
end

--- Set checkbox state
---@param state string
---@return MdCheck
function MdCheck:set(state)

    local cl = vim.api.nvim_get_current_line()
    local content = cl

    if cl:find(self.states.unchecked) then
        content = cl:gsub(self.states.unchecked, state)
    elseif cl:find(self.states.in_progress) then
        content = cl:gsub(self.states.in_progress, state)
    elseif cl:find(self.states.checked) then
        content = cl:gsub(self.states.checked, state)
    end
    vim.api.nvim_set_current_line(content)

    return self
end

--- Mark checkbox as checked
---@return MdCheck
function MdCheck:check() self:set(self.states.checked) return self end

--- Mark checkbox as in progress
---@return MdCheck
function MdCheck:in_progress() self:set(self.states.in_progress) return self end

--- Uncheck checkbox
---@return MdCheck
function MdCheck:uncheck() self:set(self.states.unchecked) return self end

--- Create checkbox
---@return MdCheck
function MdCheck:create()
    local cl = vim.api.nvim_get_current_line()
    local content = cl:gsub("- ", "- [ ] ")
    vim.api.nvim_set_current_line(content)

    return self
end

--- Remove checkbox
---@return MdCheck
function MdCheck:remove()
    local cl = vim.api.nvim_get_current_line()
    local content = cl:gsub("%- %[%s*.-%s*%]", "-")
    vim.api.nvim_set_current_line(content)

    return self
end

--- Create user commands
---@return MdCheck
function MdCheck:create_user_commands()

    vim.api.nvim_create_user_command('MdCheckToggle', function() self:toggle() end, {})
    vim.api.nvim_create_user_command('MdCheckCheck', function() self:check() end, {})
    vim.api.nvim_create_user_command('MdCheckInProgress', function() self:in_progress() end, {})
    vim.api.nvim_create_user_command('MdCheckUncheck', function() self:uncheck() end, {})
    vim.api.nvim_create_user_command('MdCheckCreate', function() self:create() end, {})
    vim.api.nvim_create_user_command('MdCheckRemove', function() self:remove() end, {})

    return self
end

-- Module
local M = {}
local mdcheck = nil

M.setup = function(opts)

    local config = opts or {}
    mdcheck = MdCheck:new(config)
    mdcheck:create_user_commands()

end

M.toggle = function() return mdcheck:toggle() end
M.check = function() return mdcheck:check() end
M.in_progress = function() return mdcheck:in_progress() end
M.uncheck = function() return mdcheck:uncheck() end
M.create = function() return mdcheck:create() end
M.remove = function() return mdcheck:remove() end
M.has_checkbox = function() return mdcheck:has_checkbox() end

return M

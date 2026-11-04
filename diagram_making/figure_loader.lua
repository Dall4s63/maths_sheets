local M = {}

local generic_write = function(self)
    if simple_rectangle.template == nil then
        simple_rectangle.template = io.open(path.."template.tex"):read("a")
    end

    local out = simple_rectangle.template:gsub("%%([%w_]+)_(%w)%%", function(key,format)
        -- print(self[key])
        -- print(key)
        return string.format("%"..format, self[key]) end)
    return out
end

M.setup = function(script_func, path)
    local fig_base = {}
    fig_base.helps = {}
    fig_base.defaults = {}
    fig_base.mt = {}
end

return M

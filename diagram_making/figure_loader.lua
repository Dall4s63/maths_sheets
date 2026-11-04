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
    fig_base.mt.__index = function(table,key)
        return fig_base.defaults[key]
    end
    fig_base.write = function (obj)
        if fig_base.template == nil then
            fig_base.template = io.open(path.."template.tex"):read("a")
        end

        local out = fig_base.template:gsub("%%([%w_]+)_(%w)%%", function(key,format)
            -- print(self[key])
            -- print(key)
            return string.format("%"..format, self[key]) end)
        return out
    end
    fig_base.new = function()
        local out = {}
        setmetatable(out, fig_base.mt)
        out.write = fig_base.write
        return out
    end
end

return M

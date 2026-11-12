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
    fig_base.types = {}
    fig_base.mt = {
        parent = fig_base,
    }
    fig_base.mt.__index = function(table,key)
        if fig_base.index_preproc ~= nil then
            local v = fig_base.index_preproc(table,key)
            if v ~= nil then return v end
        end
        return fig_base.defaults[key]
    end
    fig_base.write = function (obj)
        if fig_base.template == nil then
            fig_base.template = io.open(path.."template.tex"):read("a")
        end

        if fig_base.write_preproc ~= nil then
            fig_base.write_preproc(obj)
        end

        -- Secion processing: maybe just boolean

        local out = fig_base.template:gsub("%%%[([%w_]+)%s*(.*)%]%%", function(key, text)
            if obj[key] then
                return text
            end
            return ""
        end)

        out = out:gsub("%%([%w_]+)_(%w)%%", function(key,format)
            -- print(self[key])
            -- print(key)
            return string.format("%"..format, obj[key]) end)
        return out
    end
    fig_base.new = function()
        local out = { }
        setmetatable(out, fig_base.mt)
        out.write = fig_base.write
        return out
    end
    fig_base.param = function(name, help, t, default)
        fig_base.helps[name] = help
        fig_base.types[name] = t
        fig_base.defaults[name] = default
    end
    script_func(path, fig_base)
    fig_base.param = nil
    return fig_base
end

return M

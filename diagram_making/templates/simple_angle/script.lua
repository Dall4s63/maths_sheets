local path = ...

-- print(io.open(path.."template.tex"):read("a"))

local simple_angle = {
    mt = {},
    default_angle = 110,
}

local write = function(self)
    if simple_angle.template == nil then
        simple_angle.template = io.open(path.."template.tex"):read("a")
    end

    local out = simple_angle.template:gsub("%%([%w_]+)_(%w)%%", function(key,format)
        -- print(self[key])
        -- print(key)
        return string.format("%"..format, self[key]) end)
    return out
end

simple_angle.mt.__index = function (table, key)
    if key == "half_angle" then
        return table.angle / 2
    end
    local d = simple_angle[string.format("default_%s",key)]
    return d;
end

function simple_angle.new()
    local out = {}
    setmetatable(out, simple_angle.mt)
    out.write = write
    return out
end

return simple_angle

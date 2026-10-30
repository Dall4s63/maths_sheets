local path = ...

-- print(io.open(path.."template.tex"):read("a"))

local simple_angle = {
    mt = {},
    main_help = "A single angle diagram with a given magnitude.",
    defaults = {
        angle = 110,
        label = "\\theta",
    },
    helps = {
        angle = "The angle on the diagram.",
        label = "Label placed in the angle.",
        value_label = "If this is true, then the value of the angle will be used as the label.",
    },
}

local write = function(self)
    if simple_angle.template == nil then
        simple_angle.template = io.open(path.."template.tex"):read("a")
    end

    if self.value_label then
        self.label = tostring(math.floor(self.angle + 0.5)).."\\degree"
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
    local d = simple_angle.defaults[key]
    return d;
end

function simple_angle.new()
    local out = {}
    setmetatable(out, simple_angle.mt)
    out.write = write
    return out
end

return simple_angle

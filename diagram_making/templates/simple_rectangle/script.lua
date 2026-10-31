local path = ...

local simple_rectangle = {
    mt = {},
    main_help = "A rectangle diagram.",
    defaults = {
        length = 4,
        width = 3,
        left_label = "",
        top_label = "",
        right_label = "",
        bottom_label = "",
    },
    helps = {
        length = "Length of the rectangle horizontaly.",
        width = "Width of the rectangle vertically.",
        left_label = "Label on the left side of the rectangle.",
        top_label = "Label on the top side of the rectangle.",
        right_label = "Label on the right side of the rectangle.",
        bottom_label = "Label on the bottom side of the rectangle.",
    },
}

local write = function(self)
    if simple_rectangle.template == nil then
        simple_rectangle.template = io.open(path.."template.tex"):read("a")
    end

    local out = simple_rectangle.template:gsub("%%([%w_]+)_(%w)%%", function(key,format)
        -- print(self[key])
        -- print(key)
        return string.format("%"..format, self[key]) end)
    return out
end

simple_rectangle.mt.__index = function (table, key)
    local d = simple_rectangle.defaults[key]
    return d;
end

function simple_rectangle.new()
    local out = {}
    setmetatable(out, simple_rectangle.mt)
    out.write = write
    return out
end

return simple_rectangle

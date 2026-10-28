local simple_angle = {
    mt = {},
    default_angle = 110,
}

simple_angle.mt.__index = function (table, key)
    local d = simple_angle[string.format("default_%s",key)]
    return d;
end

function simple_angle.new()
    local out = {}
    setmetatable(out, simple_angle.mt)
    return out
end

return simple_angle

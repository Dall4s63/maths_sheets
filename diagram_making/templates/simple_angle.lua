simple_angle = {
    mt = {
        __index = function (table, key)
            local d = base_shapes["angle"][string.format("default_%s",key)]
            return d;
        end
    },
    default_angle = 110,
}

return simple_angle.default_angle

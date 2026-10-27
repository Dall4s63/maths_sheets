
--[[
Table Plan:
First table is 
    diagram_name -> diagram_base_table
The input is checked as a diagram name. (maybe we can parse options in 
the first command.

This puts us into a scoped mode where the use can input 
values for options.

When in the scoped mode, you have a table that represents 
the options that have been set. The __index function of 
the meta table links to the base table for the chosen diagram 
containing defaults and help information.
--]]

base_shapes = {
    angle = {
        mt = {
            __index = function (table, key)
                local d = base_shapes["angle"][string.format("default_%s",key)]
                return d;
            end
        },
        default_angle = 110,
    },
}

print(base_shapes["angle"].default_angle)

angle_test = {}
setmetatable(angle_test, base_shapes["angle"].mt)

str = io.read()

if str == "angle" then
    print(angle_test.angle)
end

print(str)


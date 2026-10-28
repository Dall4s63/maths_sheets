
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

base_shapes = {}

base_shapes.simple_angle = loadfile("templates/simple_angle/script.lua")("templates/simple_angle/")

angle_test = base_shapes.simple_angle.new()

print(angle_test:write())

str = io.read()

if base_shapes[str] ~= nil then
    print(base_shapes[str])
end

print(str)


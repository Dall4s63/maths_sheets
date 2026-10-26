
--[[
Table Plan:
First table is 
    diagram_name -> diagram_base_table
The input is checked as a diagram name. (maybe we can parse options in 
the first command.

This puts us into a scoped mode where the use can input 
values for options.
--]]

if str == "angle" then
    print("hello")
end

print(str)

str = io.read()

if str == "angle" then
    print("hello")
end

print(str)


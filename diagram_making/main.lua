
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

Simple command language:
 - quit/exit/q -> exit the application.
 - create -> start working on a new shape.
 - help -> provide context based help, in base mode it provides a list 
 of options, maybe there could be a search function. In scoped mode
 it provides the help menu for the current shape.
 - set -> used for setting values in the scoped mode.
 - write -> write the current object.
--]]

base_shapes = {}

base_shapes.simple_angle = loadfile("templates/simple_angle/script.lua")("templates/simple_angle/")

-- angle_test = base_shapes.simple_angle.new()
-- 
-- print(angle_test:write())

cur_scope_str = "> "
cur_scope_obj = nil

while true do
    io.write(cur_scope_str)
    str = io.read()
    if str == nil then
        break
    end

    local command = {}
    for w in str:gmatch("[%w._]+") do
        table.insert(command, w)
    end

    if command[1] == "exit" or command[1] == "q" or command[1] == "quit" then
        -- TODO maybe have an unsaved changes warning?
        break
    end
    
    if cur_scope_obj == nil then
        if command[1] == "create" and base_shapes[command[2]] ~= nil then
            print(base_shapes[command[2]])
            cur_scope_obj = base_shapes[command[2]].new()
            cur_scope_str = string.format("%s> ", command[2])
        end
    else
        if command[1] == "set" and command[2] ~= nil and command[3] ~= nil then
            cur_scope_obj[command[2]] = command[3]
            print("set "..command[2])
        elseif command[1] == "write" then
            local document_template = io.open("document_template.tex","r")
            local figure_template = io.open("figure_template.tex","r")
            local out = io.open("out/a.out","w")
            local dt = document_template:read("a")
            local ft = figure_template:read("a")
            print(cur_scope_obj:write())
            local t = string.format(ft, cur_scope_obj:write())
            t = dt:format(t)
            out:write(t)
            out:close()
            figure_template:close()
            document_template:close()
        end
    end
end


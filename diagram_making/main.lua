
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

New Idea: Context dependent commands.

General (always available):
 - quit/exit/q
 - focus name/home: change focus context.
 - back: to up one focus level.
 - help [figs/options]: gives context command help or list of figures. 
 - create fig/doc [type(fig only)] [name]: creates a new figure/document.
 - write pdf/svg [name]: writes the current scope/provided object.
                         might fail in home scope without provided name.
 - list: lists the available documents/figures.

Document Scope:
 - list: list the figures in the document.

Figure Scope:
 - set option value: set an option on the current figure.

--]]

docs = require("docs")
fig_loader = require("figure_loader")
lfs = require("lfs")

commands_help = {
    ["quit/exit/q"] = "Exit the application",
    ["list"] = "List the available documents or figures based on context.",
    ["back"] = "Return focus back a step.",
    ["create doc/fig"] = "Create a new document/figure.",
    ["set parameter value"] = "(Figure focus only) Set parameter for currently focused figure.",
    ["help figs"] = "List available base figures.",
    ["help"] = "(Figure focus) list available parameters.",
}

local pdf_export = function(name, state)
    local document_template = io.open("document_template.tex","r")
    local figure_template = io.open("figure_template.tex","r")
    local dt = document_template:read("a")
    local ft = figure_template:read("a")
    figure_template:close()
    document_template:close()
    local content = "%s"
    for p, v in pairs(state.docs[name].figs) do
        print(v)
        local s = v:write()
        print(s)
        local t = ft:format(s).."\n%s"
        content = content:format(t)
    end
    content = content:format("")
    local out = io.open("out/"..name..".tex","w")
    out:write(dt:format(content))
    out:close()
    local dir = lfs.currentdir()
    -- print(dir)
    lfs.chdir(dir.."/out")
    os.execute("xelatex "..name..".tex")
    lfs.chdir(dir)
end

local svg_export = function(name, state)
    local document_template = io.open("document_template.tex","r")
    local dt = document_template:read("a")
    document_template:close()
    local dir = lfs.currentdir()
    -- print(dir)
    
    for fig_n, fig in pairs(state.docs[name].figs) do
        local filename = name.."_"..fig_n
        local out = io.open("out/"..filename..".tex","w")

        local content = dt:format(fig:write())
        out:write(content)

        out:close()
        lfs.chdir(dir.."/out")
        os.execute("lualatex --output-format=dvi "..filename..".tex")
        os.execute("dvisvgm "..filename..".dvi")
        lfs.chdir(dir)
    end

end

general_commands = {
    quit = function (cmd, state)
        return true
    end,
    q = function (cmd, state)
        return true
    end,
    exit = function (cmd, state)
        return true
    end,

    list = function (cmd, state)
        if state.focus.doc ~= nil then
            print("Available figures:")
            for s, _ in pairs(state.focus.doc.figs) do
                print("\t"..s)
            end
        else
            print("Available documents:")
            for s, _ in pairs(state.docs) do
                print("\t"..s)
            end
        end
    end,

    back = function (cmd, state)
        if state.focus.fig ~= nil then
            state.focus.fig = nil
            state.focus.fig_name = nil
        elseif state.focus.doc ~= nil then
            state.focus.doc = nil
            state.focus.doc_name = nil
        end
    end,

    create = function (cmd, state)
        if cmd[2] == "doc" then
            local name = cmd[3]
            if cmd[3] == nil then
                name = "new_document"
            end
            local base_name = name
            local counter = 2
            while state.docs[name] ~= nil do
                name = base_name..counter
                counter = counter + 1
            end
            state.docs[name] = docs.new()
            print("Created new document \""..name.."\"")
            state.focus.doc = state.docs[name]
            state.focus.doc_name = name
            return
        end

        if cmd[2] == "fig" then
            if state.focus.doc == nil then
                print("Focus a document before creating a figure.")
                return
            end
            if cmd[3] == nil then
                print("Choose a figure type: create fig type [name]")
                return
            end

            if state.base_figures[cmd[3]] == nil then
                print("Unknown figure type \""..cmd[3].."\"")
                return
            end

            local doc = state.focus.doc
            local name = cmd[4]
            if cmd[4] == nil then
                name = "new_figure"
            end
            local base_name = name
            local counter = 2
            while doc.figs[name] ~= nil do
                name = base_name..counter
                counter = counter + 1
            end
            doc.figs[name] = state.base_figures[cmd[3]].new()
            state.focus.fig = doc.figs[name]
            state.focus.fig_name = name
            return
        end
        print("Expected command format: create doc/(fig type) [name]")
        return
    end,

    help = function (cmd, state)
        if cmd[2] == "figs" then
            for k, v in pairs(state.base_figures) do
                print(k)
                print("\t"..v.main_help)
                print("")
            end
            return
        end
        for k, v in pairs(commands_help) do
            print(k)
            print("\t"..v)
            print("")
        end
    end,

    export = function (cmd, state)
        if cmd[2] == nil then
            print("Expected format: export document_name [svg]")
            return
        end
        if state.docs[cmd[2]] == nil then
            print("No document named: \""..cmd[2].."\"")
            return
        end
        if cmd[3] ~= "svg" and cmd[3] ~= "pdf" then
            print("Supported formats are \"svg\" and \"pdf\".")
            return
        end
        if cmd[3] == "svg" then
            svg_export(cmd[2], state)
            return
        end
        pdf_export(cmd[2], state)
    end,
}

figure_commands = {
    set = function (cmd, state)
        if cmd[2] == nil or cmd[3] == nil then
            print("Usage: set parameter_name value")
            return
        end
        local fig_base = getmetatable(state.focus.fig).parent
        if fig_base.helps[cmd[2]] == nil then
            print("Figure has no parameter \""..cmd[2].."\"")
            return
        end
        local param_type = fig_base.types[cmd[2]]
        if param_type == nil then
            state.focus.fig[cmd[2]] = cmd[3]
            -- TODO remove?
            print("Warning no type for this parameter")
            print("Set \""..cmd[2].."\" to \""..cmd[3].."\"")
            return
        end
        if param_type == "number" then
            local num = tonumber(cmd[3])
            if num == nil then
                print("Parameter \""..cmd[2].."\" expects a number.")
                return
            end
            state.focus.fig[cmd[2]] = num
        end
        if param_type == "boolean" then
            local v = cmd[3]:tolower()
            if v == "false" then
                state.focus.fig[cmd[2]] = false
                return
            end
            if v == "true" then
                state.focus.fig[cmd[2]] = false
                return
            end
            print("Parameter \""..cmd[2].."\" expects true or false.")
            return
        end
        state.focus.fig[cmd[2]] = cmd[3]
        print("Set \""..cmd[2].."\" to \""..cmd[3].."\"")
    end,
    help = function (cmd, state)
        local fig_mt = getmetatable(state.focus.fig)
        for k, v in pairs(fig_mt.parent.helps) do
            print(k)
            print("\t"..v)
            print("")
        end
    end,
}

function command_parse(str)
    local cmd = {}
    while (str:len() > 0) do
        local ai, aj, avalue = str:find("\"(.*)\"")
        local bi, bj, bvalue = str:find("(%g+)")

        if bi == nil then
            return cmd
        end

        if ai == nil then
            table.insert(cmd, bvalue)
            str = str:sub(bj+1)
            goto continue
        end

        if ai <= bi then
            table.insert(cmd, avalue)
            str = str:sub(aj+1)
        else
            table.insert(cmd, bvalue)
            str = str:sub(bj+1)
        end
        ::continue::
    end
    return cmd
end

function handle_command(state)
    -- io.write(state.focus.str)
    if state.focus.doc_name ~= nil then
        io.write(state.focus.doc_name)
    end
    if state.focus.fig_name ~= nil then
        io.write("/")
        io.write(state.focus.fig_name)
    end
    io.write("> ")
    local str = io.read()
    if str == nil then 
        return true
    end
    local cmd = command_parse(str)
    local func
    if state.focus.fig ~= nil then
        func = figure_commands[cmd[1]]
    end
    if func == nil then
        func = general_commands[cmd[1]]
    end
    if func == nil then
        -- TODO error handling
        return
    end
    return func(cmd, state)
end

state = {
    base_figures = {},
    docs = {},
    focus = {
        doc = nil,
        fig = nil,
    }
}

for s in lfs.dir("templates") do
    if s == "." or s == ".." then
        goto continue
    end
    local p = "templates/"..s.."/"
    print(p.."script.lua")
    local func = loadfile(p.."script.lua")
    state.base_figures[s] = fig_loader.setup(func, p)
    ::continue::
end

while not handle_command(state) do
    io.write("\n")
end

--             for k, v in pairs(base_shapes) do
--                 print(k)
--                 print("\t"..v.main_help.."\n")
--             end
--         end
--     else
--         if command[1] == "set" and command[2] ~= nil and command[3] ~= nil then
--             cur_scope_obj[command[2]] = command[3]
--             print("set "..command[2])
--         elseif command[1] == "write" then
--             local document_template = io.open("document_template.tex","r")
--             local figure_template = io.open("figure_template.tex","r")
--             local out = io.open("out/a.out","w")
--             local dt = document_template:read("a")
--             local ft = figure_template:read("a")
--             print(cur_scope_obj:write())
--             local t = string.format(ft, cur_scope_obj:write())
--             t = dt:format(t)
--             out:write(t)
--             out:close()
--             figure_template:close()
--             document_template:close()
--         elseif command[1] == "help" then
--             for k, v in pairs(cur_scope.helps) do
--                 print(k)
--                 print("\t"..v)
--                 print("")
--             end
--         end
--     end
-- end


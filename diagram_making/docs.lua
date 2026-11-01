-- A document is just a collection of shapes that can be edited

local M = {}

local Document = {
    write = function (self)
        local document_template = io.open("document_template.tex","r")
        local figure_template = io.open("figure_template.tex","r")
        local out = io.open("out/a.out","w")
        local dt = document_template:read("a")
        local ft = figure_template:read("a")
        local t = "%s"
        for _, shape in self.shapes do 
            print(cur_scope_obj:write())
            local fig = ft:format(shape:write()).."%s\n"
            t = t:format(t, fig)
        end
        t = t:format("")
        t = dt:format(t)
        out:write(t)
        out:close()
        figure_template:close()
        document_template:close()
    end,
}

M.mt = {
    __index = Document,
}

M.new = function ()
    local d = {
        shapes = {},
    }
    setmetatable(d,M.mt)
    return d
end

return M

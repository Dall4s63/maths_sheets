template = io.open("template.tex","r")
out = io.open("a.out","w")

template_string = template:read("a")

template_string = template_string:gsub("##1",140)
template_string = template_string:gsub("##2",140/2)

out:write(template_string)

out:close()
template:close()


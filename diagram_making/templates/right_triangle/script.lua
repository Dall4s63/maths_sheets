-- Right angle triangle
local path, base = ...

local labels = {
    "a_label",
    "b_label",
    "c_label",
}

for _, l in ipairs(labels) do
    base.section(l, function (self)
        return self[l] ~= nil
    end)
end

base.main_help = "A simple right angled triangle."
base.param("a","The length of the base side (a).", "number", 4)
base.param("b","The length of the height side (b).", "number", 3)
base.param("a_label", "The label of the a side.", "string")
base.param("b_label", "The label of the b side.", "string")
base.param("c_label", "The label of the c side.", "string")


local path, base = ...

base.main_help = "A single angle diagram with a given magnitude."
base.param("angle","The angle on the diagram.", "number", 110)
base.param("label","Label placed in the angle.", "string", "\\theta")
base.param("value_label","If this is true, then the value of the angle will be used as the label.", "boolean")
base.param("num_arcs","Number of arc lines, up to 3", "number", 1)

base.write_preproc = function (self)
    if self.value_label then
        self.label = tostring(math.floor(self.angle + 0.5)).."\\degree"
    end
    self.arc_1 = false
    self.arc_2 = false
    self.arc_3 = false
    if self.num_arcs >= 1 then
        self.arc_1 = true
    end
    if self.num_arcs >= 2 then
        self.arc_2 = true
    end
    if self.num_arcs >= 3 then
        self.arc_3 = true
    end
end

base.index_preproc = function (table, key)
    if key == "half_angle" then
        return table.angle / 2
    end
end


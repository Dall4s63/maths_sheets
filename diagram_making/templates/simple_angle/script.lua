local path, base = ...

base.main_help = "A single angle diagram with a given magnitude.",
base.param("angle","The angle on the diagram.", 110)
base.param("label","Label placed in the angle.", "\\theta")
base.param("value_label","If this is true, then the value of the angle will be used as the label.")

base.write_preproc = function (self)
    if self.value_label then
        self.label = tostring(math.floor(self.angle + 0.5)).."\\degree"
    end
end

base.index_preproc = function (table, key)
    if key == "half_angle" then
        return table.angle / 2
    end
end


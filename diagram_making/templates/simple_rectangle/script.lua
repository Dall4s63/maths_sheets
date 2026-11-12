local path, base = ...

base.main_help = "A rectangle diagram."

base.param("length", "Length of the rectangle horizontaly.", "number", 4)
base.param("width", "Width of the rectangle vertically.", "number", 3)
base.param("left_label", "Label on the left side of the rectangle.", "string")
base.param("top_label", "Label on the top side of the rectangle.", "string")
base.param("right_label", "Label on the right side of the rectangle.", "string")
base.param("bottom_label", "Label on the bottom side of the rectangle.", "string")


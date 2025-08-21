dofile("Thèmes/polygon-theme/common.lua")

CellType = {
    UNKNOWN = "0",
    MULTI = "1",
}

Settings = {}

Settings.laptop_mode = false
Settings.wheel_offset = 1.5
Settings.cell_offset = -1.0
Settings.width = 975.0
Settings.height = 575.0
Settings.thickness = 20.0
Settings.cell_spacing = 4.0
Settings.ring_spacing = 4.0
Settings.text_spacing = 4.0
Settings.cell_radius = 0.0
Settings.font_name = "Cantarell"
Settings.font_size = 16.0
Settings.interline = 1.8

Settings.cell = {
    [1] = {
        ["type"] = CellType.MULTI,
        ["x"] = 0.0,
        ["y"] = 0.0,
        ["angle_1"] = 0.0,
        ["n"] = 4,
        ["openning"] = {
            [1] = 0.8,
            [2] = 0.6,
            [3] = 0.4,
            [4] = 1.0,
        },
        ["angle_2"] = 0.0,
        ["h_align"] = 0.0,
        ["v_align"] = 0.5,
        ["invert"] = false,
        ["color"] = {
            [1] = Common.color.to_rgb01(171, 71, 188, 1.0),
            [2] = Common.color.to_rgb01(171, 71, 188, 1.0),
            [3] = Common.color.to_rgb01(171, 71, 188, 0.8),
            [4] = Common.color.to_rgb01(171, 71, 188, 0.6),
            [5] = Common.color.to_rgb01(171, 71, 188, 0.0),
        }
    },
    [2] = {
        ["type"] = CellType.MULTI,
        ["x"] = 0.0,
        ["y"] = 0.0,
        ["angle_1"] = 0.0,
        ["n"] = 3,
        ["openning"] = {
            [1] = 0.8,
            [2] = 0.6,
            [3] = 1.0,
        },
        ["angle_2"] = 0.0,
        ["h_align"] = 0.0,
        ["v_align"] = 0.5,
        ["invert"] = false,
        ["color"] = {
            [1] = Common.color.to_rgb01(171, 71, 188, 1.0),
            [2] = Common.color.to_rgb01(171, 71, 188, 1.0),
            [3] = Common.color.to_rgb01(171, 71, 188, 0.8),
            [4] = Common.color.to_rgb01(171, 71, 188, 0.0),
        }
    },
    [3] = {
        ["type"] = CellType.MULTI,
        ["x"] = 0.0,
        ["y"] = 0.0,
        ["angle_1"] = 0.0,
        ["n"] = 3,
        ["openning"] = {
            [1] = 0.8,
            [2] = 0.6,
            [3] = 1.0,
        },
        ["angle_2"] = 0.0,
        ["h_align"] = 0.0,
        ["v_align"] = 0.5,
        ["invert"] = true,
        ["color"] = {
            [1] = Common.color.to_rgb01(171, 71, 188, 1.0),
            [2] = Common.color.to_rgb01(171, 71, 188, 1.0),
            [3] = Common.color.to_rgb01(171, 71, 188, 0.8),
            [4] = Common.color.to_rgb01(171, 71, 188, 0.0),
        }
    },
    [4] = {
        ["type"] = CellType.MULTI,
        ["x"] = 0.0,
        ["y"] = 0.0,
        ["angle_1"] = 0.0,
        ["n"] = 3,
        ["openning"] = {
            [1] = 0.8,
            [2] = 0.6,
            [3] = 1.0,
        },
        ["angle_2"] = math.pi,
        ["h_align"] = 1.0,
        ["v_align"] = 0.5,
        ["invert"] = false,
        ["color"] = {
            [1] = Common.color.to_rgb01(171, 71, 188, 1.0),
            [2] = Common.color.to_rgb01(171, 71, 188, 1.0),
            [3] = Common.color.to_rgb01(171, 71, 188, 0.8),
            [4] = Common.color.to_rgb01(171, 71, 188, 0.0),
        }
    },
    [5] = {
        ["type"] = CellType.MULTI,
        ["x"] = 0.0,
        ["y"] = 0.0,
        ["angle_1"] = 0.0,
        ["n"] = 3,
        ["openning"] = {
            [1] = 0.8,
            [2] = 0.6,
            [3] = 1.0,
        },
        ["angle_2"] = math.pi,
        ["h_align"] = 1.0,
        ["v_align"] = 0.5,
        ["invert"] = true,
        ["color"] = {
            [1] = Common.color.to_rgb01(171, 71, 188, 1.0),
            [2] = Common.color.to_rgb01(171, 71, 188, 1.0),
            [3] = Common.color.to_rgb01(171, 71, 188, 0.8),
            [4] = Common.color.to_rgb01(171, 71, 188, 0.0),
        }
    },
    [6] = {
        ["type"] = CellType.MULTI,
        ["x"] = 0.0,
        ["y"] = 0.0,
        ["angle_1"] = 0.0,
        ["n"] = 2,
        ["openning"] = {
            [1] = 0.8,
        },
        ["angle_2"] = 0.0,
        ["h_align"] = 0.0,
        ["v_align"] = 0.5,
        ["invert"] = false,
        ["color"] = {
            [1] = Common.color.to_rgb01(171, 71, 188, 1.0),
            [2] = Common.color.to_rgb01(171, 71, 188, 1.0),
            [3] = Common.color.to_rgb01(171, 71, 188, 0.0),
        }
    }
}
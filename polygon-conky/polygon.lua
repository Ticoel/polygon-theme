require("cairo")
require("imlib2")

local laptop_mode = false
local wheel_offset = 1.5
local cell_offset = -1.0
local wheel_radius = 300.0
local thickness = 20.0
local cell_spacing = 4.0
local ring_spacing = 4.0
local text_spacing = 4.0
local cell_radius = 0.0
local font_name = "Cantarell"
local font_size = 16.0
local interline = 1.25
local raw_infos = ""

local color = {
    r = 0.0,
    g = 0.0,
    b = 0.0,
    a = 1.0,
}

function color.new(r, g, b, a)
    local self = setmetatable({}, color)
    self.r = r
    self.g = g
    self.b = b
    self.a = a
    return self
end

function color.toRGB01(r, g, b, a)
    local self = setmetatable({}, color)
    self.r = r / 255.0
    self.g = g / 255.0
    self.b = b / 255.0
    self.a = a
    return self
end

local coords = {
    [1] = {
        [1] = 0.0,
        [2] = 0.0,
        [3] = 0.0,
        [4] = 4,
        [5] = {
            [1] = 0.8,
            [2] = 0.6,
            [3] = 0.4,
            [4] = 1.0,
        },
        [6] = 0.0,
        [7] = 0.0,
        [8] = 0.5,
        [9] = false,
        [10] = {
            [1] = color.toRGB01(0, 107, 255, 1.0),
            [2] = color.toRGB01(0, 107, 255, 1.0),
            [3] = color.toRGB01(0, 107, 255, 0.8),
            [4] = color.toRGB01(0, 107, 255, 0.6),
            [5] = color.toRGB01(0, 107, 255, 0.0),
        }
    },
    [2] = {
        [1] = 0.0,
        [2] = 0.0,
        [3] = 0.0,
        [4] = 3,
        [5] = {
            [1] = 0.8,
            [2] = 0.6,
            [3] = 1.0,
        },
        [6] = 0.0,
        [7] = 0.0,
        [8] = 0.5,
        [9] = false,
        [10] = {
            [1] = color.toRGB01(148, 0, 255, 1.0),
            [2] = color.toRGB01(148, 0, 255, 1.0),
            [3] = color.toRGB01(148, 0, 255, 0.8),
            [4] = color.toRGB01(148, 0, 255, 0.0),
        }
    },
    [3] = {
        [1] = 0.0,
        [2] = 0.0,
        [3] = 0.0,
        [4] = 3,
        [5] = {
            [1] = 0.8,
            [2] = 0.6,
            [3] = 1.0,
        },
        [6] = 0.0,
        [7] = 0.0,
        [8] = 0.5,
        [9] = true,
        [10] = {
            [1] = color.toRGB01(255, 0, 235, 1.0),
            [2] = color.toRGB01(255, 0, 235, 1.0),
            [3] = color.toRGB01(255, 0, 235, 0.8),
            [4] = color.toRGB01(255, 0, 235, 0.0),
        }
    },
    [4] = {
        [1] = 0.0,
        [2] = 0.0,
        [3] = 0.0,
        [4] = 3,
        [5] = {
            [1] = 0.8,
            [2] = 0.6,
            [3] = 1.0,
        },
        [6] = math.pi,
        [7] = 1.0,
        [8] = 0.5,
        [9] = false,
        [10] = {
            [1] = color.toRGB01(255, 0, 107, 1.0),
            [2] = color.toRGB01(255, 0, 107, 1.0),
            [3] = color.toRGB01(255, 0, 107, 0.8),
            [4] = color.toRGB01(255, 0, 107, 0.0),
        }
    },
    [5] = {
        [1] = 0.0,
        [2] = 0.0,
        [3] = 0.0,
        [4] = 3,
        [5] = {
            [1] = 0.8,
            [2] = 0.6,
            [3] = 1.0,
        },
        [6] = math.pi,
        [7] = 1.0,
        [8] = 0.5,
        [9] = true,
        [10] = {
            [1] = color.toRGB01(255, 20, 0, 1.0),
            [2] = color.toRGB01(255, 20, 0, 1.0),
            [3] = color.toRGB01(255, 20, 0, 0.8),
            [4] = color.toRGB01(255, 20, 0, 0.0),
        }
    },

    [6] = {
        [1] = 0.0,
        [2] = 0.0,
        [3] = 0.0,
        [4] = 1,
        [5] = {
            [1] = 1.0,
        },
        [6] = 0.0,
        [7] = 0.0,
        [8] = 0.5,
        [9] = false,
        [10] = {
            [1] = color.new(0.0, 0.0, 0.0, 1.0),
            [2] = color.new(1.0, 1.0, 1.0, 1.0),
        }
    },
}

local infos = {
    [1] =
    {
        [1] = {
            [1] = "",
            [2] = "",
            [3] = "",
            [4] = "",
            [5] = "",
            [6] = "",
        },
        [2] = {
            [1] = "",
            [2] = "",
            [3] = "",
            [4] = "",
            [5] = "",
            [6] = "",
        },
        [3] = {
            [1] = string.upper("Memory"),
            [2] = "",
            [3] = "",
            [4] = "",
            [5] = "",
            [6] = "",
        },
        [4] = {
            [1] = string.upper("Storage"),
            [2] = "",
            [3] = "",
            [4] = "",
            [5] = "",
            [6] = "",
        },
        [5] = {
            [1] = string.upper("Network"),
            [2] = "",
            [3] = "",
            [4] = "",
            [5] = "",
        },
        [6] = {
            [1] = string.upper("Power"),
        },
    },
    [2] = {
        [1] = {
            [1] = 0.0,
            [2] = 0.0,
            [3] = 0.0,
        },
        [2] = {
            [1] = 0.0,
            [2] = 0.0,
        },
        [3] = {
            [1] = 0.0,
            [2] = 0.0,
        },
        [4] = {
            [1] = 0.0,
            [2] = 0.0,
        },
        [5] = {
            [1] = 0.0,
            [2] = 0.0,
        },
    },
    [3] = {
        [1] = {
            [1] = "",
            [2] = "",
            [3] = "",
        },
        [2] = {
            [1] = "",
            [2] = "",
        },
        [3] = {
            [1] = "",
            [2] = "",
        },
        [4] = {
            [1] = "",
            [2] = "",
        },
        [5] = {
            [1] = "",
            [2] = "",
        },
    },
}

function get_raw_value(parameter)
    return string.gsub(conky_parse(string.format("${%s}", parameter)), "^%s*(.-)%s*$", "%1")
end

function write_multi(x, y, angle, texts, font_name, font_size, color, font_slant, font_face, h_align, v_align, interline,
                     h_pos, v_pos)
    local extents = cairo_text_extents_t:create()
    tolua.takeownership(extents)

    cairo_select_font_face(cr, font_name, font_slant, font_face);
    cairo_set_font_size(cr, font_size)

    local widths = {}
    local max_width = 0.0
    local max_height = 0.0

    for i = 1, #texts do
        cairo_text_extents(cr, texts[i], extents)

        max_width = math.max(math.abs(extents.x_advance), max_width)
        max_height = math.max(math.abs(extents.height), max_height)

        widths[i] = math.abs(extents.x_advance)
    end

    local xx = 0.0
    local yy = 0.0

    cairo_save(cr)

    cairo_translate(cr, x, y)
    cairo_rotate(cr, angle)

    for i = 1, #texts do
        xx = (max_width - widths[i]) * h_align - max_width * h_pos
        yy = max_height * interline * (i - 1) - max_height * interline * (#texts - 1.0) * v_pos + max_height * v_align

        cairo_translate(cr, xx, 0.0)
        cairo_translate(cr, 0.0, yy)
        cairo_move_to(cr, 0.0, 0.0)

        cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a)
        cairo_show_text(cr, texts[i])

        cairo_translate(cr, -xx, -yy)
    end

    cairo_restore(cr)
end

function write_line(x, y, angle, text, font_name, font_size, color, font_slant, font_face, h_align, v_align)
    local extents = cairo_text_extents_t:create()
    tolua.takeownership(extents)

    cairo_select_font_face(cr, font_name, font_slant, font_face);
    cairo_set_font_size(cr, font_size)
    cairo_text_extents(cr, text, extents)

    xx = extents.width * h_align
    yy = extents.height * v_align

    cairo_save(cr)
    cairo_translate(cr, x, y)
    cairo_rotate(cr, angle)
    cairo_translate(cr, -xx, yy)
    cairo_move_to(cr, 0, 0)

    cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a)
    cairo_show_text(cr, text)
    cairo_restore(cr)
end

function draw_arc(x, y, orientation, openning, ext_radius, blackground_thickness, foreground_thickness, color,
                  ratio, reverse)
    local radius = ext_radius - foreground_thickness / 2.0
    local start_angle = 0.0
    local end_angle_1 = 0.0
    local end_angle_2 = 0.0

    if reverse then
        start_angle = orientation - math.pi * openning / 2.0
        end_angle_1 = start_angle - math.pi * (2.0 - openning) * 1.0
        end_angle_2 = start_angle - math.pi * (2.0 - openning) * ratio
    else
        start_angle = orientation + math.pi * openning / 2.0
        end_angle_1 = start_angle + math.pi * (2.0 - openning) * 1.0
        end_angle_2 = start_angle + math.pi * (2.0 - openning) * ratio
    end

    cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
    cairo_set_line_width(cr, blackground_thickness)
    cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a)

    cairo_new_path(cr)

    if reverse then
        cairo_arc_negative(cr, x, y, radius, start_angle, end_angle_1)
    else
        cairo_arc(cr, x, y, radius, start_angle, end_angle_1)
    end

    cairo_set_operator(cr, CAIRO_OPERATOR_SOURCE)
    cairo_stroke(cr)

    cairo_set_line_width(cr, foreground_thickness)

    if reverse then
        cairo_arc_negative(cr, x, y, radius, start_angle, end_angle_2)
    else
        cairo_arc(cr, x, y, radius, start_angle, end_angle_2)
    end
end

function draw_circle(x, y, radius, color)
    cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a)

    cairo_move_to(cr, x, y)

    cairo_new_path(cr, x, y)
    cairo_arc(cr, x, y, radius, 0, math.pi * 2.0)
end

function start()
    cairo_translate(cr, conky_window.width * 0.5, conky_window.height * 0.5)

    local n = #coords
    if not laptop_mode then n = n - 1 end

    cell_radius = wheel_radius * math.sin(math.pi / n) - cell_spacing

    for i = 1, n do
        coords[i][3] = math.pi * wheel_offset + math.pi * 2.0 * (1.0 / n) * math.fmod(i + cell_offset, n)
        coords[i][1] = wheel_radius * math.cos(coords[i][3])
        coords[i][2] = wheel_radius * math.sin(coords[i][3])
    end

    infos[1][1][2] = string.upper(get_raw_value("sysname"))
    infos[1][1][3] = get_raw_value("kernel")
    infos[1][1][4] = get_raw_value("nodename")
    infos[1][1][5] = get_raw_value("uptime")
    infos[1][1][6] = "Processes - " .. get_raw_value("processes")
    infos[1][1][7] = "In Running - " .. get_raw_value("running_processes")

    infos[1][2][1] = string.upper("Processor") .. " (" .. get_raw_value("freq_g cpu0") .. "GHz)"
    infos[1][2][2] = get_raw_value("top name 1") .. " - " .. get_raw_value("top cpu 1") .. "%"
    infos[1][2][3] = get_raw_value("top name 2") .. " - " .. get_raw_value("top cpu 2") .. "%"
    infos[1][2][4] = get_raw_value("top name 3") .. " - " .. get_raw_value("top cpu 3") .. "%"
    infos[1][2][5] = get_raw_value("top name 4") .. " - " .. get_raw_value("top cpu 4") .. "%"
    infos[1][2][6] = get_raw_value("top name 5") .. " - " .. get_raw_value("top cpu 5") .. "%"

    infos[1][3][2] = get_raw_value("top_mem name 1") .. " - " .. get_raw_value("top_mem mem 1") .. "%"
    infos[1][3][3] = get_raw_value("top_mem name 2") .. " - " .. get_raw_value("top_mem mem 2") .. "%"
    infos[1][3][4] = get_raw_value("top_mem name 3") .. " - " .. get_raw_value("top_mem mem 3") .. "%"
    infos[1][3][5] = get_raw_value("top_mem name 4") .. " - " .. get_raw_value("top_mem mem 4") .. "%"
    infos[1][3][6] = get_raw_value("top_mem name 5") .. " - " .. get_raw_value("top_mem mem 5") .. "%"

    infos[1][4][2] = get_raw_value("top_io name 1") .. " - " .. get_raw_value("top_io io_perc 1") .. "%"
    infos[1][4][3] = get_raw_value("top_io name 2") .. " - " .. get_raw_value("top_io io_perc 2") .. "%"
    infos[1][4][4] = get_raw_value("top_io name 3") .. " - " .. get_raw_value("top_io io_perc 3") .. "%"
    infos[1][4][5] = get_raw_value("top_io name 4") .. " - " .. get_raw_value("top_io io_perc 4") .. "%"
    infos[1][4][6] = get_raw_value("top_io name 5") .. " - " .. get_raw_value("top_io io_perc 5") .. "%"

    infos[1][5][2] = "Interface - " .. get_raw_value("gw_iface")
    infos[1][5][3] = "IP local - " .. get_raw_value("addr ${gw_iface}")
    infos[1][5][4] = "Up - " .. get_raw_value("totalup ${gw_iface}")
    infos[1][5][5] = "Down - " .. get_raw_value("totaldown ${gw_iface}")

    raw_infos = get_raw_value("time %H")
    infos[2][1][1] = tonumber(raw_infos) / 23.0
    raw_infos = get_raw_value("time %M")
    infos[2][1][2] = tonumber(raw_infos) / 59.0
    raw_infos = get_raw_value("time %S")
    infos[2][1][3] = tonumber(raw_infos) / 59.0

    raw_infos = get_raw_value("cpu cpu0")
    infos[2][2][1] = tonumber(raw_infos) / 100.0
    raw_infos = get_raw_value("acpitemp")
    infos[2][2][2] = tonumber(raw_infos) / 90.0

    raw_infos = get_raw_value("memperc")
    infos[2][3][1] = tonumber(raw_infos) / 100
    raw_infos = get_raw_value("swapperc")
    infos[2][3][2] = tonumber(raw_infos) / 100

    raw_infos = get_raw_value("fs_used_perc /")
    infos[2][4][1] = tonumber(raw_infos) / 100
    raw_infos = get_raw_value("fs_used_perc /home")
    infos[2][4][2] = tonumber(raw_infos) / 100

    raw_infos = get_raw_value("upspeedf ${gw_iface}")
    infos[2][5][1] = tonumber(raw_infos) / 2048
    raw_infos = get_raw_value("downspeedf ${gw_iface}")
    infos[2][5][2] = tonumber(raw_infos) / 2048

    infos[3][1][1] = "Hours"
    infos[3][1][2] = "Minutes"
    infos[3][1][3] = "Seconds"

    infos[3][2][1] = "Usage - " .. get_raw_value("cpu cpu0") .. "%"
    infos[3][2][2] = "Temp. - " .. get_raw_value("acpitemp") .. "°C"

    infos[3][3][1] = "RAM - " .. get_raw_value("mem")
    infos[3][3][2] = "SWAP - " .. get_raw_value("swap")

    infos[3][4][1] = "Root - " .. get_raw_value("fs_used /")
    infos[3][4][2] = "Home - " .. get_raw_value("fs_used /home")

    infos[3][5][1] = "Up - " .. get_raw_value("upspeed ${gw_iface}")
    infos[3][5][2] = "Down - " .. get_raw_value("downspeed ${gw_iface}")

    for i = 1, n do
        cairo_push_group(cr)

        draw_circle(coords[i][1],
            coords[i][2],
            cell_radius - (thickness + ring_spacing) * (coords[i][4] - 1),
            coords[i][10][coords[i][4] + 1])

        cairo_fill_preserve(cr)

        write_multi(coords[i][1],
            coords[i][2],
            0,
            infos[1][i],
            font_name,
            font_size,
            coords[i][10][1],
            CAIRO_FONT_SLANT_NORMAL,
            CAIRO_FONT_WEIGHT_BOLD,
            0.5,
            0.5,
            interline,
            0.5,
            0.5)

        cairo_pop_group_to_source(cr);

        cairo_fill(cr)

        for j = 1, coords[i][4] do
            if j == coords[i][4] then break end
            draw_arc(coords[i][1],
                coords[i][2],
                coords[i][3],
                coords[i][5][j],
                cell_radius - (thickness + ring_spacing) * (j - 1),
                thickness / 3.0,
                thickness,
                coords[i][10][j + 1],
                infos[2][i][j],
                coords[i][9])

            cairo_stroke(cr)

            local offset = (coords[i][5][j] / 2)
            local a = 0.0
            if coords[i][9] then
                a = coords[i][3] - math.pi * offset
            else
                a = coords[i][3] + math.pi * offset
            end

            local distance = cell_radius - (thickness + ring_spacing) * (j - 1) + text_spacing

            write_line(coords[i][1] + math.cos(a) * distance,
                coords[i][2] + math.sin(a) * distance,
                a + coords[i][6],
                infos[3][i][j],
                font_name,
                font_size,
                coords[i][10][1],
                CAIRO_FONT_SLANT_NORMAL,
                CAIRO_FONT_WEIGHT_BOLD,
                coords[i][7],
                coords[i][8])

            cairo_fill(cr)
        end
    end
end

function conky_main()
    if conky_window == nil then
        return
    end

    local cs = cairo_xlib_surface_create(conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height)
    cr = cairo_create(cs)

    start()

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr = nil
end

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
local text_align = 0.5
local interline = 1.5
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

local function sum(numbers, starti, endi)
    local value = 0.0

    if starti == nil then
        starti = 1
    end

    if starti > #numbers then
        starti = #numbers
    end

    if endi == nil or endi > #numbers then
        endi = #numbers
    end

    if starti > endi then
        return 0.0
    end

    if starti == endi then
        return numbers[starti]
    end

    for i = starti, endi do
        value = value + numbers[i]
    end

    return value
end

function write_text(x, y, max_width, text, font_name, font_size, color, font_slant, font_face, align, interline)
    local words_text = {}
    local words_width = {}
    local max_height = 0.0

    local extents = cairo_text_extents_t:create()
    tolua.takeownership(extents)

    cairo_select_font_face(cr, font_name, font_slant, font_face);
    cairo_set_font_size(cr, font_size)

    for word in string.gmatch(text, "(%S+)") do
        cairo_text_extents(cr, word, extents)

        table.insert(words_text, word)
        table.insert(words_width, extents.x_advance)
        max_height = math.max(math.abs(extents.height), max_height)
    end

    local starti = 1
    local li = 1
    local y_offset = 0.0

    for i = 1, #words_width do
        local width = sum(words_width, starti, i)
        local next_width = 0.0

        if i < #words_width then
            next_width = sum(words_width, starti, i + 1)
        end

        if next_width > max_width * 1.0 or i == #words_width then
            local r = math.max(max_width - width, 0.0)

            local n = i - starti + 1

            local spacing = 0.0
            if n > 1 then
                spacing = r / (n - 1)
            end

            if i == #words_width then
                cairo_text_extents(cr, " ", extents)
                spacing = extents.x_advance
            end

            for j = starti, i do
                local z = (i - starti) - (i - j)
                local x_offset = sum(words_width, starti, j - 1) + spacing * z

                write_line(x + x_offset, y + y_offset, 0.0, words_text[j], font_name, font_size, color, font_slant,
                    font_face, 0.0, 0.0)
            end

            y_offset = max_height * 1.25 * li
            li = li + 1

            starti = i + 1
        end
    end

    return {
        [1] = y_offset - max_height * 1.25,
        [2] = y_offset,
    }
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

    -- cairo_set_source_rgba(cr, 1, 1, 1, 1)
    -- cairo_rectangle(cr, 0, 0, conky_window.width, conky_window.height)
    -- cairo_fill(cr)

    local output = get_raw_value("execi 120 dmesg -l err")

    local sp = 0.0

    for line in string.gmatch(output, "([^\n]*)\n?") do
        sp = sp + write_text(0, sp, 400,
            line,
            "Source Code Pro", 16, color.new(1, 0, 0, 1), CAIRO_FONT_SLANT_NORMAL,
            CAIRO_FONT_WEIGHT_BOLD, 0.0, 0.0)[2]
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

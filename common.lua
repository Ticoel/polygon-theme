require("cairo")
require("imlib2")

Common = {}

Common.color = {
    r = 0.0,
    g = 0.0,
    b = 0.0,
    a = 1.0,
}

Common.color.new = function(r, g, b, a)
    local self = setmetatable({}, Common.color)
    self.r = r
    self.g = g
    self.b = b
    self.a = a

    return self
end

Common.color.to_rgb01 = function(r, g, b, a)
    local self = setmetatable({}, Common.color)
    self.r = r / 255.0
    self.g = g / 255.0
    self.b = b / 255.0
    self.a = a

    return self
end

Common.color.white = function()
    local self = setmetatable({}, Common.color)
    self.r = 1.0
    self.g = 1.0
    self.b = 1.0
    self.a = 1.0

    return self
end

Common.dict_contains_key = function(dict, key)
    for k, _ in pairs(dict) do
        if k == key then
            return true
        end
    end

    return false
end

Common.get_raw_value = function(parameter)
    local raw_value = conky_parse(string.format("${%s}", parameter))

    -- retourne la valeur brut en supprimant les espaces blanc au début et à la fin
    return string.gsub(raw_value, "^%s*(.-)%s*$", "%1")
end

Common.write_multi = function(x,
                              y,
                              angle,
                              texts,
                              font_name,
                              font_size,
                              color,
                              font_slant,
                              font_face,
                              h_align,
                              v_align,
                              interline,
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
        max_height = math.max(math.abs(extents.y_bearing), max_height)

        widths[i] = math.abs(extents.x_advance)
    end

    local xx = 0.0
    local yy = 0.0

    cairo_save(cr)

    cairo_translate(cr, x, y)
    cairo_rotate(cr, angle)

    for i = 1, #texts do
        local x_offset_1 = (max_width - widths[i]) * h_align
        local x_offset_2 = max_width * h_pos
        xx = x_offset_1 - x_offset_2

        local y_offset_1 = max_height * v_align
        local y_offset_2 = max_height * interline * (#texts - 1.0) * v_pos
        yy = max_height * interline * (i - 1) - y_offset_2 + y_offset_1

        cairo_translate(cr, xx, 0.0)
        cairo_translate(cr, 0.0, yy)
        cairo_move_to(cr, 0.0, 0.0)

        cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a)
        cairo_show_text(cr, texts[i])

        cairo_translate(cr, -xx, -yy)
    end

    cairo_restore(cr)
end

Common.write_line = function(x,
                             y,
                             angle,
                             text,
                             font_name,
                             font_size,
                             color,
                             font_slant,
                             font_face,
                             h_align,
                             v_align)
    local extents = cairo_text_extents_t:create()
    tolua.takeownership(extents)

    cairo_select_font_face(cr, font_name, font_slant, font_face);
    cairo_set_font_size(cr, font_size)

    cairo_text_extents(cr, text, extents)

    local xx = extents.width * h_align
    local yy = extents.height * v_align

    cairo_save(cr)
    cairo_translate(cr, x, y)
    cairo_rotate(cr, angle)
    cairo_translate(cr, -xx, yy)
    cairo_move_to(cr, 0, 0)

    cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a)
    cairo_show_text(cr, text)
    cairo_restore(cr)

    return {
        ["width"] = extents.width,
        ["height"] = extents.height
    }
end

Common.length = function(x_1, y_1, x_2, y_2)
    return math.sqrt(((x_2 - x_1) ^ 2) + ((y_2 - y_1) ^ 2))
end

Common.compute_i = function(i, n, o)
    i = i % (n + o)
    if i == 0 then
        i = n + o
    end
    return i
end

Common.capsule = function(i, n, width, height)
    if n < 4 then
        print("n should be set to 4")
        return nil
    end

    if width <= height
    then
        print("width should be greater than height")
        return nil
    end

    local angle = 0
    local x = 0
    local y = 0
    local r = height * 0.5
    local dist_1 = width - r * 2

    local t_1 = 0
    local t_2 = 0
    local t_3 = 0
    local t_4 = 0

    local nn = math.floor(n / 4)
    local mod = (n % 4)

    local i_1 = 0
    local i_2 = Common.compute_i(i, nn, 0)
    local i_3 = 0
    local i_4 = Common.compute_i(i, nn, 0)

    local o_1 = 0
    local o_3 = 0

    local n_1 = nn
    local n_2 = nn
    local n_3 = nn
    local n_4 = nn

    if n % 4 == 0 then
        if nn == 1 then
            n_1 = nn + 1
            n_3 = nn + 1

            i_1 = Common.compute_i(i, nn, 0)
            i_3 = Common.compute_i(i, nn, 0)
        else
            n_1 = nn - 1
            n_3 = nn - 1

            i_1 = Common.compute_i(i, nn, 0) - 1
            i_3 = Common.compute_i(i, nn, 0) - 1
        end

        n_2 = nn + 1
        n_4 = nn + 1
    else
        if mod == 1 then
            if nn == 1 then
                i_3 = Common.compute_i(i, nn, 0)
                n_3 = nn + 1
            else
                i_3 = Common.compute_i(i, nn, 0) - 1
                n_3 = nn - 1
            end

            i_1 = Common.compute_i(i, nn, 1) - 1
            o_1 = 1
            n_2 = nn + 1
            n_4 = nn + 1
        elseif mod == 2 then
            i_1 = Common.compute_i(i, nn, 1) - 1
            i_3 = Common.compute_i(i, nn, 1) - 1
            o_1 = 1
            o_3 = 1
            n_2 = nn + 1
            n_3 = nn
            n_4 = nn + 1
        elseif mod == 3 then
            i_1 = Common.compute_i(i, nn, 1) - 1
            i_3 = Common.compute_i(i, nn, 2) - 1
            o_1 = 1
            o_3 = 2
            n_2 = nn + 1
            n_3 = nn + 1
            n_4 = nn + 1
        end
    end

    t_1 = (1 / n_1) * i_1
    t_2 = (1 / n_2) * i_2
    t_3 = (1 / n_3) * i_3
    t_4 = (1 / n_4) * i_4

    if i <= (nn + o_1) then
        x = -(dist_1 * 0.5) + (dist_1 * t_1)
        y = -r
    elseif i <= (nn + o_1) + nn then
        angle = math.pi * -0.5 + math.pi * t_2
        x = math.cos(angle) * r + (dist_1 * 0.5)
        y = math.sin(angle) * r
    elseif i <= (nn + o_1) + nn + (nn + o_3) then
        x = (dist_1 * 0.5) - (dist_1 * t_3)
        y = r
    else
        angle = math.pi * 0.5 + math.pi * t_4
        x = math.cos(angle) * r - (dist_1 * 0.5)
        y = math.sin(angle) * r
    end

    return {
        ["x"] = x,
        ["y"] = y,
    }
end

Common.draw_arc_slider = function(x,
                                  y,
                                  orientation,
                                  openning,
                                  ext_radius,
                                  blackground_thickness,
                                  foreground_thickness,
                                  color,
                                  ratio,
                                  reverse)
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

    cairo_new_path(cr)

    cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
    cairo_set_line_width(cr, blackground_thickness)
    cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a)

    if reverse then
        cairo_arc_negative(cr, x, y, radius, start_angle, end_angle_1)
    else
        cairo_arc(cr, x, y, radius, start_angle, end_angle_1)
    end

    cairo_set_operator(cr, CAIRO_OPERATOR_SOURCE)
    cairo_stroke_preserve(cr)

    cairo_new_path(cr)

    cairo_set_line_width(cr, foreground_thickness)

    if reverse then
        cairo_arc_negative(cr, x, y, radius, start_angle, end_angle_2)
    else
        cairo_arc(cr, x, y, radius, start_angle, end_angle_2)
    end

    cairo_stroke_preserve(cr)
end

Common.draw_filled_circle = function(x, y, radius, color)
    cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a)
    cairo_new_path(cr)
    cairo_arc(cr, x, y, radius, 0, math.pi * 2.0)
    cairo_fill_preserve(cr)
end

Common.draw_stroked_circle = function(x, y, radius, color)
    cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a)
    cairo_new_path(cr)
    cairo_arc(cr, x, y, radius, 0, math.pi * 2.0)
    cairo_stroke_preserve(cr)
end

Common.fill = function()
    cairo_fill(cr)
end

Common.stroke = function()
    cairo_stroke(cr)
end

Common.push = function()
    cairo_push_group(cr)
end

Common.pop = function()
    cairo_pop_group_to_source(cr)
end

Common.get_connection = function()
    local datas = {}
    local size = 0
    
    local connection_total = 0
    local cmd = ""
    local raw_value = ""

    for i = 1, 65535 do
        cmd = string.format("tcp_portmon %s %s count", i, i)
        raw_value = Common.get_raw_value(cmd)
        local connection = tonumber(raw_value)

        for j = 0, connection - 1 do
            cmd = string.format("tcp_portmon %s %s rport %d", i, i, j)
            raw_value = Common.get_raw_value(cmd)
            local rport = raw_value

            cmd = string.format("tcp_portmon %s %s rservice %d", i, i, j)
            raw_value = Common.get_raw_value(cmd)
            local rservice = raw_value

            if not Common.dict_contains_key(datas, rport) then
                datas[rport] = {
                    ["rservice"] = rservice,
                    ["connection"] = 0,
                }

                size = size + 1
            end

            datas[rport]["connection"] = datas[rport]["connection"] + 1
            connection_total = connection_total + 1
        end
    end

    return {
        ["connection_total"] = size,
        ["connections"] = datas,
    }
end

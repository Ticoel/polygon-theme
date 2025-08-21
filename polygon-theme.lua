dofile("Thèmes/polygon-theme/settings.lua")
dofile("Thèmes/polygon-theme/infos.lua")

local cs = nil
cr = nil

function conky_main()
    if conky_window == nil then
        print("error: conky_window is nil")
        return
    end

    cs = cairo_xlib_surface_create(conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height)

    if cs == nil then
        print("error: cs is nil")
        return
    end

    cr = cairo_create(cs)

    if cr == nil then
        print("error: cr is nil")
        return
    end  

    -- Calcul les dimensions

    local n = #Settings.cell

    local pos_1 = Common.capsule(n, n, Settings.width, Settings.height)
    local length = nil

    for i = 1, n do
        local pos_2 = Common.capsule(i, n, Settings.width, Settings.height)

        if pos_1 ~= nil and pos_2 ~= nil then
            Settings.cell[i]["x"] = pos_2["x"]
            Settings.cell[i]["y"] = pos_2["y"]
            Settings.cell[i]["angle_1"] = math.atan(pos_2["y"], pos_2["x"])

            if i > 1 then
                length = math.min(Common.length(pos_1["x"], pos_1["y"], pos_2["x"], pos_2["y"]), length)
            else
                length = Common.length(pos_1["x"], pos_1["y"], pos_2["x"], pos_2["y"])
            end
        end

        pos_1 = pos_2
    end

    if length ~= nil then
        Settings.cell_radius = length * 0.5 - Settings.cell_spacing
    end

    -- Récupère les informations

    local raw = nil
    
    -- -- Cellule 1 : Système

    Infos.cell[1]["body"][1] = string.upper("Operating System")
    Infos.cell[1]["body"][2] = Common.get_raw_value("sysname") .. " " .. Common.get_raw_value("kernel")  .. " " .. Common.get_raw_value("machine")
    Infos.cell[1]["body"][3] = Common.get_raw_value("nodename")
    Infos.cell[1]["body"][4] = "Uptime - " .. Common.get_raw_value("uptime")
    Infos.cell[1]["body"][5] = "Process(es) - " .. Common.get_raw_value("processes")
    Infos.cell[1]["body"][6] = "In Running - " .. Common.get_raw_value("running_processes")

    raw = Common.get_raw_value("time %H")
    Infos.cell[1]["ring"][1] = tonumber(raw) / 23.0
    raw = Common.get_raw_value("time %M")
    Infos.cell[1]["ring"][2] = tonumber(raw) / 59.0
    raw = Common.get_raw_value("time %S")
    Infos.cell[1]["ring"][3] = tonumber(raw) / 59.0

    Infos.cell[1]["label"][1] = "Hours"
    Infos.cell[1]["label"][2] = "Minutes"
    Infos.cell[1]["label"][3] = "Seconds"

    -- -- Cellule 2 : Proceseur

    Infos.cell[2]["body"][1] = string.upper("Processor") .. " (" .. Common.get_raw_value("freq_g cpu0")
        .. "GHz)"
    Infos.cell[2]["body"][2] = Common.get_raw_value("top name 2") .. " - "
        .. Common.get_raw_value("top cpu 2") .. "%"
    Infos.cell[2]["body"][3] = Common.get_raw_value("top name 2") .. " - "
        .. Common.get_raw_value("top cpu 2") .. "%"
    Infos.cell[2]["body"][4] = Common.get_raw_value("top name 3") .. " - "
        .. Common.get_raw_value("top cpu 3") .. "%"
    Infos.cell[2]["body"][5] = Common.get_raw_value("top name 4") .. " - "
        .. Common.get_raw_value("top cpu 4") .. "%"
    Infos.cell[2]["body"][6] = Common.get_raw_value("top name 5") .. " - "
        .. Common.get_raw_value("top cpu 5") .. "%"

    raw = Common.get_raw_value("cpu cpu0")
    Infos.cell[2]["ring"][1] = tonumber(raw) / 100.0
    raw = Common.get_raw_value("acpitemp")
    Infos.cell[2]["ring"][2] = tonumber(raw) / 90.0

    Infos.cell[2]["label"][1] = "Usage - " .. Common.get_raw_value("cpu cpu0") .. "%"
    Infos.cell[2]["label"][2] = "Temp. - " .. Common.get_raw_value("acpitemp") .. "°C"

    -- -- Cellule 3 : Mémoire

    Infos.cell[3]["body"][1] = string.upper("Memory")
    Infos.cell[3]["body"][2] = Common.get_raw_value("top_mem name 1") .. " - "
        .. Common.get_raw_value("top_mem mem 1") .. "%"
    Infos.cell[3]["body"][3] = Common.get_raw_value("top_mem name 2") .. " - "
        .. Common.get_raw_value("top_mem mem 2") .. "%"
    Infos.cell[3]["body"][4] = Common.get_raw_value("top_mem name 3") .. " - "
        .. Common.get_raw_value("top_mem mem 3") .. "%"
    Infos.cell[3]["body"][5] = Common.get_raw_value("top_mem name 4") .. " - "
        .. Common.get_raw_value("top_mem mem 4") .. "%"
    Infos.cell[3]["body"][6] = Common.get_raw_value("top_mem name 5") .. " - "
        .. Common.get_raw_value("top_mem mem 5") .. "%"

    raw = Common.get_raw_value("memperc")
    Infos.cell[3]["ring"][1] = tonumber(raw) / 100
    raw = Common.get_raw_value("swapperc")
    Infos.cell[3]["ring"][2] = tonumber(raw) / 100

    Infos.cell[3]["label"][1] = "RAM - " .. Common.get_raw_value("mem")
    Infos.cell[3]["label"][2] = "SWAP - " .. Common.get_raw_value("swap")

    -- -- Cellule 4 : Réseaux

    Infos.cell[4]["body"][1] = string.upper("Network")
    Infos.cell[4]["body"][2] = "Interface - " .. Common.get_raw_value("gw_iface")
    Infos.cell[4]["body"][3] = "IP local - " .. Common.get_raw_value("addr ${gw_iface}")
    Infos.cell[4]["body"][4] = "IP public - " .. Common.get_raw_value("curl https://api.ipify.org?format=txt 1")
    Infos.cell[4]["body"][5] = "Up - " .. Common.get_raw_value("totalup ${gw_iface}")
    Infos.cell[4]["body"][6] = "Down - " .. Common.get_raw_value("totaldown ${gw_iface}")

    raw = Common.get_raw_value("upspeedf ${gw_iface}")
    Infos.cell[4]["ring"][1] = tonumber(raw) / 2048
    raw = Common.get_raw_value("downspeedf ${gw_iface}")
    Infos.cell[4]["ring"][2] = tonumber(raw) / 2048

    Infos.cell[4]["label"][1] = "Up - " .. Common.get_raw_value("upspeed ${gw_iface}")
    Infos.cell[4]["label"][2] = "Down - " .. Common.get_raw_value("downspeed ${gw_iface}")

    -- -- Cellule 5 : Stockage

    Infos.cell[5]["body"][1] = string.upper("Storage")
    Infos.cell[5]["body"][2] = Common.get_raw_value("top_io name 1") .. " - "
        .. Common.get_raw_value("top_io io_perc 1") .. "%"
    Infos.cell[5]["body"][3] = Common.get_raw_value("top_io name 2") .. " - "
        .. Common.get_raw_value("top_io io_perc 2") .. "%"
    Infos.cell[5]["body"][4] = Common.get_raw_value("top_io name 3") .. " - "
        .. Common.get_raw_value("top_io io_perc 3") .. "%"
    Infos.cell[5]["body"][5] = Common.get_raw_value("top_io name 4") .. " - "
        .. Common.get_raw_value("top_io io_perc 4") .. "%"
    Infos.cell[5]["body"][6] = Common.get_raw_value("top_io name 5") .. " - "
        .. Common.get_raw_value("top_io io_perc 5") .. "%"

    raw = Common.get_raw_value("fs_used_perc /")
    Infos.cell[5]["ring"][1] = tonumber(raw) / 100
    raw = Common.get_raw_value("fs_used_perc /home")
    Infos.cell[5]["ring"][2] = tonumber(raw) / 100

    Infos.cell[5]["label"][1] = "Root - " .. Common.get_raw_value("fs_used /")
    Infos.cell[5]["label"][2] = "Home - " .. Common.get_raw_value("fs_used /home")

    -- -- Cellule 6 : Connexion   

    local con_max = Common.get_raw_value("tcp_portmon 1 65535 count") - 1
    local connections = {}
    connections[-1] = 0
    connections[22] = 0
    connections[25] = 0
    connections[80] = 0
    connections[143] = 0
    connections[443] = 0
    connections[465] = 0
    connections[587] = 0
    connections[830] = 0
    connections[993] = 0
    local std_serv_in_use = 0

    if con_max > 0 then
        for i = 0, con_max do
            local raw_rport = Common.get_raw_value("tcp_portmon 1 65535 rport " .. i)
            local rport = tonumber(raw_rport)

            if connections[rport] == nil then
                connections[-1] = connections[-1] + 1
            else
                connections[rport] = tonumber(connections[rport]) + 1
            end
        end
    end

    for k, v in pairs(connections) do
        if connections[k] > 0 then
            std_serv_in_use = std_serv_in_use + 1
        end
    end

    Infos.cell[6]["body"][1] = string.upper("Network Connections")
    Infos.cell[6]["body"][2] = string.format("22 (SSH, etc.) < %s conn(s)", connections[22])
    Infos.cell[6]["body"][3] = string.format("25 (SMTP) < %s conn(s)", connections[25])
    Infos.cell[6]["body"][4] = string.format("80 (HTTP) < %s conn(s)", connections[80])
    Infos.cell[6]["body"][5] = string.format("143 (IMAP) < %s conn(s)", connections[143])
    Infos.cell[6]["body"][6] = string.format("443 (HTTPS) < %s conn(s)", connections[443])
    Infos.cell[6]["body"][7] = string.format("465 (SMTP) < %s conn(s)", connections[465])
    Infos.cell[6]["body"][8] = string.format("587 (SMTP) < %s conn(s)", connections[587])
    Infos.cell[6]["body"][9] = string.format("830 (SSH) < %s conn(s)", connections[830])
    Infos.cell[6]["body"][10] = string.format("993 (IMAPS) < %s conn(s)", connections[993])
    Infos.cell[6]["body"][11] = string.format("Others... < %s conn(s)", connections[-1])
    
    Infos.cell[6]["ring"][1] = std_serv_in_use / 9.0

    Infos.cell[6]["label"][1] = "Std serv. in use"

    -- Dessine
    
    cairo_translate(cr, conky_window.width * 0.5, conky_window.height * 0.5)

    for i = 1, n do
        if Settings.cell[i]["type"] == CellType.UNKNOWN then
            print(string.format("Cell %s should be implanted", i))
        end
        
        if Settings.cell[i]["type"] == CellType.MULTI then
            Common.push()

            Common.draw_filled_circle(Settings.cell[i]["x"],
                Settings.cell[i]["y"],
                Settings.cell_radius - (Settings.thickness
                    + Settings.ring_spacing) * (Settings.cell[i]["n"] - 1),
                Settings.cell[i]["color"][Settings.cell[i]["n"] + 1])

            Common.write_multi(Settings.cell[i]["x"],
                Settings.cell[i]["y"],
                0,
                Infos.cell[i]["body"],
                Settings.font_name,
                Settings.font_size,
                Settings.cell[i]["color"][1],
                CAIRO_FONT_SLANT_NORMAL,
                CAIRO_FONT_WEIGHT_BOLD,
                0.5,
                0.5,
                Settings.interline,
                0.5,
                0.5)

            Common.pop()

            Common.fill()

            for j = 1, Settings.cell[i]["n"] do
                if j == Settings.cell[i]["n"] then break end
                Common.draw_arc_slider(Settings.cell[i]["x"],
                    Settings.cell[i]["y"],
                    Settings.cell[i]["angle_1"],
                    Settings.cell[i]["openning"][j],
                    Settings.cell_radius - (Settings.thickness + Settings.ring_spacing) * (j - 1),
                    Settings.thickness / 3.0,
                    Settings.thickness,
                    Settings.cell[i]["color"][j + 1],
                    Infos.cell[i]["ring"][j],
                    Settings.cell[i]["invert"])

                Common.stroke()

                local offset = (Settings.cell[i]["openning"][j] / 2)
                local a = 0.0
                if Settings.cell[i][9] then
                    a = Settings.cell[i]["angle_1"] - math.pi * offset
                else
                    a = Settings.cell[i]["angle_1"] + math.pi * offset
                end

                local distance = Settings.cell_radius - (Settings.thickness
                    + Settings.ring_spacing) * (j - 1) + Settings.text_spacing

                Common.write_line(Settings.cell[i]["x"] + math.cos(a) * distance,
                    Settings.cell[i]["y"] + math.sin(a) * distance,
                    a + Settings.cell[i]["angle_2"],
                    Infos.cell[i]["label"][j],
                    Settings.font_name,
                    Settings.font_size,
                    Settings.cell[i]["color"][1],
                    Settings.CAIRO_FONT_SLANT_NORMAL,
                    Settings.CAIRO_FONT_WEIGHT_BOLD,
                    Settings.cell[i]["h_align"],
                    Settings.cell[i]["v_align"])

                Common.fill()
            end
        end
    end
    
    cairo_destroy(cr)
    cr = nil
    cairo_surface_destroy(cs)
    cs = nil
end

function conky_destroy()
    cairo_destroy(cr)
    cr = nil
    cairo_surface_destroy(cs)
    cs = nil
end
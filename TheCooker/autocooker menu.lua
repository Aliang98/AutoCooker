local function is_playing()
	if not BaseNetworkHandler then 
		return false 
	end
	return BaseNetworkHandler._gamestate_filter.any_ingame_playing[ game_state_machine:last_queued_state_name() ]
end

local function in_mainmenu()
	if (game_state_machine:current_state_name() == "menu_main") then
		return true
	end
	return false
end

local lang = localization_TC:get_language()
local id_level = managers.job:current_level_id()

local mission_table = {
	["pal"] = {
		{ text = string.format("%s", lang.menu_autocook), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker.lua")) end },
		{ text = string.format("%s", lang.menu_semi_auto), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker semi auto.lua")) end },
		{ text = string.format("%s", lang.menu_auto_secure), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker secure.lua")) end },
		{ text = string.format("%s", lang.menu_auto_bag), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker bag meth.lua")) end },
		{ text = string.format("%s", lang.menu_box), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker fc.lua")) end },
		{ text = string.format("%s", lang.menu_public), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker announce.lua")) end },
		{},
		{ text = string.format("%s", lang.menu_more_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker more bags.lua")) end },
		{ text = string.format("%s", lang.menu_less_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker less bags.lua")) end }
	},
	["crojob2"] = {
		{ text = string.format("%s", lang.menu_autocook), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker.lua")) end },
		{ text = string.format("%s", lang.menu_semi_auto), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker semi auto.lua")) end },
		{ text = string.format("%s", lang.menu_auto_secure), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker secure.lua")) end },
		{ text = string.format("%s", lang.menu_auto_bag), callback_func = function() 
			dofile(string.format(localization_TC.config.other.file_path.."autocooker bag meth.lua"))
			if not global_toggle_bag_meth then
				managers.chat:_receive_message(1, lang.cooker, string.format("%s", lang.menu_ex_warning), tweak_data.system_chat_color)
			end
		end },
		{ text = string.format("%s", lang.menu_public), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker announce.lua")) end },
		{},
		{ text = string.format("%s", lang.menu_more_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker more bags.lua")) end },
		{ text = string.format("%s", lang.menu_less_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker less bags.lua")) end },
		{},
		{ text = string.format("%s", lang.menu_secure_all), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker secure all.lua")) end }
	},
	["alex_1"] = {
		{ text = string.format("%s", lang.menu_autocook), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker.lua")) end },
		{ text = string.format("%s", lang.menu_semi_auto), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker semi auto.lua")) end },
		{ text = string.format("%s", lang.menu_auto_secure), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker secure.lua")) end },
		{ text = string.format("%s", lang.menu_auto_bag), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker bag meth.lua")) end },
		{ text = string.format("%s", lang.menu_circuit), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker fc.lua")) end },
		{ text = string.format("%s", lang.menu_public), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker announce.lua")) end },
		{ text = string.format("%s", lang.menu_less_spam), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker spam.lua")) end },
		{},
		{ text = string.format("%s", lang.menu_more_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker more bags.lua")) end },
		{ text = string.format("%s", lang.menu_less_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker less bags.lua")) end },
		{},
		{ text = string.format("%s", lang.menu_secure_all), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker secure all.lua")) end }
	},
	["rat"] = {
		{ text = string.format("%s", lang.menu_autocook), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker.lua")) end },
		{ text = string.format("%s", lang.menu_semi_auto), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker semi auto.lua")) end },
		{ text = string.format("%s", lang.menu_auto_secure), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker secure.lua")) end },
		{ text = string.format("%s", lang.menu_auto_bag), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker bag meth.lua")) end },
		{ text = string.format("%s", lang.menu_circuit), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker fc.lua")) end },
		{ text = string.format("%s", lang.menu_public), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker announce.lua")) end },
		{ text = string.format("%s", lang.menu_less_spam), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker spam.lua")) end },
		{},
		{ text = string.format("%s", lang.menu_more_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker more bags.lua")) end },
		{ text = string.format("%s", lang.menu_less_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker less bags.lua")) end },
		{},
		{ text = string.format("%s", lang.menu_secure_all), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker secure all.lua")) end }
	},
	["mia_1"] = {
		{ text = string.format("%s", lang.menu_autocook), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker.lua")) end },
		{ text = string.format("%s", lang.menu_semi_auto), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker semi auto.lua")) end },
		{ text = string.format("%s", lang.menu_auto_secure), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker secure.lua")) end },
		{ text = string.format("%s", lang.menu_auto_bag), callback_func = function() 
			dofile(string.format(localization_TC.config.other.file_path.."autocooker bag meth.lua"))
			if not global_toggle_bag_meth then
				managers.chat:_receive_message(1, lang.cooker, string.format("%s", lang.menu_ex_warning), tweak_data.system_chat_color)
			end
		end },
		{ text = string.format("%s", lang.menu_public), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker announce.lua")) end },
		{},
		{ text = string.format("%s", lang.menu_more_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker more bags.lua")) end },
		{ text = string.format("%s", lang.menu_less_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker less bags.lua")) end },
	},
	["mex_cooking"] = {
		{ text = string.format("%s", lang.menu_autocook), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker.lua")) end },
		{ text = string.format("%s", lang.menu_semi_auto), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker semi auto.lua")) end },
		{ text = string.format("%s", lang.menu_auto_secure), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker secure.lua")) end },
		{ text = string.format("%s", lang.menu_auto_bag), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker bag meth.lua")) end },
		{ text = string.format("%s", lang.menu_public), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker announce.lua")) end },
		{ text = string.format("%s", lang.menu_less_spam), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker spam.lua")) end },
		{},
		{ text = string.format("%s", lang.menu_more_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker more bags.lua")) end },
		{ text = string.format("%s", lang.menu_less_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker less bags.lua")) end }
	},
	["cane"] = {
		{ text = string.format("%s", lang.menu_autocook), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker.lua")) end },
		{ text = string.format("%s", lang.menu_auto_bag), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker bag meth.lua")) end },
		{ text = string.format("%s", lang.menu_auto_secure), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker secure.lua")) end },
		{ text = string.format("%s", lang.menu_public), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker announce.lua")) end },
		{},
		{ text = string.format("%s", lang.menu_more_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker more bags.lua")) end },
		{ text = string.format("%s", lang.menu_less_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker less bags.lua")) end },
		{},
		{ text = string.format("%s", lang.menu_secure_all), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker secure all.lua")) end }
	},
	["nail"] = {
		{ text = string.format("%s", lang.menu_autocook), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker.lua")) end },
		{ text = string.format("%s", lang.menu_semi_auto), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker semi auto.lua")) end },
		{ text = string.format("%s", lang.menu_auto_secure), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker secure.lua")) end },
		{ text = string.format("%s", lang.menu_auto_pill), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker bag meth.lua")) end },
		{ text = string.format("%s", lang.menu_public), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker announce.lua")) end },
		{ text = string.format("%s", lang.menu_less_spam), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker spam.lua")) end },
		{},
		{ text = string.format("%s", lang.menu_more_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker more bags.lua")) end },
		{ text = string.format("%s", lang.menu_less_bags), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker less bags.lua")) end },
		{},
		{ text = string.format("%s", lang.menu_secure_all), callback_func = function() dofile(string.format(localization_TC.config.other.file_path.."autocooker secure all.lua")) end }
	},
	["hover_color"] = {
		{ text = "Neongreen", callback_func = function() color_changer_tc:change_color({57, 255, 20}, "h", "Neongreen") end },
		{ text = "Lilac", callback_func = function() color_changer_tc:change_color({216, 145, 239}, "h", "Lilac") end },
		{ text = "Sky Blue", callback_func = function() color_changer_tc:change_color({135, 206, 235}, "h", "Sky Blue") end },
		{ text = "Royal Blue", callback_func = function() color_changer_tc:change_color({65, 105, 225}, "h", "Royal Blue") end },
		{ text = "Coral", callback_func = function() color_changer_tc:change_color({255, 127, 80}, "h", "Coral") end },
		{ text = "Sandy Brown", callback_func = function() color_changer_tc:change_color({244, 164, 96}, "h", "Sandy Brown") end },
		{ text = "Wheat", callback_func = function() color_changer_tc:change_color({245, 222, 179}, "h", "Wheat") end },
		{ text = "Silver", callback_func = function() color_changer_tc:change_color({192, 192, 192}, "h", "Silver") end },
		{ text = "Rosy Brown", callback_func = function() color_changer_tc:change_color({188, 143, 143}, "h", "Rosy Brown") end },
		{ text = "Orange", callback_func = function() color_changer_tc:change_color({255, 165, 0}, "h", "Orange") end },
		{ text = "Indigo", callback_func = function() color_changer_tc:change_color({75, 0, 130}, "h", "Indigo") end },
		{ text = "Dark Green", callback_func = function() color_changer_tc:change_color({0, 100, 0}, "h", "Dark Green") end },
		{ text = "Fire Brick", callback_func = function() color_changer_tc:change_color({178, 34, 34}, "h", "Fire Brick") end },
		{ text = "Misty Rose", callback_func = function() color_changer_tc:change_color({"FFE4E1"}, "h", "Misty Rose") end },
		{},
		{ text = "Default", callback_func = function() color_changer_tc:change_color({255, 77, 198, 255}, "h", "default") end },
	},
	["button_color"] = {
		{ text = "Neongreen", callback_func = function() color_changer_tc:change_color({57, 255, 20}, "b", "Neongreen") end },
		{ text = "Lilac", callback_func = function() color_changer_tc:change_color({216, 145, 239}, "b", "Lilac") end },
		{ text = "Sky Blue", callback_func = function() color_changer_tc:change_color({135, 206, 235}, "b", "Sky Blue") end },
		{ text = "Royal Blue", callback_func = function() color_changer_tc:change_color({65, 105, 225}, "b", "Royal Blue") end },
		{ text = "Coral", callback_func = function() color_changer_tc:change_color({255, 127, 80}, "b", "Coral") end },
		{ text = "Sandy Brown", callback_func = function() color_changer_tc:change_color({244, 164, 96}, "b", "Sandy Brown")  end },
		{ text = "Wheat", callback_func = function() color_changer_tc:change_color({245, 222, 179}, "b", "Wheat") end },
		{ text = "Silver", callback_func = function() color_changer_tc:change_color({192, 192, 192}, "b", "Silver") end },
		{ text = "Rosy Brown", callback_func = function() color_changer_tc:change_color({188, 143, 143}, "b", "Rosy Brown") end },
		{ text = "Orange", callback_func = function() color_changer_tc:change_color({255, 165, 0}, "b", "Orange") end },
		{ text = "Indigo", callback_func = function() color_changer_tc:change_color({75, 0, 130}, "b", "Indigo") end },
		{ text = "Dark Green", callback_func = function() color_changer_tc:change_color({0, 100, 0}, "b", "Dark Green") end },
		{ text = "Fire Brick", callback_func = function() color_changer_tc:change_color({178, 34, 34}, "b", "Fire Brick") end },
		{ text = "Misty Rose", callback_func = function() color_changer_tc:change_color({"FFE4E1"}, "b", "Misty Rose") end },
		{},
		{ text = "Default", callback_func = function() color_changer_tc:change_color({127, 0, 170, 255}, "b", "default") end },
	}
}

local function mission_menu()
	local list = managers.job:current_level_id()
	
	local dialog_data = {    
		title = string.format("%s", lang.menu_title),
		text = string.format("%s", lang.menu_description),
		button_list = {}
	}
	
	for _, mission_func in pairs(mission_table[list]) do
		table.insert(dialog_data.button_list, mission_func)
	end

	table.insert(dialog_data.button_list, {})
	table.insert(dialog_data.button_list, { text = managers.localization:text("dialog_cancel"), cancel_button = true }) 
	managers.system_menu:show_buttons(dialog_data)
end

local function reconnect()
	local room_id = localization_TC["config"]["other"]["reconnect_id"]
	if room_id ~= "" then
		managers.network.matchmake:join_server(room_id)
		return
	end
	managers.mission._fading_debug_output:script().log(string.format("No server found.."), Color.red)
end

local function color_name(color_type)
	if color_type == "button_color" then
		return localization_TC["config"]["other"]["menucolor_button"]["cb"]
	end
	return localization_TC["config"]["other"]["menucolor_hover"]["ch"]
end

local function button_color_menu(color_type)
	local current = color_name(color_type)
	local dialog_data = {    
		title = string.gsub(color_type, "_", " ").." Menu",
		text = "Current: "..current.."                                                                                             Restart game to let changes take full effect",
		button_list = {}
	}
	
	for _, dostuff in pairs(mission_table[color_type]) do
		if dostuff then
			table.insert(dialog_data.button_list, dostuff)
		end
	end
	
	table.insert(dialog_data.button_list, {})
	table.insert(dialog_data.button_list, {text = "back", callback_func = function() main_menu_the_cooker() end,})
	table.insert(dialog_data.button_list, { text = managers.localization:text("dialog_cancel"), focus_callback_func = function () end, cancel_button = true }) 
	managers.system_menu:show_buttons(dialog_data)
end

local main_menu_table = {
	{ text = string.format("%s", lang.m_menu_reconnect), callback_func = function()
		if in_mainmenu() then
			reconnect()
		else
			MenuCallbackHandler:_dialog_end_game_yes()
		end
	end },
	{},
	{ text = "Button Color", callback_func = function() button_color_menu("button_color") end },
	{ text = "Button Hover", callback_func = function() button_color_menu("hover_color") end }
}

function main_menu_the_cooker()
	local dialog_data = {    
		title = string.format("%s", lang.menu_title),
		text = string.format("%s", lang.menu_description),
		button_list = {}
	}
	
	for _, MM_func in pairs(main_menu_table) do
		table.insert(dialog_data.button_list, MM_func)
	end

	table.insert(dialog_data.button_list, {})
	table.insert(dialog_data.button_list, { text = managers.localization:text("dialog_cancel"), cancel_button = true }) 
	managers.system_menu:show_buttons(dialog_data)
end

if is_playing() then
	if not (id_level == 'pal' or id_level == 'nail' or id_level == 'cane' or id_level == 'mex_cooking' or id_level == 'alex_1' or id_level == 'rat' or id_level == 'crojob2' or id_level == 'mia_1') then
		managers.chat:_receive_message(1, lang.cooker, string.format("%s", lang.menu_heist_warning), tweak_data.system_chat_color)
		return
	end

	mission_menu()
else
	main_menu_the_cooker()
end

--[[custom colors
Color.purple = Color("9932CC")
Color.labia = Color("E75480")
Color.gold = Color("FFD700")
Color.silver = Color("CFCFC4")
Color.bronze = Color("CD7F32")
Color.neongreen = Color("39FF14")
Color.lilac = Color("D891EF")
Color.brown = Color("6B4423")
Color.grey = Color("B2BEB5")
Color.limited = Color("4F7942")
Color.unlimited = Color("FDEE00")
Color.pro = Color("7BB661")
Color.wip = Color("0D98BA")

--global colors
Color.AliceBlue = Color('F0F8FF')          
Color.AntiqueWhite = Color('FAEBD7')           
Color.Aqua = Color('00FFFF')           
Color.Aquamarine = Color('7FFFD4')           
Color.Azure = Color('F0FFFF')           
Color.Beige = Color('F5F5DC')           
Color.Bisque = Color('FFE4C4')                     
Color.BlanchedAlmond = Color('FFEBCD')                     
Color.BlueViolet = Color('8A2BE2')           
Color.Brown = Color('A52A2A')           
Color.BurlyWood = Color('DEB887')           
Color.CadetBlue = Color('5F9EA0')           
Color.Chartreuse = Color('7FFF00')           
Color.Chocolate = Color('D2691E')           
Color.Coral = Color('FF7F50')           
Color.CornflowerBlue = Color('6495ED')           
Color.Cornsilk = Color('FFF8DC')           
Color.Crimson = Color('DC143C')           
Color.Cyan = Color('00FFFF')           
Color.DarkBlue = Color('00008B')           
Color.DarkCyan = Color('008B8B')           
Color.DarkGoldenRod = Color('B8860B')          
Color.DarkGray = Color('A9A9A9')           
Color.DarkGreen = Color('006400')           
Color.DarkKhaki = Color('BDB76B')           
Color.DarkMagenta = Color('8B008B')           
Color.DarkOliveGreen = Color('556B2F')           
Color.DarkOrange = Color('FF8C00')           
Color.DarkOrchid = Color('9932CC')           
Color.DarkRed = Color('8B0000')           
Color.DarkSalmon = Color('E9967A')           
Color.DarkSeaGreen = Color('8FBC8F')           
Color.DarkSlateBlue = Color('483D8B')           
Color.DarkSlateGray = Color('2F4F4F')           
Color.DarkTurquoise = Color('00CED1')           
Color.DarkViolet = Color('9400D3')           
Color.DeepPink = Color('FF1493')           
Color.DeepSkyBlue = Color('00BFFF')           
Color.DimGray = Color('696969')           
Color.DodgerBlue = Color('1E90FF')           
Color.FireBrick = Color('B22222')                     
Color.ForestGreen = Color('228B22')           
Color.Fuchsia = Color('FF00FF')           
Color.Gainsboro = Color('DCDCDC')                     
Color.Gold = Color('FFD700')           
Color.GoldenRod = Color('DAA520')           
Color.Gray = Color('808080')                      
Color.GreenYellow = Color('ADFF2F')           
Color.HoneyDew = Color('F0FFF0')           
Color.HotPink = Color('FF69B4')           
Color.IndianRed = Color('CD5C5C')           
Color.Indigo = Color('4B0082')                     
Color.Khaki = Color('F0E68C')           
Color.Lavender = Color('E6E6FA')           
Color.LavenderBlush = Color('FFF0F5')           
Color.LawnGreen = Color('7CFC00')           
Color.LemonChiffon = Color('FFFACD')           
Color.LightBlue = Color('ADD8E6')           
Color.LightCoral = Color('F08080')           
Color.LightCyan = Color('E0FFFF')           
Color.LightGoldenRodYellow = Color('FAFAD2')           
Color.LightGray = Color('D3D3D3')           
Color.LightGreen = Color('90EE90')           
Color.LightPink = Color('FFB6C1')           
Color.LightSalmon = Color('FFA07A')           
Color.LightSeaGreen = Color('20B2AA')           
Color.LightSkyBlue = Color('87CEFA')           
Color.LightSlateGray = Color('778899')           
Color.LightSteelBlue = Color('B0C4DE')           
Color.LightYellow = Color('FFFFE0')           
Color.Lime = Color('00FF00')           
Color.LimeGreen = Color('32CD32')           
Color.Linen = Color('FAF0E6')           
Color.Magenta = Color('FF00FF')           
Color.Maroon = Color('800000')           
Color.MediumAquaMarine = Color('66CDAA')           
Color.MediumBlue = Color('0000CD')           
Color.MediumOrchid = Color('BA55D3')           
Color.MediumPurple = Color('9370DB')           
Color.MediumSeaGreen = Color('3CB371')           
Color.MediumSlateBlue = Color('7B68EE')           
Color.MediumSpringGreen = Color('00FA9A')           
Color.MediumTurquoise = Color('48D1CC')           
Color.MediumVioletRed = Color('C71585')           
Color.MidnightBlue = Color('191970')           
Color.MintCream = Color('F5FFFA')           
Color.MistyRose = Color('FFE4E1')           
Color.Moccasin = Color('FFE4B5')                     
Color.Navy = Color('000080')           
Color.OldLace = Color('FDF5E6')           
Color.Olive = Color('808000')           
Color.OliveDrab = Color('6B8E23')           
Color.Orange = Color('FFA500')           
Color.OrangeRed = Color('FF4500')           
Color.Orchid = Color('DA70D6')           
Color.PaleGoldenRod = Color('EEE8AA')           
Color.PaleGreen = Color('98FB98')           
Color.PaleTurquoise = Color('AFEEEE')           
Color.PaleVioletRed = Color('DB7093')           
Color.PapayaWhip = Color('FFEFD5')     
Color.PeachPuff = Color('FFDAB9')          
Color.Peru = Color('CD853F')          
Color.Pink = Color('FFC0CB')           
Color.Plum = Color('DDA0DD')      
Color.PowderBlue = Color('B0E0E6')           
Color.RosyBrown = Color('BC8F8F')           
Color.RoyalBlue = Color('4169E1')           
Color.SaddleBrown = Color('8B4513')           
Color.Salmon = Color('FA8072')           
Color.SandyBrown = Color('F4A460')           
Color.SeaGreen = Color('2E8B57')           
Color.SeaShell = Color('FFF5EE')           
Color.Sienna = Color('A0522D')           
Color.Silver = Color('C0C0C0')           
Color.SkyBlue = Color('87CEEB')           
Color.SlateBlue = Color('6A5ACD')           
Color.SlateGray = Color('708090')                     
Color.SpringGreen = Color('00FF7F')           
Color.SteelBlue = Color('4682B4')           
Color.Tan = Color('D2B48C')           
Color.Teal = Color('008080')
Color.Thistle = Color('D8BFD8')           
Color.Tomato = Color('FF6347')           
Color.Turquoise = Color('40E0D0')           
Color.Violet = Color('EE82EE')           
Color.Wheat = Color('F5DEB3')                                
Color.YellowGreen = Color('9ACD32') --]]
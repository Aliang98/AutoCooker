if rawget(_G, "color_changer_tc") then
	rawset(_G, "color_changer_tc", nil)
end

rawset(_G, "color_changer_tc", {})

function color_changer_tc:getColor(color_type, msg)
	if msg then
		managers.mission._fading_debug_output:script().log(string.format("Saved Color: %s %s %s %s", tonumber(color_type[1]), tonumber(color_type[2]), tonumber(color_type[3]), (tonumber(color_type[4]) or 0)), Color.green)
	end
	local r, g, b = tonumber(color_type[1])/255, tonumber(color_type[2])/255, tonumber(color_type[3])/255
	if tonumber(color_type[4]) then
		local t = tonumber(color_type[4])/255
		return Color(r, g, b, t)
	end
	return Color(r, g, b)
end

function color_changer_tc:hex(hex, t)
	local r, g, b = hex:match('(..)(..)(..)')
	r, g, b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
	if t then
		return r, g, b, t
	end
	return r, g, b
end

function color_changer_tc:change_color(color_type, menu_type, current)
	local r, g, b, t = tonumber(color_type[1]), tonumber(color_type[2]), tonumber(color_type[3]), tonumber(color_type[4])
	
	if type(color_type[1]) == "string" then
		r, g, b, t = color_changer_tc:hex(color_type[1], tonumber(color_type[2]))
	end
	
	if menu_type == "h" then
		localization_TC.config.other.menucolor_hover.ch = current
		localization_TC.config.other.menucolor_hover.r = r
		localization_TC.config.other.menucolor_hover.g = g
		localization_TC.config.other.menucolor_hover.b = b
		localization_TC.config.other.menucolor_hover.t = t	
		
		if tweak_data and tweak_data.screen_colors and tweak_data.screen_colors.button_stage_2 then
			tweak_data.screen_colors.button_stage_2 = self:getColor({r, g, b, t}, true)
		end
	elseif menu_type == "b" then		
		localization_TC.config.other.menucolor_button.cb = current
		localization_TC.config.other.menucolor_button.r = r
		localization_TC.config.other.menucolor_button.g = g
		localization_TC.config.other.menucolor_button.b = b
		localization_TC.config.other.menucolor_button.t = t
		
		if tweak_data and tweak_data.screen_colors and tweak_data.screen_colors.button_stage_3 then
			tweak_data.screen_colors.button_stage_3 = self:getColor({r, g, b, t}, true)
		end
	end
	localization_TC:save_config()
end

function color_changer_tc:load_colors()
	if tweak_data and tweak_data.screen_colors and tweak_data.screen_colors.button_stage_2 and tweak_data.screen_colors.button_stage_3 then
		tweak_data.screen_colors.button_stage_2 = self:getColor(
			{
				localization_TC.config.other.menucolor_hover.r, 
				localization_TC.config.other.menucolor_hover.g,
				localization_TC.config.other.menucolor_hover.b,
				localization_TC.config.other.menucolor_hover.t
			},
			false
		)

		tweak_data.screen_colors.button_stage_3 = self:getColor(
			{
				localization_TC.config.other.menucolor_button.r, 
				localization_TC.config.other.menucolor_button.g,
				localization_TC.config.other.menucolor_button.b,
				localization_TC.config.other.menucolor_button.t
			},
			false
		)
	end
end

if not SystemFS:exists("mods/ColorText/mod.txt") then
	color_changer_tc:load_colors()
end
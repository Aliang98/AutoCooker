local lang = localization_TC:get_language()
Color.gold = Color("FFD700")
if localization_TC.config.other.allow_cooker then
	if global_toggle_meth then
		if (bag_amount == 1) then
			managers.chat:_receive_message(1, lang.menu_button_spawn_cooker, string.format("%s", lang.menu_button_lessm_enable_warning), tweak_data.system_chat_color)
			return
		end
		bag_amount = bag_amount - 1
		--managers.mission._fading_debug_output:script().log(string.format("%s %s", bag_amount, lang.menu_button_lessm_enable),  Color.gold)
		managers.chat:_receive_message(1, lang.menu_button_spawn_cooker, string.format("%s %s", bag_amount, lang.menu_button_lessm_enable), Color.gold)
	else
		--managers.chat:_receive_message(1, lang.menu_button_spawn_cooker, string.format("%s", lang.menu_button_morelessm_enable_warning), tweak_data.system_chat_color)
		managers.chat:_receive_message(1, lang.menu_button_spawn_cooker, string.format("%s", lang.menu_button_morelessm_enable_warning), tweak_data.system_chat_color)
	end
else
	managers.chat:_receive_message(1, lang.menu_button_spawn_cooker, string.format("%s", lang.allow_cooker_msg), tweak_data.system_chat_color)
end
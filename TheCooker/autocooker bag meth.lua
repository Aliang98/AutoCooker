local lang = localization_TC:get_language()
--if localization_TC.config.other.allow_cooker then
	if global_toggle_meth then
		global_auto_bag_meth = global_auto_bag_meth or false
		if not global_auto_bag_meth then
			global_toggle_bag_meth = true
			--managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_bag_on),  Color.green)
			managers.chat:_receive_message(1, lang.menu_button_bag_cooker, string.format("%s", lang.menu_button_bag_on), Color.green)
		else
			global_toggle_bag_meth = false
			if (id_level == 'nail') then
				BetterDelayedCalls_TC:Remove("drop_bags_3_times_meth_done")
			end
			--managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_bag_off),  Color.red)
			managers.chat:_receive_message(1, lang.menu_button_bag_cooker, string.format("%s", lang.menu_button_bag_off), Color.red)
		end
		global_auto_bag_meth = not global_auto_bag_meth
	else
		managers.chat:_receive_message(1, lang.menu_button_bag_cooker, string.format("%s", lang.menu_button_bag_enable_warning), tweak_data.system_chat_color)
	end
--else
--	managers.chat:_receive_message(1, lang.menu_button_bag_cooker, string.format("%s", lang.allow_cooker_msg), tweak_data.system_chat_color)
--end
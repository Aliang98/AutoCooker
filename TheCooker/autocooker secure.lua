local lang = localization_TC:get_language()
if localization_TC.config.other.allow_cooker then
	if global_toggle_meth and global_toggle_bag_meth then
		global_ac_secure = global_ac_secure or false
		if not global_ac_secure then
			global_auto_secure = true
			managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_secure_on),  Color.green)
		else
			global_auto_secure = false
			managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_secure_off),  Color.red)
		end
		global_ac_secure = not global_ac_secure
	else
		managers.chat:_receive_message(1, lang.menu_button_secure_cooker, string.format("%s", lang.menu_button_secure_enable_warning), tweak_data.system_chat_color)
	end
else
	managers.chat:_receive_message(1, lang.menu_button_secure_cooker, string.format("%s", lang.allow_cooker_msg), tweak_data.system_chat_color)
end
local lang = localization_TC:get_language()
if global_toggle_meth and global_semi_auto then
	localization_TC.config.other.last_chem = nil
	localization_TC:save_config()
	global_spam_ac = global_spam_ac or false
	if not global_spam_ac then
		global_anti_spam_toggle = true
		-- managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_spam_on),  Color.green)
		managers.chat:_receive_message(1, lang.menu_button_spam_on, string.format("%s", lang.menu_button_spam_on), Color.green)
	else
		global_anti_spam_toggle = false
		-- managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_spam_off),  Color.red)
		managers.chat:_receive_message(1, lang.menu_button_spam_off, string.format("%s", lang.menu_button_spam_off), Color.red)
	end
	global_spam_ac = not global_spam_ac
else
	managers.chat:_receive_message(1, lang.menu_button_spam_cooker, string.format("%s", lang.menu_button_spam_enable_warning), tweak_data.system_chat_color)
end
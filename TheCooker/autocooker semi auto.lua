local lang = localization_TC:get_language()
if global_toggle_meth then
	global_semi_auto = global_semi_auto or false
	if not global_semi_auto then
		global_semi_auto_toggle = true
		-- managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_semi_on),  Color.green)
		managers.chat:_receive_message(1, lang.menu_button_semi_on, string.format("%s", lang.menu_button_semi_on), Color.green)
	else
		if global_spam_ac then
			global_spam_ac = not global_spam_ac
			global_anti_spam_toggle = false
		end
		global_semi_auto_toggle = false
		-- managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_semi_off),  Color.red)
		managers.chat:_receive_message(1, lang.menu_button_semi_off, string.format("%s", lang.menu_button_semi_off), Color.red)
	end
	global_semi_auto = not global_semi_auto
else
	managers.chat:_receive_message(1, lang.menu_button_semi_cooker, string.format("%s", lang.menu_button_semi_enable_warning), tweak_data.system_chat_color)
end
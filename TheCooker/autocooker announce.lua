local lang = localization_TC:get_language()
if global_toggle_meth then
	global_announce = global_announce or false
	if not global_announce then
		global_announce_toggle = true
		managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_announce_on),  Color.green)
	else
		global_announce_toggle = false
		managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_announce_off),  Color.red)
	end
	global_announce = not global_announce
else
	managers.chat:_receive_message(1, lang.menu_button_announce_cooker, string.format("%s", lang.menu_button_announce_enable_warning), tweak_data.system_chat_color)
end
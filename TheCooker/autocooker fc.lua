local lang = localization_TC:get_language()
if global_toggle_meth then
	global_flare_circuit = global_flare_circuit or false
	if not global_flare_circuit then
		global_toggle_flare_circuit = true
		managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_circuit_on),  Color.green)
	else
		global_toggle_flare_circuit = false
		managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_circuit_off),  Color.red)
	end
	global_flare_circuit = not global_flare_circuit
else
	managers.chat:_receive_message(1, lang.menu_button_circuit_cooker, string.format("%s", lang.menu_button_circuit_enable_warning), tweak_data.system_chat_color)
end
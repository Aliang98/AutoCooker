local lang = localization_TC:get_language()
if localization_TC.config.other.allow_cooker then
	dofile(localization_TC.config.other.file_path.."auto secure/secure bags.lua")
	
	global_secure_all = global_secure_all or false
	if not global_secure_all then
		global_secure_all_toggle = true

		BetterDelayedCalls_TC:Add("find_secure_bags", 4, function() 
			secure_bags:find_bags()
		end, true)
		
		--managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_secure_all_on),  Color.green)
		managers.chat:_receive_message(1, lang.menu_button_secure_cooker, string.format("%s", lang.menu_button_secure_all_on), Color.green)
	else
		global_secure_all_toggle = false
		
		BetterDelayedCalls_TC:Remove("find_secure_bags")
		
		--managers.mission._fading_debug_output:script().log(string.format("%s", lang.menu_button_secure_all_off),  Color.red)
		managers.chat:_receive_message(1, lang.menu_button_secure_cooker, string.format("%s", lang.menu_button_secure_all_off), Color.red)
	end
	global_secure_all = not global_secure_all
else
	managers.chat:_receive_message(1, lang.menu_button_secure_cooker, string.format("%s", lang.allow_cooker_msg), tweak_data.system_chat_color)
end
local function total_xp()
	local num_alive_players = managers.network:session():amount_of_alive_players()
	return managers.experience:get_xp_dissected(true, num_alive_players, true)
end
	
BetterDelayedCalls_TC:Add("the_cooker_delay_exp_id", 360, function()
	if localization_TC["config"]["other"]["show_experience"] then
		local total_exp = total_xp()
		if total_exp and total_exp > 0 then
			local ex_string = managers.experience:experience_string(total_exp)
			managers.chat:_receive_message(1, lang.cooker, string.format("[%s] experience gained so far.", ex_string), tweak_data.system_chat_color)
		end
	end
end, true)
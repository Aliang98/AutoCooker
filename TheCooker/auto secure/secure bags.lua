if rawget(_G, "secure_bags") then
	rawset(_G, "secure_bags", nil)
end

if not rawget(_G, "secure_bags") then
	rawset(_G, "secure_bags", {
		player_unit = managers.player:player_unit(),
		is_server = Network:is_server(),
		secure_msg = false
	})
	
	local lang = localization_TC:get_language()
	local internal_carry_names = {
		["meth"] = lang.secure_meth,
		["meth_half"] = lang.secure_half_meth,
		["present"] = lang.secure_present,
		["counterfeit_money"] = lang.secure_money
	}
	
	dofile(localization_TC.config.other.file_path.."auto secure/secure.lua")

	function can_interact()
		return true
	end

	function secure_bags:is_host_or_client_msg(msg)
		if self.is_server then
			managers.chat:send_message(1, managers.network.system, msg)
		else
			managers.chat:send_message(ChatManager.GAME, 1, msg)
		end
	end
	
	function secure_bags:annouce_secured_bags(id)
		--[[local text
		for k, v in pairs(internal_carry_names) do
			if (k == id) then
				text = v
				break
			end
		end
		
		if self.secure_msg then
			local msg = string.format("%s %s", text, lang.bag_secured)
			if global_semi_auto_toggle then
				managers.mission._fading_debug_output:script().log(msg, Color("FFD700"))
			elseif global_announce_toggle then
				self:is_host_or_client_msg(msg)
			elseif not global_announce_toggle then
				managers.chat:_receive_message(1, lang.cooker, msg, tweak_data.system_chat_color)
			end
			self.secure_msg = false
		end--]]
	end
	
	function secure_bags:find_bags()
		for _,unit in pairs(managers.interaction._interactive_units) do
			if not alive(unit) then 
				managers.mission._fading_debug_output:script().log(string.format(lang.auto_secure_bags_warning),  Color.green)
				return 
			end
			
			if not alive(secure_bags.player_unit) then 
				return 
			end
			
			managers.player:drop_carry()
			
			local interaction = unit:interaction()
			local carry = unit:carry_data()

			if unit and interaction and carry then
				local carry_tweak = tostring(tweak_data.carry[carry:carry_id()].bag_value)
				if (type(carry_tweak) == "string") then
					for k, v in pairs(internal_carry_names) do
						if (k == carry_tweak) then
							self.secure_msg = true
							interaction.can_interact = can_interact
							interaction:interact(secure_bags.player_unit)
							interaction.can_interact = nil
							auto_secure:secure_carry(carry_tweak, true)
							break
						end
					end
				end
			end
		end
	end
end
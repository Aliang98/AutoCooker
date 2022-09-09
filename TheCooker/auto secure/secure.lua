if not managers.job then
	return
end

if rawget(_G, "auto_secure") then
	rawset(_G, "auto_secure", nil)
end

if not rawget(_G, "auto_secure") then
	rawset(_G, "auto_secure", {
		id_level = managers.job:current_level_id(),
		level_table = {
			["rat"] = {
				position = Vector3(5700, -10625, 100)
			},
			["alex_1"] = {
				position = Vector3(5700, -10625, 100)
			},
			["cane"] = {
				position = Vector3(7837, -991, -475.28)
			},
			["crojob2"] = {
				position = Vector3(-3907, 9638, -118)
			},
			["nail"] = {
				position = Vector3(-10356.9, -322.8, -3020.3)
			},
			["mia_1"] = {
				position = Vector3(math.random(30000, 78000), math.random(-30000, -110000), 0)
			},
			["mex_cooking"] = {
				position = Vector3(math.random(30000, 78000), math.random(-30000, -110000), 0)
			},
			["pal"] = {
				position = Vector3(math.random(30000, 78000), math.random(-30000, -110000), 0)
			}
		}
	})
	
	local player_unit = managers.player:player_unit()
	
	function can_interact()
		return true
	end
	
	function auto_secure:drop_carry(pos, bag_name)
		if not pos then
			return
		end
		
		local carry_data = managers.player:get_my_carry_data()
		local rotation = player_unit:camera():rotation()
		local forward = Vector3(0, 0, 0)
		if carry_data then
			if Network:is_server() then
				managers.player:server_drop_carry(carry_data.carry_id, carry_data.multiplier, carry_data.dye_initiated, carry_data.has_dye_pack, carry_data.dye_value_multiplier, pos, rotation, forward, 0, zipline_unit, managers.network:session():local_peer())
			else
				managers.network:session():send_to_host("server_drop_carry", carry_data.carry_id, carry_data.multiplier, carry_data.dye_initiated, carry_data.has_dye_pack, carry_data.dye_value_multiplier, pos, rotation, forward, 0, zipline_unit)
			end

			managers.player:clear_carry()
			
			if global_secure_all_toggle then
				secure_bags:annouce_secured_bags(bag_name)
			end
		end
	end
	
	function auto_secure:drop_carry_client(pos, bag_name)
		if not pos then
			return
		end
		
		local rotation = player_unit:camera():rotation()
		local forward = Vector3(0, 0, 0)
		managers.network:session():send_to_host('server_drop_carry', bag_name, 1, false, false, 1, pos, Vector3(math.random(-180, 180), math.random(-180, 180), 0), Vector3(0, 0, 1), 1, nil)
	end
	
	function auto_secure:interact(unit, interaction_name)
		if alive(player_unit) then
			local interaction = unit:interaction()
			local carry = unit:carry_data()
			if interaction and carry and (carry:carry_id() == interaction_name) then
				interaction.can_interact = can_interact
				interaction:interact(player_unit)
				interaction.can_interact = nil
			end
		end
	end
	
	function auto_secure:secure_drop(unit, bag_name)
		self:interact(unit, bag_name)
		self:drop_carry(self.level_table[self.id_level].position, bag_name)
	end
	
	function auto_secure:secure_carry(bag_name, bypass)
		if BLT_CarryStacker or PlayerManager.carry_stack or PlayerManager.stack_table then
			local carry_bags
			if PlayerManager.carry_stack then
				carry_bags = #PlayerManager.carry_stack
			elseif PlayerManager.stack_table then
				carry_bags = #PlayerManager.stack_table
			elseif BLT_CarryStacker.stack then
				carry_bags = #BLT_CarryStacker.stack
			end
			
			local count_table
			if carry_bags then
				count_table = carry_bags + (managers.player:is_carrying() and 1 or 0)
			else
				count_table = (managers.player:is_carrying() and 1 or 0)
			end
			
			for i = 1, count_table do
				if bypass or Network:is_server() then
					self:drop_carry(self.level_table[self.id_level].position, bag_name)
				else
					self:drop_carry_client(self.level_table[self.id_level].position, bag_name)
				end
			end

			managers.hud:remove_special_equipment("carrystacker")
			return
		end
		
		if bypass or Network:is_server() then
			self:drop_carry(self.level_table[self.id_level].position, bag_name)
		else
			self:drop_carry_client(self.level_table[self.id_level].position, bag_name)
		end
	end
	
	function auto_secure:secure_fake(bag_name)
		managers.loot:secure(bag_name, managers.money:get_bag_value(bag_name), true)
	end
end
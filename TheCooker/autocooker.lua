Color.labia = Color("E75480") --acid
Color.lilac = Color("D891EF") --caustic soda
Color.purple = Color("9932CC") --hydrogen chloride
Color.wip = Color("0D98BA") --take meth
Color.customyellow = Color("fbff00") --circuit
Color.customred = Color("ff8400") --flare
Color.customwhite = Color("ffffff") --waypoints

--globals to save performance
local lang = localization_TC:get_language()
local is_server = Network:is_server()
local player_unit = managers.player:player_unit()
local id_level = managers.job:current_level_id()

bag_amount = 1
local file_path = localization_TC.config.other.file_path.."%s"
local prop_path = "units/pd2_dlc_nails/props/nls_prop_methlab_meth/%s"
local finish_first = 0
local meth_loop_check = 1
local cooking_waypoint = cooking_waypoint or nil
local msg = {lang.mu, lang.cs, lang.hcl, lang.flare, lang.circuit, lang.transformer, lang.pill, lang.added, lang.needed}
local colormsg = {Color.labia, Color.lilac, Color.purple, Color.customyellow, Color.customred, Color.customwhite, Color.customwhite}
local addfake = {'acid', 'caustic_soda', 'hydrogen_chloride'}
local addreal = {'muriatic_acid', 'caustic_soda', 'hydrogen_chloride', 'place_flare', 'circuit_breaker', 'transformer_box', 'pku_pills'}
local needed_chem = {'methlab_bubbling', 'methlab_caustic_cooler', 'methlab_gas_to_salt', 'taking_meth'}
local blacklist = {'taking_meth', 'pku_pills', 'taking_meth_huge', 'hold_pku_present', 'hold_take_counterfeit_money'}
local nail_bag_table = {"nail_muriatic_acid", "nail_caustic_soda", "nail_hydrogen_chloride", "nail_euphadrine_pills"}
local counterfeit_int_names = {"press_plates", "hold_insert_paper_roll", "hold_insert_printer_ink", "hold_start_printer"}
local counterfeit_msgs = {lang.counterfeit_press_plates, lang.counterfeit_h_insert_paper_roll, lang.counterfeit_h_insert_printer_ink, lang.counterfeit_h_start_printer}
local lab_rat_chem_loc = {
	[1] = Vector3(868.6, -754.2, 1578.6), 
	[2] = Vector3(-4116.9, 580.7, 1456.8), 
	[3] = Vector3(-5638.2, -821.3, 1213), 
	[4] = Vector3(1320, -52, 0)
} 
local lab_rat_prop_path = {
	string.format(prop_path, "nls_prop_methlab_meth"),
	string.format(prop_path, "nls_prop_methlab_meth_a"),
	string.format(prop_path, "nls_prop_methlab_meth_b"),
	string.format(prop_path, "nls_prop_methlab_meth_c"),
	string.format(prop_path, "nls_prop_methlab_meth_d")
}

if not global_unit_remove_backup then global_unit_remove_backup = ObjectInteractionManager.remove_unit end
function ObjectInteractionManager.remove_unit(self, unit)
	if (cooking_waypoint == unit:interaction().tweak_data) then
		managers.hud:remove_waypoint(tostring(unit:interaction().tweak_data))
		cooking_waypoint = nil
	end
	managers.hud:remove_waypoint(tostring(unit:interaction().tweak_data))
	global_unit_remove_backup(self, unit)
end

function can_interact()
	return true
end

function interactbytweak(inter, check, bypass)
	if not alive(player_unit) then return end
	for _,unit in pairs(World:find_units_quick("all", 1)) do
		local interaction = unit:interaction()
		if interaction then
			if (interaction.tweak_data == inter) and interaction._active then
			
				if check then
					return true
				end
				
				if (localization_TC.config.other.bypass_ing_check) then
					interaction.can_interact = can_interact
				end
				
				if bypass then
					interaction:interact(player_unit)
					return
				end
				
				if not global_semi_auto_toggle then
					interaction:interact(player_unit)
				else
					if localization_TC.config.other.use_waypoints then
						local icon = tweak_data.interaction[interaction.tweak_data].icon
						for i = math.random(1,5),5 do
							managers.hud:add_waypoint(tostring(interaction.tweak_data), {icon = icon or 'wp_standard', distance = true, position = interaction:interact_position(), no_sync = true, present_timer = 0, state = "present", radius = 10000, color = colormsg[i] or Color.customwhite, blend_mode = "add"})
							break
						end
						cooking_waypoint = interaction.tweak_data
					end
				end
				
				if (localization_TC.config.other.bypass_ing_check) then
					interaction.can_interact = nil
				end
				
				break
			end
		end
	end
end

global_toggle_meth = global_toggle_meth or false
if not global_toggle_meth then
	localization_TC.config.other.last_chem = nil
	localization_TC:save_config()

	dofile(string.format(file_path, "/auto secure/secure.lua"))

	--disable bain dialog but not on miami
	if not (id_level == "mia_1") then
		if not dialog_bain then dialog_bain = DialogManager.queue_dialog end
		function DialogManager.queue_dialog(self, id, params)
			if localization_TC.config.other.disable_bain then
				return
			end
			dialog_bain(self, id, params)
		end
	end

	local function is_server_msgs(msg)
		if is_server then
			managers.chat:send_message(1, managers.network.system, msg)
		else
			managers.chat:send_message(ChatManager.GAME, 1, msg)
		end
	end
	
	local function semi_auto_msgs(name, table, color)
		if not global_semi_auto_toggle then
			local msg_table_num
			if (name == addreal[4] or name == addreal[5] or name == addreal[6]) then
				msg_table_num = 9
			else
				msg_table_num = 8
			end
			
			for _, v in pairs(counterfeit_int_names) do
				if (name == v) then
					managers.mission._fading_debug_output:script().log(string.format('%s %s', table, msg[msg_table_num]), color)
				else
					managers.mission._fading_debug_output:script().log(string.format('%s %s', table, msg[msg_table_num]), color)
					break
				end
			end
		elseif global_announce_toggle then
			is_server_msgs(string.format("%s %s", table, msg[9]))
		elseif not global_announce_toggle then
			managers.chat:_receive_message(1, lang.cooker, string.format("%s %s", table, msg[9]), tweak_data.system_chat_color)
		end
	end

	local function addchem_and_announce(name, cook, addreal, addfake, color)
		local can_pickup = managers.player:can_pickup_equipment(addfake) --does'nt work client side, making it slow ni auto?
		
		if (localization_TC.config.other.bypass_ing_check) then
			interactbytweak(cook)
		elseif (interactbytweak(name, true) or not can_pickup) then
			if can_pickup then
				interactbytweak(addreal) --adds wp to chems on ground
			end
		
			DelayedCalls:Add("interact_chems", 0.3, function()
				interactbytweak(cook)
			end)
		end
		
		if not global_semi_auto_toggle and ((localization_TC.config.other.bypass_ing_check) or (interactbytweak(addreal, true) or not can_pickup)) then
			find_table_name(name, 1, 3, msg, nil, "semi")
		elseif global_semi_auto_toggle then
			find_table_name(name, 1, 3, msg, nil, "semi")
		end
	end

	function find_table_name(name, to, from, table, cook, check)
		for i=to,from do
			if (name == addreal[i] or name == counterfeit_int_names[i]) then
				if (check == "dialog") then
					addchem_and_announce(name, cook, addreal[i], addfake[i], colormsg[i])
				elseif (check == "semi") then
					semi_auto_msgs(name, table[i], colormsg[i])
				end
			end
		end
	end
	
	local function announce_bagged(carry, num)
		local BagList = {}
		local bags_on_map
		
		for _,unit in pairs(managers.interaction._interactive_units) do
			local interaction = (alive(unit) and (unit['interaction'] ~= nil)) and unit:interaction()
			if interaction then
				local carry = unit:carry_data()
				if carry then
					table.insert(BagList, carry:carry_id())
				end
			end
		end
		
		if not bags_on_map then 
			bags_on_map = string.format(". %s %s", #BagList, lang.bags_on_ground)
		end
		
		DelayedCalls:Add("annouce_delay", 1, function()
			if not alive(player_unit) then return end
			
			if carry and num then
				bag_amount = bag_amount + tonumber(num)
			end
			
			local secured_bags_on_map = (managers.loot:get_secured_mandatory_bags_amount()) + (managers.loot:get_secured_bonus_bags_amount())
			local bags_secured_msg = string.format(". %s %s", secured_bags_on_map, lang.bag_secured)
			if not global_toggle_bag_meth and global_announce_toggle and bags_on_map then
				is_server_msgs(string.format("%s%s%s", lang.bag_on_table, bags_on_map, bags_secured_msg))
			elseif global_announce_toggle and bags_on_map and global_auto_secure then
				is_server_msgs(string.format("%s %s%s%s", tostring(bag_amount), lang.secured_bag, bags_on_map, bags_secured_msg))
			elseif global_announce_toggle and bags_on_map then
				is_server_msgs(string.format("%s %s%s%s", tostring(bag_amount), lang.bag_bagged, bags_on_map, bags_secured_msg))
			else
				if not global_toggle_bag_meth then
					managers.chat:_receive_message(1, lang.cooker, string.format("%s%s%s", lang.bag_on_table, bags_on_map, bags_secured_msg), tweak_data.system_chat_color)
				elseif global_auto_secure then
					managers.chat:_receive_message(1, lang.cooker, string.format("%s %s%s%s", tostring(bag_amount), lang.secured_bag, bags_on_map, bags_secured_msg), tweak_data.system_chat_color)
				else
					managers.chat:_receive_message(1, lang.cooker, string.format("%s %s%s%s", tostring(bag_amount), lang.bag_bagged, bags_on_map, bags_secured_msg), tweak_data.system_chat_color)
				end
			end
			
			if carry and num then
				bag_amount = bag_amount - tonumber(num)
			end
		end)
	end
	
	if not toggle_meth_orig then toggle_meth_orig = ObjectInteractionManager.add_unit end
	function ObjectInteractionManager.add_unit(self, unit)
		toggle_meth_orig(self, unit)

		if global_allowed_mod and (id_level == 'crojob2' or id_level == 'mia_1') then
			if not global_auto_bag_meth then
				global_toggle_bag_meth = true
				global_auto_bag_meth = not global_auto_bag_meth
			end
		end
		
		local interaction = unit:interaction()
		if unit and interaction then
			if not alive(player_unit) then return end
			local set_take_bag_type
			local set_take_stationary
			local carry_data = managers.player:get_my_carry_data()
			local pos = interaction:interact_position()
			local position2 = Vector3(pos.x + (-50 or 0), pos.y, pos.z + 40)
			local position = position2 or player_unit:camera():position()
			local rotation = player_unit:camera():rotation()
			local forward = player_unit:camera():forward()

			if global_toggle_flare_circuit then
				DelayedCalls:Add("ac_anti_obstacle", 1, function()
					if not alive(player_unit) then return end
					if (id_level == 'alex_1' or id_level == 'rat' or id_level == 'pal') then
						for i=4,6 do
							if (interaction.tweak_data == addreal[i]) and not (interaction.tweak_data == needed_chem[i] or interaction.tweak_data == needed_chem[i] or interaction.tweak_data == needed_chem[i]) then
								interactbytweak(addreal[i])
								if (id_level == 'pal') then
									find_table_name(addreal[i], 5, 6, msg, nil, "semi")
								else
									find_table_name(addreal[i], 4, 5, msg, nil, "semi")
								end
							end						
						end
					end
				end)
			end
			
			if (id_level == 'pal') then
				DelayedCalls:Add("ac_counterfeit_objectives", 1, function()
					for i=1,4 do
						if (interaction.tweak_data == counterfeit_int_names[i]) then
							if not global_semi_auto_toggle then
								interactbytweak(counterfeit_int_names[i])
							end
							find_table_name(counterfeit_int_names[i], 1, 4, counterfeit_msgs, nil, "semi")
						end						
					end
				end)
			end
			
			if interaction.tweak_data == 'pku_pills' then set_take_bag_type = "nail_euphadrine_pills" set_take_stationary = "pku_pills" end
			if interaction.tweak_data == 'taking_meth_huge' then set_take_bag_type = "meth_half" set_take_stationary = "taking_meth_huge" end
			if interaction.tweak_data == 'taking_meth' then set_take_bag_type = "meth" set_take_stationary = "taking_meth" end
			if interaction.tweak_data == 'hold_pku_present' then set_take_bag_type = "present" set_take_stationary = "hold_pku_present" end
			if interaction.tweak_data == 'hold_take_counterfeit_money' then set_take_bag_type = "counterfeit_money" set_take_stationary = "hold_take_counterfeit_money" end
			if not set_take_bag_type and not set_take_stationary then return end

			local timer
			if id_level == "nail" then
				timer = 2.1
			else
				timer = 2.5
			end
			
			if global_toggle_bag_meth and timer then
				DelayedCalls:Add("the_cooker_bag_delay", timer, function() --add unit function runs two times, this prevent it
					if carry_data and (set_take_stationary == "taking_meth") and (carry_data.carry_id == "equipment_bag" or carry_data.carry_id == "cro_loot2" or carry_data.carry_id == "cro_loot1") then
						managers.player:drop_carry()
					elseif (set_take_stationary == "taking_meth_huge") and (interaction.tweak_data == set_take_stationary) then
						BetterDelayedCalls_TC:Add("drop_bags_3_times_meth_done", 1.3, function()
							managers.player:drop_carry()
							interactbytweak(set_take_stationary, false, true)
							if global_auto_secure then
								auto_secure:secure_carry(set_take_bag_type)
								if (bag_amount > 1) then
									for i = 1, bag_amount do
										managers.loot:secure(set_take_bag_type, managers.money:get_bag_value(set_take_bag_type), true)
									end
									announce_bagged(true, 1)
								else
									announce_bagged()
								end
							else
								drop_bag(set_take_bag_type, position, true)
								if (bag_amount > 1) then
									for i = 1, bag_amount do
										drop_bag(set_take_bag_type, position, true)
									end
									announce_bagged(true, 1)
								else
									announce_bagged()
								end
							end
						end, 4)
						return
					elseif (set_take_stationary == "pku_pills") and (interaction.tweak_data == set_take_stationary) then
						managers.player:drop_carry()
						interactbytweak(set_take_stationary)
						DelayedCalls:Add("interact_zipline", 1, function()
							if not alive(player_unit) then return end
							find_drop_bag(nail_bag_table[4], lab_rat_chem_loc[4], false, 1, nil, true)
						end)
						return
					end
				
					if interaction.tweak_data == set_take_stationary then
						carry_data = managers.player:get_my_carry_data() --updates carry data
						if is_server then
							interaction:interact(managers.player:player_unit())
							if carry_data then
								if global_auto_secure then
									auto_secure:secure_carry(set_take_bag_type)
									for i = 1, bag_amount do
										managers.loot:secure(set_take_bag_type, managers.money:get_bag_value(set_take_bag_type), true)
									end
									announce_bagged(true, 1)
								else
									for i = 1, bag_amount do
										managers.player:server_drop_carry(set_take_bag_type, 1, false, false, 1, position, Vector3(math.random(-180, 180), math.random(-180, 180), 0), Vector3(0, 0, 1), 100, nil)
									end
									announce_bagged()
								end
							else
								managers.player:clear_carry()
								if global_auto_secure then
									for i = 1, bag_amount do
										managers.loot:secure(set_take_bag_type, managers.money:get_bag_value(set_take_bag_type), true)
									end
								else
									for i = 1, bag_amount do
										managers.player:server_drop_carry(set_take_bag_type, 1, false, false, 1, position, Vector3(math.random(-180, 180), math.random(-180, 180), 0), Vector3(0, 0, 1), 100, nil)
									end
								end
								announce_bagged()
							end
						else
							if carry_data then
								if global_auto_secure then --test 2 rounds with bag_amount
									auto_secure:secure_carry(set_take_bag_type)
									interaction:interact(managers.player:player_unit())
									managers.player:clear_carry()
									auto_secure:secure_carry(set_take_bag_type)
									if bag_amount > 1 then
										bag_amount = bag_amount - 1
										for i = 1, bag_amount do
											managers.loot:secure(set_take_bag_type, managers.money:get_bag_value(set_take_bag_type), true) 
										end
									end
									announce_bagged(true, 1)
								else --test 2 rounds with and without bag_amount
									for i = 1, bag_amount do
										managers.network:session():send_to_host('server_drop_carry', set_take_bag_type, 1, false, false, 1, position, Vector3(math.random(-180, 180), math.random(-180, 180), 0), Vector3(0, 0, 1), 100, nil)
										managers.player:clear_carry()
										interaction:interact(managers.player:player_unit())
									end
									announce_bagged()
								end
							else
								if global_auto_secure then
									interaction:interact(managers.player:player_unit())
									managers.player:clear_carry()
									auto_secure:secure_carry(set_take_bag_type)
									if bag_amount > 1 then
										bag_amount = bag_amount - 1
										for i = 1, bag_amount do
											managers.loot:secure(set_take_bag_type, managers.money:get_bag_value(set_take_bag_type), true) 
										end
										bag_amount = bag_amount + 1
									end
								else --test bag_amount
									interaction:interact(managers.player:player_unit())
									managers.player:clear_carry()
									for i = 1, bag_amount do
										managers.network:session():send_to_host('server_drop_carry', set_take_bag_type, 1, false, false, 1, position, Vector3(math.random(-180, 180), math.random(-180, 180), 0), Vector3(0, 0, 1), 100, nil)
									end
								end
								announce_bagged()
							end
						end
						
						if BLT_CarryStacker or PlayerManager.carry_stack or PlayerManager.stack_table then
							local carry_stacker
							if PlayerManager.carry_stack then
								carry_stacker = #PlayerManager.carry_stack
								PlayerManager.carry_stack[carry_stacker] = nil
							elseif PlayerManager.stack_table then
								carry_stacker = #PlayerManager.stack_table
								PlayerManager.stack_table[carry_stacker] = nil
							elseif BLT_CarryStacker.stack then
								carry_stacker = #BLT_CarryStacker.stack
								BLT_CarryStacker.stack[carry_stacker] = nil
							end
							managers.hud:remove_special_equipment("carrystacker")
							if tonumber(carry_stacker) and (tonumber(carry_stacker) > 0) then
								managers.hud:add_special_equipment({id = "carrystacker", icon = "pd2_loot", amount = carry_stacker})
							end
						end
						
						meth_loop_check = 1
					end
				end)
			else
				DelayedCalls:Add("the_cooker_interact_objects2", 0.4, function()
					if not alive(player_unit) then return end
					if (interaction.tweak_data == set_take_stationary) then
						if not (id_level == "nail") then
							announce_bagged()
						else
							if (set_take_stationary == "pku_pills") then
								DelayedCalls:Add("interact_zipline", 1, function()
									if not alive(player_unit) then return end
									find_table_name("pku_pills", 7, 7, msg, nil, "semi")
								end)
							elseif (set_take_stationary == "taking_meth_huge") then
								BetterDelayedCalls_TC:Add("drop_bags_3_times_meth_done", 1.3, function()
									announce_bagged()
								end, 4)
							end
						end
						meth_loop_check = 1
					end
				end)
			end
			localization_TC.config.other.last_chem = nil
			localization_TC:save_config()
		end
	end
	
	function drop_bag(name, position, bypass)
		if bypass or not global_semi_auto_toggle then
			local player = player_unit
			if not alive(player) then return end
			local carry_data = managers.player:get_my_carry_data()
			if carry_data and (carry_data.carry_id == name) or bypass then
				local forward = player:camera():forward()
				local throw_force = managers.player:upgrade_level("carry", "throw_distance_multiplier", 0) - 1.5
				local carry_data = tweak_data.carry[name]
				local rotation = Rotation(player:camera():rotation():yaw(), 0, 0)
				if is_server then
					managers.player:server_drop_carry(name, carry_data.multiplier, carry_data.dye_initiated, carry_data.has_dye_pack, carry_data.dye_value_multiplier, position, rotation, forward, throw_force, nil, managers.network:session():local_peer())
				else
					managers.network:session():send_to_host("server_drop_carry", name, carry_data.multiplier, carry_data.dye_initiated, carry_data.has_dye_pack, carry_data.dye_value_multiplier, position, rotation, forward, throw_force, nil)
				end
				managers.hud:remove_teammate_carry_info(HUDManager.PLAYER_PANEL)
				managers.hud:temp_hide_carry_bag()
				managers.player:update_removed_synced_carry_to_peers()
				if managers.player._current_state == "carry" then
					managers.player:set_player_state("standard")
				end
				carry_data = managers.player:get_my_carry_data()
			end
		end
	end
	
	function find_drop_bag(id, pos, toggle, counter, msgs, bypass)
		if bypass or not global_semi_auto_toggle then
			local carry_data = managers.player:get_my_carry_data()
			if carry_data and (carry_data.carry_id ~= nail_bag_table[4]) then
				managers.player:drop_carry()
			end
			BetterDelayedCalls_TC:Add("drop_bags_3_times", 3, function()
				for _,unit in pairs(managers.interaction._interactive_units) do
					local interaction = (alive(unit) and (unit['interaction'] ~= nil)) and unit:interaction()
					local carry_data = managers.player:get_my_carry_data()
					if interaction and interaction._active then
						local carry = unit:carry_data()
						if (unit:position() == pos) and carry_data and (carry_data.carry_id == nail_bag_table[4]) then
							interaction:interact(player_unit)
							break
						elseif carry and (carry:carry_id() == id) and not carry_data then
							interaction:interact(player_unit)
							break
						end
					end
					carry_data = managers.player:get_my_carry_data()
				end
				if toggle then 
					drop_bag(id, pos)
				end
			end, counter)
		end
		if (id ~= nail_bag_table[4]) then
			find_table_name(msgs, 1, 3, msg, nil, "semi")
		end
	end
	
	local dialog_table = {
		--border crystal, cook off, rats
		"pln_rt1_20", --mu
		"Play_loc_mex_cook_03", --mu
		"pln_rt1_22", --cs
		"Play_loc_mex_cook_04", --cs
		"pln_rt1_24", --hcl
		"Play_loc_mex_cook_05", --hcl
		
		--lab rats
		"pln_rat_stage1_20", --mu
		"pln_rat_stage1_22", --cs
		"pln_rat_stage1_24", --hcl
	}
	
	local function goto_ids(id)
		if (id_level == "nail") then
			if (id == dialog_table[1]) or (id == dialog_table[7]) then
				find_drop_bag(nail_bag_table[1], lab_rat_chem_loc[1], true, 3, "muriatic_acid")
			elseif (id == dialog_table[3]) or (id == dialog_table[8]) then
				find_drop_bag(nail_bag_table[2], lab_rat_chem_loc[2], true, 3, "caustic_soda")
			elseif (id == dialog_table[5]) or (id == dialog_table[9]) then
				find_drop_bag(nail_bag_table[3], lab_rat_chem_loc[3], true, 3, "hydrogen_chloride")
			end
		else
			if (id == dialog_table[1]) or (id == dialog_table[2]) then -- acid
				find_table_name("muriatic_acid", 1, 3, nil, "methlab_bubbling", "dialog")
			elseif (id == dialog_table[3]) or (id == dialog_table[4]) then -- caustic soda 
				find_table_name("caustic_soda", 1, 3, nil, "methlab_caustic_cooler", "dialog")
			elseif (id == dialog_table[5]) or (id == dialog_table[6]) then -- chloride 
				find_table_name("hydrogen_chloride", 1, 3, nil, "methlab_gas_to_salt", "dialog")
			end
		end
	end
	
	local function check_dialog(id, save)
		local dialog
		for k,v in pairs(dialog_table) do
			if (id == v) then
				if save then
					localization_TC.config.other.last_chem = id
					localization_TC:save_config()
					goto_ids(id)
				else
					dialog = false
				end
				break
			else
				dialog = true
			end
		end
		return dialog
	end
	
	--border crystal, cook off, rats, lab rats
	local queue_dialog_original = DialogManager.queue_dialog
	function DialogManager.queue_dialog(self, id, params)
		if global_anti_spam_toggle then
			if localization_TC["config"]["other"]["last_chem"] and (localization_TC["config"]["other"]["last_chem"] == id) then
				local dialog = check_dialog(id)
				if dialog == true then
					goto_ids(id)
				end
			else
				check_dialog(id, true)
			end
		else
			goto_ids(id)
		end
		return queue_dialog_original(self, id, params)
	end

	--miami, dockyard
	local function other_meth_func()
		for _, tracked_interaction in pairs({'methlab_bubbling', 'taking_meth'}) do 
			for _,unit in pairs(managers.interaction._interactive_units) do
				local interaction = (alive(unit) and (unit['interaction'] ~= nil)) and unit:interaction()
				if interaction and (interaction.tweak_data == tracked_interaction) then
					if meth_loop_check ~= 4 then
						if meth_loop_check <= 3 then
							find_table_name(addreal[meth_loop_check], 1, 3, nil, nil, "dialog")
						end
						interactbytweak(needed_chem[meth_loop_check])
						meth_loop_check = meth_loop_check + 1
						break
					end
				end
			end
		end
	end
	
	--santa workshop
	local function auto_cooker_santa()
		for _, data in pairs(managers.enemy:all_civilians()) do
			if not alive(player_unit) then return end
			data.unit:brain():on_intimidated(100, player_unit)
		end
	end
	
	--nail crack meth
	local function killobjectunit(unit)
		for i = 0, unit:num_bodies() do
			local body = unit:body(i)
			if ( body and body:enabled() ) and ( body:unit():id() ~= -1 ) then
				local center = body:center_of_mass()
				local pos = body:position()
				local unit_damage = body:extension() and body:extension().damage
				local damage_val = 5000
				local user_unit = player_unit
				if unit_damage and is_server then
					if finish_first <= 5 then
						unit_damage:damage_explosion( user_unit, center, pos, Vector3(0,0,0), damage_val )
						unit_damage:damage_damage( user_unit, center, pos, center, damage_val )
						finish_first = finish_first + 1
					else
						unit_damage:damage_explosion( user_unit, center, pos, Vector3(0,0,0), damage_val )
						unit_damage:damage_damage( user_unit, center, pos, center, damage_val )
					end
					
					local session = managers.network:session()
					local pUnit = player_unit
					if alive(pUnit) then
						session:send_to_peers_synched( "sync_body_damage_explosion", body, pUnit, center, pos, center, damage_val )
					else
						session:send_to_peers_synched( "sync_body_damage_explosion_no_attacker", body, center, pos, center, damage_val )
					end
					managers.network:session():send_to_peers_synched( "remove_unit", body )
				end
			end
		end
	end
	
	--nail
	local function crack_meth()
		for _, unit in ipairs(World:find_units_quick("all", 1)) do
			for _, u_data in pairs(lab_rat_prop_path) do
				if (unit:name() == Idstring(u_data)) then
					killobjectunit(unit)
				end
			end
		end
	end
	
	--counterfeit
	local function counterfeit_loop()
		if not global_semi_auto_toggle then
			interactbytweak("press_plates")
			interactbytweak("hold_insert_plates")
			interactbytweak("press_printer_paper")
			interactbytweak("hold_insert_paper_roll")
			interactbytweak("press_printer_ink")
			interactbytweak("hold_insert_printer_ink")
			interactbytweak("hold_start_printer")
		end
	end
	
	function start_counterfeit()
		interactbytweak("crate_loot_crowbar")
		BetterDelayedCalls_TC:Add("counterfeit", 4, function() counterfeit_loop() end, true) 
	end
	
	if (id_level == 'pal') then start_counterfeit() end
	if (id_level == 'nail') then BetterDelayedCalls_TC:Add("crack_meth", 2.5, function() crack_meth() end, true) end
	if (id_level == 'crojob2' or id_level == 'mia_1') then BetterDelayedCalls_TC:Add("hotcounter_spawn_meth_chemica", 1.5, function() other_meth_func() end, true) end
	if (id_level == "cane") then BetterDelayedCalls_TC:Add("santa_workshop_spawn_meth_chemica", 0.5, function() auto_cooker_santa() end, true) end
	--managers.mission._fading_debug_output:script().log(string.format('%s %s', lang.cooker, lang.menu_button_autocook_on), Color.green)
	managers.chat:_receive_message(1, lang.cooker, string.format('%s', lang.menu_button_autocook_on), Color.green)
else
	bag_amount = 1
	if (id_level == 'nail') then
		BetterDelayedCalls_TC:Remove("drop_bags_3_times")
		BetterDelayedCalls_TC:Remove("crack_meth")
		BetterDelayedCalls_TC:Remove("drop_bags_3_times_meth_done")
	end
	if (id_level == 'pal') then BetterDelayedCalls_TC:Remove("counterfeit") end
	if (id_level == 'rat') then BetterDelayedCalls_TC:Remove( "rats_ac_anti_spam") end
	if (id_level == 'crojob2' or id_level == 'mia_1') then BetterDelayedCalls_TC:Remove( "hotcounter_spawn_meth_chemica") end
	if (id_level == 'cane') then BetterDelayedCalls_TC:Remove( "santa_workshop_spawn_meth_chemica") end
	if global_unit_remove_backup then ObjectInteractionManager.remove_unit = global_unit_remove_backup end
	if toggle_meth_orig then ObjectInteractionManager.add_unit = toggle_meth_orig end
	if global_ac_secure then global_auto_secure = false global_ac_secure = not global_ac_secure end
	if global_auto_bag_meth then global_toggle_bag_meth = false global_auto_bag_meth = not global_auto_bag_meth end
	if global_flare_circuit then global_toggle_flare_circuit = false global_flare_circuit = not global_flare_circuit end
	if global_semi_auto then global_semi_auto_toggle = false global_semi_auto = not global_semi_auto end
	if global_announce then global_announce_toggle = false global_announce = not global_announce end
	if global_spam_ac then global_anti_spam_toggle = false global_spam_ac = not global_spam_ac end
	if dialog_bain then DialogManager.queue_dialog = dialog_bain end
	--managers.mission._fading_debug_output:script().log(string.format('%s %s', lang.cooker, lang.menu_button_autocook_off), Color.red)
	managers.chat:_receive_message(1, lang.cooker, string.format('%s', lang.menu_button_autocook_off), Color.red)
end
global_toggle_meth = not global_toggle_meth
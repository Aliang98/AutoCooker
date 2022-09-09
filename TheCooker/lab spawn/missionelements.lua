if not (rawget(_G, "localization_TC") and Network:is_server() and managers.job) then
	return
end

local flare_table = {
	--flare spawn 1 - 102261
	--102290, --interact flare
	--102203, --waypoint flare
	--102205, --flare on ground
	[102245] = true, --effect
	[102249] = true, --sound
	[102115] = true, --supply bag
	[102152] = true, --supply bag waypoint
	
	--flare spawn 2 - 102260
	--102291, --interact flare
	--102202, --waypoint flare
	--102207, --flare on ground
	[102250] = true, --effect
	[102251] = true, --sound
	[102116] = true, --supply bag
	[102153] = true, --supply bag waypoint
	
	--flare spawn 3 - 102259
	--102292, --interact flare
	--102201, --waypoint flare
	--102208, --flare on ground
	[102252] = true, --effect
	[102253] = true, --sound
	[102117] = true, --supply bag
	[102154] = true --supply bag waypoint
}

local function run_event(event)
	local player = managers.player:player_unit()
	if not (player or alive(player)) then
		return
	end
	for _, data in pairs(managers.mission._scripts) do
		for id, element in pairs(data:elements()) do
			if (id == event) then
				element:on_executed(player)
				break
			end
		end
	end
end
local time = 600 --seconds before vent close, def 50-60sec
local id_level = managers.job:current_level_id()
if string.lower(RequiredScript) == "core/lib/managers/mission/coremissionscriptelement" and _G["MissionScriptElement"] ~= nil then
	local orig_MissionScriptElement_init = MissionScriptElement.init
	function MissionScriptElement.init(self, ...)
		orig_MissionScriptElement_init(self, ...)
		
		if id_level and (id_level == "pal") then
			if localization_TC["config"]["other"]["twitch_stay_close_pal"] then
				if self._id == 134763 then
					self._values.enabled = false
				elseif self._id == 134813 then
					self._values.enabled = false
				elseif self._id == 134863 then
					self._values.enabled = false
				elseif self._id == 134713 then
					self._values.enabled = false
				end
			end
		elseif id_level and (id_level == "rat") then
			if localization_TC["config"]["other"]["twitch_stay_close"] and (self._id == 102316) then
				self._values.enabled = false
			end
			
			if localization_TC["config"]["other"]["meth_lab_disable_top"] and (self._id == 100483) then
				self._values.enabled = false
			end
			
			if localization_TC["config"]["other"]["meth_lab_disable_middle"] and (self._id == 100485) then
				self._values.enabled = false
			end
			
			if localization_TC["config"]["other"]["meth_lab_roof"] and (self._id == 100330) then
				self._values.rotation = Rotation(-90, 0, -0)
				--roof lab position x, y, z (x and y being right or left. z being the hight of the lab)
				self._values.position = Vector3(1964.79, 700.00, 2100.00)
			end
			
			if localization_TC["config"]["other"]["meth_lab_basement"] and (self._id == 100486) then
				self._values.enabled = true
			end
			
			if localization_TC["config"]["other"]["meth_lab_basement"] and (self._id == 100332) then
				self._values.rotation = Rotation(-90, 0, -0)
				--basement lab position x, y, z (x and y being right or left. z being the hight of the lab)
				self._values.position = Vector3(1900, 875, 924.84) --Vector3(2080, 975, 924.84)
			end
			
			if flare_table[self._id] then
				if localization_TC["config"]["other"]["supply_bag_spawn_balcony"] then --flare balcony	
					self._values.position = Vector3(2416.56, 454.75, 1732.52)
				elseif localization_TC["config"]["other"]["supply_bag_spawn_first_floor"] then --flare first floor
					self._values.position = Vector3(1867.92, 1348.91, 1340.93)
				elseif localization_TC["config"]["other"]["supply_bag_spawn_second_floor"] then --flare second floor
					self._values.position = Vector3(1623.996, 762.787, 1740.94)
				elseif localization_TC["config"]["other"]["supply_bag_spawn_basement_floor"] then --flare basement
					self._values.position = Vector3(1797.26, 482.39, 940.93)
				elseif localization_TC["config"]["other"]["supply_bag_spawn_roof"] then --flare roof
					self._values.position = Vector3(1918.531, 950.589, 2204.413)
				end
			end
		end
	end
end

if UseInteractionExt then
	local barricades = {
		stash_planks = true, 
		need_boards = true
	}
	local orig = UseInteractionExt.interact
	global_toggle_planks_on = global_toggle_planks_on or function(self, ...)
		orig(self, ...)
		local player = managers.player._players[1]
		if barricades[self.tweak_data] and player then
			self:set_active(true, player)
		end
	end
end

if GamePlayCentralManager then
	local orig_GPCM_2 = GamePlayCentralManager.start_heist_timer
	function GamePlayCentralManager.start_heist_timer(self, ...)
		orig_GPCM_2(self, ...)
		
		DelayedCalls:Add("heist_start_events", 1, function()
			if not alive(managers.player:player_unit()) then return end
			
			if (id_level == "rat") or (id_level == "alex_1") then
				if UseInteractionExt and UseInteractionExt.interact and localization_TC["config"]["other"]["reboard_windows"] then
					UseInteractionExt.interact = global_toggle_planks_on
				end
			end
			
			if (id_level == "rat") then
				if localization_TC["config"]["other"]["twitch_stay_close_spawn"] then
					run_event(101127) --van showup at start, very buggy
				end
			elseif (id_level == "mex_cooking") then
				if localization_TC["config"]["other"]["meth_escape_point_mex"] then
					run_event(102302)
				end
			end
		end)
	end
end
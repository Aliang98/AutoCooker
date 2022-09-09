local options_menu = "The_Cooker"
local menu_items = {}
local supply_items = {}
local lang = localization_TC:get_language()
local toggle_reload_msg = true
local file_path = localization_TC.config.other.file_path

function is_playing()
	if not BaseNetworkHandler then 
		return false 
	end
	return BaseNetworkHandler._gamestate_filter.any_ingame_playing[ game_state_machine:last_queued_state_name() ]
end

function load_languages()
	for k, v in pairs(localization_TC.config.languages) do
		table.insert(menu_items, "TheCooker_menu_"..k)
	end
	--switch current language with first language in table if not using the first one
	table.sort(menu_items, function() 
		if (menu_items[1] ~= localization_TC.config.current_lang) then 
			menu_items[1] = "TheCooker_menu_"..localization_TC.config.current_lang 
			local add_key = #menu_items + 1
			for k,v in pairs(localization_TC.config.languages) do
				menu_items[add_key] = "TheCooker_menu_"..k
				break
			end
		end
	end)
	
	table.insert(supply_items, "TheCooker_menu_SFS_default")
	table.insert(supply_items, "TheCooker_menu_SFS_first_floor")
	table.insert(supply_items, "TheCooker_menu_SFS_sec_floor")
	table.insert(supply_items, "TheCooker_menu_SFS_base_floor")
	table.insert(supply_items, "TheCooker_menu_SFS_balcony")
	table.insert(supply_items, "TheCooker_menu_SFS_roof")
	table.sort(supply_items, function() 
		if (supply_items[1] ~= localization_TC.config.other.current_supply_loc) then 
			local add_key = #supply_items + 1
			supply_items[add_key] = supply_items[1]
			supply_items[1] = localization_TC.config.other.current_supply_loc 
		end 
	end)
end
load_languages()

function reload_autocooker()
	if is_playing() and global_toggle_meth then
		if toggle_reload_msg then
			managers.chat:_receive_message(1, lang.cooker, string.format("%s", lang.reload), tweak_data.system_chat_color)
			toggle_reload_msg = false
		end
		dofile(file_path.."autocooker.lua")
		dofile(file_path.."autocooker.lua")
	end
end

function reset_config_supply_spawn()
	localization_TC.config.other.supply_bag_spawn_first_floor = false
	localization_TC.config.other.supply_bag_spawn_balcony = false
	localization_TC.config.other.supply_bag_spawn_default = false
	localization_TC.config.other.supply_bag_spawn_second_floor = false
	localization_TC.config.other.supply_bag_spawn_basement_floor = false
	localization_TC.config.other.supply_bag_spawn_roof = false
end

Hooks:Add("LocalizationManagerPostInit", "TheCookerLoc", function(loc)
	LocalizationManager:add_localized_strings({
		["TheCooker_menu_title"] = "The Cooker",
		["TheCooker_menu_desc"] = lang.mod_option_desc_change_language,
		["TheCooker_menu_AMC_title"] = lang.mod_option_title_change_language,
		["TheCooker_menu_AMC_desc"] = lang.mod_option_desc_current_lang..menu_items[1]..lang.mod_option_desc_current_lang_cont,
		["TheCooker_menu_SLR_title"] = lang.mod_option_title_enable_roof,
		["TheCooker_menu_SLR_desc"] = lang.mod_option_desc_enable_roof,
		["TheCooker_menu_SLB_title"] = lang.mod_option_title_enable_basement,
		["TheCooker_menu_SLB_desc"] = lang.mod_option_desc_enable_basement,
		["TheCooker_menu_SLDM_title"] = lang.mod_option_title_disable_middle,
		["TheCooker_menu_SLDM_desc"] = lang.mod_option_desc_disable_middle,
		["TheCooker_menu_SLDT_title"] = lang.mod_option_title_disable_top,
		["TheCooker_menu_SLDT_desc"] = lang.mod_option_desc_disable_top,
		["TheCooker_menu_SFS_title"] = lang.mod_option_title_supply_drop,
		["TheCooker_menu_SFS_desc"] = lang.mod_option_desc_supply_drop,
		["TheCooker_menu_SFS_default"] = lang.mod_option_sub_op_default,
		["TheCooker_menu_SFS_first_floor"] = lang.mod_option_sub_op_first_floor,
		["TheCooker_menu_SFS_sec_floor"] = lang.mod_option_sub_op_second_floor,
		["TheCooker_menu_SFS_base_floor"] = lang.mod_option_sub_op_basement_floor,
		["TheCooker_menu_SFS_balcony"] = lang.mod_option_sub_op_balcony,
		["TheCooker_menu_SFS_roof"] = lang.mod_option_sub_op_roof,
		["TheCooker_menu_BIC_title"] = lang.mod_option_bic_title,
		["TheCooker_menu_BIC_desc"] = lang.mod_option_bic_desc,
		["TheCooker_menu_DB_title"] = lang.mod_option_db_title,
		["TheCooker_menu_DB_desc"] = lang.mod_option_db_desc,
		["TheCooker_menu_twitch_stay_close_title"] = lang.mod_option_SC_title,
		["TheCooker_menu_twitch_stay_close_desc"] = lang.mod_option_SC_desc,
		["TheCooker_menu_twitch_stay_close_pal_title"] = lang.mod_option_SCP_title,
		["TheCooker_menu_twitch_stay_close_pal_desc"] = lang.mod_option_SCP_desc,
		["TheCooker_menu_twitch_stay_close_spawn_title"] = lang.mod_option_SCS_title,
		["TheCooker_menu_twitch_stay_close_spawn_desc"] = lang.mod_option_SCS_desc,
		["TheCooker_menu_use_waypoints_title"] = lang.mod_option_UCW_title,
		["TheCooker_menu_use_waypoints_desc"] = lang.mod_option_UCW_desc,
		["TheCooker_menu_meth_escape_point_mex_title"] = lang.mod_option_EPM_title,
		["TheCooker_menu_meth_escape_point_mex_desc"] = lang.mod_option_EPM_desc,
		["TheCooker_menu_reward_disconnect_title"] = lang.mod_option_RD_title,
		["TheCooker_menu_reward_disconnect_desc"] = lang.mod_option_RD_desc,
		["TheCooker_menu_reboard_windows_title"] = lang.mod_option_reboard_windows_title,
		["TheCooker_menu_reboard_windows_desc"] = lang.mod_option_reboard_windows_desc,
		["TheCooker_menu_show_experience_title"] = lang.mod_option_show_experience_title,
		["TheCooker_menu_show_experience_desc"] = lang.mod_option_show_experience_desc
	})
	for k, v in pairs(localization_TC.config.languages) do
		LocalizationManager:add_localized_strings({["TheCooker_menu_"..k] = k})
	end
end)

Hooks:Add("MenuManagerSetupCustomMenus", "TheCookerMenu", function( menu_manager, nodes )
	MenuHelper:NewMenu(options_menu)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "TheCookerMenu", function( menu_manager, nodes )
	MenuCallbackHandler.TheCooker_menu_language = function(self, item)
		--disable all languages
		for key, value in pairs(localization_TC.config.languages) do
			if key then
				if (localization_TC.config.languages[key].enabled) then
					localization_TC.config.languages[key].enabled = false
				end
			end
		end

		--enable selected language
		for key, value in pairs(localization_TC.config.languages) do
			if key then
				if not (localization_TC.config.languages[key].enabled) then
					for k, v in pairs(menu_items) do
						if (item:value() == k) and v == "TheCooker_menu_"..key then
							localization_TC.config.languages[key].enabled = true
							localization_TC.config.current_lang = key
							localization_TC:save_config()
							dofile(file_path.."loc/localization_TC.lua")
							reload_autocooker()
						end
					end
				end
			end
		end
	end
	MenuHelper:AddMultipleChoice({
		id = "TheCooker_menu_language",
		title = "TheCooker_menu_AMC_title",
		desc = "TheCooker_menu_AMC_desc",
		callback = "TheCooker_menu_language",
		items = menu_items,
		value = 1,
		menu_id = options_menu,
		priority = 100,
	})
	
	MenuCallbackHandler.TheCooker_menu_spawn_supply = function(self, item)
		for k, v in pairs(supply_items) do
			if (v == "TheCooker_menu_SFS_default") and (item:value() == k) then
				reset_config_supply_spawn()
				localization_TC.config.other.supply_bag_spawn_default = true
				localization_TC.config.other.current_supply_loc = v
			elseif (v == "TheCooker_menu_SFS_balcony") and (item:value() == k) then
				reset_config_supply_spawn()
				localization_TC.config.other.supply_bag_spawn_balcony = true
				localization_TC.config.other.current_supply_loc = v
			elseif (v == "TheCooker_menu_SFS_first_floor") and (item:value() == k) then
				reset_config_supply_spawn()
				localization_TC.config.other.supply_bag_spawn_first_floor = true
				localization_TC.config.other.current_supply_loc = v
			elseif (v == "TheCooker_menu_SFS_sec_floor") and (item:value() == k) then
				reset_config_supply_spawn()
				localization_TC.config.other.supply_bag_spawn_second_floor = true
				localization_TC.config.other.current_supply_loc = v
			elseif (v == "TheCooker_menu_SFS_base_floor") and (item:value() == k) then
				reset_config_supply_spawn()
				localization_TC.config.other.supply_bag_spawn_basement_floor = true
				localization_TC.config.other.current_supply_loc = v
			elseif (v == "TheCooker_menu_SFS_roof") and (item:value() == k) then
				reset_config_supply_spawn()
				localization_TC.config.other.supply_bag_spawn_roof = true
				localization_TC.config.other.current_supply_loc = v
			end
		end
		localization_TC:save_config()
	end
	MenuHelper:AddMultipleChoice({
		id = "TheCooker_menu_spawn_supply",
		title = "TheCooker_menu_SFS_title",
		desc = "TheCooker_menu_SFS_desc",
		callback = "TheCooker_menu_spawn_supply",
		items = supply_items,
		value = 1,
		menu_id = options_menu,
		priority = 99,
	})
	
	MenuCallbackHandler.TheCooker_menu_spawn_lab_roof = function(self, item)
		localization_TC.config.other.meth_lab_roof = not localization_TC.config.other.meth_lab_roof
		localization_TC:save_config()
		if localization_TC.config.other.meth_lab_roof then
			dofile(file_path.."lab spawn/missionelements.lua")
		end
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_spawn_lab_roof",
		title = "TheCooker_menu_SLR_title",
		desc = "TheCooker_menu_SLR_desc",
		callback = "TheCooker_menu_spawn_lab_roof",
		value = localization_TC.config.other.meth_lab_roof,
		menu_id = options_menu,  
		priority = 98,
	})
	
	MenuCallbackHandler.TheCooker_menu_spawn_lab_basement = function(self, item)
		localization_TC.config.other.meth_lab_basement = not localization_TC.config.other.meth_lab_basement
		localization_TC:save_config()
		if localization_TC.config.other.meth_lab_basement then
			dofile(file_path.."lab spawn/missionelements.lua")
		end
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_spawn_lab_basement",
		title = "TheCooker_menu_SLB_title",
		desc = "TheCooker_menu_SLB_desc",
		callback = "TheCooker_menu_spawn_lab_basement",
		value = localization_TC.config.other.meth_lab_basement,
		menu_id = options_menu,  
		priority = 97,
	})
	
	MenuCallbackHandler.TheCooker_menu_spawn_lab_disable_middle = function(self, item)
		localization_TC.config.other.meth_lab_disable_middle = not localization_TC.config.other.meth_lab_disable_middle
		localization_TC:save_config()
		if localization_TC.config.other.meth_lab_disable_middle then
			dofile(file_path.."lab spawn/missionelements.lua")
		end
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_spawn_lab_disable_middle",
		title = "TheCooker_menu_SLDM_title",
		desc = "TheCooker_menu_SLDM_desc",
		callback = "TheCooker_menu_spawn_lab_disable_middle",
		value = localization_TC.config.other.meth_lab_disable_middle,
		menu_id = options_menu,  
		priority = 96,
	})
	
	MenuCallbackHandler.TheCooker_menu_spawn_lab_disable_top = function(self, item)
		localization_TC.config.other.meth_lab_disable_top = not localization_TC.config.other.meth_lab_disable_top
		localization_TC:save_config()
		if localization_TC.config.other.meth_lab_disable_top then
			dofile(file_path.."lab spawn/missionelements.lua")
		end
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_spawn_lab_disable_top",
		title = "TheCooker_menu_SLDT_title",
		desc = "TheCooker_menu_SLDT_desc",
		callback = "TheCooker_menu_spawn_lab_disable_top",
		value = localization_TC.config.other.meth_lab_disable_top,
		menu_id = options_menu,  
		priority = 95,
	})
	
	MenuCallbackHandler.TheCooker_menu_twitch_stay_close = function(self, item)
		localization_TC.config.other.twitch_stay_close = not localization_TC.config.other.twitch_stay_close
		localization_TC:save_config()
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_twitch_stay_close",
		title = "TheCooker_menu_twitch_stay_close_title",
		desc = "TheCooker_menu_twitch_stay_close_desc",
		callback = "TheCooker_menu_twitch_stay_close",
		value = localization_TC.config.other.twitch_stay_close,
		menu_id = options_menu,  
		priority = 94,
	})
	
	MenuCallbackHandler.TheCooker_menu_twitch_stay_close_spawn = function(self, item)
		localization_TC.config.other.twitch_stay_close_spawn = not localization_TC.config.other.twitch_stay_close_spawn
		localization_TC:save_config()
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_twitch_stay_close_spawn",
		title = "TheCooker_menu_twitch_stay_close_spawn_title",
		desc = "TheCooker_menu_twitch_stay_close_spawn_desc",
		callback = "TheCooker_menu_twitch_stay_close_spawn",
		value = localization_TC.config.other.twitch_stay_close_spawn,
		menu_id = options_menu,  
		priority = 93,
	})
	
	MenuCallbackHandler.TheCooker_menu_twitch_stay_close_pal = function(self, item)
		localization_TC.config.other.twitch_stay_close_pal = not localization_TC.config.other.twitch_stay_close_pal
		localization_TC:save_config()
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_twitch_stay_close_pal",
		title = "TheCooker_menu_twitch_stay_close_pal_title",
		desc = "TheCooker_menu_twitch_stay_close_pal_desc",
		callback = "TheCooker_menu_twitch_stay_close_pal",
		value = localization_TC.config.other.twitch_stay_close_pal,
		menu_id = options_menu,  
		priority = 92,
	})

	MenuCallbackHandler.TheCooker_menu_meth_escape_point_mex = function(self, item)
		localization_TC.config.other.meth_escape_point_mex = not localization_TC.config.other.meth_escape_point_mex
		localization_TC:save_config()
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_meth_escape_point_mex",
		title = "TheCooker_menu_meth_escape_point_mex_title",
		desc = "TheCooker_menu_meth_escape_point_mex_desc",
		callback = "TheCooker_menu_meth_escape_point_mex",
		value = localization_TC.config.other.meth_escape_point_mex,
		menu_id = options_menu,  
		priority = 91,
	})
	-------------------------------------------------------------------------
	
	MenuCallbackHandler.TheCooker_menu_bypass_ing_check = function(self, item)
		localization_TC.config.other.bypass_ing_check = not localization_TC.config.other.bypass_ing_check
		localization_TC:save_config()
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_bypass_ing_check",
		title = "TheCooker_menu_BIC_title",
		desc = "TheCooker_menu_BIC_desc",
		callback = "TheCooker_menu_bypass_ing_check",
		value = localization_TC.config.other.bypass_ing_check,
		menu_id = options_menu,  
		priority = 20,
	})
	
	MenuCallbackHandler.TheCooker_menu_disable_bain = function(self, item)
		localization_TC.config.other.disable_bain = not localization_TC.config.other.disable_bain
		localization_TC:save_config()
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_disable_bain",
		title = "TheCooker_menu_DB_title",
		desc = "TheCooker_menu_DB_desc",
		callback = "TheCooker_menu_disable_bain",
		value = localization_TC.config.other.disable_bain,
		menu_id = options_menu,  
		priority = 19,
	})
	
	MenuCallbackHandler.TheCooker_menu_use_waypoints = function(self, item)
		localization_TC.config.other.use_waypoints = not localization_TC.config.other.use_waypoints
		localization_TC:save_config()
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_use_waypoints",
		title = "TheCooker_menu_use_waypoints_title",
		desc = "TheCooker_menu_use_waypoints_desc",
		callback = "TheCooker_menu_use_waypoints",
		value = localization_TC.config.other.use_waypoints,
		menu_id = options_menu,  
		priority = 18,
	})
	
	MenuCallbackHandler.TheCooker_menu_reward_disconnect = function(self, item)
		localization_TC.config.other.reward_disconnect = not localization_TC.config.other.reward_disconnect
		localization_TC:save_config()
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_reward_disconnect",
		title = "TheCooker_menu_reward_disconnect_title",
		desc = "TheCooker_menu_reward_disconnect_desc",
		callback = "TheCooker_menu_reward_disconnect",
		value = localization_TC.config.other.reward_disconnect,
		menu_id = options_menu,  
		priority = 17,
	})
	
	MenuCallbackHandler.TheCooker_menu_reboard_windows = function(self, item)
		localization_TC.config.other.reboard_windows = not localization_TC.config.other.reboard_windows
		localization_TC:save_config()
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_reboard_windows",
		title = "TheCooker_menu_reboard_windows_title",
		desc = "TheCooker_menu_reboard_windows_desc",
		callback = "TheCooker_menu_reboard_windows",
		value = localization_TC.config.other.reboard_windows,
		menu_id = options_menu,  
		priority = 16,
	})
	
	MenuCallbackHandler.TheCooker_menu_show_experience = function(self, item)
		localization_TC.config.other.show_experience = not localization_TC.config.other.show_experience
		localization_TC:save_config()
	end
	MenuHelper:AddToggle({
		id = "TheCooker_menu_show_experience",
		title = "TheCooker_menu_show_experience_title",
		desc = "TheCooker_menu_show_experience_desc",
		callback = "TheCooker_menu_show_experience",
		value = localization_TC.config.other.show_experience,
		menu_id = options_menu,  
		priority = 15,
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "TheCookerMenu", function(menu_manager, nodes)
	nodes[options_menu] = MenuHelper:BuildMenu(options_menu)
	MenuHelper:AddMenuItem(nodes["blt_options"], options_menu, "TheCooker_menu_title", "TheCooker_menu_desc")
end)
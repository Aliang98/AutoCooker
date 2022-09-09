local mod_name = "The Cooker" --edit this
rawset(_G, "identiier_for_"..mod_name, {
	peers_table = {},
	spam_msg_on = true,
	mod_enabled = true,
	msg_host = true,
	bypass_identifier = false,
	loc = localization_TC --edit this
})

local custom_class = _G["identiier_for_"..mod_name]

function custom_class:load_config()
	self.mod_enabled = self.loc.config.other.allow_cooker --edit this
end

function custom_class:is_server()
	if Network:is_server() then
		return true
	else
		return false
	end
end

function custom_class:is_playing()
	if not BaseNetworkHandler then 
		return false 
	end
	return BaseNetworkHandler._gamestate_filter.any_ingame_playing[ game_state_machine:last_queued_state_name() ]
end

function custom_class:turn_off_mod()
	--code to turn off mod
	if self:is_playing() then
		local level_id = managers.job:current_level_id()
	
		bag_amount = 1
		global_semi_auto_toggle = true
		if not global_semi_auto then
			global_semi_auto = not global_semi_auto
		end
		
		--global_toggle_bag_meth = false
		--if global_auto_bag_meth then
		--	global_auto_bag_meth = not global_auto_bag_meth
		--end
		
		global_auto_secure = false 
		if global_ac_secure then 
			global_ac_secure = not global_ac_secure 
		end
		
		global_secure_all_toggle = false
		if global_secure_all then
			global_secure_all = not global_secure_all
		end
		
		if (level_id == 'nail') then
			BetterDelayedCalls_TC:Remove("drop_bags_3_times")
			BetterDelayedCalls_TC:Remove("crack_meth")
			BetterDelayedCalls_TC:Remove("drop_bags_3_times_meth_done")
		end
		
		if (level_id == 'cane') then 
			BetterDelayedCalls_TC:Remove( "santa_workshop_spawn_meth_chemica")
			global_toggle_meth = not global_toggle_meth		
		end
		
		if orig_nverify_bag then NetworkPeer.verify_bag = orig_nverify_bag end
		if orig_pverify_carry then PlayerManager.verify_carry = orig_pverify_carry end
		if orig_pregister_carry then PlayerManager.register_carry = orig_pregister_carry end
	end

	if not self.mod_enabled then
		self:msg_toggle(false)
	end
end

function custom_class:turn_on_mod()
	--code to turn on mod
	if self:is_playing() then

	end
end

if NetworkPeer then
	function NetworkPeer.set_ip_verified(self, state)
		self._ip_verified = state
		self:_chk_flush_msg_queues()

		if state then
			local user = Steam:user(self:ip())
			if user and (user:rich_presence(mod_name.."_mod_identifier1712") == "1") and not custom_class.peers_table[self:id()] then
				custom_class:add_peer(self:id(), true)
				managers.chat:feed_system_message(ChatManager.GAME, string.format("%s also got '%s' mod installed!", self:name(), mod_name))
			end
		end
	end
end

if NetworkAccountSTEAM then
	function NetworkAccountSTEAM._set_presences(self)
		Steam:set_rich_presence("level", managers.experience:current_level())
		Steam:set_rich_presence(mod_name.."_mod_identifier1712", 1)

		if MenuCallbackHandler:is_modded_client() then
			Steam:set_rich_presence("is_modded", 1)
		else
			Steam:set_rich_presence("is_modded", 0)
		end
	end
end

if BaseNetworkSession then
	local _orig = BaseNetworkSession.on_load_complete
	function BaseNetworkSession.on_load_complete(self, simulation)
		_orig(self, simulation)
		if not simulation then
			for peer_id, peer in pairs(self._peers) do
				if peer:ip_verified() then
					DelayedCalls:Add("player_"..peer._user_id, 7, function()
						if managers and managers.chat and alive(peer:unit()) and peer then
							local peer = managers.network:session():peer(1)
							local user = Steam:user(peer:ip())
							if user and (user:rich_presence(mod_name.."_mod_identifier1712") == "1") then
								managers.chat:feed_system_message(ChatManager.GAME, string.format("'%s' detected from %s.", mod_name, peer:name()))
							end
						end
					end)
				end
			end
		end
	end
	
	local orig_func_on_peer_lost = BaseNetworkSession.on_peer_lost
	function BaseNetworkSession.on_peer_lost(self, peer, peer_id)
		if custom_class.peers_table[peer_id] then
			custom_class:remove_peer(peer_id)
		end
		orig_func_on_peer_lost(self, peer, peer_id)
	end
	
	local orig_func_on_peer_left = BaseNetworkSession.on_peer_left
	function BaseNetworkSession.on_peer_left(self, peer, peer_id)
		if custom_class.peers_table[peer_id] then
			custom_class:remove_peer(peer_id)
		end
		orig_func_on_peer_left(self, peer, peer_id)
	end
	
	local orig_func_on_peer_kicked = BaseNetworkSession.on_peer_kicked
	function BaseNetworkSession.on_peer_kicked(self, peer, peer_id, message_id)
		if custom_class.peers_table[peer_id] then
			custom_class:remove_peer(peer_id)
		end
		orig_func_on_peer_kicked(self, peer, peer_id, message_id)
	end
end

if ChatManager then
	local orig_receive_message_by_peer_func = ChatManager.receive_message_by_peer
	function ChatManager.receive_message_by_peer(self, channel_id, peer, message)
		if custom_class.peers_table[peer:id()] and (peer:id() == 1 and message == "yes") then
			custom_class.bypass_identifier = true
			custom_class:is_lobby_filter(true)
		end
		orig_receive_message_by_peer_func(self, channel_id, peer, message)
	end
end

function custom_class:get_peer_list(ignore_local)
	local session = managers.network:session()
	local peers = {}
	for i=1, 4 do
		local peer = session:peer(i)
		if peer then
			if ignore_local and (peer:id() == session:local_peer():id()) then
			else
				peers[peer:id()] = peer
			end
		end
	end
	return peers
end

function custom_class:get_peer(id, unitcheck, ignore_local)
	local session = managers.network:session()
	if session then
		if tonumber(id) then
			local peer = session:peer(id)
			if peer then
				if (unitcheck and ignore_local and alive(peer:unit()) and (peer:id() ~= session:local_peer():id())) then
					return true, peer
				end
				if (unitcheck and not ignore_local and alive(peer:unit())) then
					return true, peer
				end
			end
		end
		-- if the peer does not exist, return a list with all availible peers
		return false, self:get_peer_list(ignore_local)
	end
end

function custom_class:check_peers(peer_id)
	local exist, peers = self:get_peer(peer_id, true, false)
	if exist and self.peers_table[peer_id] then
		return peers
	end
	return false
end

function custom_class:count_table(t)
	local count = 0
	for _ in pairs(t) do 
		count = count + 1 
	end
	return count
end

function custom_class:update_peers()

	--nobody got the mod
	if self:count_table(self.peers_table) == 0 then
		if self:is_server() then
			for i = 2,4 do
				local exist, peers = self:get_peer(i, true, true)
				if exist then
					self:is_lobby_filter(false)
					break
				else
					self:is_lobby_filter(true)
				end
			end
		else
			self:is_lobby_filter(false)
		end
		return
	end
	
	--got the mod
	for k, v in pairs(self.peers_table) do
		if self.peers_table[k] ~= nil then
			local check = self:check_peers(k)
			if (type(check) ~= "table") and (k == check:id()) then
				if v.toggle then
					local exist, peers = self:get_peer(1, true, true)
					if exist then
						self:is_lobby_filter(true)
					else
						if (k == 1) then
							self:is_lobby_filter(true)
						elseif (k ~= 1) then
							for key,peer in pairs(peers) do
								if (k == key) then
									if self:is_server() then
										self:is_lobby_filter(true)
									else
										if self.msg_host then
											managers.chat:send_message(ChatManager.GAME, 1, string.format("Me and %s uses %s. If it's okay for us to use it, reply with 'yes' to allow it.", peer:name(), mod_name))
											self.msg_host = false
										end
									end
								end
							end
						end
					end
				else
					self:is_lobby_filter(false)
				end
			else
				self:is_lobby_filter(false)
			end
		else
			self:is_lobby_filter(false)
		end
	end
end

function custom_class:add_peer(peer, peer_id, toggle)
	local data = self.peers_table[peer_id]
	if not data then
		self.peers_table[peer_id] = toggle
	end
end

function custom_class:remove_peer(id)
	if id and self.peers_table[id] then
		self.peers_table[id] = nil
	end
	self:is_lobby_filter(false)
end

function custom_class:msg_toggle(toggle)
	if not toggle and self.spam_msg_on then
		managers.chat:_receive_message(1, mod_name.." OFF", string.format("%s is in sandbox mode.", mod_name), tweak_data.system_chat_color)
		self.spam_msg_on = false
	end
end

function custom_class:is_lobby_filter(toggle)
	if toggle then
		self.loc.config.other.allow_cooker = true
	else
		self.loc.config.other.allow_cooker = false
	end
	
	local total_bags = (managers.loot:get_secured_mandatory_bags_amount()) + (managers.loot:get_secured_bonus_bags_amount())
	self.loc.config.other.secured_bags = tostring(total_bags)
	
	self.loc:save_config()
	self:load_config()
	
	if toggle then
		self:turn_on_mod()
	else
		self:turn_off_mod()
	end
end

function custom_class:check_filters()
	if (managers.network.matchmake) and (managers.network.matchmake.lobby_handler) and (managers.network.matchmake.lobby_handler:get_lobby_data()) then
		local filter_permissions = tonumber(managers.network.matchmake.lobby_handler:get_lobby_data().permission)
		if (filter_permissions and filter_permissions == 2 or filter_permissions == 3) then
			self:is_lobby_filter(true)
		else
			self:update_peers()
		end
	else
		self:update_peers()
	end
end

function custom_class:start_loop()
	BetterDelayedCalls_TC:Add("allow_mod_check"..mod_name, 2, function()
		if custom_class.bypass_identifier then
			custom_class:is_lobby_filter(true)
		else
			custom_class:check_filters()
		end
	end, true)
end

if GamePlayCentralManager then
	local orig_GPCM = GamePlayCentralManager.start_heist_timer
	function GamePlayCentralManager.start_heist_timer(self, ...)
		orig_GPCM(self, ...)
		
		local level_id = managers.job:current_level_id()
		if (level_id == 'pal' or level_id == 'nail' or level_id == 'cane' or level_id == 'mex_cooking' or level_id == 'alex_1' or level_id == 'rat' or level_id == 'crojob2' or level_id == 'mia_1') then
			if Global.game_settings and Global.game_settings.single_player then
				custom_class:is_lobby_filter(true)
			else
				custom_class:start_loop()
			end
		else
			custom_class.loc.config.other.secured_bags = tostring(0)
			custom_class.loc:save_config()
		end
		
		if custom_class.loc.config.other and custom_class.loc.config.other.file_path then
			local path = custom_class.loc.config.other.file_path
			dofile(path.."experience.lua")
		end
	end
end
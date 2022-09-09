local function give_exp()
	local secured_bags_on_map = localization_TC["config"]["other"]["secured_bags"]
	if managers.statistics then
		local play_time = managers.statistics._global.play_time.minutes
		if play_time and (play_time >= 5) and (tonumber(secured_bags_on_map) > 0) then
			for i=0,secured_bags_on_map do
				managers.experience:on_loot_drop_xp("xp50", true)
			end
		end
	end
end

if string.lower(RequiredScript) == "lib/network/base/basenetworksession" and BaseNetworkSession then
	local orig_func_steam_disconnected = BaseNetworkSession.steam_disconnected
	function BaseNetworkSession.steam_disconnected(self)
		if localization_TC["config"]["other"]["reward_disconnect"] and Network:is_client() then
			give_exp()
		end
		orig_func_steam_disconnected(self)
	end
end

if string.lower(RequiredScript) == "lib/network/base/clientnetworksession" and ClientNetworkSession then
	local orig_func_soft_remove_peer = ClientNetworkSession._soft_remove_peer
	function ClientNetworkSession._soft_remove_peer(self, peer)
		if localization_TC["config"]["other"]["reward_disconnect"] and peer and (peer:id() == 1) then
			give_exp()
		end
		orig_func_soft_remove_peer(self, peer)
	end
end
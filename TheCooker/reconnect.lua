if string.lower(RequiredScript) == "lib/network/matchmaking/networkmatchmakingsteam" and NetworkMatchMakingSTEAM then
	local orig = NetworkMatchMakingSTEAM.join_server
	function NetworkMatchMakingSTEAM.join_server(self, room_id, skip_showing_dialog, quickplay)
		localization_TC["config"]["other"]["reconnect_id"] = room_id
		localization_TC:save_config()
		orig(self, room_id, skip_showing_dialog, quickplay)
	end
end--test
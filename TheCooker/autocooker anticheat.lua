if string.lower(RequiredScript) == "lib/network/base/networkpeer" and NetworkPeer then
	function NetworkPeer:verify_bag() 
		return true 
	end
elseif string.lower(RequiredScript) == "lib/managers/playermanager" and PlayerManager then
	function PlayerManager:verify_carry() 
		return true 
	end

	function PlayerManager:register_carry() 
		return true 
	end
end
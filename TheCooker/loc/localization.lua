if rawget(_G, "localization_TC") then
	rawset(_G, "localization_TC", nil)
end

if not rawget(_G, "localization_TC") then
	rawset(_G, "localization_TC", {
		config = {},
		language = {},
		path = "mods/TheCookerConfig/%s"
	})
	
	function localization_TC:get_language()
		for key, value in pairs(localization_TC.config.languages) do
			if key and (localization_TC.config.languages[key].enabled) then
				local str = string.format("%s", localization_TC.config.current_lang)
				for i = 1, #str do
					localization_TC.language[i] = str:sub(i, #str)
					break
				end
				for k, v in pairs(localization_TC.language) do
					return localization_TC.config.languages[v].loc
				end
			end
		end
	end
	
	function localization_TC:select_language()
		for key, value in pairs(localization_TC.config.languages) do
			if key then
				for k, v in pairs(localization_TC.config.languages[key]) do
					if (localization_TC.config.languages[key].enabled) then
						localization_TC.config.current_lang = key
						localization_TC:save_config()
					end
				end
			end
		end
		dofile("mods/TheCooker/color menu/load menu.lua")
	end
	
	function localization_TC:load_config()
		local file = JSON:jsonFile(string.format(self.path, "config.json"))
		local data = JSON:decode(file)
		for _, v in pairs(data) do
			if type(v) == "table" then
				self.config = v
			end
		end
		self:select_language()
	end
	
	function localization_TC:save_config()
		local file = io.open(string.format(self.path, "config.json"), "w")
		local data = {
			["config"] = self.config
		}

		if file then
			local contents = JSON:encode_pretty(data)
			file:write(contents)
			io.close(file)
		else
			return
		end
	end

	dofile("mods/TheCooker/loc/JSON.lua")
	localization_TC:load_config()
end
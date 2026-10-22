---@type LuxManifest
return {
	name = "arglex",
	namespace = "luxa.arglex",
	license = {
		spdx = "MIT",
		files = { "LICENSE" },
	},
	lua_modules = {
		{
			name = "arglex",
			sources = { "init.lua" },
		},
	},
}

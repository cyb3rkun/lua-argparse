---@type LuxManifest
return {
	name = "argparse",
	namespace = "luxa.argparse",
	license = {
		spdx = "MIT",
		files = { "LICENSE" },
	},
	lua_modules = {
		{
			name = "argparse",
			sources = { "init.lua" },
		},
	},
}

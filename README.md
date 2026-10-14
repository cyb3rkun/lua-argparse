# A Basic Argument parsing library for lua
    - more descriptions coming later

# Installation with [Lux](https://github.com/LuaLuxa):
```lua
{
    "cyb3rkun/lua-argparse",
    opts = { scope = "local" },
}
```
> Note: lux and the LuaLuxa ecosystem are not yet publicly released. Manual installation(cloning) is available in the meantime — just drop init.lua into your project.

# Usage
```lua
local ap = require "luxa.argparse"

-- Register Flags
ap:flag("-f", { desc = "Foo" })
	:flag("-x", { desc = "Dash X option" })
	:flag("-g", { desc = "G flag!" })
    -- Functions automatically get executed the moment the parsing step finds
    -- the flag passed
	:flag("--help-foo", { func = function() print "HELP" end, desc = "Fooo" })
	:flag("-d", {func = function ()
		ap:debug_flags()
	end, desc = "Print registered flags"})
	:option("-o", { desc = "Bar" })
	:option(
		"--long-o",
		{ func = function(val) print(val) end, desc = "Long Option" }
	)

ap:parse(arg, true)
```

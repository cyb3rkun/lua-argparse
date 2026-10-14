# A Basic Argument parsing library for lua

# Installation with [Lux](https://codeberg.org/LuaLuxa):
```lua
{
    "cyb3rkun/lua-argparse",
    opts = { scope = "local" },
}
```
> Note: lux and the LuaLuxa ecosystem are not yet publicly released. Manual installation (cloning) is available in the meantime — just drop init.lua into your project.

# Usage
Note that arguments, flags, and options do not need to be passed in a specific
order. This library works on the POSIX standard, so passing `utility -fxy
file.txt --verbose` is exactly the same as `utility file.txt --verbose -f -xy`.

---
```lua
local ArgParser = require "argparse"
local ap = ArgParser.new()

-- Register Flags
ap:flag("-f", { desc = "Foo" })
    -- Giving Descriptions allows for automatic help generation
    :flag("-x", { desc = "Dash X option" })
    :flag("-g", { desc = "G flag!" })
    -- Functions automatically get executed the moment the parsing step finds the flag passed
    -- They are optional!
    :flag("--help-foo", { func = function() print "HELP" end, desc = "Fooo" })
    :flag("-d", { 
        func = function() ap:debug_flags() end, 
        desc = "Print registered flags" 
    })
    :option("-o", { desc = "Bar" })
    :option("--long-o", { 
        func = function(val) print(val) end, 
        desc = "Long Option" 
    })

ap:parse(arg)

-- Get option values
-- If, for instance, -o=foo is passed, this will return "foo"
local o = ap:gopt("-o")
-- If, for instance, --long-o=foo is passed, this will return "foo"
local long_o = ap:gopt("--long-o")

-- Flags work the same way:
local f = ap:gflag("-f") -- Returns true if the flag was passed, otherwise nil

-- Flags can also be stacked when passing them:
ap:parse({"-fxg"}) -- Each flag (f, x, and g) will be detected
-- LONG flags (e.g. --help-foo), cannot stack for obvious reasons.

-- The library will also automatically print help info when it sees the -h flag.
-- This can be overwritten by passing a custom ap:flag("-h") and overriding the default.
```

# Arguments                  			
Arguments are automatically collected into a sequential string list.
```lua
local ArgParser = require "argparse"
local ap = ArgParser.new()

local args = { "foo", "bar", "chill" }
ap:parse(args)

-- ap:garg(idx) returns the value for that positional argument
assert(ap:garg(1) == "foo")
assert(ap:garg(2) == "bar")
assert(ap:garg(3) == "chill")
assert(#ap:gargs() == 3)
```

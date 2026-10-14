---@diagnostic disable: unused-local
--[[
	util_name [Flags -f/-x/-fx] [options] ONLY FLAGS CAN STACK \
	[Options (flags with values) -f=xyz, -x=xyz] \
	[arguments  (positional, space seperated) /run/home/usr/file.txt]
]]

---@class ArgParser
---@field flags table<string, Flag>
---@field options table<string, Option>
---@field args string[]
local ArgParser = {}

---@class Flag
---@field func nil | fun(): nil
---@field desc string

---@class Option
---@field func nil | fun(a: any): nil
---@field desc string

ArgParser.args = {}
ArgParser.flags = {}
ArgParser.options = {}

-- TODO add Execution Ordering for the flags, and options, in case user needs
-- specific order
-- -@type table<string,string[]>
-- ArgParser.exec_order = { flags = {}, options = {} }

-- Function to add flags
---@param flag_id string
---@param flag Flag
---@return ArgParser
function ArgParser:flag(flag_id, flag)
	-- When attempting to add duplicate Flag, throw error
	if not flag_id then error("Can't set a nil flag!", 2) end
	flag.desc = flag.desc or "No Description Given"

	if not self.flags[flag_id] then
		self.flags[flag_id] = flag
		return self
	end

	error(("The Flag '%s' already exists"):format(flag_id), 2)
end

---@param option_id string
---@param option Option
---@return ArgParser
function ArgParser:option(option_id, option)
	-- When attempting to add duplicate Option, throw error
	if not option_id then error("option id not specified!", 2) end

	if not self.options[option_id] then
		self.options[option_id] = option
		return self
	end

	error(("The Option '%s' already exists"):format(option_id), 2)
end

function ArgParser:flag_order() end
function ArgParser:option_order() end

---@param order string[]
function ArgParser:set_exec_order(order)
	self.exec_order = order
	return self
end

---@param opt string
---@param val string
function ArgParser:run_opt(opt, val)
	if not opt or not self.options[opt] then
		error(
			("Option '%s' does not exist, value given: '%s'"):format(opt, val),
			2
		)
	end
	if self.options[opt].func then self.options[opt].func(val) end
end

function ArgParser:run_flag(flag_id)
	if not flag_id or not self.flags[flag_id] then
		error(("Flag '%s' does not exist"):format(flag_id), 2)
	end
	if self.flags[flag_id] then self.flags[flag_id].func() end
	return ""
end

---@param Arg string
function ArgParser:parse_long_opt(Arg)
	local k, v = Arg:match "(%-%-[A-Za-z]+[A-Za-z0-9-]*)%=(.*)$"

	if k then
		self:run_opt(k, v)
		return true
	end
end

---@param Arg string
function ArgParser:parse_short_opt(Arg)
	local k, v = Arg:match "(%-[A-Za-z])%=(.*)$"

	if k then
		self:run_opt(k, v)
		return true
	end
end

---@param Arg string
function ArgParser:parse_flag(Arg)
	local flags = Arg:match "^%-([A-Za-z]+)$"
	if not flags then return end

	-- Run Associated functions for each flag
	flags:gsub(".", function(c) self:run_flag("-" .. c) end)
	return true
end
function ArgParser:parse_long_flag(Arg)
	local long_flag = Arg:match "^(%-%-[A-Za-z]+[A-Za-z0-9-]*)$"
	if not long_flag then return end

	self:run_flag(long_flag)
	return true
end

ArgParser:flag("-h", {
	desc = "Displays Help Message",
	func = function()
		print "Flags: "
		for k, v in pairs(ArgParser.flags) do
			print(k, v.desc)
		end
		print "Options: "
		for k, v in pairs(ArgParser.options) do
			print(k, v.desc)
		end
	end,
})

function ArgParser:debug_flags()
	for k, v in pairs(self.flags) do
		print(k, v.desc, v.func)
	end
	for k, v in pairs(self.options) do
		print(k, v.desc, v.func)
	end
end
---@param args string[]
---@param return_result boolean
---@return table<string, function> | nil
function ArgParser:parse(args, return_result)
	local INDEX = 1
	while INDEX <= #args do
		local current = args[INDEX]

		if self:parse_long_opt(current) then goto continue end
		if self:parse_short_opt(current) then goto continue end
		if self:parse_long_flag(current) then goto continue end
		if self:parse_flag(current) then goto continue end

		table.insert(self.args, current)

		::continue::
		INDEX = INDEX + 1
	end
end

return ArgParser

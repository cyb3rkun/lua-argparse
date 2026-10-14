local t = require "luxa.test"
---@type TestList
local tests = {
	test_registration = {
		func = function()
			local ArgParser = require "init"
			local ap = ArgParser.new()
				:flag("-f", { desc = "Foo" })
				:flag("-x", { desc = "Dash X option" })
				:flag("-g", { desc = "G flag!" })
				:flag(
					"--help-foo",
					{ func = function() print "HELP" end, desc = "Fooo" }
				)
				:flag("-d", {
					func = function() print "DEBUG" end,
					desc = "Print registered flags",
				})
				:option("-o", { desc = "Bar" })
				:option("--long-o", {
					func = function(val) print(val) end,
					desc = "Long Option",
				})
			local flags = {
				"-f",
				"-x",
				"-g",
				"--help-foo",
				"-d",
			}
			local opts = {
				"-o=boo",
				"--long-o=foo",
			}
			local args = { "foo", "bar", "foobar.txt" }
			ap:parse(flags):parse(opts):parse(args)
		end,
	},

	test_options = {
		func = function()
			local ArgParser = require "init"
			local ap = ArgParser.new()
			ap:option("-o", { desc = "Bar" })
				:option("--long-o", {
					func = function(val) print(val) end,
					desc = "Long Option",
				})
				:option("--super-long", { desc = "Bar" })
			ap:option "--ultra-long"
			local opts = {
				"-o=boo",
				"--long-o=foo",
				"--super-long=foo=super=long",
				"--ultra-long=not-really",
			}
			ap:parse(opts)
			t.assert_eq("boo", ap:gopt "-o")
			t.assert_eq("foo", ap:gopt "--long-o")
			t.assert_eq("foo=super=long", ap:gopt "--super-long")
			t.assert_eq("not-really", ap:gopt "--ultra-long")
		end,
	},

	test_flags = {
		func = function()
			local ArgParser = require "init"
			local ap = ArgParser.new()
				:flag("-f", { desc = "Foo" })
				:flag("-x", { desc = "Dash X option" })
				:flag("-g", { desc = "G flag!" })
				:flag(
					"--help-foo",
					{ func = function() print "HELP" end, desc = "Fooo" }
				)
				:flag("-d", {
					func = function() print "DEBUG" end,
					desc = "Print registered flags",
				})
			local flags = {
				"-f",
				"-x",
				"-g",
				"--help-foo",
				"-d",
			}
			ap:parse(flags)
			assert(ap:gflag "-f")
			assert(ap:gflag "-x")
			assert(ap:gflag "-g")
			assert(ap:gflag "--help-foo")
			assert(ap:gflag "-d")
		end,
	},
	test_flag_stack = {
		func = function()
			local ArgParser = require "init"
			local ap = ArgParser:new()
			ap:flag("-f", { desc = "Foo" })
				:flag("-x", { desc = "Dash X option" })
				:flag("-g", { desc = "G flag!" })
				:flag(
					"--help-foo",
					{ func = function() print "HELP" end, desc = "Fooo" }
				)
				:flag("-d", {
					func = function() print "DEBUG" end,
					desc = "Print registered flags",
				})
			ap:parse { "-fxd" }
			assert(ap:gflag "-f")
			assert(ap:gflag "-x")
			assert(not ap:gflag "-g")
			assert(not ap:gflag "--help-foo")
			assert(ap:gflag "-d")
		end,
	},

	test_args = {
		func = function()
			local ArgParser = require "init"
			local ap = ArgParser:new()

			local args = { "foo", "bar", "chill" }
			ap:parse(args)

			assert(ap:garg(1) == "foo")
			assert(ap:garg(2) == "bar")
			assert(ap:garg(3) == "chill")
			assert(#ap:gargs() == 3)
		end,
	},
}

for name, test in pairs(tests) do
	if type(name) ~= "string" then error "Test is not named!" end
	t.add_test(name, test)
end
t.test_all()

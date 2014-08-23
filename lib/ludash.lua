local table = require('table')
local string = require('string')

local lu = {}

--
-- Colections
--
function lu.each (t, func)
	-- http://springrts.com/wiki/Lua_Performance#TEST_9:_for-loops
	if lu.isArray(t) then
		local tl = #t

		for i = 1, tl do
			func(t[i], i, t)
		end
	else
		for k, v in pairs(t) do
			func(v, k, t)
		end
	end
end

function lu.map (t, func)
	local _r = {}
	local _i = 1

	lu.each(t, function (v, k)
		if lu.isArray(t) then
			local val = func(v, k, t)
			if val then
				_r[k] = val
				_i = _i + 1
			end
		else
			local val = func(v, k, t)
			table.insert(_r, val)
		end
	end)

	return _r
end

function lu.filter (t, func)
	local _r = {}
	local _i = 1

	lu.each(t, function (v, k)
		if lu.isArray(t) then
			if func(v, k, t) then
				_r[_i] = v
				_i = _i + 1
			end
		else
			if func(v, k, t) then
				table.insert(_r, v)
			end
		end
	end)

	return _r
end

--
-- Objects
--
function lu.isArray (val)
	return type(val) == 'table' and (val[1] or next(val) == nil)
end

function lu.isObject (val)
	return type(val) == 'table'
end

function lu.isString (val)
	return type(val) == 'string'
end

function lu.isNumber (val)
	return type(val) == 'number'
end

function lu.isFunction (val)
	return type(val) == 'function'
end

function lu.isBoolean (val)
	return type(val) == 'boolean'
end

function lu.isNil (val)
	return val == nil
end

--
-- Aliases
--
lu.isTable = lu.isObject
lu.forEach = lu.each
lu.collect = lu.map
lu.select = lu.filter

return lu

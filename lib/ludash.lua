local table = require('table')
local string = require('string')

local lu = {}

--
-- Colections
-- http://springrts.com/wiki/Lua_Performance#TEST_9:_for-loops
--
function lu.each (t, func)
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

	-- local pairing = pairs
	-- if lu.isArray(t) then pairing = ipairs end

	-- for key, val in pairing(t) do
	-- 	func(val, key, t)
	-- end
end

function lu.map (t, func)
	local _r = {}

	if lu.isArray(t) then
		local _i = 1
		local tl = #t

		for i = 1, tl do
			local val = func(t[i], i, t)
			if val then
				_r[_i] = val
				_i = _i + 1
			end
		end
	else
		for k, v in pairs(t) do
			local val = func(v, k, t)
			table.insert(_r, val)
		end
	end
	-- lu.each(t, function (val, index)
	-- 	local newVal = func(val, index, t)
	-- 	table.insert(r, newVal)
	-- end)
	return _r
end

function lu.filter (t, func)
	local _r = {}

	if lu.isArray(t) then
		local _i = 1
		local tl = #t

		for i = 1, tl do
			if func(t[i], i, t) then
				_r[_i] = t[i]
				_i = _i + 1
			end
		end
	else
		for k, v in pairs(t) do
			if func(v, k, t) then
				table.insert(_r, v)
			end
		end
	end

	-- lu.each(t, function (val, key, object)
	-- 	if func(val, key, object) then
	-- 		table.insert(r, val)
	-- 	end
	-- end)
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

local table = require('table')
local string = require('string')

local lu = {}

function lu.each (t, func)
	local pairing = pairs
	if lu.isArray(t) then pairing = ipairs end

	for key, val in pairing(t) do
		func(val, key, t)
	end
end

function lu.map (t, func)
	local r = {}
	for key, value in pairs(t) do
		r[key] = func(key, value, t)
	end
	return _t
end

function lu.filter (t, func)
	local r = {}

	lu.each(t, function (val, key, object)
		if func(val, key, object) then
			table.insert(r, val)
		end
	end)

	return r
end

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

return lu

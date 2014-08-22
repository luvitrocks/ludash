local table = require('table')

local lu = {}

function lu.each (t, func)
	local pairing = pairs
	if lu.isArray(t) then pairing = ipairs end

	for key, val in pairing(t) do
		func(val, key, t)
	end
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

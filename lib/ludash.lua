-- lib here

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

return lu

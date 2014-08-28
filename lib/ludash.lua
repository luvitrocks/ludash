local table = require('table')
local string = require('string')

local lu = {}

--
-- Colections (Tables)
--
function lu.each (t, func)
	-- http://springrts.com/wiki/Lua_Performance#TEST_9:_for-loops
	if lu.isArray(t) then
		local tl = #t
		for i = 1, tl do
			local v = t[i]
			func(v, i, t)
		end
	else
		for k, v in pairs(t) do
			func(v, k, t)
		end
	end
end

function lu.map (t, func)
	local _r = {}

	lu.each(t, function (v, k, l)
		if lu.isArray(t) then
			local val = func(v, k, l)
			if val then
				_r[k] = val
			end
		else
			local val = func(v, k, l)
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

function lu.find (t, func)
	if func == nil then return nil end

	local _r = nil
	lu.any(t, function (v, k, l)
		if func(v, k, l) then
			_r = v
			return true
		end
	end)

	return _r
end

function lu.reverse (t)
	local length = lu.size(t)

	for i = 1, length / 2, 1 do
		t[i], t[length-i+1] = t[length-i+1], t[i]
	end

	return t
end

function lu.reduce (t, func, memo)
	local init = memo == nil

	lu.each(t, function (v, k, l)
		if init then
			memo = v
			init = false
		else
			memo = func(memo, v, k, l)
		end
	end)

	if init then
		error('Empty array reduce without initial value')
	end

	return memo
end

function lu.reduceRight (t, func, memo)
	return lu.reduce(lu.reverse(t), func, memo)
end

function lu.where (t, props)
	local found = {}

	return lu.select(t, function (val)
		return lu.every(props, function(v, k)
			return val[k] == v
		end)
	end)
end

function lu.every (t, func)
	if lu.isEmpty(t) then return false end

	func = func or lu.identity

	local found = true
	lu.each(t, function(v, k, l)
		if found and not func(v, k, l) then
			found = false
		end
	end)

	return found
end

function lu.some (t, func)
	if lu.isEmpty(t) then return false end

	func = func or lu.identity

	local found = false
	lu.each(t, function (v, k, l)
		if not found and func(v, k, l) then
			found = true
			return found
		end
	end)

	return found
end

function lu.contains (t, val)
	return lu.some(t, function (v)
		return v == val
	end)
end

function lu.size (list, ...)
	local args = {...}

	if not lu.isEmpty(args) then
		return lu.size(args) + 1
	elseif lu.isArray(list) then
		return #list
	elseif lu.isObject(list) then
		local _l = 0
		lu.each(list, function () _l = _l + 1 end)
		return _l
	elseif lu.isString(list) then
		return list:len()
	end

	return 0
end

function lu.concat (...)
	local values = lu.flatten({...}, true)
	local _r = {}

	lu.each(values, function (v, k)
		_r[k] = v
	end)

	return _r
end

function lu.flatten (t, shallow)
	local shallow = shallow or false
	local new_flattened
	local _flat = {}

	lu.each(t, function (val, k, l)
		if lu.isTable(val) then
			new_flattened = shallow and val or lu.flatten(val)
			lu.each(new_flattened, function (v) _flat[#_flat+1] = v end)
		else
			_flat[#_flat+1] = val
		end
	end)

	return _flat
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

function lu.toBoolean (val)
	return not not val
end

function lu.isNil (val)
	return val == nil
end

function lu.isEmpty (val)
	if lu.isNil(val) then
		return true
	elseif lu.isArray(val) or lu.isObject(val) then
		return next(val) == nil
	elseif lu.isString(val) then
		return val:len() == 0
	else
		return false
	end

	return true
end

function lu.isEqual (tableA, tableB, useMt)
	local typeTabA = type(tableA)
	local typeTabB = type(tableB)

	if typeTabA ~= typeTabB then return false end
	if typeTabA ~= 'table' then return (tableA == tableB) end

	local mtA = getmetatable(tableA)
	local mtB = getmetatable(tableB)

	if useMt then
		if (mtA or mtB) and (mtA.__eq or mtB.__eq) then
			return mtA.__eq(tableA, tableB) or mtB.__eq(tableB, tableA) or (tableA == tableB)
		end
	end

	if lu.size(tableA) ~= lu.size(tableB) then return false end

	for i, v1 in pairs(tableA) do
		local v2 = tableB[i]
		if lu.isNil(v2) or not lu.isEqual(v1,v2,useMt) then return false end
	end

	for i, v1 in pairs(tableB) do
		local v2 = tableA[i]
		if lu.isNil(v2) then return false end
	end

	return true
end

function lu.identity (value)
	return value
end

local unique_id_counter = -1
function lu.uniqueId (template)
	unique_id_counter = unique_id_counter + 1

	if not template then
		return unique_id_counter
	end

	if lu.isString(template) then
		return template:format(unique_id_counter)
	end

	if lu.isFunction(template) then
		return template(unique_id_counter)
	end
end

function lu.times (n, func)
	local _r = {}
	for i = 1, n do
		_r[i] = func(i)
	end
	return _r
end

--
-- Aliases
--
lu.isTable	=	lu.isObject
lu.forEach	=	lu.each
lu.collect	=	lu.map
lu.inject	=	lu.reduce
lu.foldl	=	lu.reduce
lu.injectr	=	lu.reduceRight
lu.foldr	=	lu.reduceRight
lu.select	=	lu.filter
lu.include	=	lu.contains
lu.any		=	lu.some
lu.detect	=	lu.find
lu.all		=	lu.every
lu.compare	=	lu.isEqual
lu.uid		=	lu.uniqueId

return lu

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

function lu.size(list, ...)
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

function lu.isEqual (objA, objB, useMt)
	local typeObjA = type(objA)
	local typeObjB = type(objB)

	if typeObjA ~= typeObjB then return false end
	if typeObjA ~= 'table' then return (objA == objB) end

	local mtA = getmetatable(objA)
	local mtB = getmetatable(objB)

	if useMt then
		if (mtA or mtB) and (mtA.__eq or mtB.__eq) then
			return mtA.__eq(objA, objB) or mtB.__eq(objB, objA) or (objA == objB)
		end
	end

	if lu.size(objA) ~= lu.size(objB) then return false end

	for i, v1 in pairs(objA) do
		local v2 = objB[i]
		if lu.isNil(v2) or not lu.isEqual(v1,v2,useMt) then return false end
	end

	for i, v1 in pairs(objB) do
		local v2 = objA[i]
		if lu.isNil(v2) then return false end
	end

	return true
end

--
-- Aliases
--
lu.isTable = lu.isObject
lu.forEach = lu.each
lu.collect = lu.map
lu.select = lu.filter
lu.compare = lu.isEqual

return lu

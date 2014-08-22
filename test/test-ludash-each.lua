require('luvit-test/helper')

local _ = require('../lib/ludash')

local arrData = {12345, 'text', { foo = 'bar' }}
local index = 1
_.each(arrData, function (row, i)
	assert(i == index)
	index = index+1
end)

local objData = {foo = 'bar', num = 12}
_.each(objData, function (row, i)
	p(row, i)
end)

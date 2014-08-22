require('luvit-test/helper')

local _ = require('../lib/ludash')

local arrData = {12345, 'text', { foo = 'bar' }}
_.each(arrData, function (row, i)
	p(row, i)
end)

local objData = {foo = 'bar', num = 12}
_.each(objData, function (row, i)
	p(row, i)
end)

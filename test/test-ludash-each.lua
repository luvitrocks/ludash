require('luvit-test/helper')

local _ = require('../lib/ludash')

local r = {}

local arrData = {12345, 'text', { foo = 'bar' }}
_.each(arrData, function (row, i)
	r[i] = row
end)
assert(#r == 3)

r = {}

local objData = {foo = 'bar', num = 12345}
_.each(objData, function (row, i)
	r[i] = row
end)
assert(r.foo == 'bar')
assert(r.num == 12345)

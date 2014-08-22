require('luvit-test/helper')

local _ = require('../lib/ludash')

local people = {
	{ title = 'Robert', age = 24 },
	{ title = 'Simona', age = 29 },
	{ title = 'Jekyll', age = 26 },
	{ title = 'Aurora', age = 24 }
}

local youngest = _.filter(people, function (row, i)
	if row.age == 24 then return row end
end)

assert(#youngest == 2)
assert(youngest[1].title == 'Robert')
assert(youngest[1].age == 24)
assert(youngest[2].title == 'Aurora')
assert(youngest[2].age == 24)

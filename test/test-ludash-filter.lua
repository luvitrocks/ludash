require('luvit-test/helper')

local _ = require('../lib/ludash')

local people = {
	{ name = 'Robert', age = 24 },
	{ name = 'Simona', age = 30 },
	{ name = 'Jekyll', age = 26 },
	{ name = 'Aurora', age = 24 }
}

local youngest = _.filter(people, function (human)
	if human.age == 24 then return human end
end)

assert(#youngest == 2)
assert(youngest[1].name == 'Robert')
assert(youngest[1].age == 24)
assert(youngest[2].name == 'Aurora')
assert(youngest[2].age == 24)

local newPeople = _.map(people, function (human, i)
	if human.age % 3 == 0 then return human end
end)

p(newPeople[3])

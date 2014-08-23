require('luvit-test/helper')

local _ = require('../lib/ludash')

-- each
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

-- filter
local people = {
	{ name = 'Robert', age = 24 },
	{ name = 'Simona', age = 30 },
	{ name = 'Jekyll', age = 26 },
	{ name = 'Aurora', age = 24 }
}
local youngest = _.filter(people, function (human)
	return human.age == 24
end)
assert(#youngest == 2)
assert(youngest[1].name == 'Robert')
assert(youngest[1].age == 24)
assert(youngest[2].name == 'Aurora')
assert(youngest[2].age == 24)

local fakeUser = {
	name = 1,
	bio = 2,
	title = 3,
	some = 4,
	foo = 5,
	bar = 6
}
local fields = _.filter(fakeUser, function (prop)
	return prop % 2 == 0
end)
assert(#fields == 3)
assert(fields[1] == 2)
assert(fields[2] == 4)
assert(fields[3] == 6)

-- map
local newPeople = _.map(people, function (human)
	human.age = human.age + 10
	return human
end)
assert(#newPeople == 4)
assert(newPeople[1].name == 'Robert')
assert(newPeople[1].age == 34)
assert(newPeople[2].name == 'Simona')
assert(newPeople[2].age == 40)
assert(newPeople[3].name == 'Jekyll')
assert(newPeople[3].age == 36)
assert(newPeople[4].name == 'Aurora')
assert(newPeople[4].age == 34)

local nums = {
	one = 1,
	two = 2,
	three = 3
}
local newNums = _.map(nums, function (num)
	return num * 3
end)
equal(newNums, {9, 3, 6})

-- size
assert(_.size() == 0)
assert(_.size(nil) == 0)
assert(_.size(people) == 4)
assert(_.size(nums) == 3)
assert(_.size('some text') == 9)
assert(_.size('a','b', {}, function() end) == 4)

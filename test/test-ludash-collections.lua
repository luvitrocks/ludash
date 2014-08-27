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

-- some
local found = _.some({1, 2, 3, 4, 5}, function (num)
	return num / 2 == 1
end)
local notFound = _.some({1, 2, 3, 4, 5}, function (num)
	return num * 6 == 36
end)
local hasUpper = _.some({'a', 'B', 'c'}, function (letter)
	return letter:upper() == letter
end)
local empty = _.some({1, 2, 3})
assert(found == true)
assert(notFound == false)
assert(hasUpper == true)
assert(empty == false)

-- contains
assert(_.contains({1, 2, 3}, 3) == true)
assert(_.contains({1, 2, 3}, 5) == false)
assert(_.contains({a=1, b=2}, 2) == true)
assert(_.contains({a='foo', b='bar'}, 'bar') == true)
assert(_.contains({a='foo', b='bar'}, 'dodo') == false)

-- find
local even = _.find({1, 2, 3, 4, 5, 6}, function (num)
	return num % 2 == 0
end)
local robert = _.find(people, function (human)
	return human.name == 'Robert'
end)
local gustave = _.find(people, function (human)
	return human.name == 'Gustave'
end)
assert(even == 2)
assert(robert.name == 'Robert')
assert(robert.age == 34)
assert(gustave == nil)

-- where
local listOfPlays = {
	{title='Cymbeline', author='Shakespeare', year=1611},
	{title='Hamlet', author='Shakespeare', year=1603},
	{title='The Duke of Milan', author='Massinger', year=1623},
	{title='The Tempest', author='Shakespeare', year=1611},
	{title='Gallathea', author='Lyly', year=1585}
}
local plays = _.where(listOfPlays, {author="Shakespeare", year=1611})
assert(#plays == 2)
assert(plays[1]['title'] == 'Cymbeline')
assert(plays[1]['author'] == 'Shakespeare')
assert(plays[1]['year'] == 1611)
assert(plays[2]['title'] == 'The Tempest')
assert(plays[2]['author'] == 'Shakespeare')
assert(plays[2]['year'] == 1611)

-- every
assert(_.every({2,4,6}, function (num) return num % 2 == 0 end) == true)
assert(_.every({2,4,5}, function (num) return num % 2 == 0 end) == false)
assert(_.every({a=2,b=4,c=6}, function (val) return val % 2 == 0 end) == true)

-- reduce
assert(_.reduce({1,2,3}, function (memo, val) return memo + val end, 2) == 8)
assert(_.reduce({a=1, b=2, c=3}, function (memo, val) return memo + val end) == 6)
local abc = _.reduce({{x='a'}, {x='b'}, {x='c'}}, function (memo, val)
	return {x = memo.x .. val.x}
end)
assert(abc.x == 'abc')

-- size
assert(_.size() == 0)
assert(_.size(nil) == 0)
assert(_.size(people) == 4)
assert(_.size(nums) == 3)
assert(_.size('some text') == 9)
assert(_.size('a','b', {}, function() end) == 4)


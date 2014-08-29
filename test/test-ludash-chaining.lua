require('luvit-test/helper')

local _ = require('../lib/ludash')

local people = {
	{ name = 'Robert', age = 24 },
	{ name = 'Simona', age = 29 },
	{ name = 'Jekyll', age = 26 },
	{ name = 'Aurora', age = 24 }
}

local function twentyFour (human, ...)
	return human.age == 24
end

local function byAge (a, b)
	return a.name:byte() < b.name:byte()
end

local results = _.chain(people):filter(twentyFour):sort(byAge):value()
equal(results, {{name = 'Aurora', age = 24}, {name = 'Robert', age = 24}})

local diffSyntaxResults = _(people):chain():filter(twentyFour):sort(byAge):value()
equal(diffSyntaxResults, {{name = 'Aurora', age = 24}, {name = 'Robert', age = 24}})

local youngest = _(people):filter(function (human) return human.age == 24 end)
assert(#youngest == 2)
assert(youngest[1].name == 'Robert')
assert(youngest[1].age == 24)
assert(youngest[2].name == 'Aurora')
assert(youngest[2].age == 24)

equal(_({1, 2, 3}):value(), {1, 2, 3})

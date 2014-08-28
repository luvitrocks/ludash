require('luvit-test/helper')

local _ = require('../lib/ludash')

-- identity
assert(_.identity(1) == 1)
assert(_.identity('abc') == 'abc')

-- times
local func = ('Lua programming'):gmatch('.')
local splitted = _.times(5, func)
equal(splitted, {'L', 'u', 'a', ' ', 'p'})

-- uniqueId
assert(_.uid() == 0)
assert(_.uid() == 1)
assert(_.uid('prefix_%s') == 'prefix_2')
assert(_.uid(function (id) return 'lu'..id..'dash' end) == 'lu3dash')

-- once
local threeSum = _.once(function (a, b, c) return a + b + c end)
assert(threeSum(1,2,3) == 6)
assert(threeSum(4,5,6) == 6)

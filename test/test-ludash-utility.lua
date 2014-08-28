require('luvit-test/helper')

local _ = require('../lib/ludash')

-- times
local func = ('Lua programming'):gmatch('.')
local splitted = _.times(5, func)
equal(splitted, {'L', 'u', 'a', ' ', 'p'})

-- uniqueId
assert(_.uid() == 0)
assert(_.uid() == 1)
assert(_.uid('prefix_%s') == 'prefix_2')
assert(_.uid(function (id) return 'lu'..id..'dash' end) == 'lu3dash')

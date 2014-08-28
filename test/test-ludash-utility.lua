require('luvit-test/helper')

local _ = require('../lib/ludash')

-- uniqueId
assert(_.uid() == 0)
assert(_.uid() == 1)
assert(_.uid('prefix_%s') == 'prefix_2')
assert(_.uid(function (id) return 'lu'..id..'dash' end) == 'lu3dash')

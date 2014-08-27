require('luvit-test/helper')

local _ = require('../lib/ludash')

-- reverse
equal(_.reverse({1,2,3,4,5,6}), {6,5,4,3,2,1})
equal(_.reverse({{x='a'}, {x='b'}, {x='c'}}), {{x='c'}, {x='b'}, {x='a'}})

require('luvit-test/helper')

local _ = require('../lib/ludash')

-- isEmpty
assert(_.isEmpty({}) == true)
assert(_.isEmpty('') == true)
assert(_.isEmpty('string') == false)
assert(_.isEmpty({a = 1, b = 2}) == false)

-- isEqual
local arr = {1, 2, 3}
local hash =  {a = 1, b = 2}
local deep = {arr = arr, obj = hash}
assert(_.isEqual(arr, hash) == false)
assert(_.isEqual(arr, {1, 2, 3}) == true)
assert(_.isEqual(deep, {arr = arr, obj = hash}) == true)
assert(_.isEqual('text1', 'text1') == true)
assert(_.isEqual('text1', 'text2') == false)

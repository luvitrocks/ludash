require('luvit-test/helper')

local _ = require('../lib/ludash')

-- keys
equal(_.keys({one=1, two=2, three=3}), {"one", "two", "three"})

-- isEmpty
assert(_.isEmpty({}) == true)
assert(_.isEmpty('') == true)
assert(_.isEmpty('string') == false)
assert(_.isEmpty({a = 1, b = 2}) == false)

-- isEqual
local arr = {1, 2, 3}
local hash =  {a = 1, b = 2}
local deep = {arr = arr, obj = hash}
assert(_.isEqual(true, false) == false)
assert(_.isEqual(arr, hash) == false)
assert(_.isEqual(arr, {1, 2, 3}) == true)
assert(_.isEqual(deep, {arr = arr, obj = hash}) == true)
assert(_.isEqual('text1', 'text1') == true)
assert(_.isEqual('text1', 'text2') == false)

-- toBoolean
assert(_.toBoolean(true) == true)
assert(_.toBoolean(false) == false)
assert(_.toBoolean({}) == true)
assert(_.toBoolean(nil) == false)
assert(_.toBoolean('') == true)
assert(_.toBoolean(1) == true)
assert(_.toBoolean(0) == true)

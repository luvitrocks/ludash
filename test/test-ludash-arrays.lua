require('luvit-test/helper')

local _ = require('../lib/ludash')

-- reverse
equal(_.reverse({1,2,3,4,5,6}), {6,5,4,3,2,1})
equal(_.reverse({{x='a'}, {x='b'}, {x='c'}}), {{x='c'}, {x='b'}, {x='a'}})

-- flatten
equal(_.flatten({1,{2,3},{4,5,{6,7}}}), {1,2,3,4,5,6,7})
equal(_.flatten({1,{2},{{3}}}, true), {1,{2},{{3}}})

-- concat
equal(_.concat(1, 'a', 2, 'b', 3, true), {1,'a',2,'b',3,true})

-- invert
equal(_.invert({Moe="Moses", Larry="Louis", Curly="Jerome"}), {Moses="Moe", Louis="Larry", Jerome="Curly"})
equal(_.invert({'a','b','c'}), {a=1, b=2, c=3})

-- push
equal(_.push({1,2,3}, 4,5,6), {1,2,3,4,5,6})

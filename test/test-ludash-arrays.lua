local test = require('lua-tape').test
local _ = require('../lib/ludash')

-- reverse
test('reverse', function (t)
  t:deepEquals(_.reverse({1,2,3,4,5,6}), {6,5,4,3,2,1}, 'reversed numbers')
  t:deepEquals(_.reverse({{x='a'}, {x='b'}, {x='c'}}), {{x='c'}, {x='b'}, {x='a'}}, 'reversed tables')
  t:done()
end)

-- flatten
test('flatten', function (t)
  t:deepEquals(_.flatten({1,{2,3},{4,5,{6,7}}}), {1,2,3,4,5,6,7}, 'flatten deep')
  t:deepEquals(_.flatten({1,{2},{{3}}}, true), {1,2,{3}}, 'flatten shallow')
  t:done()
end)

-- concat
test('concat', function (t)
  t:deepEquals(_.concat(1, 'a', 2, 'b', 3, true), {1,'a',2,'b',3,true}, 'concat as array')
  t:done()
end)

-- invert
test('invert', function (t)
  t:deepEquals(_.invert({Moe='Moses', Larry='Louis', Curly='Jerome'}), {Curly='Jerome', Larry='Louis', Moe='Moses'}, 'invert dictionary')
  t:deepEquals(_.invert({'a','b','c'}), {a=1, b=2, c=3}, 'invert array')
  t:done()
end)

-- push
test('push', function (t)
  t:deepEquals(_.push({1,2,3}, 4,5,6), {1,2,3,4,5,6}, 'push to array')
  t:done()
end)

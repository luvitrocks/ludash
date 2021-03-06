# lλdash

[![build status](http://img.shields.io/travis/luvitrocks/ludash.svg?style=flat-square)](https://travis-ci.org/luvitrocks/ludash)
[![License](http://img.shields.io/badge/Licence-MIT-brightgreen.svg?style=flat-square)](LICENSE)

> [Luvit.io](http://luvit.io) utility-belt library for functional programming. Provides support for the usual functional suspects (each, map, reduce, filter...) without extending Lua core objects.

## Install

```bash
lit install voronianski/ludash
```

## Example

```lua
local _ = require('ludash')

local people = {
  { name = 'Robert', age = 24 },
  { name = 'Simona', age = 29 },
  { name = 'Jekyll', age = 26 },
  { name = 'Aurora', age = 24 }
}

local function twentyFour (human)
  return human.age == 24
end

local results = _.chain(people):filter(twentyFour):sortBy('name'):value()

p(results)
-- will output new table:
-- { {name = 'Aurora', age = 24}, {name = 'Robert', age = 24} }
```

## Documentation

The list of functions available inside _ludash_ can be classified into such categories:

* [Collection functions](#collections)
* [Array functions](#arrays)
* [Object functions](#objects)
* [Utility functions](#utilities)
* [Chaining](#chaining)

**Collection functions** are mostly meant for Lua tables which contains both an array-part and/or a map-part. **Array functions** meant for array lists or sequences. **Object functions** are meant for instances/classes. Also _ludash_ provides a bunch of helpful **utility methods** and **chaining** support.

The HTML version of this doc is available at http://luvitrocks.github.io/ludash.

## <a name="collections">Collection functions (Arrays or Objects)</a>

### each(table, iterator)

_Alias: `forEach`_

Iterates over a **table** of elements, yielding each in turn to an **iterator** function. Each invocation of **iterator** is called with three arguments: `(element, index, list)`. If list is a Lua map-like object, iterator's arguments will be `(value, key, list)`.

```lua
_.each({1, 2, 3}, print)
-- => prints each number in turn:
-- => 1 1
-- => 2 2
-- => 3 3

_.each({one=1, two=2, three=3}, function(num, key) print(num) end)
-- => prints each number in turn:
-- => one 1
-- => two 2
-- => three 3
```

Also attention is paid to performance, so `pairs`, `ipairs` and `table.insert` are **not** used for lists providing higher execution speed. Based on [Lua perf benchmarks](http://springrts.com/wiki/Lua_Performance#TEST_9:_for-loops).

### map(table, iterator)

_Alias: `collect`_

Produces a new array of values by mapping each value in **table** through a transformation function (**iterator**). If list is a Lua map-like object, **iterator**'s arguments will be `(value, key, list)`.

```lua
_.map({1, 2, 3}, function (num) return num * 3 end)
-- => {3, 6, 9}
_.map({one=1, two=2, three=3}, function (num) return num * 3 end)
-- => {3, 6, 9}
```

### reduce(table, iterator)

_Aliases: `inject`, `foldl`_

Boils down a list of values into a single table. **Memo** is the initial state of the reduction, and each successive step of it should be returned by **iterator**. The iterator is passed four arguments: the `memo`, then the `value` and `index` (or `key`) of the iteration, and finally a reference to the entire `list`.

```lua
local sum = _.reduce({1, 2, 3}, function (memo, val) return memo + val end, 0)
-- => 6

local str = _.reduce({{x='a'}, {x='b'}, {x='c'}}, function (memo, val) return memo.x .. val.x end)
-- => 'abc'
```

### reduceRight(table, iterator)

_Alias: `foldr`_

Similar to `_.reduce`, but performs from right to left.

```lua
local t = {{0, 1}, {2, 3}, {4, 5}}
local flat = _.reduceRight(t, function (memo, val) return _.concat(memo, val) end, {})
-- => {4, 5, 2, 3, 0, 1}
```

### find(table, iterator)

_Alias: `detect`_

Looks through each value in the **table**, returning the first one that passes a truth test (**iterator**). The function returns as soon as it finds an acceptable element, and doesn't traverse the entire table.

```lua
_.find({1, 2, 3, 4, 5, 6}, function (num) return num % 2 == 0 end)
-- => 2
```

### filter(table, iterator)

_Alias: `select`_

Looks through each value in the **table**, returning an array of all the values that pass a truth test (**iterator**).

```lua
_.filter({1, 2, 3, 4, 5, 6}, function (num) return num % 2 == 0 end)
-- => {2, 4, 6}
```

### where(table, properties)

Looks through each value in the **table**, returning an array of all the values that contain all of the key-value pairs listed in **properties**.

```lua
_.where(listOfPlays, {author="Shakespeare", year=1611})
-- => 
-- {
--  {title="Cymbeline", author="Shakespeare", year=1611}, 
--  {title="The Tempest", author="Shakespeare", year=1611}
-- }
```

### every(table, predicate)

_Alias: `all`_

Checks whether or not all elements pass a validation test.

```lua
_.all({2,4,6}, function (num) return num %2 == 0 end)
-- => true
```

### contains(table, value)

_Alias: `include`_

Returns `true` if the **value** is present in the **table**.

```lua
_.contains({6, 8, 10, 16}, 8) -- => true
_.contains({a='foo', b='bar'}, 'bar') -- => true
_.contains({nil, true, 0, true, true}, false) -- => false
```

### some(table, predicate)

_Alias: `any`_

Returns `true` if any of the values in the **table** pass the **predicate** truth test. Stops traversing the table if a `true` element is found.

```lua
local function isUpper (value) return value:upper() == value end
_.some({'a', 'B', 'c'}, isUpper) -- => true
```

### size(...)

When given a **table**, provides the count for the very number of values in that table.

```lua
_.size({1, 2, 3}) -- => 3
_.size({one=1, two=2}) -- => 2
```

When given a list of **arguments**, returns the count of these arguments.

```lua
_.size(1, 2, 3) -- => 3
_.size('a', 'b', {}, function () end) -- => 4
```

### sort(table, [comparator])

Sorts a **table** and relies on Lua's native `table.sort`. Handles custom comparison functions.

```lua
_.sort({'b','a','d','c'}) 
-- => "{'a','b','c','d'}"

_.sort({'b','a','d','c'}, function (a,b) return a:byte() > b:byte() end) 
-- => "{'d','c','b','a'}"
```

### sortBy(table, [iterator])

Returns a sorted copy of table, ranked in ascending order by the results of running each value through **iterator**. Iterator may also be the string name of the property to sort by.

```lua
_.sortBy({1, 2, 3, 4, 5, 6}, function (num) return math.sin(num) end)
-- => {5, 4, 6, 3, 1, 2}

_.sortBy({{name='curly', age=25}, {name='moe', age=21}, {name='larry', age=23}}, 'name')
-- => {{ name = "curly", age = 25 }, { name = "larry", age = 23 }, { name = "moe", age = 21 }}
```

**[[⇧]](#documentation)**

## <a name="arrays">Array functions</a>

### flatten(array, [shallow])

Flattens a nested **array** (the nesting can be to any depth). If you pass **shallow** flag, the array will only be flattened a single level.

```lua
_.flatten({1,{2,3},{4,5,{6,7}}}) 
-- => {1,2,3,4,5,6,7}
_.flatten({1,{2},{{3}}}, true) 
-- => {1,{2},{{3}}}
```

### reverse(array)

Reverses an **array** table order.

```lua
_.reverse({1,2,3,4,5,6})
-- => {6,5,4,3,2,1}
```

### concat(...)

Creates a new array by concatenating the **arguments** passed in. It does not alter the original versions of the values passed in.

```lua
_.concat(1, 2, 3, 4, 5, 6)
-- => {1,2,3,4,5,6}
_.concat({1,2,3}, {4,5,6})
-- => {1,2,3,4,5,6}
```

### push(array, [elements])

Adds the list of **elements** on to the end of an **array**.

```lua
local array = {1,2,3}
_.push(array, 4,5,6)
p(array)
-- => {1,2,3,4,5,6}
```

**[[⇧]](#documentation)**


## <a name="objects">Object functions</a>

### keys(table)

Retrieve all the names of the **tables**'s properties. The order of the keys is not guaranteed to be consistent.

```lua
_.keys({one=1, two=2, three=3})
-- => {"one", "two", "three"}
```

### values(table)

Retrieve all the values of the **tables**'s properties. The order of the keys is not guaranteed to be consistent.

```lua
_.keys({one=1, two=2, three=3})
-- => {1, 2, 3}
```

### invert(table)

_Alias: `mirror`_

Returns a copy of the **table** where the keys have become the values and the values the keys.

```lua
_.invert({Moe="Moses", Larry="Louis", Curly="Jerome"})
-- => {Moses="Moe", Louis="Larry", Jerome="Curly"}

_.invert({'a','b','c'})
-- => "{a=1, b=2, c=3}"
```

### isEqual(table1, table2, [useMetaTable])

_Alias: `compare`_

Performs a deep comparison between the two objects, to determine if they should be considered equal. It can compare strings, functions, nil, booleans. Compares tables by reference or by values. If optional `useMetaTable` boolean is passed (default `false`), the equality operator `==` will be used if one of the given objects has a metatable implementing `__eq`.

```lua
_.isEqual(1, 1) -- => true
_.isEqual(true, false) -- => false
_.isEqual(3.14, math.pi) -- => false
_.isEqual({3,4,5}, {3,4,{5}}) -- => false
```

### isEmpty(object)

Returns `true` if object contains no values.

```lua
_.isEmpty('') -- => true
_.isEmpty({})  -- => true
_.isEmpty({1, 2, 3}) -- => false
```

### isArray(object)

Returns `true` if object is an Array (i.e. a sequence).

```lua
_.isArray({}) -- => true
_.isArray({1, 2, 3}) -- => true
_.isArray({'a', 'b', 'c'}) -- => true
```

### isObject(object)

_Alias: `isTable`_

Returns `true` if object is an actual Object (i.e a Table).

```lua
_.isTable({}) -- => true
_.isTable(math) -- => true
_.isTable(string) -- => true
```

### isFunction(object)

Returns `true` if object is a Function.

```lua
_.isFunction(print) -- => true
_.isFunction(function () end) -- => true
_.isFunction({}) -- => false
```

### isString(object)

Returns `true` if object is a String.

```lua
_.isString('') -- => true
_.isString('Hello') -- => false
_.isString({}) -- => false
```

### isNumber(object)

Returns `true` if object is a Number.

```lua
_.isNumber(math.pi) -- => true
_.isNumber(math.huge) -- => true
_.isNumber(0/0) -- => true
_.isNumber() -- => false
```

### isBoolean(object)

Returns `true` if object is either `true` or `false`.

```lua
_.isBoolean(true) -- => true
_.isBoolean(false) -- => true
_.isBoolean(1 == 1) -- => true
_.isBoolean(print) -- => false
```

### toBoolean(object)

Converts any given object to a Boolean.

```lua
_.toBoolean(true) -- => true
_.toBoolean(false) -- => false
_.toBoolean(nil) -- => false
_.toBoolean({}) -- => true
_.toBoolean(1) -- => true
```

### isNil(object)

Returns `true` if the value of object is `nil`.

```lua
_.isNil() -- => true
_.isNil(nil) -- => true
_.isNil({}) -- => false
```

**[[⇧]](#documentation)**


## <a name="utilities">Utility functions</a>

### identity(value)

Returns the same **value** that is used as the argument. In math: `f(x) = x`. This function is used as default iterator inside _ludash_.

```lua
local moe = {name='moe'}
_.identity(moe);
-- => {name='moe'}
```

### times(n, iterator)

Calls a given **iterator** function `n` times.

```lua
local func = ('Luvit programming'):gmatch('.')
_.times(5, func) 
-- => {'L','u','v','i','t'}
```

### once(func)

Produces a **function** that runs only once. Successive calls to this function will still yield the same input.

```lua
local sq = _.once(function (v) return v * v end)
sq(1) -- => 1
sq(2) -- => 1
sq(3) -- => 1
```

### uniqueId([template])

_Alias: `uid`_

Generates and returns a globally-unique integer id for the current session. It can handle string **templates** for formatted  output with Lua `string.format` or callback **function** for the same purpose.

```lua
_.uniqueId('id%s') 
-- => 'id2'

local function formatter (id) return '$'..id..'$' end
_.uniqueId(formatter) 
-- => '$id1$'
```

### functions(table, [recurseMetaTable])

_Alias: `methods`_

Returns a sorted array of the names of every method in a **table**. If `recurseMetaTable` flag is provided (default `false`) and if the given object has a metatable implementing an `__index` field pointing to another table, will also recurse on this table.

```lua
_.functions(lu)
-- => {"all", "any", "bind", "bindAll", "clone", "compact", "compose" ... }
```

**[[⇧]](#documentation)**

## <a name="chaining">Chaining</a>

You can use _ludash_ **method chaining** (also known as _name parameter idiom_) which is a technique for invoking consecutively method calls in object-oriented style. Each method returns an object, and methods calls are chained together.

### chain(value)

Returns a wrapped table. Calling methods on this table will continue to return wrapped tables until `:value()` is used to unwrap a chained object.

For convenience, you can also use `_(value)` to start chaining methods, instead of `_.chain(value)`.

```lua
local stooges = {{name='curly', age=25}, {name='moe', age=21}, {name='larry', age=23}}
local youngest = _.chain(stooges)
    :sort(function (stooge) return stooge.age end)
    :map(function (stooge) return stooge.name .. ' is ' .. stooge.age end)
    :first()
    :value()
-- => "moe is 21"
```

### value()

Extracts the value of a wrapped chained object.

```lua
_({1, 2, 3}):value();
-- => {1, 2, 3}
```

**[[⇧]](#documentation)**

## References

## License

MIT Licensed

Copyright (c) 2014-2016 Dmitri Voronianski [dmitri.voronianski@gmail.com](mailto:dmitri.voronianski@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

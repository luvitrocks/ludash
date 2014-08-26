# lλdash

[![NPM version](http://img.shields.io/npm/v/ludash.svg?style=flat-square)](http://badge.fury.io/js/ludash)
[![build status](http://img.shields.io/travis/luvitrocks/ludash.svg?style=flat-square)](https://travis-ci.org/luvitrocks/ludash)
[![License](http://img.shields.io/badge/Licence-MIT-brightgreen.svg?style=flat-square)](LICENSE)

[Luvit.io](http://luvit.io) utility-belt library for functional programming. Provides support for the usual functional suspects (each, map, reduce, filter...) without extending Lua core objects.

## Install

```bash
npm install ludash
```

If you're not familiar with npm check this out:

- https://github.com/voronianski/luvit-npm-example#how-to
- https://github.com/luvitrocks/luvit-module-boilerplate#whats-npm

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

_Alias: `_.inject`, `_.foldl`_

Boils down a list of values into a single table. **Memo** is the initial state of the reduction, and each successive step of it should be returned by **iterator**. The iterator is passed four arguments: the `memo`, then the `value` and `index` (or `key`) of the iteration, and finally a reference to the entire `list`.

```lua
local sum = _.reduce({1, 2, 3}, function (memo, num, index) return memo + num end, 0)
-- => 6

local str = _.reduce({{x='a'}, {x='b'}, {x='c'}}, function (memo, val, index) return memo.x .. val.x end)
-- => 'abc'
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

**[[⇧]](#documentation)**

## <a name="arrays">Array functions</a>

**[[⇧]](#documentation)**


## <a name="objects">Object functions</a>

### isEqual(table1, table2, useMetaTableFlag)

_Alias: `compare`_

Performs a deep comparison between the two objects, to determine if they should be considered equal. It can compare strings, functions, nil, booleans. Compares tables by reference or by values. If optional `useMetaTableFlag` boolean is passed (default `false`), the equality operator `==` will be used if one of the given objects has a metatable implementing `__eq`.

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

**[[⇧]](#documentation)**


## <a name="chaining">Chaining</a>

**[[⇧]](#documentation)**


## References

## License

MIT Licensed

Copyright (c) 2014 Dmitri Voronianski [dmitri.voronianski@gmail.com](mailto:dmitri.voronianski@gmail.com)

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

# lλdash

[![NPM version](https://badge.fury.io/js/ludash.svg)](http://badge.fury.io/js/ludash)

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

Also attention is paid to performance, so `pairs`, `ipairs` and `table.insert` are not used for lists providing higher execution speed. Based on benchmarks [http://springrts.com/wiki/Lua_Performance#TEST_9:_for-loops](http://springrts.com/wiki/Lua_Performance#TEST_9:_for-loops).

### map(table, iterator)

_Alias: `collect`_

### filter(table, iterator)

_Alias: `select`_

**[[⇧]](#documentation)**

## <a name="arrays">Array functions</a>

**[[⇧]](#documentation)**


## <a name="objects">Object functions</a>

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

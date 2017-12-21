# Ohm [![Build Status](https://travis-ci.org/nickbclifford/Ohm.svg?branch=master)](https://travis-ci.org/nickbclifford/Ohm)
Ohm is a stack-oriented programming language inspired by [05AB1E](https://github.com/Adriandmen/05AB1E/) and [Jelly](https://github.com/DennisMitchell/jelly) designed specifically for [code golf](https://en.wikipedia.org/wiki/Code_golf).

Does tacit programming make no sense to you, but you really wish you could use Jelly's links? If so, Ohm is the language for you.

Interested in Ohm, but don't want to clone the repository? Thanks to [Dennis](https://github.com/DennisMitchell), there is an [online interpreter](https://tio.run/#ohm2) available on [TryItOnline](https://tio.run/#home).

## Programs and Syntax

Check the [full list of components](https://github.com/nickbclifford/Ohm/blob/master/components.md) for more info!

### The Stack
Ohm uses a stack memory model. Think of the stack as a big array that every component of an Ohm circuit interacts with. For example, when the instruction pointer hits a number, it will *push* that number to the stack and continue, while the `+` component *pops* two elements off the stack, adds them, and *pushes* their result. Thus, the following circuit will output 15.

```
13 2+
```

(The numbers have to be separated with a no-op (space, in this case) since Ohm continues parsing number literals until there are no more digits left.)

### Blocks
Conditional statements and loops in Ohm are handled by a construct called a _block_. (If you're familiar with Ruby, it's pretty similar to Ruby's blocks.) They're essentially sections of code that are executed differently depending on what component they're attached to. Some components that use them are `?` for if statements, `:` for for-each loops, `⁇` for array select/filtering, and `€` for array mapping.

#### If/Else
If you want to add an `else` clause to an if statement, just place the `¿` component before the end of the block and put the alternate code in between the two.

##### Example
```
0?"code for truthy condition"¿"code for falsy condition";
```

#### Auto-Pushing
Most array-looping components like `€`, `⁇`, and `‼` will automatically push the current value to the top of the stack, meaning that `_` does not have to be explicitly called to get the value. **There is one exception to this: the `:` (foreach) component**. Because of the different use cases for `:`, the value is not automatically pushed and has to be explicitly pushed via `_`.

##### Example
```
5@€^*;  Creates a new array with every element multiplied by its index
5@:_,;  Prints each element in the array
```

### Implicit Everything
Since Ohm is a golfing language, many things are done implicitly in order to save bytes for the golfer.
- If there is nothing else in the circuit, concluding components like `;` in conditional/loop blocks and `"` in string literals are inferred and do not have to be explicitly input.
- If there are not enough items on the stack when a component tries to pop from it, Ohm will push user input to the stack until there are enough.
- If a circuit has not printed anything once execution completes, the top element of the stack will automatically be printed.

### Vectorization
Most components will automatically *vectorize*, meaning that if you pass in an array(s), it will automatically perform its function over those arguments. For example, passing `[1, 2, 3]` to the `²` component will return `[1, 4, 9]`. This is more efficient than mapping or using the `«` component.

### Wires
Wires are a way to splinter your code into different functions (similar to links in Jelly). New wires are placed on a separate line, and the top-most wire is always executed as the main wire.

The `Ω` component will execute the wire below the current one, whereas `Θ` will execute the one above it, and `Φ` will pop an element from the stack and execute the wire at that index.

#### Example
```
25@Ωτ@ΩΣ
:^²_-
```

As you can see, it saves bytes by only requiring the `:` block to be declared once.

### Base 255
The `B` component can handle input bases up to 255. Because of how efficient base 255 is at storing numbers, Ohm comes with a built-in to convert base 255 back to base 10 for use in a circuit. Just surround the base 255 number with `“`. ([Here's a base 255 conversion script](https://tio.run/##y8/INfr/39PI1NTp/38LM3NTYwNLAA) for your convenience.)

### String Compression
Ohm uses a slightly-modified version of the [Smaz](https://github.com/antirez/smaz) compression library. Inside Ohm circuits, compressed string literals are delimited by `”` characters. In order to generate a compressed string, use the `Ohm::Smaz.compress` method or the `·c` component in a circuit.

## What's New?
The release of Ohm v2 brought a few new changes, namely:
- Instead of CP437, Ohm now uses its own [custom code page](https://github.com/nickbclifford/Ohm/blob/master/code_page.md).
- `true`/`false` values have been replaced with `0` and `1`.
- Network access is now made possible with `·G`, but safe mode will disable it.

## Running
The Ohm interpreter is written in Ruby 2.x (tested on >= 2.2.8). The core interpreter relies on [RSmaz](https://github.com/peterc/rsmaz) for string compression and [Ruby/GSL](https://github.com/SciRuby/rb-gsl) for polynomial solving, and the unit tests rely on [RSpec](http://rspec.info/), [Timecop](https://github.com/travisjeffery/timecop), and [Rake](https://github.com/ruby/rake).

To install dependencies for *normal use*, run `bundle install --without test`. To install unit testing dependencies, run `bundle install` normally.

### Tests
To run unit tests, run `rake`.

### Interpreter Options
|Flag|Usage|
|----|-----|
|`-c, --code-page`|Reads the given file with the Ohm encoding (default UTF-8).|
|`-d, --debug`|Activates **debug mode**, which prints the current command and stack at every iteration.|
|`-e, --eval`|Evaluates the given circuit as Ohm code.|
|`-h, --help`|Prints usage help.|
|`-l, --length`|Prints the length of the program.|
|`-s, --safe`|Activates **safe mode**, which disables components like `·G` that may have unsafe side effects.|
|`-t, --time`|Shows the time taken to execute (in seconds) after completion.|

## Troubleshooting
When using the `-e` flag for executing from the terminal, make sure your terminal is in **UTF-8** mode. This can be achieved on Windows with the command `chcp 65001`. If the terminal is in the incorrect encoding, Ruby will raise an `Encoding::CompatibilityError` when trying to use non-ASCII characters (in my experience).

## TODO
- Change wire splitting from regex to a small parser thing
- Start using [BigDecimal](https://ruby-doc.org/stdlib-2.4.2/libdoc/bigdecimal/rdoc/BigDecimal.html) for arbitrary precision calculations instead of limiting precision with Ruby `Float` (see [#8](https://github.com/nickbclifford/Ohm/issues/8))
- Possibly add hashing functions (see [#9](https://github.com/nickbclifford/Ohm/issues/9))

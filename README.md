# Ohm [![Build Status](https://travis-ci.org/nickbclifford/Ohm.svg?branch=master)](https://travis-ci.org/nickbclifford/Ohm)
Ohm is a stack-oriented programming language inspired by [05AB1E](https://github.com/Adriandmen/05AB1E/) and [Jelly](https://github.com/DennisMitchell/jelly) designed specifically for [code golf](https://en.wikipedia.org/wiki/Code_golf).

Does tacit programming make no sense to you, but you really wish you could use Jelly's links? If so, Ohm is the language for you.

## Programs and Syntax

Check the [full list of components](https://github.com/MiningPotatoes/Ohm/blob/master/components.md) for more info!

### The Stack
Ohm uses a stack memory model. Think of the stack as a big array that every component of an Ohm circuit interacts with. For example, when the instruction pointer hits a number, it will *push* that number to the stack and continue, while the `+` component *pops* two elements off the stack, adds them, and *pushes* their result. Thus, the following circuit will output 15.

```
13 2+
```

(The numbers have to be separated with a no-op (space, in this case) since Ohm continues parsing number literals until there are no more digits left.)

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

### String Compression
Ohm uses a slightly-modified version of the [Smaz](https://github.com/antirez/smaz) compression library. Inside Ohm circuits, compressed string literals are delimited by `▀` characters. In order to generate a compressed string, use the `Ohm::Smaz.compress` method.

## Running
The Ohm interpreter is written in Ruby 2.x. The core interpreter does not rely on any external gems except for [RSmaz](https://github.com/peterc/rsmaz), and the unit tests rely on [RSpec](http://rspec.info/) and [rake](https://github.com/ruby/rake).

### Tests
To run unit tests, run `rake`.

### Interpreter Options
|Flag|Usage|
|----|-----|
|`-c, --cp437`|Reads the given file with CP437 encoding (default UTF-8).|
|`-d, --debug`|Activates **debug mode**, which prints the current command and stack at every iteration.|
|`-e, --eval`|Evaluates the given circuit as Ohm code.|
|`-h, --help`|Prints usage help.|
|`-l, --length`|Prints the length of the program.|
|`-t, --time`|Shows the time taken to execute (in seconds) after completion.|

## Troubleshooting
If some of the components you're using seem to be no-ops (i.e. they either don't do anything or hang execution), make sure your terminal is in **UTF-8** mode. This can be achieved on Windows with the command `chcp 65001`.

If that doesn't fix it, feel free to open an issue here on GitHub.

## TODO
- Proper vectorization of components

# Ohm
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

### Wires
Wires are a way to splinter your code into different functions (similar to links in Jelly). New wires are placed on a separate line, and the top-most wire is always executed as the main wire.

The `Ω` component will execute the wire below the current one, whereas `Θ` will execute the one above it, and `Φ` will pop an element from the stack and execute the wire at that index.

There is one special component, `∞`, that will re-execute the **current** wire. This can be very useful for things like recursion, but be warned, as this can easily cause an infinite loop!

#### Example
```
25@Ωτ@ΩΣ
:^²_-
```

As you can see, it saves bytes by only requiring the `:` block to be declared once.

## Running
The Ohm interpreter is written in Ruby 2.x. It does not rely on any external gems other than the standard library.

### Interpreter Options
|Flag|Usage|
|----|-----|
|`-c, --cp437`|Reads the given file with CP437 encoding.|
|`-d, --debug`|Activates **debug mode**, which prints the current command and stack at every iteration.|
|`-e, --eval`|Evaluates the given circuit as Ohm code.|
|`-h, --help`|Prints usage help.|
|`-t, --time`|Shows the time taken to execute (in seconds) after completion.|

## Troubleshooting
If some of the components you're using seem to be no-ops (i.e. they either don't do anything or hang execution), make sure your terminal is in **UTF-8** mode. This can be achieved on Windows with the command `chcp 65001`.

If that doesn't fix it, feel free to open an issue here on GitHub.

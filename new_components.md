# Components
This is a list of all (currently implemented) components that are usable in an Ohm circuit.

## Single character

|Component|Action|Description|
|---------|------|-----------|
|`°`|N/A|Pushes an array of all given inputs.|
|`¹`|N/A|N/A|
|`²`|Pop `a`|Pushes `a` squared.|
|`³`|N/A|Pushes the first input.|
|`⁴`|N/A|Pushes the second input.|
|`⁵`|N/A|Pushes the third input.|
|`⁶`|Pop `a`|Pushes the `a`th input.|
|`⁷`|N/A|Pushes 16.|
|`⁸`|N/A|Pushes 100.|
|`⁹`|N/A|Pushes the value of the counter variable.|
|`⁺`|N/A|Increments the counter variable.|
|`⁻`|N/A|Decrements the counter variable.|
|`⁼`|Pop `a`, `b`|Pushes whether `a` and `b` are equal. *Does not vectorize.*|
|`⁽`|Pop `a`|Pushes the first element in `a`. *Does not vectorize.*|
|`⁾`|Pop `a`|Pushes the last element in `a`. *Does not vectorize.*|
|`ⁿ`|Pop `a`, `b`|Pushes `a`<sup>`b`</sup>.|
|`½`|Pop `a`|Pushes `a / 2` (half).|
|`⅓`|N/A|N/A|
|`¼`|N/A|N/A|
|`←`|Pop `a`, `b`|Pushes `a.unshift(b)`.|
|`↑`|Pop `a`|Pushes the maximum element in `a`.|
|`→`|Pop `a`, `b`|Pushes `a.push(b)`.|
|`↓`|Pop `a`|Pushes the minimum element in `a`.|
|`↔`|Pop `a`, `b`|Pushes `a.concat(b)`.|
|`↕`|Pop `a`|Pushes the minimum and maximum element in `a` as an array of the form `[min, max]`.|
|`ı`|Pop `a`|Pushes `a` rounded *up* to the nearest integer (ceiling).|
|`ȷ`|Pop `a`|Pushes `a` rounded *down* to the nearest integer (floor).|
|`×`|Pop `a`, `b`|Pushes `a` repeated `b` times.|
|`÷`|Pop `a`|Pushes `1 / a` (reciprocal).|
|`£`|Block|Runs the given block infinitely.|
|`¥`|Pop `a`, `b`|Pushes `a % b == 0` (divisibility).|
|`€`|Pop `a`, block|Pushes an array with the results of running the given block once for every element in `a` (map/collect).|
|`!`|Pop `a`|Pushes `a!` (factorial).|
|`"`|N/A|Creates a string literal.|
|`#`|Pop `a`|Pushes the range `0..a`.|
|`$`|N/A|Pushes the current value of the register.|
|`%`|Pop `a`, `b`|Pushes `a % b` (modulo).|
|`&`|Pop `a`, `b`|Pushes `a && b` (boolean AND).|
|`'`|Pop `a`|Pushes the character with char code `a`.|
|`(`|Pop `a`|Pushes `a` without the first element.|
|`)`|Pop `a`|Pushes `a` without the last element.|
|`*`|Pop `a`, `b`|Pushes `a * b` (multiplication).|
|`+`|Pop `a`, `b`|Pushes `a + b` (addition).|
|`,`|Pop `a`|Prints `a` to standard output (with trailing newline).|
|`-`|Pop `a`, `b`|Pushes `a - b` (subtraction).|
|`.`|N/A|Creates a character literal (e.g. `.a` ⇒ `'a'`).|
|`/`|Pop `a`, `b`|Pushes `a / b` (division).|
|Digits `0-9`|N/A|Creates a number literal.|
|`:`|Pop `a`, block|Executes the given block for each element in `a` (foreach loop).|
|`<`|Pop `a`, `b`|Pushes `a < b` (less than).|
|`=`|Get `a`|Prints `a` to standard output (with trailing newline).|
|`>`|Pop `a`, `b`|Pushes `a > b` (greater than).|
|`?`|Pop `a`, block|If `a` is truthy, executes the given block. If not, executes the block given to the `¿` component if one is present.|
|`@`|Pop `a`|Pushes the range `1..a`.|
|`A`|Pop `a`|Pushes the absolute value of `a`.|
|`B`|Pop `a`, `b`|Pushes `a` converted to base `b`.|
|`C`|N/A|N/A|
|`D`|Pop `a`|Pushes `a` twice (duplicate).|
|`E`|Pop `a`, `b`|Pushes `a == b` (equality).|
|`F`|N/A|N/A|
|`G`|Pop `a`, `b`|Pushes the range `a..b`.|
|`H`|Pop `a`, `b`|Pushes `a` split on spaces.|
|`I`|N/A|Pushes input from standard input.|
|`J`|Pop `a`|If `a` is an array, pushes `a.join('')`, else pushes `stack.join('')`.|
|`K`|Pop `a`, `b`|Pushes the amount of times that `b` occurs in `a`.|
|`L`|Pop `a`|Prints `a` to standard output (*without* trailing newline).|
|`M`|Pop `a`, block|Runs the given block `a` times.|
|`N`|Pop `a`, `b`|Pushes `a != b` (inequality).|
|`O`|N/A|Removes last element of stack.|
|`P`|Pop `a`|Pushes all primes up to `a`.|
|`Q`|N/A|Reverses stack.|
|`R`|Pop `a`|Pushes `a` reversed.|
|`S`|Pop `a`|Pushes `a` sorted.|
|`T`|N/A|N/A|
|`U`|Pop `a`|Pushes `a` uniquified.|
|`V`|Pop `a`|Pushes divisors of `a`.|
|`W`|N/A|Pushes `[stack]` (wrap).|
|`X`|Pop `a`|Pushes `!a` (boolean NOT).|
|`Y`|Pop `a`|Pushes proper divisors of `a`.|
|`Z`|Pop `a`|Pushes `a` split on newlines.|
|`[`|Pop `a`|Pushes `stack[a]`.|
|`\`|Pop `a`, `b`, `c`|Pushes `a` with all matches of `b` replaced by `c`.|
|`]`|Pop `a`|Flattens `a` by one level onto the stack.|
|`^`|N/A|Pushes index of current element in array being looped over.|
|`_`|N/A|Pushes current element in array being looped over.|
|`` ` ``|Pop `a`|Pushes char code of `a`.|
|`a`|Pop `a`, `b`|Pushes absolute difference of `a` and `b`.|
|`b`|Pop `a`|Pushes `a` in binary (base 2).|
|`c`|Pop `a`, `b`|Pushes `a nCr b` (binomial coefficient).|
|`d`|Pop `a`|Pushes `a * 2` (double).|
|`e`|Pop `a`, `b`|Pushes `a nPr b` (permutations).|
|`f`|Pop `a`|Pushes all Fibonacci numbers up to `a`.|
|`g`|Pop `a`, `b`|Pushes the range `a...b`.|
|`h`|Pop `a`|Pushes the first element of `a`.|
|`i`|Pop `a`|Pushes the last element of `a`.|
|`j`|Pop `a`, `b`|If `a` is an array, pushes `a.join(b)`, else pushes `stack.join(b)`.|
|`k`|Pop `a`, `b`|Pushes index of `b` in `a`.|
|`l`|Pop `a`|Pushes length of `a`.|
|`m`|Pop `a`|Pushes prime factors of `a`.|
|`n`|Pop `a`|Pushes *exponents* of prime factorization of `a`.|
|`o`|Pop `a`|Pushes full prime factorization of `a`.|
|`p`|Pop `a`|Pushes whether `a` is a prime number.|
|`q`|N/A|Immediately stops program execution.|
|`r`|Pop `a`, `b`, `c`|Pushes `a.tr(b, c)`.|
|`s`|Pop `a`, `b`|Pushes `b`, `a` (swap).|
|`t`|Pop `a`, `b`|Pushes `a` converted to base 10 from base `b`.|
|`u`|Pop `a`|Pushes `a` as a string.|
|`v`|Pop `a`, `b`|Pushes `a // b` (integer/floor division).|
|`w`|Pop `a`|Pushes `[a]` (wrap).|
|`x`|Pop `a`|Pushes `a` in hexadecimal (base 16).|
|`y`|Pop `a`|Pushes the sign of `a` (`1` if positive, `-1` if negative, `0` if zero).|
|`z`|Pop `a`|Pushes `a` without surrounding whitespace.|
|`{`|Pop `a`|Deep flattens `a` onto the stack.|
|`|`|Pop `a`, `b`|Pushes `a || b` (boolean OR).|
|`}`|Pop `a`|Pushes `a` split into slices of 1 (shorthand for `1σ`).|
|`~`|Pop `a`|Pushes `-a` (negative).|
|`¶`|N/A|Alternate character for newline (`\n`).|
|`β`|Pop `a`, `b`|Pushes `a` split into `b` groups.|
|`γ`|Pop `a`|Pushes all possible rotations of `a`.|
|`δ`|Pop `a`|Pushes an array of the differences between consecutive elements in `a`.|
|`ε`|Pop `a`, `b`|Pushes whether `b` is in `a`.|
|`ζ`|Pop `a`|Pushes the first and last elements of `a` as an array.|
|`η`|Pop `a`|Pushes if `a` is empty.|
|`θ`|Pop `a`, `b`, `c`|Pushes `a[b..c]` (slice arbitrarily).|
|`ι`|Pop `a`, `b`|Pushes `a[0..b]` (slice from beginning).|
|`κ`|Pop `a`, `b`|Pushes `a[b..a.length]` (slice from end).|
|`λ`|Pop `a`|Pushes `a` rotated once to the left.|
|`μ`|Pop `a`, `b`|Pushes the Cartesian product of `a` and `b`.|
|`ν`|Pop `a`, `b`|Pushes whether `b` is in `a`. *Does not vectorize.*|
|`ξ`|Pop `a`|Pushes `a` three times (triplicate).|
|`π`|Pop `a`|Pushes the `a`th prime number.|
|`ρ`|Pop `a`|Pushes `a` rotated once to the right.|
|`ς`|Pop `a`, block|Pushes `a` sorted by the results of running the given block once for each element in `a`.|
|`σ`|Pop `a`, `b`|Pushes `a` split into groups of length `b`.|
|`τ`|N/A|Pushes 10.|
|`φ`|Pop `a`|Pushes the Euler totient/phi function of `a`.|
|`χ`|Pop `a`, block|Pushes the elements in `a` that return the minimum and maximum value from the given block.|
|`ψ`|Pop `a`|Pushes all permutations of `a`.|
|`ω`|Pop `a`|Pushes the power set of `a`.|
|`Γ`|N/A|-1|
|`Δ`|Pop `a`|Pushes an array of the *absolute* differences between consecutive elements in `a`.|
|`Θ`|N/A|Executes the wire at the index before the current one.|
|`Π`|Pop `a`|If `a` is an array, pushes the total product of `a`, else pushes the total product of the stack.|
|`Σ`|Pop `a`|If `a` is an array, pushes the total sum of `a`, else pushes the total sum of the stack.|
|`Φ`|Pop `a`|Executes the wire at index `a`.|
|`Ψ`|N/A|Executes the current wire. (Great for recursion!)|
|`Ω`|N/A|Executes the wire at the index after the current one.|
|`À`|Pop `a`|Pushes `a` in all lower-case.|
|`Á`|Pop `a`|Pushes `a` in all upper-case.|
|`Â`|Pop `a`|Pushes `a` in title-case.|
|`Ã`|Pop `a`|Pushes `a` with swapped capitalization.|
|`Ä`|Pop `a`, `b`|Pushes `a` onto the stack `b` times.|
|`Å`|Pop `a`, block|Pushes whether all the elements in `a` return a truthy value from the given block.|
|`Ā`|Pop `a`|Pushes `a` with the first letter capitalized.|
|`È`|N/A|N/A|
|`É`|Pop `a`|Pushes whether any of the elements in `a` return a truthy value from the given block.|
|`Ê`|N/A|N/A|
|`Ë`|N/A|N/A|
|`Ì`|N/A|N/A|
|`Í`|N/A|N/A|
|`Î`|N/A|N/A|
|`Ï`|N/A|N/A|
|`Ò`|N/A|N/A|
|`Ó`|N/A|N/A|
|`Ô`|N/A|N/A|
|`Õ`|N/A|N/A|
|`Ö`|N/A|N/A|
|`Ø`|Pop `a`|Pushes `a` grouped by identical elements.|
|`Œ`|Pop `a`|Pushes `a` randomly shuffled.|
|`Ù`|Pop `a`, `b`|Pushes `a` with `b` spaces *appended*.|
|`Ú`|Pop `a`, `b`|Pushes `a` with `b` spaces *prepended*.|
|`Û`|Pop `a`, `b`|Pushes `a` left-justified to length `b` (with spaces).|
|`Ü`|Pop `a`, `b`|Pushes `a` right-justified to length `b` (with spaces).|
|`Ç`|Pop `a`, `b`|Pushes an array of every consecutive group of `b` elements in `a`.|
|`Ð`|N/A|Pushes a space character (` `).|
|`Ñ`|N/A|Pushes a newline character (`\n`).|
|`Ý`|N/A|Pushes an empty string (`''`).|
|`Þ`|N/A|Pushes an empty array (`[]`).|
|`à`|Pop `a`, `b`|Pushes `a & b` (bitwise AND).|
|`á`|Pop `a`, `b`|Pushes `a | b` (bitwise OR).|
|`â`|Pop `a`, `b`|Pushes `a ^ b` (bitwise XOR).|
|`ã`|Pop `a`|Pushes `~a` (bitwise NOT).|
|`ä`|N/A|N/A|
|`å`|N/A|N/A|
|`ā`|N/A|N/A|
|`æ`|Pop `a`|Pushes `a` as a palindrome.|
|`è`|Pop `a`|Pushes `a % 2 != 0` (odd).|
|`é`|Pop `a`|Pushes `a % 2 == 0` (even).|
|`ê`|Pop `a`|Pushes the first `a` Fibonacci numbers.|
|`ë`|Pop `a`|Pushes the first `a` prime numbers.|
|`ì`|Pop `a`|Pushes `a` as an integer.|
|`í`|Pop `a`|Pushes `a` as a float.|
|`î`|Pop `a`|Pushes if `a` is an integer.|
|`ï`|Pop `a`, `b`|Pushes `a.split(b)`.|
|`ò`|Pop `a`|Pushes `a` zipped.|
|`ó`|Pop `a`|Pushes `a` converted to base 10 from binary (base 2).|
|`ô`|Pop `a`|Pushes `a` converted to base 10 from hexadecimal (base 16).|
|`õ`|N/A|N/A|
|`ö`|N/A|N/A|
|`ø`|Pop `a`, `b`|Pushes an array of size `b` filled with `a`.|
|`œ`|Pop `a`|Pushes `[a, a.reverse]`.|
|`ù`|Pop `a`|If `a` is an array, pushes `a.join(' ')`, else pushes `stack.join(' ')`.|
|`ú`|Pop `a`|If `a` is an array, pushes `a.join("\n")`, else pushes `stack.join("\n")`.|
|`û`|Pop `a`, `b`, `c`|Pushes the range between `a` and `b` in steps of `c`.|
|`ü`|N/A|N/A|
|`ç`|Pop `a`, `b`|Pushes all possible combinations of `b` elements in `a`.|
|`ð`|Pop `a`|Pushes `a == a.reverse` (palindrome).|
|`ñ`|Pop `a`|Pushes whether `a` is a Fibonacci number.|
|`ý`|Pop `a`|Pushes the `a`th Fibonacci number.|
|`þ`|Pop `a`|Sleeps execution for `a` seconds.|
|`¿`|Block|Else statement for use with the `?` component.|
|`‽`|Pop `a`|If `a` is truthy, breaks out of the current block/wire.|
|`⁇`|Pop `a`, block|Pushes an array containing all elements of `a` for which the given block returns a truthy value (filter/select).|
|`⁈`|Pop `a`, block|Pushes a 2D array in which the first element contains all the elements of `a` that returned a truthy value from the given block and the second element contains all the elements of `a` that returned falsy (partition).|
|`‼`|Pop `a`, block|Same as `⁇`, except with falsy values instead of truthy ones.|
|`¡`|N/A|N/A|
|`‰`|Pop `a`|Pushes 2<sup>`a`</sup>.|
|`‱`|Pop `a`|Pushes 10<sup>`a`</sup>.|
|`¦`|Pop `a`|Pushes `a` rounded to the nearest integer.|
|`§`|Pop `a`|Pushes a random element from `a`.|
|`©`|Pop `a`|Pushes `a` repeated twice (string duplicate).|
|`®`|Pop `a`|Pushes `a[b]` (element at index).|
|`±`|Pop `a`, `b`|Pushes the `b`th root of `a`.|
|`¬`|Pop `a`|Pushes the square root of `a`.|
|`¢`|Get `a`|Sets the value of the register to `a`.|
|`¤`|N/A|N/A|
|`«`|Pop `a`, `b`|Pushes `[a, b]` (pair).|
|`»`|Pop `a`, component|Pushes an array containing the results of applying the given component for each element in `a`.|
|`‹`|Pop `a`|Pushes `a - 1` (decrement).|
|`›`|Pop `a`|Pushes `a + 1` (increment).|
|`“`|N/A|Creates a base-255 number literal.|
|`”`|N/A|Creates a compressed string literal.|
|`‘`|Pop `a`, block|Pushes the element in `a` that returns the maximum value from the given block.|
|`’`|Pop `a`, block|Same as `‘`, except with the minimum value instead of maximum.|
|`‥`|N/A|Creates a two-character literal (e.g. `‥ab` => `'ab'`).|
|`…`|N/A|Creates a two-character literal (e.g. `…abc` => `'abc'`).|
|`᠁`|N/A|Creates a code page indexes literal (e.g. `᠁?¿᠁` => `[63, 224]`)|
|`∩`|Pop `a`, `b`|Pushes the set intersection of `a` and `b`.|
|`∪`|Pop `a`, `b`|Pushes the set union of `a` and `b`.|
|`⊂`|N/A|N/A|
|`⊃`|Pop `a`, `b`|Pushes set difference of `a` and `b`.|

## Multi-character

### Constants (`α`)

|Component|Description|
|---------|-----------|
|`α0`|Pushes all the digits from 0-9 (`0123456789`).|
|`α1`|Pushes all the digits from 1-9 (`123456789`).|
|`α@`|Pushes all the printable ASCII characters (` ` to `~`).|
|`αA`|Pushes the normal uppercase alphabet (`ABCDEFGHIJKLMNOPQRSTUVWXYZ`).|
|`αC`|Pushes all the consonants (`BCDFGHJKLMNPQRSTVWXYZbcdfghjklmnpqrstvwxyz`).|
|`aQ`|Pushes the uppercase alphabet ordered as it is on a keyboard (`['QWERTYUIOP', 'ASDFGHJKL', 'ZXCVBNM']`).|
|`αW`|Pushes all the tokens that match the `\w` regex metachar (`abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_`).|
|`αY`|Pushes all the consonants **without `y`** (`BCDFGHJKLMNPQRSTVWXZbcdfghjklmnpqrstvwxz`).|
|`αa`|Pushes the normal lowercase alphabet (`abcdefghijklmnopqrstuvwxyz`).|
|`αc`|Pushes all the vowels (`AEIOUaeiou`).|
|`αe`|Pushes Euler's constant `e` (`2.7182818...`).
|`αq`|Pushes the lowercase alphabet ordered as it is on a keyboard (`['qwertyuiop', 'asdfghjkl', 'zxcvbnm']`).||
|`αy`|Pushes all the vowels **including `y`** (`AEIOUYaeiouy`).|
|`απ`|Pushes pi (`3.1415926...`).|
|`αφ`|Pushes phi/the golden ratio (`1.6180339...`).|
|`αΩ`|Pushes the Ohm codepage.|

### Time (`υ`)

|Component|Action|Description|
|---------|------|-----------|
|`υ!`|N/A|Pushes the current timestamp.|
|`υ%`|Pop `a`|Pushes the current time formatted using `a` as a `strftime` format string.|
|`υ‰`|Pop `a`, `b`|Pushes the time specified by timestamp `a` formatted using `b` as a `strftime` format string.|
|`υD`|N/A|Pushes the current day.|
|`υH`|N/A|Pushes the current hour.|
|`υI`|N/A|Pushes the current minute.|
|`υM`|N/A|Pushes the current month.|
|`υN`|N/A|Pushes the current nanosecond (yes, really).|
|`υS`|N/A|Pushes the current second.|
|`υW`|N/A|Pushes the current weekday (1-7).|
|`υY`|N/A|Pushes the current year.|
|`υd`|Pop `a`|Pushes the day specified by timestamp `a`.|
|`υh`|Pop `a`|Pushes the hour specified by timestamp `a`.|
|`υi`|Pop `a`|Pushes the minute specified by timestamp `a`.|
|`υm`|Pop `a`|Pushes the month specified by timestamp `a`.|
|`υn`|Pop `a`|Pushes the nanosecond specified by timestamp `a`.|
|`υs`|Pop `a`|Pushes the second specified by timestamp `a`.|
|`υw`|Pop `a`|Pushes the weekday (1-7) specified by timestamp `a`.|
|`υy`|Pop `a`|Pushes the year specified by timestamp `a`.|
|`υ§`|Pop `a`, `b`|Pushes the timestamp of the time given by parsing `a`, using `b` as a `strptime` format string.|

### Arithmetic (`Æ`)

|Component|Action|Description|
|---------|------|-----------|
|`Æ²`|Pop `a`|Pushes whether `a` is a perfect square.|
|`Æⁿ`|Pop `a`, `b`|Pushes whether `a` is a perfect `b`th power.|
|`Æ↑`|Pop `a`, `b`|Pushes the greatest common divisor of `a` and `b`.|
|`Æ↓`|Pop `a`, `b`|Pushes the least common multiple of `a` and `b`.|
|`Æ×`|Pop `a`, `b`|Pushes Pushes `a`<sup>`b`</sup> (complex exponentiation), where `a` and `b` are either numbers or arrays in the form `[real, imag]`.|
|`Æ*`|Pop `a`, `b`|Pushes `a * b` (complex multiplication), where `a` and `b` are either numbers or arrays in the form `[real, imag]`.|
|`Æ/`|Pop `a`, `b`|Pushes `a / b` (complex division), where `a` and `b` are either numbers or arrays in the form `[real, imag]`.|
|`ÆC`|Pop `a`|Pushes the cosine of `a` radians.|
|`ÆD`|Pop `a`|Pushes `a` radians converted to degrees.|
|`ÆE`|Pop `a`|Pushes `a` degrees converted to radians.|
|`ÆH`|Pop `a`, `b`|Pushes the hypotenuse of a right triangle with sides `a` and `b`.|
|`ÆL`|Pop `a`|Pushes the natural logarithm of `a`.|
|`ÆM`|Pop `a`|Pushes the base 10 logarithm of `a`.|
|`ÆN`|Pop `a`|Pushes the base 2 logarithm of `a`.|
|`ÆS`|Pop `a`|Pushes the sine of `a` radians.|
|`ÆT`|Pop `a`|Pushes the tangent of `a` radians.|
|`Æc`|Pop `a`|Pushes the arccosine of `a`.|
|`Æl`|Pop `a`, `b`|Pushes the base `a` logarithm of `b`.|
|`Æp`|Pop `a`, `b`|Pushes whether `a` and `b` are coprime.|
|`Æs`|Pop `a`|Pushes the arcsine of `a`.|
|`Æt`|Pop `a`|Pushes the arctangent of `a`.|
|`Æu`|Pop `a`, `b`|Pushes the arctangent of `b / a` (`atan2`).|
|`Æ¬`|Pop `a`|Pushes the *complex* square root of `a`, where `a` is either a number or an array in the form `[real, imag]`.|
|`Æ¤`|Pop `a`, `b`|Pushes the `b`th `a`-gonal number.|
|`Æ«`|Pop `a`, `b`|Pushes `a << b` (left bit-shift).|
|`Æ»`|Pop `a`, `b`|Pushes `a >> b` (right bit-shift).|

### Extras (`·`)

|Component|Action|Description|
|---------|------|-----------|
|`·/`|Pop `a`, `b`|Pushes an array of all the matches/captures of `a` tested against regex `b`.|
|`·\`|Pop `a`|Pushes the diagonals of `a`, assuming `a` is a matrix.|
|`·e`|Pop `a`|Evaluates `a` as Ohm code.|
|`·p`|Pop `a`|Pushes all prefixes of `a`.|
|`·r`|N/A|Pushes a random float between 0 and 1.|
|`·s`|Pop `a`|Pushes all suffixes of `a`.|
|`·~`|Pop `a`, `b`|If `a` matches regex `b`, pushes the index of the first match, else pushes `-1`.|
|`·ψ`|Pop `a`, `b`|Pushes whether `a` and `b` are permutations of each other.|
|`·Θ`|Pop `a`, block|Continuously evaluates the given block until the result returned has already been seen, using `a` as the initial value. Pushes the final result.|
|`·Ω`|Pop `a`, block|Same as above, except pushes the list of intermediate results.|
|`·Ø`|Pop `a`|Pushes the indices of `a` grouped together by equal values.|
|`·¦`|Pop `a`, `b`|Pushes `a` rounded to `b` decimal places.|

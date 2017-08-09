# Components
This is a list of all (currently implemented) components that are usable in an Ohm circuit.

## Single character

### Components with blocks
These components will execute all components between them and a `;` character (or end of line), called a *block*.

|Component|Description|Migrated|
|---------|-----------|---------|
|`?`|Pops `a`, and if true, executes its associated block (if statement).|Y|
|`¿`|If this component is between a `?` and `;`, the block from `¿` to `;` will be executed if the condition given to `?` is false (else clause).|Y|
|`:`|Pops `a` and executes its associated block for each element in `a`, with the special components `^` and `_` set as the index and element currently being looped, respectively (foreach loop).|Y|
|`M`|Pops `a` and runs its associated block `a` times.|Y|
|`ë`|Pops `a` and pushes a 2D array where the first element contains all the elements of `a` that pushed `true` and the second element contains all the elements of `a` that pushed `false`.|Y|
|`Å`|Pops `a` and pushes whether all the elements in `a` push `true` from its associated block.|N|
|`É`|Pops `a` and pushes whether any of the elements in `a` push `true` from its associated block.|N|
|`░`|Pops `a` and pushes an array containing all elements of `a` for which its associated block pushes `true` (filter/select).|Y|
|`▒`|Same as above, except `false` instead of `true` (reject).|Y|
|`▓`|Pops `a` and pushes an array with the results of running its associated block once for every element in `a` (map/collect).|Y|
|`╠`|Pops `a` and pushes `a` sorted by the results of running its associated block once for every element in `a`.|Y|
|`╨`|Pops `a` and pushes the element in `a` that gives the maximum value from its associated block.|Y|
|`╥`|Pops `a` and pushes the element in `a` that gives the minimum value from its associated block.|Y|
|`╫`|Pops `a` and pushes the elements in `a` that give the minimum and maximum value from its associated block.|Y|
|`∙Ω`|Pops `a` and continuously evaluates its associated block until the result given has already been seen, using `a` as the initial value. Pushes the list of intermediate results.|N|
|`∙Θ`|Same as about, except it only pushes the final result.|N|
|`∞`|Runs its associated block infinitely.|Y|

### Wire/block flow
|Component|Description|Migrated|
|---------|-----------|---------|
|`▄`|Executes the current wire. (Great for recursion!)|Y|
|`Φ`|Pops `a` and executes the wire at index `a`.|Y|
|`Θ`|Executes the wire at the index before the current one.|Y|
|`Ω`|Executes the wire at the index after the current one.|Y|
|`■`|Pops `a` and breaks out of the current block/wire if `a` is true.|Y|

### Utility
|Component|Action|Description|Migrated|
|---------|------|-----------|--------|
|`!`|Pop `a`|Pushes `a!` (factorial).|Y|
|`"`|N/A|Creates a string literal.|Y|
|`#`|Pop `a`|Pushes the range `0..a`.|Y|
|`$`|N/A|Pushes the current value of the register.|Y|
|`%`|Pop `a`, `b`|Pushes `a % b` (modulo).|Y|
|`&`|Pop `a`, `b`|Pushes `a && b` (boolean AND).|Y|
|`'`|Pop `a`|Pushes the character with char code `a`.|Y|
|`(`|Pop `a`|Pushes `a` without the first element.|Y|
|`)`|Pop `a`|Pushes `a` without the last element.|Y|
|`*`|Pop `a`, `b`|Pushes `a * b` (multiplication).|Y|
|`+`|Pop `a`, `b`|Pushes `a + b` (addition).|Y|
|`,`|Pop `a`|Prints `a` to standard output (with trailing newline).|Y|
|`-`|Pop `a`, `b`|Pushes `a - b` (subtraction).|Y|
|`.`|N/A|Creates a character literal (i.e. `.a` ⇒ `'a'`).|Y|
|`/`|Pop `a`, `b`|Pushes `a / b` (division).|Y|
|Digits `0-9`|N/A|Creates a number literal.|Y|
|`<`|Pop `a`, `b`|Pushes `a < b` (less than).|Y|
|`=`|Get `a`|Prints `a` to standard output (with trailing newline).|Y|
|`>`|Pop `a`, `b`|Pushes `a > b` (greater than).|Y|
|`@`|Pop `a`|Pushes the range `1..a`.|Y|
|`A`|Pop `a`|Pushes the absolute value of `a`.|Y|
|`B`|Pop `a`, `b`|Pushes `a` converted to base `b`.|Y|
|`C`|Pop `a`, `b`|Pushes `a` concatenated with `b`.|Y|
|`D`|Pop `a`|Pushes `a` twice (duplicate).|Y|
|`E`|Pop `a`, `b`|Pushes `a == b` (equality).|Y|
|`F`|N/A|Pushes boolean `false`.|Y|
|`G`|Pop `a`, `b`|Pushes the range `a..b`.|Y|
|`H`|Pop `a`, `b`|Pushes `a.push(b)` (Note that this **does not work** with strings).|Y|
|`I`|N/A|Pushes input from standard input.|Y|
|`J`|Pop `a`|If `a` is an array, pushes `a.join('')`, else pushes `stack.join('')`.|Y|
|`K`|Pop `a`, `b`|Pushes the amount of times that `b` occurs in `a`.|Y|
|`L`|Pop `a`|Prints `a` to standard output (*without* trailing newline).|Y|
|`N`|Pop `a`, `b`|Pushes `a != b` (inequality).|Y|
|`O`|N/A|Removes last element of stack.|Y|
|`P`|Pop `a`|Pushes all primes up to `a`.|Y|
|`Q`|N/A|Reverses stack.|Y|
|`R`|Pop `a`|Pushes `a` reversed.|Y|
|`S`|Pop `a`|Pushes `a` sorted.|Y|
|`T`|N/A|Pushes boolean `true`.|Y|
|`U`|Pop `a`|Pushes `a` uniquified.|Y|
|`V`|Pop `a`|Pushes divisors of `a`.|Y|
|`W`|N/A|Pushes `[stack]` (wrap).|Y|
|`X`|Pop `a`, `b`|Pushes `b` prepended to `a`.|Y|
|`Y`|Pop `a`|Pushes proper divisors of `a`.|Y|
|`Z`|Pop `a`|Pushes `a` split on newlines.|Y|
|`[`|Pop `a`|Pushes `stack[a]`.|Y|
|`\`|Pop `a`|Pushes `!a` (boolean NOT).|Y|
|`]`|Pop `a`|Flattens `a` by one level onto the stack.|Y|
|`^`|N/A|Pushes index of current element in array being looped over.|Y|
|`_`|N/A|Pushes current element in array being looped over.|Y|
|`` ` ``|Pop `a`|Pushes char code of `a`.|Y|
|`a`|Pop `a`, `b`|Pushes `b`, `a` (swap).|Y|
|`b`|Pop `a`|Pushes `a` in binary (base 2).|Y|
|`c`|Pop `a`, `b`|Pushes `a nCr b` (binomial coefficient).|Y|
|`d`|Pop `a`|Pushes `a * 2` (double).|Y|
|`e`|Pop `a`, `b`|Pushes `a nPr b` (permutations).|Y|
|`f`|Pop `a`|Pushes all Fibonacci numbers up to `a`.|Y|
|`g`|Pop `a`, `b`|Pushes the range `a...b`.|Y|
|`h`|Pop `a`|Pushes the first element of `a`.|Y|
|`i`|Pop `a`|Pushes the last element of `a`.|Y|
|`j`|Pop `a`, `b`|If `a` is an array, pushes `a.join(b)`, else pushes `stack.join(b)`.|Y|
|`k`|Pop `a`, `b`|Pushes index of `b` in `a`.|Y|
|`l`|Pop `a`|Pushes length of `a`.|Y|
|`m`|Pop `a`|Pushes prime factors of `a`.|Y|
|`n`|Pop `a`|Pushes *exponents* of prime factorization of `a`.|Y|
|`o`|Pop `a`|Pushes full prime factorization of `a`.|Y|
|`p`|Pop `a`|Pushes whether `a` is a prime number.|Y|
|`q`|N/A|Immediately stops program execution.|Y|
|`r`|Pop `a`, `b`, `c`|Pushes `a.tr(b, c)`.|Y|
|`s`|Pop `a`|Pushes `a` as a string.|Y|
|`t`|Pop `a`, `b`|Pushes `a` converted to base 10 from base `b`.|Y|
|`u`|Pop `a`, `b`|Pushes the index of the first occurrence of subarray `b` in `a`.|Y|
|`v`|Pop `a`, `b`|Pushes `a // b` (integer/floor division).|Y|
|`w`|Pop `a`|Pushes `[a]` (wrap).|Y|
|`x`|Pop `a`|Pushes `a` in hexadecimal (base 16).|Y|
|`y`|Pop `a`|Pushes the sign of `a` (`1` if positive, `-1` if negative, `0` if zero).|Y|
|`z`|Pop `a`|Pushes `a` split on spaces.|Y|
|`{`|Pop `a`|Deep flattens `a` onto the stack.|Y|
|`|`|Pop `a`, `b`|Pushes `a || b` (boolean OR).|Y|
|`}`|Pop `a`|Pushes `a` split into slices of 1 (shorthand for `1σ`).|Y|
|`~`|Pop `a`|Pushes `-a` (negative).|Y|
|`Ç`|Pop `a`, `b`|Pushes an array of every consecutive group of `b` elements in `a`.|Y|
|`ü`|N/A|Pushes a space character (` `).|Y|
|`é`|Pop `a`|Pushes `a % 2 == 0` (even).|Y|
|`â`|Pop `a`|Pushes the first `a` prime numbers.|N|
|`ä`|Pop `a`, `b`|Pushes `a & b` (bitwise AND).|Y|
|`à`|Pop `a`, `b`|Pushes `a | b` (bitwise OR).|Y|
|`å`|Pop `a`, `b`|Pushes `a ^ b` (bitwise XOR).|Y|
|`ç`|Pop `a`, `b`|Pushes all possible combinations of length `b` of elements in `a`.|Y|
|`ê`|Pop `a`|Pushes the first `a` Fibonacci numbers.|N|
|`è`|Pop `a`|Pushes `a % 2 != 0` (odd).|Y|
|`ï`|Pop `a`, `b`|Pushes `a.split(b)`.|N|
|`î`|Pop `a`|Pushes `a` as an integer.|N|
|`ì`|Pop `a`|Pushes if `a` is an integer.|N|
|`Ä`|Pop `a`, `b`|Pushes `a` onto the stack `b` times.|Y|
|`æ`|Pop `a`|Pushes `a` as a palindrome.|Y|
|`ô`|Pop `a`|Pushes `a` as a float.|N|
|`ö`|Pop `a`|Pushes `a != 0`.|N|
|`ò`|Pop `a`|Pushes `~a` (bitwise NOT).|N|
|`û`|Pop `a`, `b`, `c`|Pushes the range between `a` and `b` in steps of `c`.|N|
|`ù`|Pop `a`|If `a` is an array, pushes `a.join(' ')`, else pushes `stack.join(' ')`.|N|
|`ÿ`|N/A|Pushes empty string (`''`).|Y|
|`Ö`|Pop `a`|Pushes `a == 0`.|N|
|`Ü`|Pop `a`, `b`|Pushes set union of `a` and `b`.|Y|
|`¢`|Get `a`|Sets the value of the register to `a`.|N|
|`£`|Pop `a`|Sleeps execution for `a` seconds.|N|
|`¥`|Pop `a`, `b`|Pushes `a % b == 0` (divisibility).|Y|
|`₧`|Pop `a`|Pushes `a == a.reverse` (palindrome).|N|
|`ƒ`|Pop `a`|Pushes the `a`th Fibonacci number.|N|
|`á`|Pop `a`|If `a` is an array, pushes `a.join("\n")`, else pushes `stack.join("\n")`.|N|
|`í`|Pop `a`|Pushes `a` zipped.|N|
|`ó`|Pop `a`|Pushes `a` converted to base 10 from binary (base 2).|N|
|`ú`|Pop `a`|Pushes `a` converted to base 10 from hexadecimal (base 16).|N|
|`ñ`|Pop `a`|Pushes whether `s` is a Fibonacci number.|N|
|`Ñ`|N/A|Pushes a newline character (`\n`), functions as a newline inside string literals.|Y|
|`ª`|Pop `a`|Pushes `a[b]` (element at index).|N|
|`º`|Pop `a`|Pushes 2<sup>`a`</sup>.|N|
|`⌐`|Pop `a`|Pushes all permutations of `a`.|Y|
|`¬`|Pop `a`|Pushes the power set of `a`.|Y|
|`½`|Pop `a`|Pushes `a / 2` (half).|N|
|`¼`|N/A|Pushes the current value of the counter.|N|
|`¡`|N/A|Increments the counter by 1.|N|
|`«`|Pop `a`, `b`|Pushes `[a, b]` (pair).|N|
|`»`|Pop `a`|Pushes a *single component* mapped over all values of `a`.|Y|
|`│`|Pop `a`|Pushes if `a` is empty.|Y|
|`┤`|Pop `a`, `b`|Pushes `a[b..a.length]` (slice from end).|Y|
|`╡`|Pop `a`|Pushes the first and last elements of `a` as an array.|Y|
|`╣`|Pop `a`|Pushes all possible rotations of `a`.|Y|
|`║`|N/A|Creates a base-220 number literal. (i.e. `║Ö╔H╪║` ⇒ `987654321`)|Y|
|`╜`|Pop `a`|Pushes `a` rotated once to the left.|Y|
|`╛`|Pop `a`|Pushes full prime factorization of `a` with repetition.|Y|
|`┴`|Pop `a`|Pushes `a` in all upper-case.|N|
|`┬`|Pop `a`|Pushes `a` in all lower-case.|N|
|`├`|Pop `a`, `b`|Pushes `a[0..b]` (slice from beginning).|Y|
|`─`|Pop `a`, `b`|Pushes set difference of `a` and `b`.|N|
|`┼`|N/A|Pushes the first input given.|N|
|`╞`|Pop `a`|Pushes `a` grouped by identical elements.|N|
|`╟`|Pop `a`|Pushes `a` randomly shuffled.|N|
|`╚`|Pop `a`, `b`|Pushes `a` with `b` spaces *prepended*.|N|
|`╔`|Pop `a`, `b`|Pushes `a` with `b` spaces *appended*.|N|
|`╩`|Pop `a`, `b`|Pushes `a` left-justified to length `b` (with spaces).|N|
|`╦`|Pop `a`, `b`|Pushes `a` right-justified to length `b` (with spaces).|N|
|`═`|Pop `a`, `b`, `c`|Pushes `a[b..c]` (slice arbitrarily).|Y|
|`╬`|Pop `a`|Pushes a random element from `a`.|N|
|`╧`|Pop `a`|Pushes maximum element in `a`.|Y|
|`╤`|Pop `a`|Pushes minimum element in `a`.|Y|
|`╙`|Pop `a`|Pushes `a` rotated once to the right.|Y|
|`╒`|Pop `a`, `b`|Pushes the Cartesian product of `a` and `b`.|Y|
|`╪`|Pop `a`|Pushes minimum and maximum element in `a` as an array in the form `[min, max]`.|Y|
|`┘`|N/A|Pushes the second input given.|Y|
|`┌`|N/A|Pushes the third input given.|Y|
|`█`|N/A|Pushes empty array (`[]`).|Y|
|`▀`|N/A|Creates a compressed string literal (see README).|Y|
|`ß`|Pop `a`, `b`|Pushes `a` split into `b` groups.|Y|
|`Γ`|N/A|Pushes -1.|Y|
|`π`|Pop `a`|Pushes the `a`th prime number.|Y|
|`Σ`|Pop `a`|If `a` is an array, pushes the total sum of `a`, else pushes the total sum of the stack.|Y|
|`σ`|Pop `a`, `b`|Pushes `a` split into groups of length `b`.|Y|
|`µ`|Pop `a`|If `a` is an array, pushes the total product of `a`, else pushes the total product of the stack.|Y|
|`τ`|N/A|Pushes the number 10.|Y|
|`δ`|Pop `a`|Pushes an array with the deltas of (distance between) consecutive elements in `a`.|Y|
|`φ`|Pop `a`|Pushes the Euler totient/phi function of `a`.|Y|
|`ε`|Pop `a`, `b`|Pushes whether `b` is in `a`.|Y|
|`∩`|Pop `a`, `b`|Pushes set intersection of `a` and `b`.|Y|
|`≡`|Pop `a`|Pushes `a` three times (triplicate).|Y|
|`±`|Pop `a`, `b`|Pushes the `b`th root of `a`.|N|
|`≥`|Pop `a`|Pushes `a + 1` (increment).|N|
|`≤`|Pop `a`|Pushes `a - 1` (decrement).|N|
|`⌠`|Pop `a`|Pushes `a` rounded *up* to the nearest integer (ceiling).|N|
|`⌡`|Pop `a`|Pushes `a` rounded *down* to the nearest integer (floor).|N|
|`÷`|Pop `a`|Pushes `1 / a` (reciprocal).|Y|
|`≈`|Pop `a`|Pushes `a` rounded to the nearest integer.|N|
|`°`|Pop `a`|Pushes 10<sup>`a`</sup>.|N|
|`·`|Pop `a`, `b`|Pushes `a` repeated `b` times.|Y|
|`√`|Pop `a`|Pushes the square root of `a`.|N|
|`ⁿ`|Pop `a`, `b`|Pushes `a`<sup>`b`</sup>.|Y|
|`²`|Pop `a`|Pushes `a` squared.|Y|

## Multi-character

### Arithmetic (`Æ`)
|Component|Action|Description|Migrated|
|---------|------|-----------|--------|
|`ÆA`|Pop `a`, `b`|Pushes the Ackermann function of `a` and `b`.|N|
|`ÆC`|Pop `a`|Pushes the cosine of `a` radians.|N|
|`ÆD`|Pop `a`|Pushes `a` radians converted to degrees.|N|
|`ÆE`|Pop `a`|Pushes `a` degrees converted to radians.|N|
|`ÆH`|Pop `a`, `b`|Pushes the hypotenuse of a right triangle with sides `a` and `b`.|N|
|`ÆL`|Pop `a`|Pushes the natural logarithm of `a`.|N|
|`ÆM`|Pop `a`|Pushes the base 10 logarithm of `a`.|N|
|`ÆN`|Pop `a`|Pushes the base 2 logarithm of `a`.|N|
|`ÆS`|Pop `a`|Pushes the sine of `a` radians.|N|
|`ÆT`|Pop `a`|Pushes the tangent of `a` radians.|N|
|`Æc`|Pop `a`|Pushes the arccosine of `a`.|N|
|`Æl`|Pop `a`, `b`|Pushes the base `a` logarithm of `b`.|N|
|`Æp`|Pop `a`, `b`|Pushes whether `a` and `b` are coprime.|N|
|`Æs`|Pop `a`|Pushes the arcsine of `a`.|N|
|`Æt`|Pop `a`|Pushes the arctangent of `a`.|N|
|`Æu`|Pop `a`, `b`|Pushes the arctangent of `b / a` (`atan2`).|N|
|`Æ┴`|Pop `a`, `b`|Pushes the greatest common divisor of `a` and `b`.|N|
|`Æ┬`|Pop `a`, `b`|Pushes the least common multiple of `a` and `b`.|N|
|`Æ█`|Pop `a`, `b`|Pushes the `b`th `a`-gonal number.|N|
|`Æⁿ`|Pop `a`, `b`|Pushes whether `a` is a perfect `b`th power.|N|
|`Æ²`|Pop `a`|Pushes whether `a` is a perfect square.|N|

### Time (`╓`)
|Component|Action|Description|Migrated|
|---------|------|-----------|--------|
|`╓!`|N/A|Pushes the current timestamp.|N|
|`╓%`|Pop `a`|Pushes the current time formatted using `a` as a `strftime` format string.|N|
|`╓&`|Pop `a`, `b`|Pushes the time specified by timestamp `a` formatted using `b` as a `strftime` format string.|N|
|`╓D`|N/A|Pushes the current day.|N|
|`╓H`|N/A|Pushes the current hour.|N|
|`╓I`|N/A|Pushes the current minute.|N|
|`╓M`|N/A|Pushes the current month.|N|
|`╓N`|N/A|Pushes the current nanosecond (yes, really).|N|
|`╓S`|N/A|Pushes the current second.|N|
|`╓W`|N/A|Pushes the current weekday (1-7).|N|
|`╓Y`|N/A|Pushes the current year.|N|
|`╓d`|Pop `a`|Pushes the day specified by timestamp `a`.|N|
|`╓h`|Pop `a`|Pushes the hour specified by timestamp `a`.|N|
|`╓i`|Pop `a`|Pushes the minute specified by timestamp `a`.|N|
|`╓m`|Pop `a`|Pushes the month specified by timestamp `a`.|N|
|`╓n`|Pop `a`|Pushes the nanosecond specified by timestamp `a`.|N|
|`╓s`|Pop `a`|Pushes the second specified by timestamp `a`.|N|
|`╓w`|Pop `a`|Pushes the weekday (1-7) specified by timestamp `a`.|N|
|`╓y`|Pop `a`|Pushes the year specified by timestamp `a`.|N|
|`╓₧`|Pop `a`, `b`|Pushes the timestamp of the time given by parsing `a`, using `b` as a `strptime` format string.|N|

### Constants (`α`)
**Note**: Because these are constants, they only push to the stack.

|Component|Description|Migrated|
|---------|-----------|--------|
|`α0`|Pushes all the digits from 0-9 (`0123456789`).|N|
|`α1`|Pushes all the digits from 1-9 (`123456789`).|N|
|`α@`|Pushes all the printable ASCII characters (` ` to `~`).|N|
|`αA`|Pushes the normal uppercase alphabet (`ABCDEFGHIJKLMNOPQRSTUVWXYZ`).|N|
|`αK`|Pushes all the keys on a keyboard (`` `1234567890-=qwertyuiop[]\asdfghjkl;'zxcvbnm,./ ``).|N|
|`αc`|Pushes all the consonants (`bcdfghjklmnpqrstvwxyz`).|N|
|`αe`|Pushes all the consonants **without `y`** (`bcdfghjklmnpqrstvwxz`).|N|
|`αk`|Pushes the alphabet ordered like it is on a keyboard (`qwertyuiopasdfghjklzxcvbnm`).|N|
|`αv`|Pushes all the vowels (`aeiou`).|N|
|`αy`|Pushes all the vowels **including `y`** (`aeiouy`).|N|
|`αå`|Pushes all the tokens that match the `\w` regex metachar (`abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_`).|N|
|`αê`|Pushes Euler's constant `e` (`2.718281...`).|N|
|`αÅ`|Same as `αå`, except with the uppercase and lowercase characters switched.|N|
|`αß`|Pushes the normal lowercase alphabet (`abcdefghijklmnopqrstuvwxyz`).|N|
|`απ`|Pushes pi (`3.1415926...`).|N|

### Extras (`∙`)
|Component|Action|Description|Migrated|
|---------|------|-----------|--------|
|`∙!`|Pop `a`, `b`, `c`|Pushes `a` with matches of regex `b` replaced with `c`.|N|
|`∙*`|Pop `a`, `b`|Pushes an array of size `b` filled with `a`.|N|
|`∙/`|Pop `a`, `b`|Pushes an array of all the matches/captures of `a` tested against regex `b`.|N|
|`∙I`|Pop `a`|Pushes the `a`th input.|N|
|`∙\`|Pop `a`|Pushes the diagonals of `a`, assuming `a` is a matrix.|N|
|`∙e`|Pop `a`|Evaluates `a` as Ohm code.|N|
|`∙p`|Pop `a`|Pushes all prefixes of `a`.|N|
|`∙r`|N/A|Pushes a random float between 0 and 1.|N|
|`∙s`|Pop `a`|Pushes all suffixes of `a`.|N|
|`∙~`|Pop `a`, `b`|If `a` matches regex `b`, pushes the index of the first match, else pushes `nil`.|N|
|`∙î`|Pop `a`|Pushes whether `a` is an integer.|N|
|`∙⌐`|Pop `a`, `b`|Pushes whether `a` and `b` are permutations of each other.|N|
|`∙«`|Pop `a`, `b`|Pushes `a << b` (left bit-shift).|N|
|`∙»`|Pop `a`, `b`|Pushes `a >> b` (right bit-shift).|N|
|`∙╞`|Pop `a`|Pushes the indices of `a` grouped together by equal values.|N|
|`∙≈`|Pop `a`, `b`|Pushes `a` rounded to `b` decimal places.|N|

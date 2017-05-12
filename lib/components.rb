require 'prime'
require 'time'

require_relative 'helpers'

class Ohm
  include Helpers
  # These lambdas are executed during Ohm#exec.
  COMPONENTS = {
    '!' => {
      call: ->(a){factorial(a.to_i)},
    },
    '#' => {
      call: ->(a){a = a.to_i; (a <= 0 ? 0.downto(a) : (0..a)).to_a},
    },
    '$' => {
      call: ->{@vars[:register]},
    },
    '%' => {
      call: ->(a, b){a.to_f % b.to_f},
    },
    '&' => {
      call: ->(a, b){a && b},
    },
    '\'' => {
      call: ->(a){a.to_i.chr},
    },
    '(' => {
      call: ->(a){arr_else_str(a)[1, a.length]},
      depth: [1],
      arr_str: true,
    },
    ')' => {
      call: ->(a){arr_else_str(a)[0, a.length - 1]},
      depth: [1],
      arr_str: true,
    },
    '*' => {
      call: ->(a, b){a.to_f * b.to_f},
    },
    '+' => {
      call: ->(a, b){a.to_f + b.to_f},
    },
    ',' => {
      call: ->(a){@printed = true; puts untyped_to_s(a)},
      no_vec: true,
    },
    '-' => {
      call: ->(a, b){a.to_f - b.to_f},
    },
    '/' => {
      call: ->(a, b){a.to_f / b.to_f},
    },
    '<' => {
      call: ->(a, b){a.to_f < b.to_f},
    },
    '=' => {
      call: ->(a){@printed = true; puts untyped_to_s(a)},
      get: true,
      no_vec: true,
    },
    '>' => {
      call: ->(a, b){a.to_f > b.to_f},
    },
    '@' => {
      call: ->(a){a = a.to_i; (a <= 1 ? 1.downto(a) : (1..a)).to_a},
    },
    'A' => {
      call: ->(a){a.to_f.abs},
    },
    'B' => {
      call: ->(a, b){to_base(a.to_i, b.to_i)},
    },
    'C' => {
      call: ->(a, b){arr_else_str(a).concat(arr_else_str(b))},
      depth: [1, 1],
      arr_str: true,
    },
    'D' => {
      call: ->(a){[a, a]},
      multi: true,
      no_vec: true,
    },
    'E' => {
      call: ->(a, b){untyped_to_s(a) == untyped_to_s(b)},
    },
    'F' => {
      call: ->{false},
    },
    'G' => {
      call: ->(a, b){a, b = a.to_i, b.to_i; (a <= b ? (a..b) : a.downto(b)).to_a},
    },
    'H' => {
      call: ->(a, b){a.push(b)},
      # depth: [1], FIXME
      no_vec: true,
    },
    'I' => {
      call: ->{input},
    },
    'J' => {
      call: ->(a){arr_or_stack(a, &:join)},
      depth: [1],
      arr_stack: true,
    },
    'K' => {
      call: ->(a, b){arr_else_chars(a).count(b)},
      depth: [1],
      arr_str: true,
    },
    'L' => {
      call: ->(a){@printed = true; print untyped_to_s(a)},
      no_vec: true
    },
    'N' => {
      call: ->(a, b){untyped_to_s(a) != untyped_to_s(b)},
    },
    'O' => {
      call: ->{@stack = @stack[0, @stack.length - 1]; nil},
    },
    'P' => {
      call: ->(a){Prime.entries(a.to_i)},
    },
    'Q' => {
      call: ->{@stack = @stack.reverse; nil},
    },
    'R' => {
      call: ->(a){arr_else_str(a).reverse},
      depth: [1],
      arr_str: true,
    },
    'S' => {
      call: ->(a){arr_else_chars_join(a, &:sort)},
      depth: [1],
      arr_str: true,
    },
    'T' => {
      call: ->{true},
    },
    'U' => {
      call: ->(a){arr_else_chars_join(a, &:uniq)},
      depth: [1],
      arr_str: true,
    },
    'V' => {
      call: ->(a){(1..a.to_i).select {|n| a.to_i % n == 0}},
    },
    'W' => {
      call: ->{@stack = Stack.new(self, [@stack]); nil},
    },
    'X' => {
      call: ->(a, b){arr_else_chars_join(a) {|a| a.unshift(b)}},
      depth: [1, 1],
      arr_str: true,
    },
    'Y' => {
      call: ->(a){(1...a.to_i).select {|n| a.to_i % n == 0}},
    },
    'Z' => {
      call: ->(a){untyped_to_s(a).split("\n")},
    },
    '[' => {
      call: ->(a){@stack[a.to_i]},
    },
    '\\' => {
      call: ->(a){!a},
    },
    ']' => {
      call: ->(a){a.is_a?(Array) ? a.flatten(1) : a},
      multi: true,
      no_vec: true,
    },
    '^' => {
      call: ->{@vars[:index]},
    },
    '_' => {
      call: ->{@vars[:value]},
    },
    '`' => {
      call: ->(a){x = untyped_to_s(a); x.length == 1 ? x.ord : x.each_char.map(&:ord)},
    },
    'a' => {
      call: ->(a, b){[b, a]},
      multi: true,
      no_vec: true,
    },
    'b' => {
      call: ->(a){to_base(a.to_i, 2)},
    },
    'c' => {
      call: ->(a, b){nCr(a.to_i, b.to_i)},
    },
    'd' => {
      call: ->(a){a.to_f * 2},
    },
    'e' => {
      call: ->(a, b){nPr(a.to_i, b.to_i)},
    },
    'f' => {
      call: ->(a){fibonacci_upto(a.to_i)},
    },
    'g' => {
      call: ->(a, b){a, b = a.to_i, b.to_i; (a <= b ? (a...b) : (x = a.downto(b); x[0, x.length - 1])).to_a},
    },
    'h' => {
      call: ->(a){arr_else_chars(a).first},
      depth: [1],
      arr_str: true,
    },
    'i' => {
      call: ->(a){arr_else_chars(a).last},
      depth: [1],
      arr_str: true,
    },
    'j' => {
      call: ->(a, b){arr_or_stack(a) {|a| a.join(untyped_to_s(b))}},
      depth: [1],
      arr_stack: true,
    },
    'k' => {
      call: ->(a, b){arr_else_str(a).index(b)},
      # depth: [1], FIXME
      # arr_str: true,
      no_vec: true,
      nils: true,
    },
    'l' => {
      call: ->(a){arr_else_str(a).length},
      # depth: [1],
      # arr_str: true,
      no_vec: true,
    },
    'm' => {
      call: ->(a){a.to_i.prime_division.map {|x| x[0]}},
    },
    'n' => {
      call: ->(a){a.to_i.prime_division.map {|x| x[1]}},
    },
    'o' => {
      call: ->(a){a.to_i.prime_division},
    },
    'p' => {
      call: ->(a){a.to_i.prime?},
    },
    'r' => {
      call: ->(a, b, c){untyped_to_s(a).tr(untyped_to_s(b), untyped_to_s(c))},
    },
    's' => {
      call: ->(a){untyped_to_s(a)},
    },
    't' => {
      call: ->(a, b){from_base(untyped_to_s(a), b.to_i)},
    },
    'u' => {
      call: ->(a, b){subarray_index(*[a, b].map {|x| arr_else_str(x)})},
      depth: [1, 1],
    },
    'v' => {
      call: ->(a, b){a.to_f.div(b.to_f)},
    },
    'w' => {
      call: ->(a){[a]},
      no_vec: true,
    },
    'x' => {
      call: ->(a){to_base(a.to_i, 16)},
    },
    'y' => {
      call: ->(a){a.to_f <=> 0},
    },
    'z' => {
      call: ->(a){untyped_to_s(a).split(' ')},
    },
    '{' => {
      call: ->(a){a.is_a?(Array) ? a.flatten : a},
      multi: true,
      no_vec: true,
    },
    '|' => {
      call: ->(a, b){a || b},
    },
    '}' => {
      call: ->(a){(a.is_a?(Array) ? a.each_slice(1) : untyped_to_s(a).each_char).to_a},
      depth: [1],
      arr_str: true,
    },
    '~' => {
      call: ->(a){-a.to_f},
    },
    "\u00C7" => {
      call: ->(a, b){arr_else_chars_inner_join(a) {|a| a.each_cons(b.to_i).to_a}},
      depth: [1],
      arr_str: true,
    },
    "\u00FC" => {
      call: ->{' '},
    },
    "\u00E9" => {
      call: ->(a){a.to_f % 2 == 0},
    },
    "\u00E2" => {
      call: ->(a){Prime.first(a.to_i)},
    },
    "\u00E4" => {
      call: ->(a, b){a.to_i & b.to_i},
    },
    "\u00E0" => {
      call: ->(a, b){a.to_i | b.to_i},
    },
    "\u00E5" => {
      call: ->(a, b){a.to_i ^ b.to_i},
    },
    "\u00E7" => {
      call: ->(a, b){arr_else_chars_inner_join(a) {|a| a.combination(b.to_i).to_a}},
      depth: [1],
      arr_str: true,
    },
    "\u00EA" => {
      call: ->(a){a.to_i.times.map {|i| nth_fibonacci(i + 1)}},
    },
    "\u00E8" => {
      call: ->(a){a.to_f % 2 != 0},
    },
    "\u00EF" => {
      call: ->(a, b){untyped_to_s(a).split(untyped_to_s(b))},
    },
    "\u00EE" => {
      call: ->(a){a.to_i},
    },
    "\u00EC" => {
      call: ->(a){a.to_f % 1 == 0},
    },
    "\u00C4" => {
      call: ->(a, b){Array.new(b.to_i) {a}},
      multi: true,
    },
    "\u00E6" => {
      call: ->(a){arr_else_chars_join(a) {|a| a + a.reverse[1, a.length]}},
      depth: [1],
      arr_str: true,
    },
    "\u00C6" => {
      'A' => {
        call: ->(a, b){ackermann(a.to_i, b.to_i)},
      },
      'C' => {
        call: ->(a){Math.cos(a.to_f)},
      },
      'D' => {
        call: ->(a){a.to_f * (180 / Math::PI)},
      },
      'E' => {
        call: ->(a){a.to_f * (Math::PI / 180)},
      },
      'H' => {
        call: ->(a, b){Math.hypot(a.to_f, b.to_f)},
      },
      'L' => {
        call: ->(a){Math.log(a.to_f)},
      },
      'M' => {
        call: ->(a){Math.log10(a.to_f)},
      },
      'N' => {
        call: ->(a){Math.log2(a.to_f)},
      },
      'S' => {
        call: ->(a){Math.sin(a.to_f)},
      },
      'T' => {
        call: ->(a){Math.tan(a.to_f)},
      },
      'c' => {
        call: ->(a){Math.acos(a.to_f)},
      },
      'l' => {
        call: ->(a, b){Math.log(b.to_f) / Math.log(a.to_f)},
      },
      'p' => {
        call: ->(a, b){a.to_i.gcd(b.to_i) == 1},
      },
      's' => {
        call: ->(a){Math.asin(a.to_f)},
      },
      't' => {
        call: ->(a){Math.atan(a.to_f)},
      },
      'u' => {
        call: ->(a, b){Math.atan2(b.to_f, a.to_f)},
      },
      "\u2534" => {
        call: ->(a, b){a.to_i.gcd(b.to_i)},
      },
      "\u252C" => {
        call: ->(a, b){a.to_i.lcm(b.to_i)},
      },
      "\u2588" => {
        call: ->(a, b){b = b.to_i; ((a.to_i - 2) * ((b * (b  - 1)) / 2)) + b},
      },
      "\u207F" => {
        call: ->(a, b){perfect_exp?(a.to_i, b.to_i)},
      },
      "\u00B2" => {
        call: ->(a){perfect_exp?(a.to_i, 2)},
      },
    },
    "\u00F4" => {
      call: ->(a){a.to_f},
    },
    "\u00F6" => {
      call: ->(a){a.to_f != 0},
    },
    "\u00F2" => {
      call: ->(a){~a.to_i},
    },
    "\u00FB" => {
      call: ->(a, b, c){a.to_f.step(b.to_f, c.to_f).to_a},
    },
    "\u00F9" => {
      call: ->(a){arr_or_stack(a) {|a| a.join(' ')}},
      depth: [1],
      arr_stack: true,
    },
    "\u00FF" => {
      call: ->{''},
    },
    "\u00D6" => {
      call: ->(a){a.to_f == 0},
    },
    "\u00DC" => {
      call: ->(a, b){x = arr_else_chars(a) | arr_else_chars(b); [a, b].any? {|i| i.is_a?(Array)} ? x : x.join},
      no_vec: true,
    },
    "\u00A2" => {
      call: ->(a){@vars[:register] = a},
      nils: true,
      no_vec: true,
    }, # This doesn't have to go under GET since assignment still returns the value
    "\u00A3" => {
      call: ->(a){sleep(a.to_f); nil},
    },
    "\u00A5" => {
      call: ->(a, b){a.to_f % b.to_f == 0},
    },
    "\u20A7" => {
      call: ->(a){untyped_to_s(a) == untyped_to_s(a).reverse},
    },
    "\u0192" => {
      call: ->(a){nth_fibonacci(a.to_i)},
    },
    "\u00E1" => {
      call: ->(a){arr_or_stack(a) {|a| a.join("\n")}},
      depth: [1],
      arr_stack: true,
    },
    "\u00ED" => {
      call: ->(a){zip_arr(a)},
      depth: [2],
    },
    "\u00F3" => {
      call: ->(a){from_base(a.to_s, 2)},
    },
    "\u00FA" => {
      call: ->(a){from_base(a.to_s, 16)},
    },
    "\u00F1" => {
      call: ->(a){fibonacci?(a.to_i)},
    },
    "\u00D1" => {
      call: ->{"\n"},
    },
    "\u00AA" => {
      call: ->(a, b){arr_else_str(a)[b.to_i]},
      nils: true,
      depth: [1],
      arr_str: true,
    },
    "\u00BA" => {
      call: ->(a){2 ** a.to_f},
    },
    "\u2310" => {
      call: ->(a){arr_else_chars_inner_join(a) {|a| a.permutation.to_a}},
      depth: [1],
      arr_str: true,
    },
    "\u00AC" => {
      call: ->(a){arr_else_chars_inner_join(a) {|a| powerset(a)}},
      depth: [1],
      arr_str: true,
    },
    "\u00BD" => {
      call: ->(a){a.to_f / 2},
    },
    "\u00BC" => {
      call: ->{@vars[:counter]},
    },
    "\u00A1" => {
      call: ->{@vars[:counter] += 1; nil},
    },
    "\u00AB" => {
      call: ->(a, b){[a, b]},
      no_vec: true,
    },
    "\u2502" => {
      call: ->(a){arr_else_str(a).empty?},
      depth: [1],
      arr_str: true,
    },
    "\u2524" => {
      call: ->(a, b){a = arr_else_str(a); a[b.to_i..a.length]},
      depth: [1],
      arr_str: true,
    },
    "\u2561" => {
      call: ->(a){a = arr_else_chars(a); [a.first, a.last]},
      depth: [1],
      arr_str: true,
    },
    "\u2562" => {
      call: ->{},
    },
    "\u2556" => {
      call: ->{},
    },
    "\u2555" => {
      call: ->{},
    },
    "\u2563" => {
      call: ->(a){arr_else_chars_inner_join(a) {|a| Array.new(a.length) {|i| c = a.rotate(i)}}},
      depth: [1],
      arr_str: true,
    },
    "\u2557" => {
      call: ->{},
    },
    "\u255D" => {
      call: ->{},
    },
    "\u255C" => {
      call: ->(a){arr_else_chars_join(a, &:rotate)},
      depth: [1],
      arr_str: true,
    },
    "\u255B" => {
      call: ->(a){a.to_i.prime_division.each_with_object([]) {|(b, x), m| x.times {m << b}}},
    },
    "\u2510" => {
      call: ->{},
    },
    "\u2514" => {
      call: ->{},
    },
    "\u2534" => {
      call: ->(a){untyped_to_s(a).upcase},
    },
    "\u252C" => {
      call: ->(a){untyped_to_s(a).downcase},
    },
    "\u251C" => {
      call: ->(a, b){arr_else_str(a)[0..b.to_i]},
      depth: [1],
      arr_str: true,
    },
    "\u2500" => {
      call: ->(a, b){x = arr_else_chars(a) - arr_else_chars(b); [a, b].any? {|i| i.is_a?(Array)} ? x : x.join},
      no_vec: true,
    },
    "\u253C" => {
      call: ->{input_access(0)},
    },
    "\u255E" => {
      call: ->(a){arr_else_chars_inner_join(a) {|a| a.group_by {|x| x}.values}},
      depth: [1],
      arr_str: true,
    },
    "\u255F" => {
      call: ->(a){arr_else_chars_join(a, &:shuffle)},
      depth: [1],
      arr_str: true,
    },
    "\u255A" => {
      call: ->(a, b){' ' * b.to_i + untyped_to_s(a)},
    },
    "\u2554" => {
      call: ->(a, b){untyped_to_s(a) + ' ' * b.to_i},
    },
    "\u2569" => {
      call: ->(a, b){untyped_to_s(a).ljust(b.to_i)},
    },
    "\u2566" => {
      call: ->(a, b){untyped_to_s(a).rjust(b.to_i)},
    },
    "\u2550" => {
      call: ->(a, b, c){arr_else_str(a)[b.to_i..c.to_i]},
      depth: [1],
      arr_str: true,
    },
    "\u256C" => {
      call: ->(a){arr_else_chars(a).sample},
      depth: [1],
      arr_str: true,
    },
    "\u2567" => {
      call: ->(a){arr_else_chars(a).max},
      depth: [1],
      arr_str: true,
    },
    "\u2568" => {
      call: ->{},
    },
    "\u2564" => {
      call: ->(a){arr_else_chars(a).min},
      depth: [1],
      arr_str: true,
    },
    "\u2565" => {
      call: ->{},
    },
    "\u2559" => {
      call: ->(a){arr_else_chars_join(a) {|a| a.rotate(-1)}},
      depth: [1],
      arr_str: true,
    },
    "\u2558" => {
      call: ->{},
    },
    "\u2552" => {
      call: ->(a, b){x = arr_else_chars(a).product(arr_else_chars(b)); [a, b].any? {|i| i.is_a?(Array)} ? x : x.map(&:join)},
      no_vec: true,
    },
    "\u2553" => {
      '!' => {
        call: ->{Time.now.to_i},
      },
      '%' => {
        call: ->(a){Time.now.strftime(untyped_to_s(a))},
      },
      '&' => {
        call: ->(a, b){Time.at(a.to_f).strftime(untyped_to_s(b))},
      },
      'D' => {
        call: ->{Time.now.day},
      },
      'H' => {
        call: ->{Time.now.hour},
      },
      'I' => {
        call: ->{Time.now.min},
      },
      'M' => {
        call: ->{Time.now.month},
      },
      'N' => {
        call: ->{Time.now.nsec},
      },
      'S' => {
        call: ->{Time.now.sec},
      },
      'W' => {
        call: ->{Time.now.wday},
      },
      'Y' => {
        call: ->{Time.now.year},
      },
      'd' => {
        call: ->(a){Time.at(a.to_f).day},
      },
      'h' => {
        call: ->(a){Time.at(a.to_f).hour},
      },
      'i' => {
        call: ->(a){Time.at(a.to_f).min},
      },
      'm' => {
        call: ->(a){Time.at(a.to_f).month},
      },
      'n' => {
        call: ->(a){Time.at(a.to_f).nsec},
      },
      's' => {
        call: ->(a){Time.at(a.to_f).sec},
      },
      'w' => {
        call: ->(a){Time.at(a.to_f).wday},
      },
      'y' => {
        call: ->(a){Time.at(a.to_f).year},
      },
      "\u20A7" => {
        call: ->(a, b){Time.strptime(untyped_to_s(a), untyped_to_s(b)).to_i},
      },
    },
    "\u256A" => {
      call: ->(a){arr_else_chars(a).minmax},
      depth: [1],
      arr_str: true,
    },
    "\u2518" => {
      call: ->{input_access(1)},
    },
    "\u250C" => {
      call: ->{input_access(2)},
    },
    "\u2588" => {
      call: ->{[]},
    },
    "\u258C" => {
      call: ->{},
    },
    "\u2590" => {
      call: ->{},
    },
    "\u03B1" => {
      '0' => {
        call: ->{('0'..'9').to_a.join},
      },
      '1' => {
        call: ->{('1'..'9').to_a.join},
      },
      '@' => {
        call: ->{(' '..'~').to_a.join},
      },
      'A' => {
        call: ->{('A'..'Z').to_a.join},
      },
      'K' => {
        call: ->{'`1234567890-=qwertyuiop[]\\asdfghjkl;\'zxcvbnm,./'},
      },
      'c' => {
        call: ->{'bcdfghjklmnpqrstvwxyz'},
      },
      'e' => {
        call: ->{'bcdfghjklmnpqrstvwxz'},
      },
      'k' => {
        call: ->{'qwertyuiopasdfghjklzxcvbnm'},
      },
      'v' => {
        call: ->{'aeiou'},
      },
      'y' => {
        call: ->{'aeiouy'},
      },
      "\u00E5" => {
        call: ->{'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'},
      },
      "\u00EA" => {
        call: ->{Math::E},
      },
      "\u00C5" => {
        call: ->{'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_'},
      },
      "\u00DF" => {
        call: ->{('a'..'z').to_a.join},
      }, # Heh. Alpha-beta.
      "\u03C0" => {
        call: ->{Math::PI},
      },
    },
    "\u00DF" => {
      call: ->(a, b){arr_else_chars_inner_join(a) {|a| arr_in_groups(a, b.to_i)}},
      depth: [1],
      arr_str: true,
    },
    "\u0393" => {
      call: ->{-1},
    },
    "\u03C0" => {
      call: ->(a){Prime.first(a.to_i).last},
    },
    "\u03A3" => {
      call: ->(a){arr_or_stack(a) {|a| a.map(&:to_f).reduce(:+)}},
      depth: [1],
      arr_stack: true,
    },
    "\u03C3" => {
      call: ->(a, b){arr_else_chars_inner_join(a) {|a| a.each_slice(b.to_i).to_a}},
      depth: [1],
      arr_str: true,
    },
    "\u00B5" => {
      call: ->(a){arr_or_stack(a) {|a| a.map(&:to_f).reduce(:*)}},
      depth: [1],
      arr_stack: true,
    },
    "\u03C4" => {
      call: ->{10},
    },
    "\u03B4" => {
      call: ->(a){a.each_cons(2).map {|a, b| b.to_f - a.to_f}},
      depth: [1],
    },
    "\u03C6" => {
      call: ->(a){a = a.to_i; a.prime_division.map {|x| 1 - (1.0 / x[0])}.reduce(a, :*).to_i},
    },
    "\u03B5" => {
      call: ->(a, b){arr_else_str(a).include?(b)},
      depth: [1],
      arr_str: true,
      no_arr_str: 1
    },
    "\u2229" => {
      call: ->(a, b){x = arr_else_chars(a) & arr_else_chars(b); [a, b].any? {|i| i.is_a?(Array)} ? x : x.join},
      no_vec: true,
    },
    "\u2261" => {
      call: ->(a){[a, a, a]},
      multi: true,
      no_vec: true,
    },
    "\u00B1" => {
      call: ->(a, b){a.to_f ** (1 / b.to_f)},
    },
    "\u2265" => {
      call: ->(a){a.to_f + 1},
    },
    "\u2264" => {
      call: ->(a){a.to_f - 1},
    },
    "\u2320" => {
      call: ->(a){a.to_f.ceil},
    },
    "\u2321" => {
      call: ->(a){a.to_f.floor},
    },
    "\u00F7" => {
      call: ->(a){1 / a.to_f},
    },
    "\u2248" => {
      call: ->(a){a.to_f.round},
    },
    "\u00B0" => {
      call: ->(a){10 ** a.to_f},
    },
    "\u2219" => {
      '*' => {
        call: ->(a, b){Array.new(b.to_i) {a}},
      },
      '/' => {
        call: ->(a, b){untyped_to_s(a).match(untyped_to_s(b)).to_a},
      },
      'I' => {
        call: ->(a){input_access(a.to_i)},
      },
      '\\' => {
        call: ->(a){diagonals(a)},
        depth: [2],
      },
      'p' => {
        call: ->(a){arr_else_chars_inner_join(a) {|a| acc = []; a.map {|i| acc += arr_else_chars(i)}}},
        depth: [1],
        arr_str: true,
      },
      'r' => {
        call: ->{rand},
      },
      's' => {
        call: ->(a){arr_else_chars_inner_join(arr_else_str(a).reverse) {|a| acc = []; a.map {|i| (acc += arr_else_chars(i)).reverse}}},
        depth: [1],
        arr_str: true,
      },
      '~' => {
        call: ->(a, b){untyped_to_s(a) =~ Regexp.new(untyped_to_s(b))},
        nils: true,
      },
      "\u00EE" => {
        call: ->(a){begin Integer(a) rescue return false end; true},
      },
      "\u2310" => {
        call: ->(a, b){arr_else_chars(a).sort == arr_else_chars(b).sort},
        depth: [1, 1],
        arr_str: true,
      },
      "\u00AB" => {
        call: ->(a, b){a.to_i << b.to_i},
      },
      "\u00BB" => {
        call: ->(a, b){a.to_i >> b.to_i},
      },
      "\u255E" => {
        call: ->(a){group_equal_indices(arr_else_chars(a))},
        depth: [1],
        arr_str: true,
      },
      "\u2248" => {
        call: ->(a, b){a.to_f.round(b.to_i)},
      },
    },
    "\u00B7" => {
      call: ->(a, b){untyped_to_s(a) * b.to_i},
    }, # Repeat string
    "\u221A" => {
      call: ->(a){Math.sqrt(a.to_f)},
    },
    "\u207F" => {
      call: ->(a, b){a.to_f ** b.to_f},
    },
    "\u00B2" => {
      call: ->(a){a.to_f ** 2},
    },
  }

  # These components mark the opening statement of a block.
  OPENERS = %W(? : M \u00EB \u00C9 \u00C5 \u2591 \u2592 \u2593 \u2560 \u2568 \u2565 \u256B \u221E \u2219\u03A9 \u2219\u0398)
end

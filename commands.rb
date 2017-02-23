require 'prime'

require_relative 'helpers'

class Ohm
  include Helpers
  # These lambdas are executed during Ohm#exec.
  COMMANDS = {
    ' ' => ->{},
    '!' => ->(a){factorial(a)},
    '"' => ->{},
    '#' => ->{},
    '$' => ->{@register},
    '%' => ->(a, b){a.to_f % b.to_f},
    '&' => ->(a, b){a && b},
    '\'' => ->(a){a.to_i.chr},
    '(' => ->{},
    ')' => ->{},
    '*' => ->(a, b){a.to_f * b.to_f},
    '+' => ->(a, b){a.to_f + b.to_f},
    ',' => ->(a){@printed = true; puts a},
    '-' => ->(a, b){a.to_f - b.to_f},
    '.' => ->{},
    '/' => ->(a, b){a.to_f / b.to_f},
    ':' => ->{},
    ';' => ->{},
    '<' => ->(a){a - 1},
    '=' => ->(a){@printed = true; puts a},
    '>' => ->(a){a + 1},
    '?' => ->{}, # TODO: if statement
    '@' => ->{},
    'A' => ->{},
    'B' => ->{},
    'C' => ->{},
    'D' => ->(a){return a, a},
    'E' => ->(a, b){untyped_to_s(a) == untyped_to_s(b)},
    'F' => ->{false},
    'G' => ->{},
    'H' => ->{},
    'I' => ->{gets.strip},
    'J' => ->{},
    'K' => ->{},
    'L' => ->{},
    'M' => ->{},
    'N' => ->{},
    'O' => ->{},
    'P' => ->(a){Prime.entries(a.to_i)},
    'Q' => ->{},
    'R' => ->{},
    'S' => ->{},
    'T' => ->{true},
    'U' => ->{},
    'V' => ->{},
    'W' => ->(a){[a]},
    'X' => ->{},
    'Y' => ->{},
    'Z' => ->{},
    '[' => ->{},
    '\\' => ->{},
    ']' => ->{@stack = [@stack]; nil},
    '^' => ->{},
    '_' => ->{},
    '`' => ->(a){a.ord},
    'a' => ->{},
    'b' => ->{},
    'c' => ->(a, b){nCr(a.to_f, b.to_f)},
    'd' => ->{},
    'e' => ->(a, b){nPr(a.to_f, b.to_f)},
    'f' => ->{},
    'g' => ->{},
    'h' => ->{},
    'i' => ->{},
    'j' => ->{},
    'k' => ->{},
    'l' => ->{},
    'm' => ->{},
    'n' => ->{},
    'o' => ->{},
    'p' => ->(a){a.to_i.prime?},
    'q' => ->{},
    'r' => ->{},
    's' => ->{},
    't' => ->{},
    'u' => ->{},
    'v' => ->{},
    'w' => ->{},
    'x' => ->{},
    'y' => ->{},
    'z' => ->{},
    '{' => ->{},
    '|' => ->(a, b){a || b},
    '}' => ->{},
    '~' => ->(a){-a.to_f},
    "\u00C7" => ->{},
    "\u00FC" => ->{},
    "\u00E9" => ->{},
    "\u00E2" => ->{},
    "\u00E4" => ->{},
    "\u00E0" => ->{},
    "\u00E5" => ->{},
    "\u00E7" => ->{},
    "\u00EA" => ->{},
    "\u00EB" => ->{},
    "\u00E8" => ->{},
    "\u00EF" => ->{},
    "\u00EE" => ->{},
    "\u00EC" => ->{},
    "\u00C4" => ->{},
    "\u00C5" => ->{},
    "\u00C9" => ->{},
    "\u00E6" => ->{},
    "\u00C6" => ->{},
    "\u00F4" => ->{},
    "\u00F6" => ->{},
    "\u00F2" => ->{},
    "\u00FB" => ->{},
    "\u00F9" => ->{},
    "\u00FF" => ->{},
    "\u00D6" => ->{},
    "\u00DC" => ->{},
    "\u00A2" => ->(a){@register = a}, # This doesn't have to go under GET since assignment still returns the value
    "\u00A3" => ->{},
    "\u00A5" => ->{},
    "\u20A7" => ->{},
    "\u0192" => ->{},
    "\u00E1" => ->{},
    "\u00ED" => ->{},
    "\u00F3" => ->{},
    "\u00FA" => ->{},
    "\u00F1" => ->{},
    "\u00D1" => ->{},
    "\u00AA" => ->{},
    "\u00BA" => ->(a){2 ** a.to_f},
    "\u00BF" => ->{}, # TODO: else clause
    "\u2310" => ->(a){(a.is_a?(Array) ? a : [a]).permutation.to_a},
    "\u00AC" => ->(a){powerset(a)},
    "\u00BD" => ->(a){a.to_f / 2},
    "\u00BC" => ->{@counter},
    "\u00A1" => ->{@counter += 1},
    "\u00AB" => ->{},
    "\u00BB" => ->{},
    "\u2591" => ->{},
    "\u2592" => ->{},
    "\u2593" => ->{},
    "\u2502" => ->{},
    "\u2524" => ->{},
    "\u2561" => ->{},
    "\u2562" => ->{},
    "\u2556" => ->{},
    "\u2555" => ->{},
    "\u2563" => ->{},
    "\u2551" => ->{},
    "\u2557" => ->{},
    "\u255D" => ->{},
    "\u255C" => ->{},
    "\u255B" => ->{},
    "\u2510" => ->{},
    "\u2514" => ->{},
    "\u2534" => ->{},
    "\u252C" => ->{},
    "\u251C" => ->{},
    "\u2500" => ->{},
    "\u253C" => ->{},
    "\u255E" => ->{},
    "\u255F" => ->{},
    "\u255A" => ->{},
    "\u2554" => ->{},
    "\u2569" => ->{},
    "\u2566" => ->{},
    "\u2560" => ->{},
    "\u2550" => ->{},
    "\u256C" => ->{},
    "\u2567" => ->{},
    "\u2568" => ->{},
    "\u2564" => ->{},
    "\u2565" => ->{},
    "\u2559" => ->{},
    "\u2558" => ->{},
    "\u2552" => ->{},
    "\u2553" => ->{},
    "\u256B" => ->{},
    "\u256A" => ->{},
    "\u2518" => ->{},
    "\u250C" => ->{},
    "\u2588" => ->{},
    "\u2584" => ->{},
    "\u258C" => ->{},
    "\u2590" => ->{},
    "\u2580" => ->{},
    "\u03B1" => ->{},
    "\u00DF" => ->{},
    "\u0393" => ->{},
    "\u03C0" => ->(a){Prime.take(a.to_i).last},
    "\u03A3" => ->(a){arr_or_stack(a) {|a| a.map(&:to_f).reduce(0, :+)}},
    "\u03C3" => ->{},
    "\u00B5" => ->{},
    "\u03C4" => ->(a){arr_or_stack(a) {|a| a.map(&:to_f).reduce(1, :*)}},
    "\u03A6" => ->{},
    "\u0398" => ->{},
    "\u03A9" => ->{},
    "\u03B4" => ->{},
    "\u221E" => ->{},
    "\u03C6" => ->{},
    "\u03B5" => ->(a, b){begin a.include?(b) rescue false end},
    "\u2229" => ->{},
    "\u2261" => ->(a){return a, a, a},
    "\u00B1" => ->{},
    "\u2265" => ->{},
    "\u2264" => ->{},
    "\u2320" => ->{},
    "\u2321" => ->{},
    "\u00F7" => ->(a){1 / a.to_f},
    "\u2248" => ->(a){a.round},
    "\u00B0" => ->(a){10 ** a.to_f},
    "\u2219" => ->{},
    "\u00B7" => ->(a, b){a * b.to_f}, # Repeat string
    "\u221A" => ->{},
    "\u207F" => ->(a, b){a.to_f ** b.to_f},
    "\u00B2" => ->(a){a.to_f ** 2},
    "\u25A0" => ->{}
  }

  # When these commands are run, the values given to them will only be retrieved from the stack instead of being popped.
  STACK_GET = %W(=)

  # When these commands are run, their return value will be appended to the stack with a splat operator.
  MULTIPLE_PUSH = %W(D \u2261)
end

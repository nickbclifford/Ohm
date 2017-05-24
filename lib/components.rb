require 'prime'
require 'time'

require_relative 'helpers'

class Ohm
  include Helpers

  COMPONENTS = {
    "\u00B0" => {
      call: ->{@inputs}
    },
    "\u00B9" => {
      call: ->{}
    },
    "\u00B2" => {
      call: ->(a){a.to_f ** 2}
    },
    "\u00B3" => {
      call: ->{}
    },
    "\u2074" => {
      call: ->{}
    },
    "\u2075" => {
      call: ->{}
    },
    "\u2076" => {
      call: ->{}
    },
    "\u2077" => {
      call: ->{}
    },
    "\u2078" => {
      call: ->{}
    },
    "\u2079" => {
      call: ->{}
    },
    "\u207A" => {
      call: ->{}
    },
    "\u207B" => {
      call: ->{}
    },
    "\u207C" => {
      call: ->(a, b){untyped_to_s(a) == untyped_to_s(b)}
    },
    "\u207D" => {
      call: ->{}
    },
    "\u207E" => {
      call: ->{}
    },
    "\u207F" => {
      call: ->(a, b){a.to_f ** b.to_f}
    },
    "\u00BD" => {
      call: ->{}
    },
    "\u2153" => {
      call: ->{}
    },
    "\u00BC" => {
      call: ->{}
    },
    "\u2190" => {
      call: ->{}
    },
    "\u2191" => {
      call: ->(a){arr_else_chars(a).max},
      depth: [1],
      arr_str: true
    },
    "\u2192" => {
      call: ->{}
    },
    "\u2193" => {
      call: ->(a){arr_else_chars(a).min},
      depth: [1],
      arr_str: true
    },
    "\u2194" => {
      call: ->{}
    },
    "\u2195" => {
      call: ->(a){arr_else_chars(a).minmax},
      depth: [1],
      arr_str: true
    },
    "\u0131" => {
      call: ->{}
    },
    "\u0237" => {
      call: ->{}
    },
    "\u00D7" => {
      call: ->{}
    },
    "\u00F7" => {
      call: ->{}
    },
    "\u00A3" => {
      call: ->{}
    },
    "\u00A5" => {
      call: ->{}
    },
    "\u20AC" => {
      call: ->{}
    },
    '!' => {
      call: ->(a){factorial(a.to_i)}
    },
    # " reserved: string literal
    '#' => {
      call: ->(a){0.method((a = a.to_i) > 0 ? :upto : :downto)[a].to_a}
    },
    '$' => {
      call: ->{@vars[:register]}
    },
    '%' => {
      call: ->(a){a.to_f % b.to_f}
    },
    '&' => {
      call: ->(a, b){a && b}
    },
    '\'' => {
      call: ->(a){a.to_i.chr}
    },
    '(' => {
      call: ->(a){a = arr_else_str(a); a[1, a.length]},
      depth: [1],
      arr_str: true
    },
    ')' => {
      call: ->(a){a = arr_else_str(a); a[0, a.length - 1]},
      depth: [1],
      arr_str: true
    },
    '*' => {
      call: ->(a, b){a.to_f * b.to_f}
    },
    '+' => {
      call: ->(a, b){a.to_f + b.to_f}
    },
    ',' => {
      call: ->(a){@printed = true; puts untyped_to_s(a)}
    },
    '-' => {
      call: ->(a, b){a.to_f - b.to_f}
    },
    # . reserved: character literal
    '/' => {
      call: ->(a, b){a.to_f / b.to_f}
    },
    # 0-9 reserved: numeric literal
    # : reserved: foreach loop
    '<' => {
      call: ->(a, b){a.to_f < b.to_f}
    },
    '=' => {
      call: ->(a){@printed = true; puts untyped_to_s(a)},
      get: true
    },
    '>' => {
      call: ->(a, b){a.to_f > b.to_f}
    },
    # ? reserved: if statement
    '@' => {
      call: ->(a){1.method((a = a.to_i) > 1 ? :upto : :downto)[a].to_a}
    },
    'A' => {
      call: ->(a){a.to_f.abs}
    },
    'B' => {
      call: ->(a, b){to_base(a.to_i, b.to_i)}
    },
    'C' => {
      call: ->(a, b){arr_else_str(a).concat(arr_else_str(b))}
    },
    'D' => {
      call: ->(a){[a, a]},
      multi: true
    },
    'E' => {
      call: ->(a, b){untyped_to_s(a) == untyped_to_s(b)},
      no_vec: true
    },
    'F' => {
      call: ->{false}
    },
    'G' => {
      call: ->(a, b){(a = a.to_i).method(a > (b = b.to_i) ? :upto : :downto)[b].to_a}
    },
    'H' => {
      call: ->(a, b){a.push(b)},
      # depth: [1], FIXME
      no_vec: true
    },
    'I' => {
      call: ->{input}
    },
    'J' => {
      call: ->(a){arr_or_stack(a, &:join)},
      depth: [1],
      arr_stack: true
    },
    'K' => {
      call: ->(a){arr_else_chars(a).count(b)},
      depth: [1],
      arr_str: true
    },
    'L' => {
      call: ->(a){@printed = true; print untyped_to_s(a)},
      no_vec: true
    },
    # M reserved: exec # times
    'N' => {
      call: ->(a, b){untyped_to_s(a) != untyped_to_s(b)}
    },
    'O' => {
      call: ->{@stack = @stack[0, @stack.length - 1]; nil}
    },
    'P' => {
      call: ->(a){Prime.entries(a.to_i)}
    },
    'Q' => {
      call: ->{@stack.reverse!; nil}
    },
    'R' => {
      call: ->(a){arr_else_str(a).reverse},
      depth: [1],
      arr_str: true
    },
    'S' => {
      call: ->{}
    },
    'T' => {
      call: ->{}
    },
    'U' => {
      call: ->{}
    },
    'V' => {
      call: ->{}
    },
    'W' => {
      call: ->{}
    },
    'X' => {
      call: ->{}
    },
    'Y' => {
      call: ->{}
    },
    'Z' => {
      call: ->{}
    },
    '[' => {
      call: ->{}
    },
    '\\' => {
      call: ->{}
    },
    ']' => {
      call: ->{}
    },
    '^' => {
      call: ->{}
    },
    '_' => {
      call: ->{}
    },
    '`' => {
      call: ->{}
    },
    'a' => {
      call: ->{}
    },
    'b' => {
      call: ->{}
    },
    'c' => {
      call: ->{}
    },
    'd' => {
      call: ->{}
    },
    'e' => {
      call: ->{}
    },
    'f' => {
      call: ->{}
    },
    'g' => {
      call: ->{}
    },
    'h' => {
      call: ->{}
    },
    'i' => {
      call: ->{}
    },
    'j' => {
      call: ->{}
    },
    'k' => {
      call: ->{}
    },
    'l' => {
      call: ->{}
    },
    'm' => {
      call: ->{}
    },
    'n' => {
      call: ->{}
    },
    'o' => {
      call: ->{}
    },
    'p' => {
      call: ->{}
    },
    'q' => {
      call: ->{}
    },
    'r' => {
      call: ->{}
    },
    's' => {
      call: ->{}
    },
    't' => {
      call: ->{}
    },
    'u' => {
      call: ->{}
    },
    'v' => {
      call: ->{}
    },
    'w' => {
      call: ->{}
    },
    'x' => {
      call: ->{}
    },
    'y' => {
      call: ->{}
    },
    'z' => {
      call: ->{}
    },
    '{' => {
      call: ->{}
    },
    '|' => {
      call: ->{}
    },
    '}' => {
      call: ->{}
    },
    '~' => {
      call: ->{}
    },
    "\u00B6" => {
      call: ->{}
    },
    "\u03B1" => {
      call: ->{}
    },
    "\u03B2" => {
      call: ->{}
    },
    "\u03B3" => {
      call: ->{}
    },
    "\u03B4" => {
      call: ->{}
    },
    "\u03B5" => {
      call: ->{}
    },
    "\u03B6" => {
      call: ->{}
    },
    "\u03B7" => {
      call: ->{}
    },
    "\u03B8" => {
      call: ->{}
    },
    "\u03B9" => {
      call: ->{}
    },
    "\u03BA" => {
      call: ->{}
    },
    "\u03BB" => {
      call: ->{}
    },
    "\u03BC" => {
      call: ->{}
    },
    "\u03BD" => {
      call: ->{}
    },
    "\u03BE" => {
      call: ->{}
    },
    "\u03BF" => {
      call: ->{}
    },
    "\u03C0" => {
      call: ->{}
    },
    "\u03C1" => {
      call: ->{}
    },
    "\u03C2" => {
      call: ->{}
    },
    "\u03C3" => {
      call: ->{}
    },
    "\u03C4" => {
      call: ->{}
    },
    "\u03C5" => {
      call: ->{}
    },
    "\u03C6" => {
      call: ->{}
    },
    "\u03C7" => {
      call: ->{}
    },
    "\u03C8" => {
      call: ->{}
    },
    "\u03C9" => {
      call: ->{}
    },
    "\u0393" => {
      call: ->{}
    },
    "\u0394" => {
      call: ->{}
    },
    "\u0398" => {
      call: ->{}
    },
    "\u03A3" => {
      call: ->{}
    },
    "\u03A6" => {
      call: ->{}
    },
    "\u03A8" => {
      call: ->{}
    },
    "\u03A9" => {
      call: ->{}
    },
    "\u00C0" => {
      call: ->{}
    },
    "\u00C1" => {
      call: ->{}
    },
    "\u00C2" => {
      call: ->{}
    },
    "\u00C3" => {
      call: ->{}
    },
    "\u00C4" => {
      call: ->{}
    },
    "\u00C5" => {
      call: ->{}
    },
    "\u0100" => {
      call: ->{}
    },
    "\u00C6" => {
      call: ->{}
    },
    "\u00C8" => {
      call: ->{}
    },
    "\u00C9" => {
      call: ->{}
    },
    "\u00CA" => {
      call: ->{}
    },
    "\u00CB" => {
      call: ->{}
    },
    "\u00CC" => {
      call: ->{}
    },
    "\u00CD" => {
      call: ->{}
    },
    "\u00CE" => {
      call: ->{}
    },
    "\u00CF" => {
      call: ->{}
    },
    "\u00D2" => {
      call: ->{}
    },
    "\u00D3" => {
      call: ->{}
    },
    "\u00D4" => {
      call: ->{}
    },
    "\u00D5" => {
      call: ->{}
    },
    "\u00D6" => {
      call: ->{}
    },
    "\u00D8" => {
      call: ->{}
    },
    "\u0152" => {
      call: ->{}
    },
    "\u00D9" => {
      call: ->{}
    },
    "\u00DA" => {
      call: ->{}
    },
    "\u00DB" => {
      call: ->{}
    },
    "\u00DC" => {
      call: ->{}
    },
    "\u00C7" => {
      call: ->{}
    },
    "\u00D0" => {
      call: ->{}
    },
    "\u00D1" => {
      call: ->{}
    },
    "\u00DD" => {
      call: ->{}
    },
    "\u00DE" => {
      call: ->{}
    },
    "\u00E0" => {
      call: ->{}
    },
    "\u00E1" => {
      call: ->{}
    },
    "\u00E2" => {
      call: ->{}
    },
    "\u00E3" => {
      call: ->{}
    },
    "\u00E4" => {
      call: ->{}
    },
    "\u00E5" => {
      call: ->{}
    },
    "\u0101" => {
      call: ->{}
    },
    "\u00E6" => {
      call: ->{}
    },
    "\u00E8" => {
      call: ->{}
    },
    "\u00E9" => {
      call: ->{}
    },
    "\u00EA" => {
      call: ->{}
    },
    "\u00EB" => {
      call: ->{}
    },
    "\u00EC" => {
      call: ->{}
    },
    "\u00ED" => {
      call: ->{}
    },
    "\u00EE" => {
      call: ->{}
    },
    "\u00EF" => {
      call: ->{}
    },
    "\u00F2" => {
      call: ->{}
    },
    "\u00F3" => {
      call: ->{}
    },
    "\u00F4" => {
      call: ->{}
    },
    "\u00F5" => {
      call: ->{}
    },
    "\u00F6" => {
      call: ->{}
    },
    "\u00F8" => {
      call: ->{}
    },
    "\u0153" => {
      call: ->{}
    },
    "\u00F9" => {
      call: ->{}
    },
    "\u00FA" => {
      call: ->{}
    },
    "\u00FB" => {
      call: ->{}
    },
    "\u00FC" => {
      call: ->{}
    },
    "\u00E7" => {
      call: ->{}
    },
    "\u00F0" => {
      call: ->{}
    },
    "\u00F1" => {
      call: ->{}
    },
    "\u00FD" => {
      call: ->{}
    },
    "\u00FE" => {
      call: ->{}
    },
    "\u00BF" => {
      call: ->{}
    },
    "\u203D" => {
      call: ->{}
    },
    "\u2047" => {
      call: ->{}
    },
    "\u2048" => {
      call: ->{}
    },
    "\u203C" => {
      call: ->{}
    },
    "\u00A1" => {
      call: ->{}
    },
    "\u2030" => {
      call: ->{}
    },
    "\u2031" => {
      call: ->{}
    },
    "\u00A6" => {
      call: ->{}
    },
    "\u00A7" => {
      call: ->{}
    },
    "\u00A9" => {
      call: ->{}
    },
    "\u00AE" => {
      call: ->{}
    },
    "\u00B1" => {
      call: ->{}
    },
    "\u00AC" => {
      call: ->{}
    },
    "\u00A2" => {
      call: ->{}
    },
    "\u00A4" => {
      call: ->{}
    },
    "\u00AB" => {
      call: ->{}
    },
    "\u00BB" => {
      call: ->{}
    },
    "\u2039" => {
      call: ->{}
    },
    "\u203A" => {
      call: ->{}
    },
    "\u201C" => {
      call: ->{}
    },
    "\u201D" => {
      call: ->{}
    },
    "\u2018" => {
      call: ->{}
    },
    "\u2019" => {
      call: ->{}
    },
    "\u00B7" => {
      call: ->{}
    },
    "\u2025" => {
      call: ->{}
    },
    "\u2026" => {
      call: ->{}
    },
    "\u1801" => {
      call: ->{}
    },
    "\u2229" => {
      call: ->{}
    },
    "\u222A" => {
      call: ->{}
    },
    "\u2282" => {
      call: ->{}
    },
    "\u2283" => {
      call: ->{}
    }
  }
end

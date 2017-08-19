require 'cmath'
require 'net/http'
require 'prime'
require 'time'
require 'uri'

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
      call: ->{input_access(0)}
    },
    "\u2074" => {
      call: ->{input_access(1)}
    },
    "\u2075" => {
      call: ->{input_access(2)}
    },
    "\u2076" => {
      call: ->(a){input_access(a.to_i)}
    },
    "\u2077" => {
      call: ->{16}
    },
    "\u2078" => {
      call: ->{100}
    },
    "\u2079" => {
      call: ->{@vars[:counter]}
    },
    "\u207A" => {
      call: ->{@vars[:counter] += 1; nil}
    },
    "\u207B" => {
      call: ->{@vars[:counter] = 0; nil}
    },
    "\u207C" => {
      call: ->(a, b){untyped_to_s(a) == untyped_to_s(b)},
      no_vec: true
    },
    "\u207D" => {
      call: ->(a){arr_else_chars(a).first},
      no_vec: true
    },
    "\u207E" => {
      call: ->(a){arr_else_chars(a).last},
      no_vec: true
    },
    "\u207F" => {
      call: ->(a, b){a.to_f ** b.to_f}
    },
    "\u00BD" => {
      call: ->(a){a.to_f / 2}
    },
    "\u2153" => {
      call: ->{}
    },
    "\u00BC" => {
      call: ->{}
    },
    "\u2190" => {
      call: ->(a, b){arr_else_chars_join(a) {|x| x.unshift(b)}},
      # depth: [1], FIXME
      no_vec: true
    },
    "\u2191" => {
      call: ->(a){arr_else_chars(a).max},
      depth: [1],
      arr_str: true
    },
    "\u2192" => {
      call: ->(a, b){a.push(b)},
      # depth: [1], FIXME
      no_vec: true
    },
    "\u2193" => {
      call: ->(a){arr_else_chars(a).min},
      depth: [1],
      arr_str: true
    },
    "\u2194" => {
      call: ->(a, b){arr_else_str(a).concat(arr_else_str(b))}
    },
    "\u2195" => {
      call: ->(a){arr_else_chars(a).minmax},
      depth: [1],
      arr_str: true
    },
    "\u0131" => {
      call: ->(a){a.to_f.ceil}
    },
    "\u0237" => {
      call: ->(a){a.to_f.floor}
    },
    "\u00D7" => {
      call: ->(a, b){untyped_to_s(a) * b.to_i}
    }, # Repeat string
    "\u00F7" => {
      call: ->(a){1 / a.to_f}
    },
    # pound sign reserved: infinite loop
    "\u00A5" => {
      call: ->(a, b){a.to_f % b.to_f == 0}
    },
    # euro sign reserved: map
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
      call: ->(a, b){a.to_f % b.to_f}
    },
    '&' => {
      call: ->(a, b){truthy?(a) && truthy?(b)}
    },
    '\'' => {
      call: ->(a){a.map(&:to_i).pack('U*')},
      depth: [1]
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
      call: ->{}
    },
    'D' => {
      call: ->(a){[a, a]},
      multi: true
    },
    'E' => {
      call: ->(a, b){untyped_to_s(a) == untyped_to_s(b)}
    },
    'F' => {
      call: ->{} # TODO: change to something useful
    },
    'G' => {
      call: ->(a, b){(a = a.to_i).method(a > (b = b.to_i) ? :upto : :downto)[b].to_a}
    },
    'H' => {
      call: ->(a){untyped_to_s(a).split(' ')}
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
      call: ->(a){arr_else_chars_join(a, &:sort)},
      depth: [1],
      arr_str: true
    },
    'T' => {
      call: ->{} # TODO: change to something useful
    },
    'U' => {
      call: ->(a){arr_else_chars_join(a, &:uniq)},
      depth: [1],
      arr_str: true
    },
    'V' => {
      call: ->(a){(1..(a = a.to_i)).select {|i| (a % i).zero?}}
    },
    'W' => {
      call: ->{@stack = Stack.new(self, [@stack]); nil}
    },
    'X' => {
      call: ->(a){!truthy?(a)}
    },
    'Y' => {
      call: ->(a){(1...(a = a.to_i)).select {|i| (a % i).zero?}}
    },
    'Z' => {
      call: ->(a){untyped_to_s(a).split("\n")}
    },
    '[' => {
      call: ->(a){@stack[a.to_i]}
    },
    '\\' => {
      call: ->(a, b, c){untyped_to_s(a).gsub(untyped_to_s(b), untyped_to_s(c))}
    },
    ']' => {
      call: ->(a){a.is_a?(Array) ? a.flatten(1) : a},
      multi: true
    },
    '^' => {
      call: ->{@vars[:index]}
    },
    '_' => {
      call: ->{@vars[:value]}
    },
    '`' => {
      call: ->(a){x = untyped_to_s(a).unpack('U*'); x.length == 1 ? x[0] : x}
    },
    'a' => {
      call: ->(a, b){(a.to_f - b.to_f).abs},
    },
    'b' => {
      call: ->(a){to_base(a.to_i, 2)}
    },
    'c' => {
      call: ->(a, b){nCr(a.to_i, b.to_i)}
    },
    'd' => {
      call: ->(a){a.to_f * 2}
    },
    'e' => {
      call: ->(a, b){nPr(a.to_i, b.to_i)}
    },
    'f' => {
      call: ->(a){fibonacci_upto(a.to_i)}
    },
    'g' => {
      call: ->(a, b){x = (a = a.to_i).method(a > (b = b.to_i) ? :upto : :downto)[b].to_a; x[0, x.length - 1]}
    },
    'h' => {
      call: ->(a){arr_else_chars(a).first},
      depth: [1],
      arr_str: true
    },
    'i' => {
      call: ->(a){arr_else_chars(a).last},
      depth: [1],
      arr_str: true
    },
    'j' => {
      call: ->(a, b){arr_or_stack(a) {|x| x.join(untyped_to_s(b))}},
      depth: [1],
      arr_stack: true
    },
    'k' => {
      call: ->(a, b){x = arr_else_str(a).index(b); x.nil? ? -1 : x},
      # depth: [1], FIXME
      # arr_str: true,
      no_vec: true
    },
    'l' => {
      call: ->(a){arr_else_str(a).length},
      no_vec: true
    },
    'm' => {
      call: ->(a){a.to_i.prime_division.map(&:first)},
    },
    'n' => {
      call: ->(a){a.to_i.prime_division.map(&:last)},
    },
    'o' => {
      call: ->(a){a.to_i.prime_division.each_with_object([]) {|(b, e), m| e.times {m << b}}},
    },
    'p' => {
      call: ->(a){a.to_i.prime?},
    },
    # q reserved: halt execution
    'r' => {
      call: ->(a, b, c){untyped_to_s(a).tr(untyped_to_s(b), untyped_to_s(c))}
    },
    's' => {
      call: ->(a, b){[b, a]},
      multi: true
    },
    't' => {
      call: ->(a, b){from_base(untyped_to_s(a), b.to_i)},
    },
    'u' => {
      call: ->(a){untyped_to_s(a)}
    },
    'v' => {
      call: ->(a, b){a.to_f.div(b.to_f)},
    },
    'w' => {
      call: ->(a){[a]},
      no_vec: true
    },
    'x' => {
      call: ->(a){to_base(a.to_i, 16)},
    },
    'y' => {
      call: ->(a){a.to_f <=> 0},
    },
    'z' => {
      call: ->(a){untyped_to_s(a).strip},
    },
    '{' => {
      call: ->(a){a.is_a?(Array) ? a.flatten : a},
      no_vec: true
    },
    '|' => {
      call: ->(a, b){truthy?(a) || truthy?(b)}
    },
    '}' => {
      call: ->(a){a.is_a?(Array) ? a.each_slice(1).to_a : untyped_to_s(a).chars},
      depth: [1],
      arr_str: true
    },
    '~' => {
      call: ->(a){-a.to_f}
    },
    # pilcrow reserved: newline in circuit
    "\u03B1" => {
      '0' => {
        call: ->{('0'..'9').to_a.join}
      },
      '1' => {
        call: ->{('1'..'9').to_a.join}
      },
      '@' => {
        call: ->{(' '..'~').to_a.join}
      },
      'A' => {
        call: ->{('A'..'Z').to_a.join}
      },
      'C' => {
        call: ->{'BCDFGHJKLMNPQRSTVWXYZbcdfghjklmnpqrstvwxyz'}
      },
      'Q' => {
        call: ->{%w(QWERTYUIOP ASDFGHJKL ZXCVBNM)}
      },
      'W' => {
        call: ->{'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_'}
      },
      'Y' => {
        call: ->{'BCDFGHJKLMNPQRSTVWXZbcdfghjklmnpqrstvwxz'}
      },
      'a' => {
        call: ->{('a'..'z').to_a.join}
      },
      'c' => {
        call: ->{'AEIOUaeiou'}
      },
      'e' => {
        call: ->{Math::E}
      },
      'q' => {
        call: ->{%w(qwertyuiop asdfghjkl zxcvbnm)}
      },
      'y' => {
        call: ->{'AEIOUYaeiouy'}
      },
      "\u03C0" => {
        call: ->{Math::PI}
      },
      "\u03C6" => {
        call: ->{(1 + Math.sqrt(5)) / 2}
      },
      "\u03A9" => {
        call: ->{CODE_PAGE}
      }
    },
    "\u03B2" => {
      call: ->(a, b){arr_else_chars_inner_join(a) {|a| arr_in_groups(a, b.to_i)}},
      depth: [1],
      arr_str: true
    },
    "\u03B3" => {
      call: ->(a){arr_else_chars_inner_join(a) {|a| Array.new(a.length) {|i| c = a.rotate(i)}}},
      depth: [1],
      arr_str: true
    },
    "\u03B4" => {
      call: ->(a){a.each_cons(2).map {|a, b| b.to_f - a.to_f}},
      depth: [1]
    },
    "\u03B5" => {
      call: ->(a, b){arr_else_str(a).include?(b)},
      depth: [1],
      arr_str: true
    },
    "\u03B6" => {
      call: ->(a){a = arr_else_chars(a); [a.first, a.last]},
      depth: [1],
      arr_str: true
    },
    "\u03B7" => {
      call: ->(a){arr_else_str(a).empty?},
      depth: [1],
      arr_str: true
    },
    "\u03B8" => {
      call: ->(a, b, c){arr_else_str(a)[b.to_i..c.to_i]},
      depth: [1],
      arr_str: true
    },
    "\u03B9" => {
      call: ->(a, b){arr_else_str(a)[0..b.to_i]},
      depth: [1],
      arr_str: true
    },
    "\u03BA" => {
      call: ->(a, b){a = arr_else_str(a); a[b.to_i..a.length]},
      depth: [1],
      arr_str: true
    },
    "\u03BB" => {
      call: ->(a){arr_else_chars_join(a, &:rotate)},
      no_vec: true
    },
    "\u03BC" => {
      call: ->(a, b){arr_else_chars_inner_join(a, b) {|a, b| a.product(b)}},
      no_vec: true
    },
    "\u03BD" => {
      call: ->(a, b){arr_else_str(a).include?(b)},
      no_vec: true
    },
    "\u03BE" => {
      call: ->(a){[a, a, a]},
      multi: true
    },
    "\u03C0" => {
      call: ->(a){Prime.first(a.to_i).last},
    },
    "\u03C1" => {
      call: ->(a){arr_else_chars_join(a) {|a| a.rotate(-1)}},
      no_vec: true
    },
    # end-sigma reserved: sort by
    "\u03C3" => {
      call: ->(a, b){arr_else_chars_inner_join(a) {|a| a.each_slice(b.to_i).to_a}},
      depth: [1],
      arr_str: true
    },
    "\u03C4" => {
      call: ->{10}
    },
    "\u03C5" => {
      '!' => {
        call: ->{Time.now.to_i}
      },
      '%' => {
        call: ->(a){Time.now.strftime(untyped_to_s(a))}
      },
      'D' => {
        call: ->{Time.now.day}
      },
      'H' => {
        call: ->{Time.now.hour}
      },
      'I' => {
        call: ->{Time.now.min}
      },
      'M' => {
        call: ->{Time.now.month}
      },
      'N' => {
        call: ->{Time.now.nsec}
      },
      'S' => {
        call: ->{Time.now.sec}
      },
      'W' => {
        call: ->{Time.now.wday}
      },
      'Y' => {
        call: ->{Time.now.year}
      },
      'd' => {
        call: ->(a){Time.at(a.to_f).day}
      },
      'h' => {
        call: ->(a){Time.at(a.to_f).hour}
      },
      'i' => {
        call: ->(a){Time.at(a.to_f).min}
      },
      'm' => {
        call: ->(a){Time.at(a.to_f).month}
      },
      'n' => {
        call: ->(a){Time.at(a.to_f).nsec}
      },
      's' => {
        call: ->(a){Time.at(a.to_f).sec}
      },
      'w' => {
        call: ->(a){Time.at(a.to_f).wday}
      },
      'y' => {
        call: ->(a){Time.at(a.to_f).year}
      },
      "\u2030" => {
        call: ->(a, b){Time.at(a.to_f).strftime(untyped_to_s(b))}
      },
      "\u00A7" => {
        call: ->(a, b){Time.strptime(untyped_to_s(a), untyped_to_s(b)).to_i}
      },
    },
    "\u03C6" => {
      call: ->(a){a = a.to_i; a.prime_division.map {|x| 1 - (1.0 / x[0])}.reduce(a, :*).to_i},
    },
    # chi reserved: minmax by
    "\u03C8" => {
      call: ->(a){arr_else_chars_inner_join(a) {|a| a.permutation.to_a}},
      depth: [1],
      arr_str: true
    },
    "\u03C9" => {
      call: ->(a){arr_else_chars_inner_join(a, &method(:powerset))},
      depth: [1],
      arr_str: true
    },
    "\u0393" => {
      call: ->{-1}
    },
    "\u0394" => {
      call: ->(a){a.each_cons(2).map {|a, b| (a.to_f - b.to_f).abs}},
      depth: [1]
    },
    # capital theta reserved: execute previous wire
    "\u03A0" => {
      call: ->(a){arr_or_stack(a) {|a| a.map(&:to_f).reduce(:*)}},
      depth: [1],
      arr_stack: true
    },
    "\u03A3" => {
      call: ->(a){arr_or_stack(a) {|a| a.map(&:to_f).reduce(:+)}},
      depth: [1],
      arr_stack: true
    },
    # capital phi reserved: execute wire at index
    # capital psi reserved: execute current wire
    # capital omega reserved: execute next wire
    "\u00C0" => {
      call: ->(a){untyped_to_s(a).downcase}
    },
    "\u00C1" => {
      call: ->(a){untyped_to_s(a).upcase}
    },
    "\u00C2" => {
      call: ->(a){untyped_to_s(a).gsub(/\w+/, &:capitalize)}
    },
    "\u00C3" => {
      call: ->(a){untyped_to_s(a).swapcase}
    },
    "\u00C4" => {
      call: ->(a, b){Array.new(b.to_i) {a}},
      multi: true
    },
    # capital A with ring reserved: all truthy in array
    "\u0100" => {
      call: ->(a){untyped_to_s(a).capitalize}
    },
    "\u00C6" => {
      "\u00B2" => {
        call: ->(a){perfect_exp?(a.to_i, 2)}
      },
      "\u207F" => {
        call: ->(a, b){perfect_exp?(a.to_i, b.to_i)}
      },
      "\u2191" => {
        call: ->(a, b){a.to_i.gcd(b.to_i)}
      },
      "\u2193" => {
        call: ->(a, b){a.to_i.lcm(b.to_i)}
      },
      "\u00D7" => {
        call: ->(a, b){(Complex(*a.map(&:to_f)) ** Complex(*b.map(&:to_f))).rect},
        depth: [1, 1]
      },
      '*' => {
        call: ->(a, b){(Complex(*a.map(&:to_f)) * Complex(*b.map(&:to_f))).rect},
        depth: [1, 1]
      },
      '/' => {
        call: ->(a, b){(Complex(*a.map(&:to_f)) / Complex(*b.map(&:to_f))).rect},
        depth: [1, 1]
      },
      'C' => {
        call: ->(a){Math.cos(a.to_f)}
      },
      'D' => {
        call: ->(a){a.to_f * (180 / Math::PI)}
      },
      'E' => {
        call: ->(a){a.to_f * (Math::PI / 180)}
      },
      'H' => {
        call: ->(a, b){Math.hypot(a.to_f, b.to_f)}
      },
      'L' => {
        call: ->(a){Math.log(a.to_f)}
      },
      'M' => {
        call: ->(a){Math.log10(a.to_f)}
      },
      'N' => {
        call: ->(a){Math.log2(a.to_f)}
      },
      'S' => {
        call: ->(a){Math.sin(a.to_f)}
      },
      'T' => {
        call: ->(a){Math.tan(a.to_f)}
      },
      'c' => {
        call: ->(a){Math.acos(a.to_f)}
      },
      'l' => {
        call: ->(a, b){Math.log(b.to_f) / Math.log(a.to_f)}
      },
      'p' => {
        call: ->(a, b){a.to_i.gcd(b.to_i) == 1}
      },
      's' => {
        call: ->(a){Math.asin(a.to_f)}
      },
      't' => {
        call: ->(a){Math.atan(a.to_f)}
      },
      'u' => {
        call: ->(a, b){Math.atan2(b.to_f, a.to_f)}
      },
      "\u00AC" => {
        call: ->(a){CMath.sqrt(Complex(*a.map(&:to_f))).rect},
        depth: [1]
      },
      "\u00A4" => {
        call: ->(a, b){b = b.to_i; ((a.to_i - 2) * ((b * (b  - 1)) / 2)) + b}
      },
      "\u00AB" => {
        call: ->(a, b){a.to_i << b.to_i}
      },
      "\u00BB" => {
        call: ->(a, b){a.to_i >> b.to_i}
      },
    },
    "\u00C8" => {
      call: ->{}
    },
    # capital E with acute reserved: any truthy in array
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
      call: ->(a){arr_else_chars_inner_join(a) {|a| a.group_by {|x| x}.values}},
      depth: [1],
      arr_str: true
    },
    "\u0152" => {
      call: ->(a){arr_else_chars_join(a, &:shuffle)},
      depth: [1],
      arr_str: true
    },
    "\u00D9" => {
      call: ->(a, b){untyped_to_s(a) + ' ' * b.to_i}
    },
    "\u00DA" => {
      call: ->(a, b){' ' * b.to_i + untyped_to_s(a)}
    },
    "\u00DB" => {
      call: ->(a, b){untyped_to_s(a).ljust(b.to_i)}
    },
    "\u00DC" => {
      call: ->(a, b){untyped_to_s(a).rjust(b.to_i)}
    },
    "\u00C7" => {
      call: ->(a, b){arr_else_chars_inner_join(a) {|a| a.each_cons(b.to_i).to_a}},
      depth: [1],
      arr_str: true
    },
    "\u00D0" => {
      call: ->{' '}
    },
    "\u00D1" => {
      call: ->{"\n"}
    },
    "\u00DD" => {
      call: ->{''}
    },
    "\u00DE" => {
      call: ->{[]}
    },
    "\u00E0" => {
      call: ->(a, b){a.to_i & b.to_i}
    },
    "\u00E1" => {
      call: ->(a, b){a.to_i | b.to_i}
    },
    "\u00E2" => {
      call: ->(a, b){a.to_i ^ b.to_i}
    },
    "\u00E3" => {
      call: ->(a){~a.to_i}
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
      call: ->(a){arr_else_chars_join(a) {|a| a + a.reverse[1, a.length]}},
      depth: [1],
      arr_str: true
    },
    "\u00E8" => {
      call: ->(a){a.to_i % 2 != 0}
    },
    "\u00E9" => {
      call: ->(a){a.to_i % 2 == 0}
    },
    "\u00EA" => {
      call: ->(a){Array.new(a.to_i) {|i| nth_fibonacci(i + 1)}}
    },
    "\u00EB" => {
      call: ->(a){Prime.first(a.to_i)},
    },
    "\u00EC" => {
      call: ->(a){a.to_i}
    },
    "\u00ED" => {
      call: ->(a){a.to_f}
    },
    "\u00EE" => {
      call: ->(a){a.to_f % 1 == 0}
    },
    "\u00EF" => {
      call: ->(a, b){untyped_to_s(a).split(untyped_to_s(b))},
    },
    "\u00F2" => {
      call: ->(a){zip_arr(a)},
      depth: [2]
    },
    "\u00F3" => {
      call: ->(a){from_base(a.to_s, 2)},
    },
    "\u00F4" => {
      call: ->(a){from_base(a.to_s, 16)},
    },
    "\u00F5" => {
      call: ->{}
    },
    "\u00F6" => {
      call: ->{}
    },
    "\u00F8" => {
      call: ->(a, b){Array.new(b.to_i) {a}},
    },
    "\u0153" => {
      call: ->(a){x = arr_else_str(a); [x, x.reverse]},
      depth: [1],
      arr_str: true
    },
    "\u00F9" => {
      call: ->(a){arr_or_stack(a) {|a| a.join(' ')}},
      depth: [1],
      arr_stack: true
    },
    "\u00FA" => {
      call: ->(a){arr_or_stack(a) {|a| a.join("\n")}},
      depth: [1],
      arr_stack: true
    },
    "\u00FB" => {
      call: ->(a, b, c){a.to_f.step(b.to_f, c.to_f).to_a}
    },
    "\u00FC" => {
      call: ->{}
    },
    "\u00E7" => {
      call: ->(a, b){arr_else_chars_inner_join(a) {|a| a.combination(b.to_i).to_a}},
      depth: [1],
      arr_str: true
    },
    "\u00F0" => {
      call: ->(a){untyped_to_s(a) == untyped_to_s(a).reverse}
    },
    "\u00F1" => {
      call: ->(a){fibonacci?(a.to_i)}
    },
    "\u00FD" => {
      call: ->(a){nth_fibonacci(a.to_i)}
    },
    "\u00FE" => {
      call: ->(a){sleep(a.to_f); nil}
    },
    # upside down question mark reserved: else statement
    # interrobang reserved: break out of block/wire
    # double question mark reserved: select from array
    # question/exclamation mark reserved: partition from array
    # double exclamation mark reserved: reject from array
    "\u00A1" => {
      call: ->{}
    },
    "\u2030" => {
      call: ->(a){2 ** a.to_f}
    },
    "\u2031" => {
      call: ->(a){10 ** a.to_f}
    },
    "\u00A6" => {
      call: ->(a){a.to_f.round},
    },
    "\u00A7" => {
      call: ->(a){arr_else_chars(a).sample},
      depth: [1],
      arr_str: true
    },
    "\u00A9" => {
      call: ->(a){untyped_to_s(a) * 2}
    }, # String duplication
    "\u00AE" => {
      call: ->(a, b){arr_else_str(a)[b.to_i]},
      depth: [1],
      arr_str: true
    },
    "\u00B1" => {
      call: ->(a, b){a.to_f ** (1 / b.to_f)},
    },
    "\u00AC" => {
      call: ->(a){Math.sqrt(a.to_f)},
    },
    "\u00A2" => {
      call: ->(a){@vars[:register] = a},
      no_vec: true
    }, # This doesn't have to go under GET since assignment still returns the value
    "\u00A4" => {
      call: ->{}
    },
    "\u00AB" => {
      call: ->(a, b){[a, b]},
      no_vec: true
    },
    # right double angle bracket reserved: single-component map
    "\u2039" => {
      call: ->(a){a.to_f - 1}
    },
    "\u203A" => {
      call: ->(a){a.to_f + 1}
    },
    # left quote reserved: base-255 literal
    # right quote reserved: Smaz-compressed string literal
    # left single quote reserved: min by
    # right single quote resereved: max by
    "\u00B7" => {
      '/' => {
        call: ->(a, b){untyped_to_s(a).match(untyped_to_s(b)).to_a}
      },
      '\\' => {
        call: ->(a){diagonals(a)},
        depth: [2]
      },
      'G' => {
        call: ->(a){a.prepend('http://') unless a.start_with?('http://', 'https://'); Net::HTTP.get(URI(a))},
        unsafe: true
      },
      'e' => {
        call: ->(a){
          block = Ohm.new(untyped_to_s(a), @debug, @safe_mode, @top_level, @stack, @inputs, @vars).exec
          @printed ||= block.printed
          @stack = block.stack
        }
      },
      'p' => {
        call: ->(a){arr_else_chars_inner_join(a) {|a| acc = []; a.map {|i| acc += arr_else_chars(i)}}},
        depth: [1],
        arr_str: true
      },
      'r' => {
        call: ->{rand}
      },
      's' => {
        call: ->(a){arr_else_chars_inner_join(arr_else_str(a).reverse) {|a| acc = []; a.map {|i| (acc += arr_else_chars(i)).reverse}}},
        depth: [1],
        arr_str: true
      },
      'w' => {
        call: ->(a, b){subarray_index(*[a, b].map(&method(:arr_else_str)))},
        depth: [1, 1],
        arr_str: true
      },
      '~' => {
        call: ->(a, b){untyped_to_s(a) =~ Regexp.new(untyped_to_s(b))}
      },
      "\u03C8" => {
        call: ->(a, b){arr_else_chars(a).sort == arr_else_chars(b).sort},
        depth: [1, 1],
        arr_str: true
      },
      "\u00D8" => {
        call: ->(a){group_equal_indices(arr_else_chars(a))},
        depth: [1],
        arr_str: true
      },
      "\u00A6" => {
        call: ->(a, b){a.to_f.round(b.to_i)}
      }
    },
    # 2-dot reserved: two character literal
    # ellipsis reserved: three character literal
    # Mongolian ellipsis reserved: code page indexes literal
    "\u2229" => {
      call: ->(a, b){arr_else_chars_join(a, b) {|a, b| a & b}},
      no_vec: true
    },
    "\u222A" => {
      call: ->(a, b){arr_else_chars_join(a, b) {|a, b| a | b}},
      no_vec: true
    },
    "\u2282" => {
      call: ->{}
    },
    "\u2283" => {
      call: ->(a, b){arr_else_chars_join(a, b) {|a, b| a - b}}
    }
  }
end

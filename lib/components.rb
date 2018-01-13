require_relative 'helpers'

require 'bigdecimal/math'
require 'cmath'
require 'gsl'
require 'net/http'
require 'prime'
require 'time'
require 'uri'

class Ohm
  include Helpers

  COMPONENTS = {
    '°' => {
      call: ->{@inputs}
    },
    '¹' => {
      call: ->{}
    },
    '²' => {
      call: ->(a){to_decimal(a) ** 2}
    },
    '³' => {
      call: ->{input_access(0)}
    },
    '⁴' => {
      call: ->{input_access(1)}
    },
    '⁵' => {
      call: ->{input_access(2)}
    },
    '⁶' => {
      call: ->(a){input_access(a.to_i)}
    },
    '⁷' => {
      call: ->{16}
    },
    '⁸' => {
      call: ->{100}
    },
    '⁹' => {
      call: ->{@vars[:counter]}
    },
    '⁺' => {
      call: ->{@vars[:counter] += 1; nil}
    },
    '⁻' => {
      call: ->{@vars[:counter] = 0; nil}
    },
    '⁼' => {
      call: ->(a, b){untyped_to_s(a) == untyped_to_s(b)},
      no_vec: true
    },
    '⁽' => {
      call: ->(a){arr_else_chars(a).first},
      no_vec: true
    },
    '⁾' => {
      call: ->(a){arr_else_chars(a).last},
      no_vec: true
    },
    'ⁿ' => {
      call: ->(a, b){to_decimal(a) ** to_decimal(b)}
    },
    '½' => {
      call: ->(a){to_decimal(a) / 2}
    },
    '⅓' => {
      call: ->{}
    },
    '¼' => {
      call: ->{}
    },
    '←' => {
      call: ->(a, b){arr_else_chars_join(a) {|x| x.unshift(b)}},
      # depth: [1], FIXME
      no_vec: true
    },
    '↑' => {
      call: ->(a){arr_else_chars(a).max},
      depth: [1],
      arr_str: true
    },
    '→' => {
      call: ->(a, b){a.push(b)},
      # depth: [1], FIXME
      no_vec: true
    },
    '↓' => {
      call: ->(a){arr_else_chars(a).min},
      depth: [1],
      arr_str: true
    },
    '↔' => {
      call: ->(a, b){arr_else_str(a).concat(arr_else_str(b))}
    },
    '↕' => {
      call: ->(a){arr_else_chars(a).minmax},
      depth: [1],
      arr_str: true
    },
    'ı' => {
      call: ->(a){to_decimal(a).ceil}
    },
    'ȷ' => {
      call: ->(a){to_decimal(a).floor}
    },
    '×' => {
      call: ->(a, b){untyped_to_s(a) * b.to_i}
    }, # Repeat string
    '÷' => {
      call: ->(a){1 / to_decimal(a)}
    },
    # pound sign reserved: infinite loop
    '¥' => {
      call: ->(a, b){to_decimal(a) % to_decimal(b) == 0}
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
      call: ->(a, b){to_decimal(a) % to_decimal(b)}
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
      call: ->(a, b){to_decimal(a) * to_decimal(b)}
    },
    '+' => {
      call: ->(a, b){to_decimal(a) + to_decimal(b)}
    },
    ',' => {
      call: ->(a){@printed = true; puts untyped_to_s(a)}
    },
    '-' => {
      call: ->(a, b){to_decimal(a) - to_decimal(b)}
    },
    # . reserved: character literal
    '/' => {
      call: ->(a, b){to_decimal(a) / to_decimal(b)}
    },
    # 0-9 reserved: numeric literal
    # : reserved: foreach loop
    '<' => {
      call: ->(a, b){to_decimal(a) < to_decimal(b)}
    },
    '=' => {
      call: ->(a){@printed = true; puts untyped_to_s(a)},
      get: true
    },
    '>' => {
      call: ->(a, b){to_decimal(a) > to_decimal(b)}
    },
    # ? reserved: if statement
    '@' => {
      call: ->(a){1.method((a = a.to_i) > 1 ? :upto : :downto)[a].to_a}
    },
    'A' => {
      call: ->(a){to_decimal(a).abs}
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
      call: ->(a, b){(a = a.to_i).method(a < (b = b.to_i) ? :upto : :downto)[b].to_a}
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
      call: ->(a, b){arr_else_chars(a).count(b)},
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
      no_vec: true
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
      call: ->(a){(a.is_a?(Array) && a.length >= 1) ? a.map {|a| !truthy?(a)} : !truthy?(a)},
      no_vec: true
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
      call: ->(a, b, c){untyped_to_s(a).gsub(Regexp.new(untyped_to_s(b)), untyped_to_s(c))}
    },
    # ] reserved: flatten one level onto the stack
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
      call: ->(a, b){(to_decimal(a) - to_decimal(b)).abs},
    },
    'b' => {
      call: ->(a){to_base(a.to_i, 2)}
    },
    'c' => {
      call: ->(a, b){nCr(a.to_i, b.to_i)}
    },
    'd' => {
      call: ->(a){to_decimal(a) * 2}
    },
    'e' => {
      call: ->(a, b){nPr(a.to_i, b.to_i)}
    },
    'f' => {
      call: ->(a){fibonacci_upto(a.to_i)}
    },
    'g' => {
      call: ->(a, b){x = (a = a.to_i).method(a < (b = b.to_i) ? :upto : :downto)[b].to_a; x[0, x.length - 1]}
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
      call: ->(a){run_length_decode(a.to_i.prime_division)},
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
      call: ->(a, b){to_decimal(a).div(to_decimal(b))},
    },
    'w' => {
      call: ->(a){[a]},
      no_vec: true
    },
    'x' => {
      call: ->(a){to_base(a.to_i, 16)},
    },
    'y' => {
      call: ->(a){to_decimal(a) <=> 0},
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
      # depth: [1],
      # arr_str: true
      no_vec: true
    },
    '~' => {
      call: ->(a){-to_decimal(a)}
    },
    # pilcrow reserved: newline in circuit
    'α' => {
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
      'π' => {
        call: ->{Math::PI}
      },
      'φ' => {
        call: ->{(1 + Math.sqrt(5)) / 2}
      },
      'Γ' => {
        call: ->{
          <<-GOAT
   ___.
  //  \\\\
 ((   ''
  \\\\__,
 /6 (%)\\,
(__/:";,;\\--____----_
 ;; :';,:';`;,';,;';`,`_
    ;:,;;';';,;':,';';,-Y\\
    ;,;,;';';,;':;';'; Z/
    / ;,';';,;';,;';;'
   / / |';/~~~~~\\';;'
  ( K  | |      || |
   \\_\\ | |      || |
    \\Z | |      || |
       L_|      LL_|
       LW/      LLW/
          GOAT
        }
      },
      'Ω' => {
        call: ->{CODE_PAGE}
      }
    },
    'β' => {
      call: ->(a, b){arr_else_chars_inner_join(a) {|a| arr_in_groups(a, b.to_i)}},
      depth: [1],
      arr_str: true
    },
    'γ' => {
      call: ->(a){arr_else_chars_inner_join(a) {|a| Array.new(a.length) {|i| c = a.rotate(i)}}},
      depth: [1],
      arr_str: true
    },
    'δ' => {
      call: ->(a){a.each_cons(2).map {|a, b| to_decimal(b) - to_decimal(a)}},
      depth: [1]
    },
    'ε' => {
      call: ->(a, b){arr_else_str(a).include?(b)},
      depth: [1],
      arr_str: true
    },
    'ζ' => {
      call: ->(a){a = arr_else_chars(a); [a.first, a.last]},
      depth: [1],
      arr_str: true
    },
    'η' => {
      call: ->(a){arr_else_str(a).empty?},
      depth: [1],
      arr_str: true
    },
    'θ' => {
      call: ->(a, b, c){arr_else_str(a)[b.to_i..c.to_i]},
      depth: [1],
      arr_str: true
    },
    'ι' => {
      call: ->(a, b){arr_else_str(a)[0..b.to_i]},
      depth: [1],
      arr_str: true
    },
    'κ' => {
      call: ->(a, b){a = arr_else_str(a); a[b.to_i..a.length]},
      depth: [1],
      arr_str: true
    },
    'λ' => {
      call: ->(a){arr_else_chars_join(a, &:rotate)},
      no_vec: true
    },
    'μ' => {
      call: ->(a, b){arr_else_chars_inner_join(a, b) {|a, b| a.product(b)}},
      no_vec: true
    },
    'ν' => {
      call: ->(a, b){arr_else_str(a).include?(b)},
      no_vec: true
    },
    'ξ' => {
      call: ->(a){[a, a, a]},
      multi: true
    },
    'π' => {
      call: ->(a){Prime.first(a.to_i).last},
    },
    'ρ' => {
      call: ->(a){arr_else_chars_join(a) {|a| a.rotate(-1)}},
      no_vec: true
    },
    # end-sigma reserved: sort by
    'σ' => {
      call: ->(a, b){arr_else_chars_inner_join(a) {|a| a.each_slice(b.to_i).to_a}},
      depth: [1],
      arr_str: true
    },
    'τ' => {
      call: ->{10}
    },
    'υ' => {
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
        call: ->(a){Time.at(to_decimal(a)).utc.day}
      },
      'h' => {
        call: ->(a){Time.at(to_decimal(a)).utc.hour}
      },
      'i' => {
        call: ->(a){Time.at(to_decimal(a)).utc.min}
      },
      'm' => {
        call: ->(a){Time.at(to_decimal(a)).utc.month}
      },
      'n' => {
        call: ->(a){Time.at(to_decimal(a)).utc.nsec}
      },
      's' => {
        call: ->(a){Time.at(to_decimal(a)).utc.sec}
      },
      'w' => {
        call: ->(a){Time.at(to_decimal(a)).utc.wday}
      },
      'y' => {
        call: ->(a){Time.at(to_decimal(a)).utc.year}
      },
      '‰' => {
        call: ->(a, b){Time.at(to_decimal(a)).utc.strftime(untyped_to_s(b))}
      },
      '§' => {
        call: ->(a, b){Time.strptime(untyped_to_s(a), untyped_to_s(b)).to_i}
      },
    },
    'φ' => {
      call: ->(a){a = a.to_i; a.prime_division.map {|x| 1 - (1.0 / x[0])}.reduce(a, :*).to_i},
    },
    # chi reserved: minmax by
    'ψ' => {
      call: ->(a){arr_else_chars_inner_join(a) {|a| a.permutation.to_a}},
      depth: [1],
      arr_str: true
    },
    'ω' => {
      call: ->(a){arr_else_chars_inner_join(a, &method(:powerset))},
      depth: [1],
      arr_str: true
    },
    'Γ' => {
      call: ->{-1}
    },
    'Δ' => {
      call: ->(a){a.each_cons(2).map {|a, b| (to_decimal(a) - to_decimal(b)).abs}},
      depth: [1]
    },
    # capital theta reserved: execute previous wire
    'Π' => {
      call: ->(a){arr_or_stack(a) {|a| a.map(&method(:to_decimal)).reduce(:*)}},
      depth: [1],
      arr_stack: true
    },
    'Σ' => {
      call: ->(a){arr_or_stack(a) {|a| a.map(&method(:to_decimal)).reduce(:+)}},
      depth: [1],
      arr_stack: true
    },
    # capital phi reserved: execute wire at index
    # capital psi reserved: execute current wire
    # capital omega reserved: execute next wire
    'À' => {
      call: ->(a){untyped_to_s(a).downcase}
    },
    'Á' => {
      call: ->(a){untyped_to_s(a).upcase}
    },
    'Â' => {
      call: ->(a){untyped_to_s(a).gsub(/\w+/, &:capitalize)}
    },
    'Ã' => {
      call: ->(a){untyped_to_s(a).swapcase}
    },
    'Ä' => {
      call: ->(a, b){Array.new(b.to_i) {a}},
      multi: true
    },
    # capital A with ring reserved: all truthy in array
    'Ā' => {
      call: ->(a){untyped_to_s(a).capitalize}
    },
    'Æ' => {
      '²' => {
        call: ->(a){perfect_exp?(a.to_i, 2)}
      },
      'ⁿ' => {
        call: ->(a, b){perfect_exp?(a.to_i, b.to_i)}
      },
      '↑' => {
        call: ->(a, b){a.to_i.gcd(b.to_i)}
      },
      '↓' => {
        call: ->(a, b){a.to_i.lcm(b.to_i)}
      },
      '×' => {
        call: ->(a, b){(Complex(*a.map(&method(:to_decimal))) ** Complex(*b.map(&method(:to_decimal)))).rect},
        depth: [1, 1]
      },
      '*' => {
        call: ->(a, b){(Complex(*a.map(&method(:to_decimal))) * Complex(*b.map(&method(:to_decimal)))).rect},
        depth: [1, 1]
      },
      '/' => {
        call: ->(a, b){(Complex(*a.map(&method(:to_decimal))) / Complex(*b.map(&method(:to_decimal)))).rect},
        depth: [1, 1]
      },
      'C' => {
        call: ->(a){BigMath.cos(to_decimal(a), DECIMAL_PRECISION)}
      },
      'D' => {
        call: ->(a){to_decimal(a) * (180 / BigMath.PI(DECIMAL_PRECISION))}
      },
      'E' => {
        call: ->(a){to_decimal(a) * (BigMath.PI(DECIMAL_PRECISION) / 180)}
      },
      'H' => {
        call: ->(a, b){BigMath.sqrt((to_decimal(a) ** 2) + (to_decimal(b) ** 2), DECIMAL_PRECISION)}
      },
      'L' => {
        call: ->(a){BigMath.log(to_decimal(a), DECIMAL_PRECISION)}
      },
      'M' => {
        call: ->(a){BigMath.log(to_decimal(a), DECIMAL_PRECISION) / BigMath.log(to_decimal(10), DECIMAL_PRECISION)}
      },
      'N' => {
        call: ->(a){BigMath.log(to_decimal(a), DECIMAL_PRECISION) / BigMath.log(to_decimal(2), DECIMAL_PRECISION)}
      },
      'R' => {
        call: ->(a){GSL::Poly[*a.map(&:to_f)].solve.to_a.each_slice(2).to_a},
        depth: [1]
      },
      'S' => {
        call: ->(a){BigMath.sin(to_decimal(a), DECIMAL_PRECISION)}
      },
      'T' => {
        call: ->(a){BigMath.sin(to_decimal(a), DECIMAL_PRECISION) / BigMath.cos(to_decimal(a), DECIMAL_PRECISION)}
      },
      'c' => {
        call: ->(a){Math.acos(a.to_f)}
      },
      'l' => {
        call: ->(a, b){BigMath.log(to_decimal(b), DECIMAL_PRECISION) / BigMath.log(to_decimal(a), DECIMAL_PRECISION)}
      },
      'm' => {
        call: ->(a){a.map(&method(:to_decimal)).reduce(:+) / a.length},
        depth: [1]
      },
      'n' => {
        call: ->(a){a = a.map(&method(:to_decimal)).sort; (a[a.length.pred / 2] + a[a.length / 2]) / 2},
        depth: [1]
      },
      'o' => {
        call: ->(a){a.select {|e| a.count(e) == a.map {|x| a.count(x)}.max}.uniq},
        depth: [1]
      },
      'p' => {
        call: ->(a, b){a.to_i.gcd(b.to_i) == 1}
      },
      'r' => {
        call: ->(a){a.reduce([1]) {|m, r| polynomial_mul(m, [1, -Complex(*r.map(&method(:to_decimal)))])}.map(&:rect)},
        depth: [2]
      },
      's' => {
        call: ->(a){Math.asin(a.to_f)}
      },
      't' => {
        call: ->(a){BigMath.atan(to_decimal(a), 20)}
      },
      'u' => {
        call: ->(a, b){Math.atan2(b.to_f, a.to_f)}
      },
      'ρ' => {
        call: ->(a, b){polynomial_mul(a.map(&method(:to_decimal)), b.map(&method(:to_decimal)))},
        depth: [1, 1]
      },
      '¬' => {
        call: ->(a){CMath.sqrt(Complex(*a.map(&method(:to_decimal)))).rect},
        depth: [1]
      },
      '¤' => {
        call: ->(a, b){b = b.to_i; ((a.to_i - 2) * ((b * (b  - 1)) / 2)) + b}
      },
      '«' => {
        call: ->(a, b){a.to_i << b.to_i}
      },
      '»' => {
        call: ->(a, b){a.to_i >> b.to_i}
      },
    },
    'È' => {
      call: ->{}
    },
    # capital E with acute reserved: any truthy in array
    'Ê' => {
      call: ->{}
    },
    'Ë' => {
      call: ->{}
    },
    'Ì' => {
      call: ->{}
    },
    'Í' => {
      call: ->{}
    },
    'Î' => {
      call: ->{}
    },
    'Ï' => {
      call: ->{}
    },
    'Ò' => {
      call: ->{}
    },
    'Ó' => {
      call: ->{}
    },
    'Ô' => {
      call: ->{}
    },
    'Õ' => {
      call: ->{}
    },
    'Ö' => {
      call: ->(a){group_equal(a).map {|e| [e[0], e.length]}},
      depth: [1],
      arr_str: true
    },
    'Ø' => {
      call: ->(a){group_equal(a)},
      depth: [1],
      arr_str: true
    },
    'Œ' => {
      call: ->(a){arr_else_chars_join(a, &:shuffle)},
      depth: [1],
      arr_str: true
    },
    'Ù' => {
      call: ->(a, b){untyped_to_s(a) + ' ' * b.to_i}
    },
    'Ú' => {
      call: ->(a, b){' ' * b.to_i + untyped_to_s(a)}
    },
    'Û' => {
      call: ->(a, b){untyped_to_s(a).ljust(b.to_i)}
    },
    'Ü' => {
      call: ->(a, b){untyped_to_s(a).rjust(b.to_i)}
    },
    'Ç' => {
      call: ->(a, b){arr_else_chars_inner_join(a) {|a| a.each_cons(b.to_i).to_a}},
      depth: [1],
      arr_str: true
    },
    'Ð' => {
      call: ->{' '}
    },
    'Ñ' => {
      call: ->{"\n"}
    },
    'Ý' => {
      call: ->{''}
    },
    'Þ' => {
      call: ->{[]}
    },
    'à' => {
      call: ->(a, b){a.to_i & b.to_i}
    },
    'á' => {
      call: ->(a, b){a.to_i | b.to_i}
    },
    'â' => {
      call: ->(a, b){a.to_i ^ b.to_i}
    },
    'ã' => {
      call: ->(a){~a.to_i}
    },
    'ä' => {
      call: ->(a){a.to_i.prime_division}
    },
    'å' => {
      call: ->{}
    },
    'ā' => {
      call: ->{}
    },
    'æ' => {
      call: ->(a){arr_else_chars_join(a) {|a| a + a.reverse[1, a.length]}},
      depth: [1],
      arr_str: true
    },
    'è' => {
      call: ->(a){a.to_i % 2 != 0}
    },
    'é' => {
      call: ->(a){a.to_i % 2 == 0}
    },
    'ê' => {
      call: ->(a){Array.new(a.to_i) {|i| nth_fibonacci(i + 1)}}
    },
    'ë' => {
      call: ->(a){Prime.first(a.to_i)},
    },
    'ì' => {
      call: ->(a){a.to_i}
    },
    'í' => {
      call: ->(a){to_decimal(a)}
    },
    'î' => {
      call: ->(a){to_decimal(a) % 1 == 0}
    },
    'ï' => {
      call: ->(a, b){untyped_to_s(a).split(untyped_to_s(b))},
    },
    'ò' => {
      call: ->(a){zip_arr(a)},
      depth: [2]
    },
    'ó' => {
      call: ->(a){from_base(a.to_s, 2)},
    },
    'ô' => {
      call: ->(a){from_base(a.to_s, 16)},
    },
    'õ' => {
      call: ->{}
    },
    'ö' => {
      call: ->(a){x = run_length_decode(a); x.all? {|a| a.is_a?(String)} ? x.join : x},
      depth: [2]
    },
    'ø' => {
      call: ->(a, b){Array.new(b.to_i) {a}},
    },
    'œ' => {
      call: ->(a){x = arr_else_str(a); [x, x.reverse]},
      depth: [1],
      arr_str: true
    },
    'ù' => {
      call: ->(a){arr_or_stack(a) {|a| a.join(' ')}},
      depth: [1],
      arr_stack: true
    },
    'ú' => {
      call: ->(a){arr_or_stack(a) {|a| a.join("\n")}},
      depth: [1],
      arr_stack: true
    },
    'û' => {
      call: ->(a, b, c){to_decimal(a).step(to_decimal(b), to_decimal(c)).to_a}
    },
    'ü' => {
      call: ->{}
    },
    'ç' => {
      call: ->(a, b){arr_else_chars_inner_join(a) {|a| a.combination(b.to_i).to_a}},
      depth: [1],
      arr_str: true
    },
    'ð' => {
      call: ->(a){untyped_to_s(a) == untyped_to_s(a).reverse}
    },
    'ñ' => {
      call: ->(a){fibonacci?(a.to_i)}
    },
    'ý' => {
      call: ->(a){nth_fibonacci(a.to_i)}
    },
    'þ' => {
      call: ->(a){sleep(to_decimal(a)); nil}
    },
    # upside down question mark reserved: else statement
    # interrobang reserved: break out of block/wire
    # double question mark reserved: select from array
    # question/exclamation mark reserved: partition from array
    # double exclamation mark reserved: reject from array
    '¡' => {
      call: ->{}
    },
    '‰' => {
      call: ->(a){2 ** to_decimal(a)}
    },
    '‱' => {
      call: ->(a){10 ** to_decimal(a)}
    },
    '¦' => {
      call: ->(a){to_decimal(a).round},
    },
    '§' => {
      call: ->(a){arr_else_chars(a).sample},
      depth: [1],
      arr_str: true
    },
    '©' => {
      call: ->(a){untyped_to_s(a) * 2}
    }, # String duplication
    '®' => {
      call: ->(a, b){arr_else_str(a)[b.to_i]},
      depth: [1],
      arr_str: true
    },
    '±' => {
      call: ->(a, b){to_decimal(a) ** (1 / to_decimal(b))},
    },
    '¬' => {
      call: ->(a){BigMath.sqrt(to_decimal(a), 20)},
    },
    '¢' => {
      call: ->(a){@vars[:register] = a},
      no_vec: true
    }, # This doesn't have to go under GET since assignment still returns the value
    '¤' => {
      call: ->{}
    },
    '«' => {
      call: ->(a, b){[a, b]},
      no_vec: true
    },
    # right double angle bracket reserved: single-component map
    '‹' => {
      call: ->(a){to_decimal(a) - 1}
    },
    '›' => {
      call: ->(a){to_decimal(a) + 1}
    },
    # left quote reserved: base-255 literal
    # right quote reserved: Smaz-compressed string literal
    # left single quote reserved: min by
    # right single quote resereved: max by
    '·' => {
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
      'c' => {
        call: ->(a){Ohm::Smaz.compress(untyped_to_s(a))}
      },
      'd' => {
        call: ->(a){Ohm::Smaz.decompress(untyped_to_s(a))}
      },
      'e' => {
        call: ->(a){
          block = sub_ohm(untyped_to_s(a)).exec
          @printed ||= block.printed
          @stack = block.stack
          nil
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
      'ψ' => {
        call: ->(a, b){arr_else_chars(a).sort == arr_else_chars(b).sort},
        depth: [1, 1],
        arr_str: true
      },
      'Ø' => {
        call: ->(a){group_equal_indices(arr_else_chars(a))},
        depth: [1],
        arr_str: true
      },
      '¦' => {
        call: ->(a, b){to_decimal(a).round(b.to_i)}
      }
    },
    # 2-dot reserved: two character literal
    # ellipsis reserved: three character literal
    # Mongolian ellipsis reserved: code page indexes literal
    '∩' => {
      call: ->(a, b){arr_else_chars_join(a, b) {|a, b| a & b}},
      no_vec: true
    },
    '∪' => {
      call: ->(a, b){arr_else_chars_join(a, b) {|a, b| a | b}},
      no_vec: true
    },
    '⊂' => {
      call: ->{}
    },
    '⊃' => {
      call: ->(a, b){arr_else_chars_join(a, b) {|a, b| a - b}},
      depth: [1, 1]
    }
  }
end

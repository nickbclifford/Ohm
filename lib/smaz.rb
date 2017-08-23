require 'rsmaz'

require_relative 'helpers'

class Ohm
  module Smaz
    module_function

    def compress(str)
      # Compress, convert bytes to hex, concatenate, convert to base 10, convert to base 255
      Helpers.to_base(RSmaz.compress(str).unpack('H*')[0].to_i(16), BASE_DIGITS.length).gsub("\u201D", "\u201C")
    end

    def decompress(compressed)
      # Convert to base 10, split into hex bytes, map into char bytes, join, decompress
      RSmaz.decompress(format('%02X', Helpers.from_base(compressed.gsub("\u201C", "\u201D"), BASE_DIGITS.length)).scan(/.{2}/).map {|i| i.to_i(16).chr}.join)
    end
  end
end

require_relative 'helpers'
require_relative 'smaz_ohm'

class Ohm
  module Smaz
    module_function

    def compress(str)
      # Compress, convert bytes to hex, concatenate, convert to base 10, convert to base 220
      Helpers.to_base(compress_c(str).unpack('H*')[0].to_i(16), 220).gsub("\u2580", "\u2551")
    end

    def decompress(compressed)
      # Convert to base 10, split into hex bytes, map into char bytes, join, decompress
      decompress_c(format('%02X', Helpers.from_base(compressed.gsub("\u2551", "\u2580"), 220)).scan(/.{2}/).map {|i| i.to_i(16).chr}.join)
    end
  end
end

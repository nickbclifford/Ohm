RSpec.describe Ohm do
  describe 'constants components' do
    describe 'α0' do
      include_examples 'component', 'all the digits from 0 to 9', result: '0123456789'
    end
    describe 'α1' do
      include_examples 'component', 'all the digits from 1 to 9', result: '123456789'
    end
    describe 'α@' do
      include_examples 'component', 'all printable ASCII characters', result: ' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~'
    end
    describe 'αA' do
      include_examples 'component', 'the uppercase alphabet', result: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    end
    describe 'αC' do
      include_examples 'component', 'all consonants', result: 'BCDFGHJKLMNPQRSTVWXYZbcdfghjklmnpqrstvwxyz'
    end
    describe 'αQ' do
      include_examples 'component', 'the uppercase alphabet ordered like a keyboard', result: %w(QWERTYUIOP ASDFGHJKL ZXCVBNM)
    end
    describe 'αW' do
      include_examples 'component', 'all characters that match regex \\w', result: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_'
    end
    describe 'αY' do
      include_examples 'component', 'all consonants without `y`', result: 'BCDFGHJKLMNPQRSTVWXZbcdfghjklmnpqrstvwxz'
    end
    describe 'αa' do
      include_examples 'component', 'the lowercase alphabet', result: 'abcdefghijklmnopqrstuvwxyz'
    end
    describe 'αc' do
      include_examples 'component', 'all vowels', result: 'AEIOUaeiou'
    end
    describe 'αe' do
      include_examples 'component', 'Euler\'s constant', result: BigMath.E(Ohm::DECIMAL_PRECISION)
    end
    describe 'αq' do
      include_examples 'component', 'the lowercase alphabet ordered like a keyboard', result: %w(qwertyuiop asdfghjkl zxcvbnm)
    end
    describe 'αy' do
      include_examples 'component', 'all vowels including `y`', result: 'AEIOUYaeiouy'
    end
    describe 'απ' do
      include_examples 'component', 'pi', result: BigMath.PI(Ohm::DECIMAL_PRECISION)
    end
    describe 'αφ' do
      include_examples 'component', 'phi', result: (1 + BigMath.sqrt(Ohm::Helpers.to_decimal(5), Ohm::DECIMAL_PRECISION)) / 2
    end
    describe 'αΓ' do
      include_examples 'component', 'an ASCII goat', result: <<-GOAT
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
    end
    describe 'αΩ' do
      include_examples 'component', 'the Ohm codepage', result: '°¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾ⁿ½⅓¼←↑→↓↔↕ıȷ×÷£¥€ !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~¶αβγδεζηθικλμνξπρςστυφχψωΓΔΘΠΣΦΨΩÀÁÂÃÄÅĀÆÈÉÊËÌÍÎÏÒÓÔÕÖØŒÙÚÛÜÇÐÑÝÞàáâãäåāæèéêëìíîïòóôõöøœùúûüçðñýþ¿‽⁇⁈‼¡‰‱¦§©®±¬¢¤«»‹›“”‘’·‥…᠁∩∪⊂⊃'
    end
  end
end

require 'timecop'

RSpec.describe Ohm do
  describe 'time components' do
    # NOTE: Timecop is handled in spec_helper
    describe 'υ!' do
      include_examples 'component', 'the current timestamp', result: 1513826830
    end
    describe 'υ%' do
      include_examples 'component', 'the current time formatted with a `strftime` string', stack: %w(%Y-%m-%d), result: '2017-12-20'
    end
    describe 'υD' do
      include_examples 'component', 'the current day', result: 20
    end
    describe 'υH' do
      include_examples 'component', 'the current hour', result: 21
    end
    describe 'υI' do
      include_examples 'component', 'the current minute', result: 27
    end
    describe 'υM' do
      include_examples 'component', 'the current month', result: 12
    end
    describe 'υN' do
      include_examples 'component', 'the current nanosecond', result: 0
    end
    describe 'υS' do
      include_examples 'component', 'the current second', result: 10
    end
    describe 'υW' do
      include_examples 'component', 'the current weekday', result: 3 # it is Wednesday my dudes
    end
    describe 'υY' do
      include_examples 'component', 'the current year', result: 2017
    end

    # Thanks, RSpec, for not letting me do this for whatever reason
    # Mar 19, 2017, 7:34:16 PM UTC
    # let(:timestamp) {1489952056}
    timestamp = 1489952056

    describe 'υd' do
      include_examples 'component', 'the day specified by a timestamp', stack: [timestamp], result: 19
    end
    describe 'υh' do
      include_examples 'component', 'the hour specified by a timestamp', stack: [timestamp], result: 19
    end
    describe 'υi' do
      include_examples 'component', 'the minute specified by a timestamp', stack: [timestamp], result: 34
    end
    describe 'υm' do
      include_examples 'component', 'the month specified by a timestamp', stack: [timestamp], result: 3
    end
    describe 'υn' do
      include_examples 'component', 'the nanosecond specified by a timestamp', stack: [timestamp], result: 0
    end
    describe 'υs' do
      include_examples 'component', 'the second specified by a timestamp', stack: [timestamp], result: 16
    end
    describe 'υw' do
      include_examples 'component', 'the weekday specified by a timestamp', stack: [timestamp], result: 0
    end
    describe 'υy' do
      include_examples 'component', 'the year specified by a timestamp', stack: [timestamp], result: 2017
    end
    describe 'υ‰' do
      include_examples 'component', 'the time specified by a timestamp formatted with a `strftime` string', stack: [timestamp, '%Y-%m-%d'], result: '2017-03-19'
    end
    describe 'υ§' do
      include_examples 'component', 'the timestamp of the time given by parsing a string with a `strptime` format string', stack: %w(2017-03-19 %Y-%m-%d), result: 1489899600
    end
  end
end

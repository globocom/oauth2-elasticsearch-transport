require './lib/oauth2-elasticsearch-transport'
require 'webmock/rspec'
require 'debugger'
require 'json'

def with_time(value)
  Time.stub(:now).and_return(value)
  x = yield
  Time.unstub(:now)
  x
end

def now
  @now ||= Time.now.tap do |time|
    Time.stub(:now).and_return(time)
  end
end

module HashWithMatcher
  extend RSpec::Matchers::DSL

  def symbolize obj
    if obj.is_a? Hash
      new_hash = {}
      obj.each { |key, value| new_hash[key.to_sym] = symbolize value }
      new_hash
    elsif obj.is_a? Enumerable
      obj.collect { |value| symbolize value }
    else
      obj
    end
  end

  matcher :hash_with do |expected|
    match do |actual|
      if (expected.is_a? Hash) && (actual.is_a? Hash)
        e = symbolize expected
        a = symbolize actual
        e.all? do |key, value|
          a[key] == value
        end
      else
        false
      end
    end
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include HashWithMatcher
end

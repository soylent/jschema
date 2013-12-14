if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start do
    add_filter 'test/'
    refuse_coverage_drop
  end
end

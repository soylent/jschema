# encoding: utf-8
require 'minitest/autorun'
require_relative 'assertions'

class TestFormat < Minitest::Test
  include Assertions

  def test_that_argument_is_string
    assert_raises_unless('format', :string)
  end

  def test_that_argument_is_one_of_allowed_formats
    assert_raises(JSchema::InvalidSchema) do
      validator 'unsupported_format'
    end
  end

  def test_passing_validation_by_date_time_format
    assert validator('date-time').valid?('2001-02-03T04:05:06+07:00')
  end

  def test_failing_validation_by_date_time_format
    refute validator('date-time').valid?('2001-x2-03T04:05:06+07:00')
  end

  def test_passing_validation_by_email_format
    assert validator('email').valid?('steve@apple.com')
  end

  def test_failing_validation_by_email_format
    refute validator('email').valid?('invalid_email')
  end

  def test_passing_validation_by_hostname_format
    assert validator('hostname').valid?('apple.com')
  end

  def test_failing_validation_by_hostname_format
    refute validator('hostname').valid?('invalid+hostname')
  end

  def test_passing_validation_by_ipv4_format
    assert validator('ipv4').valid?('127.0.0.1')
  end

  def test_failing_validation_by_ipv4_format
    refute validator('ipv4').valid?('0')
  end

  def test_passing_validation_by_ipv6_format
    assert validator('ipv6').valid?('::1')
  end

  def test_failing_validation_by_ipv6_format
    refute validator('ipv6').valid?('0')
  end

  def test_passing_validation_by_uri_format
    assert validator('uri').valid?('http://example.com/')
  end

  def test_passing_validation_of_non_ascii_uri
    assert validator('uri').valid?('http://☃.net/☃')
  end

  def test_failing_validation_by_uri_format
    refute validator('uri').valid?('://')
  end

  def test_passing_validation_by_regex
    assert validator('regex').valid?('\d+')
  end

  def test_failing_validation_by_regex
    refute validator('regex').valid?('**')
  end

  private

  def validator_class
    JSchema::Validator::Format
  end
end

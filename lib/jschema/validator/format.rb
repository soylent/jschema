require 'date'
require 'ipaddr'

module JSchema
  module Validator
    class Format < SimpleValidator
      private

      self.keywords = ['format']

      def validate_args(format)
        allowed_formats =
          ['date-time', 'email', 'hostname', 'ipv4', 'ipv6', 'uri', 'regex']

        if allowed_formats.include?(format)
          true
        else
          invalid_schema 'format', format
        end
      end

      def post_initialize(format)
        @validator_method = format.gsub('-', '_')
      end

      def validate_instance(instance)
        unless send(@validator_method, instance)
          "#{instance} must be a #{@validator_method}"
        end
      end

      def applicable_type
        String
      end

      def date_time(instance)
        true if DateTime.rfc3339(instance)
      rescue ArgumentError
        false
      end

      def email(instance)
        instance.include? '@'
      end

      # Acc.to RFC 1034, 3.1
      def hostname(instance)
        if instance.length.between?(1, 255)
          instance.split('.').all? do |label|
            label =~ /^[\da-z\-]{1,63}$/i
          end
        else
          false
        end
      end

      def ipv4(instance)
        IPAddr.new(instance).ipv4?
      rescue ArgumentError
        false
      end

      def ipv6(instance)
        IPAddr.new(instance).ipv6?
      rescue ArgumentError
        false
      end

      def uri(instance)
        URI.parse URI.encode(instance)
      rescue URI::InvalidURIError
        false
      end

      def regex(instance)
        Regexp.new(instance)
        true
      rescue TypeError, RegexpError
        false
      end
    end
  end
end

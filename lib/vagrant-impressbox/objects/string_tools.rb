# Impressbox namespace
module Impressbox
  # Objects namespace
  module Objects
    # Some extra tools for working with strings
    class StringTools

      # Disable creation with new for this class
      # Making new method private
      private_class_method :new

      # If str1 ends with str2 strips
      #
      # @param str1 [String] String 1
      # @param str2 [String] String 2
      #
      # @return [String]
      def self.remove_at_end(str1, str2)
        l = str2.length
        p = str1.length - l - 1
        return str1[0..p] if str1[-l..-1] == str2
        str1
      end

      # is numeric part?
      #
      # @param str [String] String
      #
      # @return [Boolean]
      def self.is_numeric(str)
        true if Float(str) rescue false
      end

      # Concat array with capitalize options
      #
      # @param strs      [Array]   Strings array
      #
      # @return [String]
      def self.concat_capitalize(strs)
        strs.map do |str|
          str.capitalize
        end.join ''
      end

    end
  end
end

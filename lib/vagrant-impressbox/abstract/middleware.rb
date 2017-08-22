module Impressbox
  module Abstract
    # Abstract middleware class
    class Middleware

      # Initialize middleware
      #
      # @param app [Object] Current app
      # @param env [Hash]   Current hash
      def initialize(app, env)
        @app = app
        @env = env
      end

      # Call method of middleware
      #
      # @param env [Hash]  Current hash used for invoking this middleware
      def call(env)
        raise I18n.t('configuring.error.must_overwrite')
      end

      # Gets UI interface
      #
      # @return [Object]
      def ui
        @env[:ui]
      end

      # Get hook when to add
      #
      # @return [Array]
      def self.hooks
        raise I18n.t('configuring.error.must_overwrite')
      end

      # Builds app
      #
      # @return [Object]
      def self.build
        Vagrant::Action::Builder.new.tap do |builder|
          builder.use self
        end
      end

    end
  end
end

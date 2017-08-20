# Loads all requirements
require 'vagrant'

# Impressbox namepsace
module Impressbox
  # Vagrant config class
  class Config < Vagrant.plugin('2', :config)
    # Filename from where to read all config data
    #
    # @!attribute [rw] file
    #
    # @return [String]
    attr_accessor :file

    # Initializer
    def initialize
      @file = UNSET_VALUE
    end

    # Finalize config
    def finalize!
      @file = 'config.impressbox.yaml' if @file == UNSET_VALUE
    end

    # Validate config values
    #
    #@param machine [::Vagrant::Machine] machine for what to validate config data
    #
    #@return [Hash]
    def validate(machine)
      errors = []

      unless good_file?
        errors << I18n.t('config.not_exist', file: @file)
      end

      {'Impressbox' => errors}
    end

    private

    # Does yaml file exists?
    #
    #@return [Boolean]
    def good_file?
      File.exist? @file
    end

  end
end

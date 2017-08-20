# Loads all requirements
require 'vagrant'

module Impressbox
  # This class is used as dummy provisioner because all
  # provision tasks are now defined in actions
  class Provisioner < Vagrant.plugin('2', :provisioner)

    # Mass Loader shortcut
    DirInfo = ::Impressbox::Objects::DirInfo

    # Config File shortcut
    ConfigFile = ::Impressbox::Objects::ConfigFile

    # Initializes the provisioner with the machine that it will be
    # provisioning along with the provisioner configuration (if there
    # is any).
    #
    # The provisioner should _not_ do anything at this point except
    # initialize internal state.
    #
    # @param [Machine] machine The machine that this will be provisioning.
    # @param [Object] config Provisioner configuration, if one was set.
    def initialize(machine, config)
      @file_config = ConfigFile.new(config.file)
      @configurators = DirInfo.create_from_relative_path('configurators', true)
      @configurators.each do |configurator|
        configurator.instance machine, @file_config
      end
      super machine, config
    end

    # Cleanup operations
    def cleanup
      @configurators.each do |configurator|
        configurator.last_instance.cleanup
      end
    end

    # Do configuration operations
    #
    #@param root_config [Hash]  Current Vagrantfile configuration instance
    def configure(root_config)
      @configurators.each do |configurator|
        configurator.last_instance.configure root_config
      end
    end

    # Do provision tasks
    def provision
      @configurators.each do |configurator|
        configurator.last_instance.provision
      end
    end

  end
end

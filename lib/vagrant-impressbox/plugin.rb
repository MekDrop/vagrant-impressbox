# Loads all requirements
require 'vagrant'
require 'vagrant-impressbox/autoload'

# Plugin definition
module Impressbox
  class Plugin < Vagrant.plugin(2)

    # Provision shortcut
    Provision = Vagrant::Action::Builtin::Provision

    #

    # Defines plug-in name
    name 'vagrant-impressbox'

    # Defines description for the plug-in
    description I18n.t('description')

    # Defines config
    config(:impressbox, :provisioner) do
      Impressbox::Config
    end

    # Defines provisioner
    provisioner(:impressbox) do
      Impressbox::Provisioner
    end

    # Defines command
    command 'impressbox' do
      Impressbox::Command
    end

    # Defines action hooks
    action_hook(:machine_action_up) do |hook|
      require_relative 'action'
      hook.after Vagrant::Action::Builtin::Provision, Action.machine_up
    end
    action_hook(:machine_action_destroy) do |hook|
      require_relative 'action'
      hook.after Vagrant::Action::Builtin::GracefulHalt, Action.machine_halt
    end
    action_hook(:machine_action_config_validate) do |hook|
      require_relative 'action'
      hook.after Vagrant::Action::Builtin::ConfigValidate, Action.config_validated
    end

  end
end

# Loads all requirements
require 'vagrant'
require 'vagrant-impressbox/autoload'

# Plugin definition
module Impressbox
  class Plugin < Vagrant.plugin(2)

    # Provision shortcut
    Provision = Vagrant::Action::Builtin::Provision

    # DirInfo shortcut
    DirInfo = Impressbox::Objects::DirInfo

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

    # Automaticaly defines commands
    DirInfo.create_from_relative_path('commands', true).each do |file|
      command file.class_name.downcase do
        require file.filename
        file.const_class_name
      end
    end

    # Automaticaly defines hooks
    # DirInfo.create_from_relative_path('middlewares').each do |file|
    #   next unless file.ruby_file?
    #   require file.filename
    #   middleware_build = file.const_class_name.build
    #   file.const_class_name.hooks.each do |hook|
    #     action_hook(hook[1]) do |real_hook|
    #       if hook.length == 2 then
    #         real_hook.method(hook[0]).call middleware_build
    #       elsif hook.length == 3 then
    #         real_hook.method(hook[0]).call hook[1], middleware_build
    #       end
    #     end
    #   end
    # end

  end
end

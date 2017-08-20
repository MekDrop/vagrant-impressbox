# This file defines autoload paths

# First trying to do that for Impressbox namespace
module Impressbox
  autoload :Plugin, 'vagrant-impressbox/plugin.rb'
  autoload :Provisioner, 'vagrant-impressbox/provisioner.rb'
  autoload :Config, 'vagrant-impressbox/config.rb'

  # now for Impressbox::Objects
  module Objects
    BASE_PATH = 'vagrant-impressbox/objects/'.freeze

    autoload :ConfigData, BASE_PATH + 'config_data.rb'
    autoload :ConfigFile, BASE_PATH + 'config_file.rb'
    autoload :SshKeyDetect, BASE_PATH + 'ssh_key_detect.rb'
    autoload :Template, BASE_PATH + 'template.rb'
    autoload :InstanceMaker, BASE_PATH + 'instance_maker.rb'
    autoload :CommandOptionsParser, BASE_PATH + 'command_options_parser.rb'
    autoload :MustacheExt, BASE_PATH + 'mustache_ext.rb'
    autoload :StringTools, BASE_PATH + 'string_tools.rb'
    autoload :FileInfo, BASE_PATH + 'file_info.rb'
    autoload :DirInfo, BASE_PATH + 'dir_info.rb'
  end

  # now for Impressbox::Abstract
  module Abstract
    BASE_PATH = 'vagrant-impressbox/abstract/'.freeze

    autoload :Middleware, BASE_PATH + 'middleware.rb'
    autoload :Command, BASE_PATH + 'command.rb'
    autoload :Configurator, BASE_PATH + 'configurator.rb'
  end

end

module Impressbox
  module Action
    include Vagrant::Action::Builtin

    def self.machine_up
      Vagrant::Action::Builder.new.tap do |builder|
        builder.use ::Impressbox::Actions::MachineUp
      end
    end

    def self.machine_halt
      Vagrant::Action::Builder.new.tap do |builder|
        builder.use ::Impressbox::Actions::MachineHalt
      end
    end

    def self.config_validated
      Vagrant::Action::Builder.new.tap do |builder|
        builder.use ::Impressbox::Actions::ConfigValidated
      end
    end

  end
end

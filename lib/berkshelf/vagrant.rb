begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant Berkshelf plugin must be run within Vagrant.'
end

require 'berkshelf'
require 'fileutils'
require 'json'
require 'tmpdir'

require_relative 'vagrant/errors'
require_relative 'vagrant/version'

module Berkshelf
  # @author Jamie Winsor <jamie@vialstudios.com>
  module Vagrant
    require_relative 'vagrant/action'
    require_relative 'vagrant/config'
    require_relative 'vagrant/env'
    require_relative 'vagrant/env_helpers'

    TESTED_CONSTRAINT = "~> 1.2.0"

    class << self
      # The path to where shelfs are created on the host machine to be mounted in
      # Vagrant guests
      #
      # @return [String]
      def shelf_path
        File.join(Berkshelf.berkshelf_path, 'vagrant')
      end

      # Generate a new shelf to be mounted in a Vagrant guest
      #
      # @return [String]
      #   path to the generated shelf
      def mkshelf(machine_name = nil)

        unless File.exist?(shelf_path)
          FileUtils.mkdir_p(shelf_path)
        end

        if machine_name.nil?
          prefix_suffix = 'berkshelf-'
        else
          prefix_suffix = ['berkshelf-', "-#{machine_name}"]
        end

        Dir.mktmpdir(prefix_suffix, shelf_path)
      end
    end
  end
end

require_relative 'vagrant/plugin'

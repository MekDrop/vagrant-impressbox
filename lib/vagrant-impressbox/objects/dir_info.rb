# Impressbox namespace
module Impressbox
  # Objects namespace
  module Objects
    # Directory reader and info
    class DirInfo

      # Extends with Enumerable
      include Enumerable

      # Dir
      #
      #@return [String]
      attr_reader :dir

      # Create from relative path
      #
      #@param path [String]     Path
      #@param only_rb [Boolean] Only ruby files
      #
      #@return [DirInfo]
      def self.create_from_relative_path(path, only_rb = false)
        fpath = File.join('..', path)
        dir = File.expand_path(fpath, __dir__)
        self.new dir
      end

      # Initializer
      #
      #@param dir [String] Directory
      #@param only_rb [Boolean] Only ruby files
      def initialize(dir, only_rb = false)
        @dir = dir
        @entries = Dir.entries(dir).reject do |entry|
          entry =~ /^\.{1,2}$/
        end.map do |entry|
          make_item entry, only_rb
        end
        clear_from_not_ruby_files if only_rb
      end

      # This used for each iterating between results
      def each(&block)
        @entries.each do |entry|
          block.call entry
        end
      end

      private

      # Gets full path for entry
      #
      #@param entry [String] Filename or Dirname
      #
      #@return [String]
      def full_path(entry)
        File.expand_path entry, @dir
      end

      # Makes item for returnin in iterations
      #
      #@param entry [String] dirname or Filename
      #@param only_rb [Boolean] Only ruby files
      #
      #@return [DirInfo,FileInfo]
      def make_item(entry, only_rb = false)
        path = full_path(entry)
        return DirInfo.new(path, only_rb) if File.directory?(path)
        FileInfo.new(path)
      end

      # Remove not ruby entry files
      def clear_from_not_ruby_files
        @entries.reject! do |entry|
          case entry
            when DirInfo
              true
            when FileInfo
              !entry.ruby_file?
          end
        end
      end

    end
  end
end

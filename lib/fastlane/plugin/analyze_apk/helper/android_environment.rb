# Relevant code was copied from the Screengrab action (https://github.com/fastlane/fastlane/blob/master/screengrab/lib/screengrab/android_environment.rb)

require 'fileutils'
require 'fastlane_core'
module Fastlane
  module Helper
    class AndroidEnvironment
      attr_reader :android_home
      attr_reader :build_tools_version

      # android_home        - the String path to the install location of the Android SDK
      # build_tools_version - the String version of the Android build tools that should be used
      def initialize(android_home, build_tools_version)
        @android_home = android_home
        @build_tools_version = build_tools_version
      end

      def build_tools_path
        @build_tools_path ||= find_build_tools(android_home, build_tools_version)
      end

      def aapt_path
        @aapt_path ||= find_aapt(build_tools_path)
      end

      private

      def find_build_tools(android_home, build_tools_version)
        return nil unless android_home

        build_tools_dir = File.join(android_home, 'build-tools')

        return nil unless build_tools_dir && File.directory?(build_tools_dir)

        return File.join(build_tools_dir, build_tools_version) if build_tools_version

        version = select_build_tools_version(build_tools_dir)

        version ? File.join(build_tools_dir, version) : nil
      end

      def select_build_tools_version(build_tools_dir)
        # Collect the sub-directories of the build_tools_dir, rejecting any that start with '.' to remove . and ..
        dir_names = Dir.entries(build_tools_dir).select { |e| !e.start_with?('.') && File.directory?(File.join(build_tools_dir, e)) }

        # Collect a sorted array of Version objects from the directory names, handling the possibility that some
        # entries may not be valid version names
        versions = dir_names.map do |d|
          begin
            Gem::Version.new(d)
          rescue
            nil
          end
        end.reject(&:nil?).sort

        # We'll take the last entry (highest version number) as the directory name we want
        versions.last.to_s
      end

      def find_aapt(build_tools_path)
        return FastlaneCore::CommandExecutor.which('aapt') unless build_tools_path

        aapt_path = File.join(build_tools_path, 'aapt')
        executable_command?(aapt_path) ? aapt_path : nil
      end

      def executable_command?(cmd_path)
        cmd_path && File.executable?(cmd_path) && !File.directory?(cmd_path)
      end
    end
  end
end

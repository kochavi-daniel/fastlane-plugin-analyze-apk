# Code inspired by Bitrise Deploy Step - https://github.com/bitrise-io/steps-deploy-to-bitrise-io
module Fastlane
  module Actions
    module SharedValues
      ANALYZE_APK_PACKAGE_NAME = :ANALYZE_APK_PACKAGE_NAME
      ANALYZE_APK_VERSION_CODE = :ANALYZE_APK_VERSION_CODE
      ANALYZE_APK_VERSION_NAME = :ANALYZE_APK_VERSION_NAME
      ANALYZE_APK_APP_NAME = :ANALYZE_APK_APP_NAME
      ANALYZE_APK_MIN_SDK = :ANALYZE_APK_MIN_SDK
      ANALYZE_APK_SIZE = :ANALYZE_APK_SIZE
    end
    class AnalyzeApkAction < Action
      def self.run(params)

        app_apk_path = params[:apk_path]
        android_home = params[:android_home]

        UI.user_error!("Couldn't find Android SDK at path '#{android_home}'") if android_home.nil? || !File.directory?(android_home)

        android_env = Fastlane::Helper::AndroidEnvironment.new(params[:android_home],
                                                               params[:build_tools_version])

        helper = Helper::AnalyzeApkHelper
        executor = FastlaneCore::CommandExecutor

        aapt_path = android_env.aapt_path

        aapt_info = executor.execute(command: "#{aapt_path} dump badging #{app_apk_path}",
                                     print_all: false,
                                     print_command: false)

        package_name, version_code, version_name = helper.filter_package_infos(aapt_info)
        app_name = helper.filter_app_label(aapt_info)
        min_sdk = helper.filter_min_sdk_version(aapt_info)
        apk_file_size = File.size(app_apk_path)

        Actions.lane_context[SharedValues::ANALYZE_APK_PACKAGE_NAME] = package_name if package_name
        Actions.lane_context[SharedValues::ANALYZE_APK_VERSION_CODE] = version_code if version_code
        Actions.lane_context[SharedValues::ANALYZE_APK_VERSION_NAME] = version_name if version_name

        Actions.lane_context[SharedValues::ANALYZE_APK_APP_NAME] = app_name if app_name
        Actions.lane_context[SharedValues::ANALYZE_APK_MIN_SDK] = min_sdk if min_sdk
        Actions.lane_context[SharedValues::ANALYZE_APK_SIZE] = apk_file_size if apk_file_size
      end

      def self.description
        'Analyzes an apk to fetch: versionCode, versionName, apk size, permissions, etc.'
      end

      def self.authors
        ['kochavi-daniel']
      end

      def self.output
        [
          ['ANALYZE_APK_VERSION_NAME', 'Apk\'s version name'],
          ['ANALYZE_APK_VERSION_CODE', 'Apk\'s version code'],
          ['ANALYZE_APK_PACKAGE_NAME', 'Apk\'s package name'],
          ['ANALYZE_APK_APP_NAME', 'App name'],
          ['ANALYZE_APK_MIN_SDK', 'Apk\'s min sdk version'],
          ['ANALYZE_APK_SIZE', 'Apk\'s size (bytes)']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "Using this plugin will enable you to extract the following info about your generated apk: versionName, versionCode, package name, app name, minSdkVersion, apk size"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :apk_path,
                                       env_name: 'FL_APK_PATH',
                                       description: 'Path to the apk you want to inspect',
                                       is_string: true,
                                       optional: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("Couldn't find apk file at path '#{value}'") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :android_home,
                                       env_name: 'FL_ANDROID_HOME',
                                       description: 'Path to the root of your Android SDK installation, e.g. ~/tools/android-sdk-macosx',
                                       is_string: true,
                                       optional: true,
                                       default_value: ENV['ANDROID_HOME'] || ENV['ANDROID_SDK']),
          FastlaneCore::ConfigItem.new(key: :build_tools_version,
                                       env_name: 'FL_BUILD_TOOLS_VERSION',
                                       description: "The Android build tools version to use, e.g. '23.0.2'",
                                       is_string: true,
                                       optional: true)
        ]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end

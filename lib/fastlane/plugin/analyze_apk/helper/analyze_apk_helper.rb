module Fastlane
  module Helper
    class AnalyzeApkHelper
      class << self
        def filter_package_infos(infos)
          package_name = ''
          version_code = ''
          version_name = ''

          package_name_version_regex = 'package: name=\'(?<package_name>.*)\' versionCode=\'(?<version_code>.*)\' versionName=\'(?<version_name>.*)\' platformBuildVersionName='
          package_name_version_match = infos.match(package_name_version_regex)

          if package_name_version_match && package_name_version_match.captures
            package_name = package_name_version_match.captures[0]
            version_code = package_name_version_match.captures[1]
            version_name = package_name_version_match.captures[2]
          end

          return [package_name, version_code, version_name]
        end
        def filter_app_label(infos)
          app_label_regex = 'application: label=\'(?<label>.+)\' icon='
          app_label_match = infos.match(app_label_regex)

          return app_label_match.captures[0] if app_label_match && app_label_match.captures

          app_label_regex = 'application-label:\'(?<label>.*)\''
          app_label_match = infos.match(app_label_regex)

          return app_label_match.captures[0] if app_label_match && app_label_match.captures

          return ''
        end

        def filter_min_sdk_version(infos)
          min_sdk = ''

          min_sdk_regex = 'sdkVersion:\'(?<min_sdk_version>.*)\''
          min_sdk_match = infos.match(min_sdk_regex)
          min_sdk = min_sdk_match.captures[0] if min_sdk_match && min_sdk_match.captures

          return min_sdk
        end
      end
    end
  end
end

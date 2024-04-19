#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_fcm_decrypt.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_fcm_decrypt'
  s.version          = '0.0.1'
  s.summary          = 'A project to use rust lib on platform to decrypt fcm messages'
  s.description      = <<-DESC
A project to use rust lib on platform to decrypt fcm messages
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.static_framework = true
  s.vendored_libraries = "libfcm_decrypt.dylib","libfcm_decrypt_64.dylib"

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end

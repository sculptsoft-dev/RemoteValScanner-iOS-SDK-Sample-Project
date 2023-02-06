#
#  Be sure to run `pod spec lint SSRemoteValSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "SSRemoteValSDK"
  spec.version      = "1.0.0"
  spec.summary      = "SSRemoteValSDK for floor Scannig "

  spec.description  = <<-DESC
  This framework use for scannig floor upload and get report in mail. 
                   DESC

  spec.homepage     = "https://github.com/sculptsoft-dev/RemoteValScanner-iOS-SDK-Sample-Project.git"
  spec.license      = "MIT"
  spec.author       = { "Akash Sheth" => "akahsheth140@gmail.com" }
  spec.source       = { :git => "https://github.com/sculptsoft-dev/RemoteValScanner-iOS-SDK-Sample-Project.git", :tag => "#{spec.version}" }

  spec.ios.deployment_target = '12.0'
  spec.vendored_frameworks = 'RemotevalSDK.xcframework'
  
  spec.dependency "Sentry"
  spec.dependency "Zip"
  spec.dependency "Reachability"
  spec.dependency "ObjectMapper"

end

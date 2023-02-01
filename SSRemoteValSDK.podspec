#
#  Be sure to run `pod spec lint SSRemoteValSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "SSRemoteValSDK"
  spec.version      = "0.0.1"
  spec.summary      = "SSRemoteValSDK for floor Scannig "

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
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

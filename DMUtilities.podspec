#
# Be sure to run `pod lib lint DMUtilities.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DMUtilities'
  s.version          = '0.1.0'
  s.summary          = 'A repo contains extensions and utilities for personal usage.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Mostly extensions to exising CocoaTouch and Foundataion classes. Some potocol-oriented enhancements.
                       DESC

  s.homepage         = 'https://github.com/grandima/DMUtilities'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'grandima' => 'grandima@gmail.com' }
  s.source           = { :git => 'https://github.com/grandima/DMUtilities.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'DMUtilities/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DMUtilities' => ['DMUtilities/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'XCGLogger'
end

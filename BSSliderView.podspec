#
# Be sure to run `pod lib lint BSSliderView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BSSliderView'
  s.version          = '1.0.4'
  s.summary          = 'BSSliderView is a slideshow / carousel for ios application.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
BSSliderView is a widget that allowed you to have your own carousel / slideshow in your app. This widget basically is an inheritance from UICollectionView, so you can add your own slide design from nib / xib file.
                       DESC

  s.homepage         = 'https://github.com/icemanbsi/BSSliderView'
  s.screenshots     = 'http://bobbystenly.com/cocoapod/BSSliderView/sample.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bobby Stenly' => 'iceman.bsi@gmail.com' }
  s.source           = { :git => 'https://github.com/icemanbsi/BSSliderView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'BSSliderView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BSSliderView' => ['BSSliderView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

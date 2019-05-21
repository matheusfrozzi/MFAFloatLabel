#
# Be sure to run `pod lib lint MFAFloatLabel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MFAFloatLabel'
  s.version          = '0.1.0'
  s.summary          = 'A beautiful and flexible UITextField subclass with material design style.'

  s.platform = :ios
  s.ios.deployment_target = '9.3'
  s.swift_version = "5.0"
  s.frameworks = 'UIKit'

  s.homepage         = 'https://github.com/matheusfrozzi/MFAFloatLabel'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'matheusfrozzi' => 'matheusfrozzi@gmail.com' }
  s.source           = { :git => 'https://github.com/matheusfrozzi/MFAFloatLabel.git', :tag => s.version.to_s }
  s.source_files = 'MFAFloatLabel/Classes/**/*'

end

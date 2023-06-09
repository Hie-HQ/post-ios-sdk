Pod::Spec.new do |s|
  s.name             = 'POST_sdk'
  s.version          = '0.1.2'
  s.summary          = 'post sdk for easy onbaording'
  s.swift_version = '4.0'
  s.description      = <<-DESC
post sdk for easy onbaording!
                       DESC
 
  s.homepage         = 'https://github.com/Hie-HQ/post-ios-sdk' 
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ashaA' => 'asha@hiehq.com' }
  s.source           = { :git => 'https://github.com/Hie-HQ/post-ios-sdk.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '13.0'
  s.source_files = 'POST_sdk/POST_sdk/POST/*.{swift}'
  s.resources = 'POST_sdk/POST_sdk/POST/**/*.{storyboard,xib,xcassets,json,png,ttf}'
  s.dependency 'Alamofire'
  s.dependency 'IQKeyboardManager'
  s.dependency 'SwiftyJSON'
  s.dependency 'SVProgressHUD'
  s.dependency 'Kingfisher'

end

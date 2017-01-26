
Pod::Spec.new do |s|

  s.name         = "AspirinKit"
  s.version      = "1.0.0"
  s.summary      = "A set of extensions and classes used to reduce headaches in iOS/macOS/tvOS development."
  s.homepage     = "https://github.com/webelectric/AspirinKit"

  s.license      = { :type => "MIT" }

  s.author             =  "Diego Doval" 
  s.social_media_url   = "http://twitter.com/diegodoval"


  s.requires_arc = true

  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.12"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "10.0"

  s.source       = { :git => "https://github.com/webelectric/AspirinKit.git", :tag => s.version.to_s }

  s.frameworks   = ['Foundation', 'CoreGraphics', 'QuartzCore']
  s.osx.frameworks   = ['AppKit', 'CoreImage']
  s.ios.frameworks   = ['UIKit', 'CoreImage']
  s.tvos.frameworks   = ['UIKit', 'CoreImage']
  s.watchos.frameworks   = ['UIKit']

  s.source_files  = ["AspirinKit/Sources/CoreGraphics/**/*.{h,swift,m}"]
  s.ios.source_files  = ["AspirinKit/Sources/UIKit/**/*.{h,swift,m}"]
  s.tvos.source_files  = ["AspirinKit/Sources/UIKit/**/*.{h,swift,m}"]

  s.pod_target_xcconfig =  {
        'SWIFT_VERSION' => '3.0',
  }
end

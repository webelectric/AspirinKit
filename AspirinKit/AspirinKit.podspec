
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

  s.source       = { :git => "https://github.com/webelectric/AspirinKit.git", :tag => "#{s.version}" }
  s.pod_target_xcconfig =  {
        'SWIFT_VERSION' => '3.0',
  }

  s.source_files  = "Sources/**/*.{h,swift,m}"

end

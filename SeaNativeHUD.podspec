
Pod::Spec.new do |s|

  s.name         = "SeaNativeHUD"
  s.version      = "0.0.1"
  s.summary      = "A easy function for Native HUD."

  s.description  = "使用简单的原生风格弹框组件"

  s.homepage     = "https://github.com/seabrea/SeaNativeHUD"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "seabrea" => "hgdigm@gmail.com" }
  # Or just: s.author    = "Bob"
  # s.authors            = { "Bob" => "hgdigm@gmail.com" }
  # s.social_media_url   = "http://twitter.com/Bob"


  # s.platform     = :ios
  s.platform     = :ios, "9.0"

  #  When using multiple platforms
  s.ios.deployment_target = "9.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/seabrea/SeaNativeHUD.git", :tag => "#{s.version}" }

  s.source_files  = "MyUIDemo/SeaNativeHUD/**/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end

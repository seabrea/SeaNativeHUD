
Pod::Spec.new do |s|

  s.name         = "SeaNativeHUD"

  s.version      = "0.0.1"

  s.summary      = "A easy function for Native HUD."

  s.description  = "在iOS上面使用的原生风格弹框组件，对项目代码无侵入，使用简单."

  s.homepage     = "https://github.com/seabrea/SeaNativeHUD"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "seabrea" => "hgdigm@gmail.com" }

  s.platform     = :ios, "9.0"

  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/seabrea/SeaNativeHUD.git", :tag => "#{s.version}" }

  s.source_files  = "MyUIDemo/SeaNativeHUD/**/*.{h,m}"

  s.requires_arc = true

end

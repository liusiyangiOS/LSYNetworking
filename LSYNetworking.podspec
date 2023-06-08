Pod::Spec.new do |s|

  s.name         = "LSYNetworking"
  s.version      = "1.0.0"
  s.summary      = "LSYNetworking is a high level request util based on AFNetworking."

  s.homepage     = "https://github.com/liusiyangiOS/LSYNetworking"
  s.license      = "MIT"
  s.author       = { "liusiyangiOS" => "liusiyang_iOS@163.com" }
  
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/liusiyangiOS/LSYNetworking.git", :tag => s.version.to_s }
  s.source_files = "LSYNetworking/*.{h,m}"
  s.requires_arc = true
  
  s.dependency "AFNetworking", "~> 4.0"
  
end

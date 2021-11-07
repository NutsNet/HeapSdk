Pod::Spec.new do |spec|

  spec.name         = "HeapSdk"
  spec.version      = "0.0.9"
  spec.summary      = "HeapSdk is a sdk chalenge"

  spec.description  = <<-DESC
This CocoaPods library will collect some events for the backend.
                   DESC

  spec.homepage     = "https://github.com/NutsNet/HeapSdk"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Christophe Vichery" => "vichery.christophe@gmail.com" }

  spec.ios.deployment_target = "14.0"
  spec.swift_version = "5.0"

  spec.source       = { :git => "https://github.com/NutsNet/HeapSdk.git", :tag => "#{spec.version}" }
  spec.source_files  = "HeapSdk/**/*.{h,m,swift}"

  spec.dependency 'Alamofire'

end

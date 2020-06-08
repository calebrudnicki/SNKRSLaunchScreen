Pod::Spec.new do |spec|

  spec.name         = "SNKRSLaunchScreen"
  spec.version      = "1.0.0"
  spec.summary      = "A SNKRS style launch screen animation"
  spec.description  = "This is a small framework to create an animation similar to the SNKRS iOS application."
  spec.homepage     = "https://github.com/calebrudnicki/SNKRSLaunchScreen"
  spec.license      = "MIT"
  spec.author       = { "Caleb Rudnicki" => "calebrudnicki@gmail.com" }
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/calebrudnicki/SNKRSLaunchScreen.git", :tag => "#{spec.version}" }
  spec.source_files  = "SNKRSLaunchScreen/**/*.{h,swift}"
  spec.swift_version   = "5.0"
  
 end
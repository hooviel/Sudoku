#
#  Be sure to run `pod spec lint Sudoku.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "Sudoku"
  s.version      = "0.0.1"
  s.summary      = "数独算法实体类"
  s.description  = <<-DESC
  数独算法实体类
                   DESC
  s.homepage     = "https://github.com/hooviel/Sudoku"
  s.license      = "MIT"
  s.author             = { "David" => "hooviel@qq.com" }
  s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.7"
  s.source       = { :git => "https://github.com/hooviel/Sudoku.git", :tag => s.version }
  s.source_files  = "*.{h,m}"
  s.requires_arc = true
  
end

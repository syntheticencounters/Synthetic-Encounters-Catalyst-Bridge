require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "CatalystBridge"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  catalyst-bridge
                   DESC
  s.homepage     = "https://github.com/syntheticencounters/Synthetic-Encounters-Catalyst-Bridge"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.authors      = { "Mike Carpenter" => "syntheticencounters@gmail.com" }
  s.platforms    = { :ios => "13.0", :tvos => "13.0" }
  s.source       = { :git => "https://github.com/syntheticencounters/Synthetic-Encounters-Catalyst-Bridge.git" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
end

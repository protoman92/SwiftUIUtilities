Pod::Spec.new do |s|

    s.platform = :ios
    s.ios.deployment_target = '8.0'
    s.name = "SwiftUIUtilitiesTests"
    s.summary = "Common Swift UIKit test utilities."
    s.requires_arc = true
    s.version = "1.6.0"
    s.license = { :type => "Apache-2.0", :file => "LICENSE" }
    s.author = { "Hai Pham" => "swiften.svc@gmail.com" }
    s.homepage = "https://github.com/protoman92/SwiftUIUtilities.git"
    s.source = { :git => "https://github.com/protoman92/SwiftUIUtilities.git", :tag => "#{s.version}"}
    s.framework = "UIKit"
    s.dependency 'SwiftUtilities/Main'
    s.dependency 'SwiftUtilitiesTests/Main'

    s.subspec 'Main' do |main|
        main.source_files = "SwiftUIUtilitiesTests/util/**/*.{swift}"
    end

end

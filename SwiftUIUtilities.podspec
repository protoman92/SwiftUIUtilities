Pod::Spec.new do |s|

    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.name = "SwiftUIUtilities"
    s.summary = "Common Swift UIKit utilities."
    s.requires_arc = true
    s.version = "1.3.3"
    s.license = { :type => "Apache-2.0", :file => "LICENSE" }
    s.author = { "Hai Pham" => "swiften.svc@gmail.com" }
    s.homepage = "https://github.com/protoman92/SwiftUIUtilities.git"
    s.source = { :git => "https://github.com/protoman92/SwiftUIUtilities.git", :tag => "#{s.version}"}
    s.framework = "UIKit"
    s.dependency 'SwiftUtilities/Main'

    s.subspec 'Main' do |main|
        main.source_files = "SwiftUIUtilities/**/*.{swift}"
    end

end

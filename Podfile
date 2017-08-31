# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def allPods
    pod 'SwiftUtilities/Main', git: 'https://github.com/protoman92/SwiftUtilities.git'
    pod 'RxDataSources', '~> 1.0'
end

target 'SwiftUIUtilities' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SwiftUIUtilities
  allPods

  target 'SwiftUIUtilitiesTests' do
    inherit! :search_paths
    # Pods for testing
    allPods
    pod 'SwiftUtilitiesTests/Main’
    
  end

end

# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

target 'RescateK9' do
  # Comment the next line if you don't want to use dynamic frameworks

  # Pods for RescateK9
  pod 'Firebase/Auth'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Storage'
  
  pod 'Kingfisher'

  target 'RescateK9Tests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RescateK9UITests' do
    # Pods for testing
  end

  post_install do |pi|
      pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
  end
end

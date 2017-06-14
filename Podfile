# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'investHR' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for investHR

	#pod 'Google/SignIn'
	pod 'Firebase/Auth'
	pod 'Firebase'
	pod 'FirebaseMessaging'
	pod 'Auth0', '~> 1.0'
	pod 'SimpleKeychain', '~> 0.7'

	#pod 'FacebookLogin'
	#pod 'LinkedinSwift', '~> 1.6.6'
	#pod 'FBSDKShareKit'



post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0.2'
        end
    end
end

  target 'investHRTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'investHRUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

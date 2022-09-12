# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'MyFreedom' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Code Style
  pod 'SwiftLint', '0.41.0'
  pod 'InputMask', '6.0.0'
  # liveness
  pod 'OZLivenessSDK', :git => 'https://gitlab.com/oz-forensics/oz-liveness-ios.git', :branch => 'develop'
  # Debug
  pod 'FLEX', :configurations => ['Debug']
  
  # Analytics & utilities
#  pod 'FBSDKCoreKit', '~> 6.5.2'
  pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '7.13.0'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'YandexMobileMetrica', '~> 3.14.0'
  pod 'AppsFlyerFramework'
  # firebase
  pod 'Firebase/Messaging'
  pod 'Firebase/Core'
  pod 'Firebase/Performance'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end

end

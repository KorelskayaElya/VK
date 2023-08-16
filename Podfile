platform :ios, '11.0'

target 'VK' do
  use_frameworks!

  pod 'Firebase/Core'
  pod 'Firebase/Storage'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'SwiftyCam'

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end


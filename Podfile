# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GitHubStatistic' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Workaround for issue regarding Xcode no longer supporting iOS 8
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end

  # Pods for GitHubStatistic
  pod 'RxSwift', '6.1.0'
  pod 'RxCocoa', '6.1.0'
  pod 'RxSwiftExt', '~> 6'
  pod 'RxRealm'
  pod 'RxAlamofire'
  pod 'RxGesture'
  pod 'Swinject', '~> 2.7.1'
  pod 'Kingfisher', '~> 6.0'
  pod 'BetterSegmentedControl', '~> 2.0'
  pod 'SwinjectStoryboard', :git => 'https://github.com/Swinject/SwinjectStoryboard.git', :commit => '0ca45c83a8aa398c153d8a036c95abb4343cfa0c'

  target 'GitHubStatisticTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '6.1.0'
    pod 'RxTest', '6.1.0'

  end

  target 'GitHubStatisticUITests' do
    # Pods for testing
  end

end


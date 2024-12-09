# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

install! 'cocoapods', warn_for_unused_master_specs_repo: false

use_frameworks!
inhibit_all_warnings!

def rx
  pod 'RxSwift', '~> 6'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxOptional'
end

def generation
  pod 'R.swift'
end

def parse
  pod 'ObjectMapper'
end

def apiTools
  pod 'Action'
end

def network
  pod 'Alamofire', '~> 5.9.1'
  pod 'SDWebImage'
end

def testing
  pod 'Quick', '~> 5.0.1'
  pod 'Nimble'
end

workspace 'GitHubUser.xcworkspace'

target 'GitHubUser' do
  rx
  generation
  parse
  apiTools
  network
  
  target 'GitHubUserTests' do
    inherit! :search_paths
    testing
  end

  target 'GitHubUserUITests' do
  end

end

abstract_target 'AppFeatures' do
  target :'UserProfile' do
    project 'AppFeatures/UserProfile/UserProfile.xcodeproj'
    rx
    generation
    parse
    apiTools
    network
  end
end

abstract_target 'Libraries' do
  target :'Common' do
    project 'Libraries/Common/Common.xcodeproj'
    rx
    generation
    apiTools
  end
  
  target :'ApiClient' do
    project 'Libraries/ApiClient/ApiClient.xcodeproj'
    rx
    network
    parse
  end
  
  target :'DesignSystem' do
    project 'Libraries/DesignSystem/DesignSystem.xcodeproj'
  end
  
  target :'Localize' do
    project 'Libraries/Localize/Localize.xcodeproj'
    generation
  end
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

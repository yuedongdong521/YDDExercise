platform :ios, '9.0'

inhibit_all_warnings!

target 'YDDExercise' do
 pod 'Masonry', '~>1.1.0'
 pod 'TOCropViewController', '~>2.5.1'
 pod 'TZImagePickerController', '~>3.2.1'
 pod 'YYCategories', '~>1.0.4'
 pod 'YYImage', '~>1.0.4'
 pod 'YYWebImage', '~>1.0.5'
 pod 'YYCache', '~>1.0.4'
 pod 'YYModel', '~>1.0.4'
 pod 'MJRefresh', '~>3.2.0'
 pod 'OpenUDID', '~>1.0.0'
 pod 'MBProgressHUD', '~>1.1.0'
 pod 'SDCycleScrollView', '~>1.80'
 pod 'NJKWebViewProgress', '~>0.2.3'
 pod 'FDFullscreenPopGesture'
 pod 'KTVHTTPCache', '~> 1.0.0'
end

post_install do |installer|
  pods_target = installer.aggregate_targets.detect do |target|
    # Target label is either `Pods` or `Pods-#{name_of_your_main_target}` based on how complex your dependency graph is.
    target.label == "Pods"
  end

  puts '+ Removing framework dependencies'

  pods_target.xcconfigs.each_pair do |config_name, config|
    next if config_name == 'Test'
    config.other_linker_flags[:frameworks] = Set.new
    config.attributes['OTHER_LDFLAGS[arch=armv7]'] = '$(inherited) -filelist "$(OBJROOT)/Pods.build/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)-armv7.objects.filelist"'
    config.attributes['OTHER_LDFLAGS[arch=arm64]'] = '$(inherited) -filelist "$(OBJROOT)/Pods.build/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)-arm64.objects.filelist"'
    config.attributes['OTHER_LDFLAGS[arch=i386]'] = '$(inherited) -filelist "$(OBJROOT)/Pods.build/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)-i386.objects.filelist"'
    config.attributes['OTHER_LDFLAGS[arch=x86_64]'] = '$(inherited) -filelist "$(OBJROOT)/Pods.build/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)-x86_64.objects.filelist"'
    config.save_as(Pathname.new("#{pods_target.support_files_dir}/#{pods_target.label}.#{config_name}.xcconfig"))
  end

end

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Appeel' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  platform :ios, '12.1'

  # Pods for Appeel
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'FirebaseUI/Storage'
  pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
  pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git'
  pod 'Kingfisher'
  pod 'Clarifai'
  pod 'Cosmos'

end

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-Appeel/Pods-Appeel-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end

require 'xcodeproj'

project_name = 'AuraHabit'
project_path = "#{project_name}.xcodeproj"

# 1. Create the project
project = Xcodeproj::Project.new(project_path)

# 2. Add the main app target
target = project.new_target(:application, project_name, :ios, '17.0')

# 3. Create a group for Sources
sources_group = project.main_group.new_group('Sources', 'Sources')

# 4. Find all .swift files recursively in Sources/
Dir.glob('Sources/**/*.swift').each do |file_path|
  # Add file reference to the group
  file_ref = sources_group.new_reference(file_path.sub('Sources/', ''))
  # Add file to the target's compile sources phase
  target.source_build_phase.add_file_reference(file_ref)
end

# 4.5. Add Localization (Localizable.strings)
variant_group = sources_group.new_variant_group('Localizable.strings')
variant_group.new_reference('en.lproj/Localizable.strings')
variant_group.new_reference('ko.lproj/Localizable.strings')
target.resources_build_phase.add_file_reference(variant_group)

# 4.6. Add Asset Catalog (Assets.xcassets)
assets_ref = sources_group.new_reference('Assets.xcassets')
assets_ref.last_known_file_type = 'folder.assetcatalog'
target.resources_build_phase.add_file_reference(assets_ref)

# 5. Set up Build Settings for the App Target
target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = "com.air.#{project_name}"
  config.build_settings['GENERATE_INFOPLIST_FILE'] = 'YES'
  config.build_settings['INFOPLIST_KEY_UIApplicationSceneManifest_Generation'] = 'YES'
  config.build_settings['INFOPLIST_KEY_UILaunchScreen_Generation'] = 'YES'
  config.build_settings['INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone'] = 'UIInterfaceOrientationPortrait'
  config.build_settings['INFOPLIST_KEY_ITSAppUsesNonExemptEncryption'] = 'NO'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['TARGETED_DEVICE_FAMILY'] = '1' # iPhone
  config.build_settings['DEVELOPMENT_TEAM'] = '' # Needs to be set in Xcode
  config.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = 'AppIcon'
  config.build_settings['MARKETING_VERSION'] = '1.0.0'
  config.build_settings['CURRENT_PROJECT_VERSION'] = '1'
end

# 6. Save the project
project.save
puts "Xcode project generated at #{project_path}"

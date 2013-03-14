# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

FACEBOOK_APP_ID = "174855642662212"

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'HelloFacebook'

  # Configuration for Facebook SDK
  app.vendor_project(File.expand_path('~/Documents/FacebookSDK/FacebookSDK.framework'),
    :static,
    :products    => %w{FacebookSDK},
    :headers_dir => 'Headers')
  app.resources_dirs << File.expand_path('~/Documents/FacebookSDK/FacebookSDK.framework/Resources')
  app.frameworks += %w{AdSupport Accounts Social}
  app.libs << '/usr/lib/libsqlite3.dylib'
  app.info_plist['FacebookAppID'] = FACEBOOK_APP_ID
  app.info_plist['CFBundleURLTypes'] = [{'CFBundleURLSchemes' => ["fb#{FACEBOOK_APP_ID}"]}]
end

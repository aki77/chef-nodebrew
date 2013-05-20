#
# Cookbook Name:: nodebrew
# Recipe:: user
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nodebrew::user_install"

Array(node['nodebrew']['user_installs']).each do |nodebrew_user|
  versions = nodebrew_user['versions'] || node['nodebrew']['user_versions']
  npm_hash = nodebrew_user['npms'] || node['nodebrew']['user_npms']

  versions.each do |version|
    nodebrew_nodejs "#{version} (#{nodebrew_user['user']})" do
      definition  version
      user        nodebrew_user['user']
    end
  end

  nodebrew_use "#{nodebrew_user['use']} (#{nodebrew_user['user']})" do
    nodebrew_version nodebrew_user['use']
    user             nodebrew_user['user']
    only_if          { nodebrew_user['use'] }
  end

  npm_hash.each do |nodejs, npms|
    Array(npms).each do |npm|
      nodebrew_npm_package "#{npm['name']} (#{nodebrew_user['user']})" do
        package_name npm['name']
        user         nodebrew_user['user']
        nodejs       nodejs

        %w{version action}.each do |attr|
          send(attr, npm[attr]) if npm[attr]
        end
      end
    end
  end
end

#
# Cookbook Name:: nodebrew
# Recipe:: user_install
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/etc/profile.d/nodebrew.sh" do
  source  "nodebrew.sh.erb"
  owner   "root"
  mode    "0755"
  only_if {node['nodebrew']['create_profiled']}
end

Array(node['nodebrew']['user_installs']).each do |nb_user|
  home_dir = Etc.getpwnam(nb_user['user']).dir
  checkout_dir = "#{Chef::Config['file_cache_path']}/nodebrew"

  git checkout_dir do
    repository  node['nodebrew']['git_url']
    reference   node['nodebrew']['git_ref']
    action      :checkout
    not_if { File.exists?("#{home_dir}/.nodebrew") }
  end

  execute "perl nodebrew setup" do
    cwd checkout_dir
    user nb_user['user']
    group nb_user['user']
    environment ({'HOME' => home_dir})
    not_if { File.exists?("#{home_dir}/.nodebrew") }
  end
end

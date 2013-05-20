#
# Cookbook Name:: nodebrew
# Provider:: nodejs
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include Chef::Nodebrew::ScriptHelpers

def load_current_resource
  @version     = new_resource.definition
  @user        = new_resource.user
end

action :install do
  perform_install
end

action :reinstall do
  perform_install
end

private

def perform_install
  if node_installed?
    Chef::Log.debug("#{new_resource} is already installed - nothing to do")
  else
    install_start = Time.now

    Chef::Log.info("Building #{new_resource}, this could take a while...")

    version = @version
    nodebrew = ::File.join(nodebrew_root, "nodebrew")
    execute "nodebrew[#{version}]" do
      command     "#{nodebrew} install #{version}"
      user        new_resource.user         if new_resource.user
      group       new_resource.group        if new_resource.group
      environment({ 'HOME' => user_home })

      action    :nothing
    end.run_action(:run)

    Chef::Log.debug("#{new_resource} build time was " +
      "#{(Time.now - install_start)/60.0} minutes")

    new_resource.updated_by_last_action(true)
  end
end

def node_installed?
  if Array(new_resource.action).include?(:reinstall)
    false
  else
    ::File.directory?(::File.join(nodebrew_root, 'node', @version))
  end
end

# -*- coding: utf-8 -*-
# Cookbook Name:: nodebrew
# Provider:: npm_package
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

require 'chef/mixin/shell_out'
include Chef::Nodebrew::ScriptHelpers
include Chef::Mixin::ShellOut

def load_current_resource
  node_binary = ::File.join(nodebrew_root, "node",  new_resource.nodejs, "bin", "node")
  npm_binary = ::File.join(nodebrew_root, "node",  new_resource.nodejs, "bin", "npm")
  @npm_command = "#{node_binary} #{npm_binary}"
end

action :install do
  if package_installed?
    Chef::Log.info "Not installing #{new_resource.package_name} already up to date"
  else
    Chef::Log.info "Installing #{new_resource.package_name}"
    url = new_resource.package_name
    url += "@\"#{new_resource.version}\"" if new_resource.version
    npm_command = @npm_command
    execute "npm-install-global" do
      command "#{npm_command} -g install #{url}"
      user        new_resource.user        if new_resource.user
      group       new_resource.group       if new_resource.group
      environment({ 'HOME' => user_home })
    end
  end
end

action :uninstall do
  npm_binary = @npm_command
  execute "npm-install-global" do
    command "#{npm_command} uninstall -g #{new_resource.package_name}"
    user        new_resource.user        if new_resource.user
    group       new_resource.group       if new_resource.group
    environment({ 'HOME' => user_home })
  end
end

private

def grep_for_version(stdout, package)
  v = nil
  stdout.force_encoding('utf-8')
  line = stdout.lines.grep(/^[^a-z]{4}#{package}\@/iu)[0]
  v = line.split(/\@/)[1].strip if line
  v
end

def package_installed?
  package_list_command = "#{@npm_command} -g list #{new_resource.package_name}"
  cmd = shell_out!(package_list_command)
  installed_version = grep_for_version(cmd.stdout, new_resource.package_name)

  if installed_version.nil? || (new_resource.version && installed_version != new_resource.version)
    false
  else
    outdated_command = "#{@npm_command} -g outdated #{new_resource.package_name}"
    cmd = shell_out!(outdated_command)
    !cmd.stdout.include?("current=")
  end
end

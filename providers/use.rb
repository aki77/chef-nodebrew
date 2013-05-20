#
# Cookbook Name:: nodebrew
# Provider:: use
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include Chef::Nodebrew::ScriptHelpers

action :create do
  if current_use_version != new_resource.nodebrew_version
    command = %{./nodebrew use #{new_resource.nodebrew_version}}

    execute "#{command} #{which_nodebrew}" do
      command     command
      cwd         nodebrew_root
      user        new_resource.user         if new_resource.user
      group       new_resource.group        if new_resource.group
      environment({ 'HOME' => user_home })

      action    :nothing
    end.run_action(:run)

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug("#{new_resource} is already set - nothing to do")
  end
end

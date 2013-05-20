#
# Cookbook Name:: nodebrew
# Library:: Chef::Nodebrew::ScriptHelpers
#

require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

class Chef
  module Nodebrew
    module ScriptHelpers
      def nodebrew_root
        ::File.join(user_home, '.nodebrew')
      end

      def user_home
        return nil unless new_resource.user

        Etc.getpwnam(new_resource.user).dir
      end

      def which_nodebrew
        "(#{new_resource.user || 'system'})"
      end

      def current_use_version
        nodebrew = ::File.join(nodebrew_root, 'nodebrew')
        cmd = shell_out!(nodebrew, "list", :user => new_resource.user, :env => { 'HOME' => user_home })
        cmd.stdout.lines.grep(/current/)[0].split(' ')[1]
      end
    end
  end
end

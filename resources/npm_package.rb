#
# Cookbook Name:: nodebrew
# Resource:: npm_package
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

actions :install, :uninstall

# Name of the nrpe check, used for the filename and the command name
attribute :package_name, :kind_of => String, :name_attribute => true
attribute :nodejs, :kind_of => String, :required => true
attribute :version, :kind_of => String, :required => false
attribute :url, :kind_of => String, :required => false
attribute :user, :kind_of => String
attribute :group, :kind_of => String

def initialize(*args)
  super
  @action = :install
end

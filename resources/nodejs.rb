#
# Cookbook Name:: nodebrew
# Resource:: nodejs
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

actions :install, :reinstall

attribute :definition,  :kind_of => String, :name_attribute => true
attribute :user,        :kind_of => String
attribute :group,       :kind_of => String

def initialize(*args)
  super
  @action = :install
  @node_version = @definition
end

def to_s
  "#{super} (#{@user || 'system'})"
end

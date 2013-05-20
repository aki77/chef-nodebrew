#
# Cookbook Name:: nodebrew
# Resource:: use
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

actions :create

attribute :nodebrew_version, :kind_of => String, :name_attribute => true
attribute :user,             :kind_of => String
attribute :group,            :kind_of => String

def initialize(*args)
  super
  @action = :create
end

def to_s
  "#{super} (#{@user || 'system'})"
end

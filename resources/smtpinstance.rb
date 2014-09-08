#
# Author:: Matt Stratton
# Cookbook Name:: iis_smtp
# Resource:: smtpinstance
#
# Copyright (C) 2014 Matt Stratton
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

actions :add

attribute :domain, :kind_of => String, :name_attribute => true
attribute :maxmessagesize, :kind_of => Integer, :default => 0
attribute :maxrecipients, :kind_of => Integer
attribute :logfiledirectory, :kind_of => String
attribute :smarthost, :kind_of => String
attr_accessor :exists, :running

def initialize(*args)
  super
  @action = :add
end

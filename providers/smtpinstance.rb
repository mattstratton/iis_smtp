#
# Author:: Matt Stratton
# Cookbook Name:: iis_smtp
# Provider:: smtpinstance
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
require 'chef/mixin/shell_out'

include Chef::Mixin::ShellOut
include Windows::Helper

action :add do
  unless @current_resource.exists
  	powershell_script "Creating smtp instance: #{ new_resource.name }" do
	code <<-EOH
		$smtpDomains = [wmiclass]'root\\MicrosoftIISv2:IIsSmtpDomain'
	    $newSMTPDomain = $smtpDomains.CreateInstance()
	    $newSMTPDomain.Name = "SmtpSvc/1/Domain/#{ new_resource.domain }"
	    $newSMTPDomain.Put()  | Out-Null

	    $SMTPServer = Get-WmiObject IISSmtpServer -namespace "ROOT\\MicrosoftIISv2" | Where-Object { $_.name -like "SmtpSVC/1" }

	    $virtualSMTPServer = Get-WmiObject IISSmtpServerSetting -namespace "ROOT\\MicrosoftIISv2" | Where-Object { $_.name -like "SmtpSVC/1" }
	    # Set maximum message size (in bytes)
		$virtualSMTPServer.MaxMessageSize = (#{new_resource.maxmessagesize} * 1024)

		# Disable session size limit
		$virtualSMTPServer.MaxSessionSize = 0

		# Set maximum number of recipients
		$virtualSMTPServer.MaxRecipients = #{ new_resource.maxrecipients}

		# Set maximum messages per connection
		$virtualSMTPServer.MaxBatchedMessages = 0

		#Enable logging
		$virtualSMTPServer.LogType = 1
		$virtualSMTPServer.LogFileDirectory = '#{new_resource.logfiledirectory}'

		# Set smarthost

		$virtualSMTPServer.SmartHost = '#{ new_resource.smarthost}'
		$virtualSMTPServer.Put() | Out-Null

    EOH
  end

  	Chef::Log.debug(cmd)
    shell_out!(cmd)
    Chef::Log.info('App created')
  else
    Chef::Log.debug("#{@new_resource} app already exists - nothing to do")
  end
end

require 'spec_helper'

describe windows_feature('Smtpsvc-Service-Update-Name') do
    it{ should be_installed }
end
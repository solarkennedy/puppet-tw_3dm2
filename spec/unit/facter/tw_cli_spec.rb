require 'spec_helper'

describe 'tw_cli fact', :type => :fact  do

  it "should find the tw_cli binary on linux when it exists" do
    Facter.fact(:kernel).stubs(:value).returns('Linux')
    Facter::Util::Resolution.stubs(:which).with('tw_cli').returns('/usr/sbin/tw_cli')
    Facter::Util::Resolution.stubs(:which).with('/usr/sbin/tw_cli').returns('/usr/sbin/tw_cli')
    Facter.fact(:tw_cli).value.should == '/usr/sbin/tw_cli'
  end

  it "should not find the tw_cli binary on linux when it doesnt exist" do
    Facter.fact(:kernel).stubs(:value).returns('Linux')
    Facter::Util::Resolution.stubs(:which).with('tw_cli').returns(nil)
    Facter.value('tw_cli').should == nil
  end

  it "When not Linux, the fact should not exist" do
    Facter.fact(:kernel).stubs(:value).returns('Solaris')
    Facter.value('tw_cli').should == nil
  end

end

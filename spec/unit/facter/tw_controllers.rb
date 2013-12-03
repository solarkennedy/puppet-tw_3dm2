require 'spec_helper'

describe 'tw_controllers fact' do

  it "should be able to read a single controller" do
    Facter.fact(:tw_cli).stubs(:value).returns '/usr/sbin/tw_cli'
    Facter::Util::Resolution.stubs(:exec).with('/usr/sbin/tw_cli show')
.returns(<<EOS)

Ctl   Model        (V)Ports  Drives   Units   NotOpt  RRate   VRate  BBU
------------------------------------------------------------------------
c8    9690SA-8I    8         8        1       0       1       1      OK       

EOS
    Facter.fact(:tw_controllers).value.should == 'c8'
  end

  it "should be able to interpret controllers with enclosures" do
    Facter::Util::Resolution.stubs(:exec).with('/usr/sbin/tw_cli show').returns(<<EOS)

Ctl   Model        (V)Ports  Drives   Units   NotOpt  RRate   VRate  BBU
------------------------------------------------------------------------
c6    9750-8i      12        12       1       0       1       1      OK       

Enclosure     Slots  Drives  Fans  TSUnits  PSUnits  Alarms   
--------------------------------------------------------------
/c6/e0        12     12      3     1        2        1        

EOS
    Facter.fact(:tw_controllers).value.should == 'c6'
  end

# example output 1:
#
# # tw_cli show version
# CLI Version = 2.00.11.020
# API Version = 2.08.00.023
#
# # tw_cli show
#
# Ctl   Model        (V)Ports  Drives   Units   NotOpt  RRate   VRate  BBU
# ------------------------------------------------------------------------
# c8    9690SA-8I    8         8        1       0       1       1      OK       
#

# example output 2:
#
# # tw_cli show version
# CLI Version = 2.00.11.016
# API Version = 2.08.00.017
# 
# # tw_cli show
# 
# Ctl   Model        (V)Ports  Drives   Units   NotOpt  RRate   VRate  BBU
# ------------------------------------------------------------------------
# c0    9750-8i      7         7        3       0       1       1      OK       
# 

# example output 3:
#
# # tw_cli show version
# CLI Version = 2.00.11.016
# API Version = 2.08.00.017
# 
# # tw_cli show
# 
# Ctl   Model        (V)Ports  Drives   Units   NotOpt  RRate   VRate  BBU
# ------------------------------------------------------------------------
# c0    9650SE-8LPML 8         8        3       0       1       1      OK       
# 

# example output 4:
#
# # tw_cli show version
# CLI Version = 2.00.06.007
# API Version = 2.03.00.006
# CLI Compatible Range = [2.00.00.001 to 2.00.06.007]
#
# # tw_cli show
#
# Ctl   Model        Ports   Drives   Units   NotOpt   RRate   VRate   BBU
# ------------------------------------------------------------------------
# c2    7506-8       8       8        2       0        3       -       -        
# c3    7506-8       8       8        2       0        3       -       -        
#

# example of no controllers being present
#
# # tw_cli show version
# CLI Version = 2.00.11.016
# API Version = 2.08.00.017
# 
# # tw_cli show
# 
# No controller found.
# Make sure appropriate LSI/3ware device driver(s) are loaded.
# 
# # echo $?
# 0


  describe 'tw_cli fact missing' do
    Facter.fact(:tw_cli).value.should == nil
    Facter.fact(:tw_controllers).value.should == nil
  end

end

# Clock input
set_property PACKAGE_PIN Y9 [get_ports {GCLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {GCLK}]
create_clock -period 10 [get_ports {GCLK}]

# Switches (SW7-SW0)
## User DIP Switches - Bank 35
set_property PACKAGE_PIN F22 [get_ports {SW[0]}];  # "SW0"
set_property PACKAGE_PIN G22 [get_ports {SW[1]}];  # "SW1"
set_property PACKAGE_PIN H22 [get_ports {SW[2]}];  # "SW2"
set_property PACKAGE_PIN F21 [get_ports {SW[3]}];  # "SW3"
set_property PACKAGE_PIN H19 [get_ports {SW[4]}];  # "SW4"
set_property PACKAGE_PIN H18 [get_ports {SW[5]}];  # "SW5"
set_property PACKAGE_PIN H17 [get_ports {SW[6]}];  # "SW6"
set_property PACKAGE_PIN M15 [get_ports {SW[7]}];  # "SW7"
set_property IOSTANDARD LVCMOS33 [get_ports {SW[*]}]

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ---------------------------------------------------------------------------- 

set_property PACKAGE_PIN R16 [get_ports {BTND}];  # "BTND"
set_property PACKAGE_PIN N15 [get_ports {BTNL}];  # "BTNL"
set_property PACKAGE_PIN R18 [get_ports {BTNR}];  # "BTNR"
set_property PACKAGE_PIN T18 [get_ports {BTNU}];  # "BTNU"

set_property IOSTANDARD LVCMOS33 [get_ports {BTNU}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTND}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTNL}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTNR}]

# LED
set_property PACKAGE_PIN T22 [get_ports {LD0}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD0}]

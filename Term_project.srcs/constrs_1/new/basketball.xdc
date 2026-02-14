
## ===== Clock & Reset =====
set_property -dict { PACKAGE_PIN R4 IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -name clk -period 10.0 [get_ports clk]
set_property -dict { PACKAGE_PIN U7 IOSTANDARD LVCMOS33 } [get_ports rst_n]

## [NEW] Directional Buttons (Tact Switches)
# Center (Shoot) - SW_TACT_0
set_property -dict { PACKAGE_PIN M21 IOSTANDARD LVCMOS33 } [get_ports btn_shoot]

# Up (Increase Y) - SW_TACT_1
set_property -dict { PACKAGE_PIN M20 IOSTANDARD LVCMOS33 } [get_ports btn_up]

# Left (Decrease X) - SW_TACT_2
set_property -dict { PACKAGE_PIN N20 IOSTANDARD LVCMOS33 } [get_ports btn_right]

# Right (Increase X) - SW_TACT_3
set_property -dict { PACKAGE_PIN M22 IOSTANDARD LVCMOS33 } [get_ports btn_left]

# Down (Decrease Y) - SW_TACT_4
set_property -dict { PACKAGE_PIN N22 IOSTANDARD LVCMOS33 } [get_ports btn_down]


## VGA Connector (4-bit RGB + HSYNC + VSYNC)
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports {vgaRed[0]}]
set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports {vgaRed[1]}]
set_property -dict { PACKAGE_PIN H18 IOSTANDARD LVCMOS33 } [get_ports {vgaRed[2]}]
set_property -dict { PACKAGE_PIN G18 IOSTANDARD LVCMOS33 } [get_ports {vgaRed[3]}]

set_property -dict { PACKAGE_PIN J19 IOSTANDARD LVCMOS33 } [get_ports {vgaGreen[0]}]
set_property -dict { PACKAGE_PIN H19 IOSTANDARD LVCMOS33 } [get_ports {vgaGreen[1]}]
set_property -dict { PACKAGE_PIN H20 IOSTANDARD LVCMOS33 } [get_ports {vgaGreen[2]}]
set_property -dict { PACKAGE_PIN G20 IOSTANDARD LVCMOS33 } [get_ports {vgaGreen[3]}]

set_property -dict { PACKAGE_PIN J20 IOSTANDARD LVCMOS33 } [get_ports {vgaBlue[0]}]
set_property -dict { PACKAGE_PIN J21 IOSTANDARD LVCMOS33 } [get_ports {vgaBlue[1]}]
set_property -dict { PACKAGE_PIN H22 IOSTANDARD LVCMOS33 } [get_ports {vgaBlue[2]}]
set_property -dict { PACKAGE_PIN J22 IOSTANDARD LVCMOS33 } [get_ports {vgaBlue[3]}]

set_property -dict { PACKAGE_PIN K22 IOSTANDARD LVCMOS33 } [get_ports hsync]
set_property -dict { PACKAGE_PIN K21 IOSTANDARD LVCMOS33 } [get_ports vsync]

## ===== FND (7-Segment + Digit Select) =====
set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports {an[7]}]
set_property -dict { PACKAGE_PIN R14 IOSTANDARD LVCMOS33 } [get_ports {an[6]}]
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports {an[5]}]
set_property -dict { PACKAGE_PIN P16 IOSTANDARD LVCMOS33 } [get_ports {an[4]}]
set_property -dict { PACKAGE_PIN R16 IOSTANDARD LVCMOS33 } [get_ports {an[3]}]
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports {an[2]}]
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports {an[1]}]
set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [get_ports {an[0]}]

set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports {seg[7]}]
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports {seg[6]}]
set_property -dict { PACKAGE_PIN W17 IOSTANDARD LVCMOS33 } [get_ports {seg[5]}]
set_property -dict { PACKAGE_PIN R18 IOSTANDARD LVCMOS33 } [get_ports {seg[4]}]
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports {seg[3]}]
set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports {seg[2]}]
set_property -dict { PACKAGE_PIN V18 IOSTANDARD LVCMOS33 } [get_ports {seg[1]}]
set_property -dict { PACKAGE_PIN P19 IOSTANDARD LVCMOS33 } [get_ports {seg[0]}]

## 4-bit Input A
set_property -dict { PACKAGE_PIN J15  IOSTANDARD LVCMOS33 } [get_ports { A[0] }];
set_property -dict { PACKAGE_PIN L16  IOSTANDARD LVCMOS33 } [get_ports { A[1] }];
set_property -dict { PACKAGE_PIN H13  IOSTANDARD LVCMOS33 } [get_ports { A[2] }];
set_property -dict { PACKAGE_PIN N15  IOSTANDARD LVCMOS33 } [get_ports { A[3] }];

## 4-bit Input B
set_property -dict { PACKAGE_PIN R16  IOSTANDARD LVCMOS33 } [get_ports { B[0] }];
set_property -dict { PACKAGE_PIN N16  IOSTANDARD LVCMOS33 } [get_ports { B[1] }];
set_property -dict { PACKAGE_PIN P15  IOSTANDARD LVCMOS33 } [get_ports { B[2] }];
set_property -dict { PACKAGE_PIN W13  IOSTANDARD LVCMOS33 } [get_ports { B[3] }];

## Carry-in (Cin)
set_property -dict { PACKAGE_PIN T16  IOSTANDARD LVCMOS33 } [get_ports { Cin }];

## 4-bit Sum output (to LEDs)
set_property -dict { PACKAGE_PIN G14  IOSTANDARD LVCMOS33 } [get_ports { Sum[0] }];
set_property -dict { PACKAGE_PIN P14  IOSTANDARD LVCMOS33 } [get_ports { Sum[1] }];
set_property -dict { PACKAGE_PIN E18  IOSTANDARD LVCMOS33 } [get_ports { Sum[2] }];
set_property -dict { PACKAGE_PIN K16  IOSTANDARD LVCMOS33 } [get_ports { Sum[3] }];

## Carry-out (Cout) to LED
set_property -dict { PACKAGE_PIN T15  IOSTANDARD LVCMOS33 } [get_ports { Cout }];
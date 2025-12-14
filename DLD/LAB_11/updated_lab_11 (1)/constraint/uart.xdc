## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}];

## Reset Button (using CPU reset button)
set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33 } [get_ports { reset_n }]; #IO_L3P_T0_DQS_AD1P_15 Sch=cpu_resetn

## Switches for control
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { baud_sel[0] }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { baud_sel[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1]
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { tx_en }]; #IO_L6N_T0_D08_VREF_14 Sch=sw[2]

## Switches for data input (using first 8 switches)
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { tx_data[0] }]; #IO_L13N_T2_MRCC_14 Sch=sw[3]
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { tx_data[1] }]; #IO_L12N_T1_MRCC_14 Sch=sw[4]
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { tx_data[2] }]; #IO_L7N_T1_D10_14 Sch=sw[5]
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { tx_data[3] }]; #IO_L17N_T2_A13_D29_14 Sch=sw[6]
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { tx_data[4] }]; #IO_L5N_T0_D07_14 Sch=sw[7]
set_property -dict { PACKAGE_PIN T8    IOSTANDARD LVCMOS18 } [get_ports { tx_data[5] }]; #IO_L24N_T3_34 Sch=sw[8]
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS18 } [get_ports { tx_data[6] }]; #IO_25_34 Sch=sw[9]
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { tx_data[7] }]; #IO_L15P_T2_DQS_RDWR_B_14 Sch=sw[10]

## Status LEDs (including rx_busy which was missing)
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { tx_ready }]; #IO_L18P_T2_A24_15 Sch=led[0]
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { tx_busy }]; #IO_L24P_T3_RS1_15 Sch=led[1]
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { rx_busy }]; #IO_L17N_T2_A25_15 Sch=led[2]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { rx_valid }]; #IO_L22P_T3_A05_D21_14 Sch=led[10]

## Received data LEDs (shifted assignments since rx_busy takes led[2])
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { rx_data[0] }]; #IO_L8P_T1_D11_14 Sch=led[3]
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { rx_data[1] }]; #IO_L7P_T1_D09_14 Sch=led[4]
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { rx_data[2] }]; #IO_L18N_T2_A11_D27_14 Sch=led[5]
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { rx_data[3] }]; #IO_L17P_T2_A14_D30_14 Sch=led[6]
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { rx_data[4] }]; #IO_L18P_T2_A12_D28_14 Sch=led[7]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { rx_data[5] }]; #IO_L16N_T2_A15_D31_14 Sch=led[8]
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { rx_data[6] }]; #IO_L14N_T2_SRCC_14 Sch=led[9]
set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { rx_data[7] }]; #IO_L15N_T2_DQS_DOUT_CSO_B_14 Sch=led[11]

## UART Interface (using USB-UART port)
set_property -dict { PACKAGE_PIN C4    IOSTANDARD LVCMOS33 } [get_ports { Rx }]; #IO_L7P_T1_AD6P_35 Sch=uart_txd_in
set_property -dict { PACKAGE_PIN D4    IOSTANDARD LVCMOS33 } [get_ports { Tx }]; #IO_L11N_T1_SRCC_35 Sch=uart_rxd_out

## Timing Constraints
set_input_delay -clock [get_clocks sys_clk_pin] -max 2 [get_ports {Rx baud_sel[*] tx_en tx_data[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -max 2 [get_ports {Tx tx_ready tx_busy rx_valid rx_busy rx_data[*]}]

## Additional Constraints to prevent warnings
set_property DRIVE 12 [get_ports {Tx}]
set_property SLEW SLOW [get_ports {Tx}]
set_property PULLUP true [get_ports {Rx}]
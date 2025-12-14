
#For input ouput switches
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { a }]; #IO_L24N_T3_RS0_15 Sch=sw[0]  #a
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { b }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1] #b
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { c }]; #IO_L6N_T0_D08_VREF_14 Sch=sw[2]  #c
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { d }]; #IO_L13N_T2_MRCC_14 Sch=sw[3]   #d

#For select lines
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { s[0] }]; #IO_L5N_T0_D07_14 Sch=sw[7] 
set_property -dict { PACKAGE_PIN T8    IOSTANDARD LVCMOS18 } [get_ports { s[1] }]; #IO_L24N_T3_34 Sch=sw[8]


#Output
#set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { y }]; #IO_L21P_T3_DQS_14 Sch=sw[15]

## LEDs
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { y }]; #IO_L18P_T2_A24_15 Sch=led[0]
#set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { LED[1] }]; #IO_L24P_T3_RS1_15 Sch=led[1]
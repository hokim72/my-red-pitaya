
### ADC

create_bd_port -dir I -from 13 -to 0 adc_dat_a_i
create_bd_port -dir I -from 13 -to 0 adc_dat_b_i

create_bd_port -dir I adc_clk_p_i
create_bd_port -dir I adc_clk_n_i

#create_bd_port -dir O adc_enc_p_o
#create_bd_port -dir O adc_enc_n_o

create_bd_port -dir O adc_csn_o

### DAC

#create_bd_port -dir O -from 13 -to 0 dac_dat_o

#create_bd_port -dir O dac_clk_o
#create_bd_port -dir O dac_rst_o
#create_bd_port -dir O dac_sel_o
#create_bd_port -dir O dac_wrt_o

### PWM

#create_bd_port -dir O -from 3 -to 0 dac_pwm_o

### XADC

#create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn
#create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux0
#create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux1
#create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux9
#create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux8

### Expansion connector

#create_bd_port -dir IO -from 7 -to 0 exp_p_tri_io
#create_bd_port -dir IO -from 7 -to 0 exp_n_tri_io

### SATA connector

#create_bd_port -dir O -from 1 -to 0 daisy_p_o
#create_bd_port -dir O -from 1 -to 0 daisy_n_o

#create_bd_port -dir I -from 1 -to 0 daisy_p_i
#create_bd_port -dir I -from 1 -to 0 daisy_n_i

### LED

create_bd_port -dir O -from 7 -to 0 led_o


# Create processing_system7
cell xilinx.com:ip:processing_system7:5.5 ps_0 {
  PCW_IMPORT_BOARD_PRESET red_pitaya.xml
  PCW_USE_S_AXI_HP0 1
} {
  M_AXI_GP0_ACLK ps_0/FCLK_CLK0
  S_AXI_HP0_ACLK ps_0/FCLK_CLK0
}

# Create all required interconnections
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {
  make_external {FIXED_IO, DDR}
  Master Disable
  Slave Disable
} [get_bd_cells ps_0]

# Create util_ds_buf
#cell xilinx.com:ip:util_ds_buf:2.1 buf_0 {
#  C_SIZE 2
#  C_BUF_TYPE IBUFDS
#} {
#  IBUF_DS_P daisy_p_i
#  IBUF_DS_N daisy_n_i
#}

# Create util_ds_buf
#cell xilinx.com:ip:util_ds_buf:2.1 buf_1 {
#  C_SIZE 2
#  C_BUF_TYPE OBUFDS
#} {
#  OBUF_DS_P daisy_p_o
#  OBUF_DS_N daisy_n_o
#}

# Create axis_red_pitaya_adc
cell hokim:user:axis_red_pitaya_adc:1.0 adc_0 {} {
  adc_clk_p adc_clk_p_i
  adc_clk_n adc_clk_n_i
  adc_dat_a adc_dat_a_i
  adc_dat_b adc_dat_b_i
  adc_csn   adc_csn_o
}

# Create c_counter_binary
cell xilinx.com:ip:c_counter_binary:12.0 cntr_0 {
  Output_Width 32
} {
  CLK adc_0/adc_clk
}

# Create xlslice
cell xilinx.com:ip:xlslice:1.0 slice_0 {
  DIN_FROM 26
  DIN_TO 26
} {
  Din cntr_0/Q
}

# Create xlconstant
cell xilinx.com:ip:xlconstant:1.1 const_0 {
  CONST_WIDTH 7
  CONST_VAL 0
}

# Create xlconcat
cell xilinx.com:ip:xlconcat:2.1 concat_0 {
  IN1_WIDTH 7
} {
  In0 slice_0/Dout
  In1 const_0/dout
  dout led_o
}

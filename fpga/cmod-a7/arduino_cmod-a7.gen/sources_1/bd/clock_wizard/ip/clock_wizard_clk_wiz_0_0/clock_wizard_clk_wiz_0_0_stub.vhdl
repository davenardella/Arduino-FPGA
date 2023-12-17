-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
-- Date        : Sun Nov 19 18:43:56 2023
-- Host        : W10-DEVELOP running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top clock_wizard_clk_wiz_0_0 -prefix
--               clock_wizard_clk_wiz_0_0_ clock_wizard_clk_wiz_0_0_stub.vhdl
-- Design      : clock_wizard_clk_wiz_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_wizard_clk_wiz_0_0 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clock_wizard_clk_wiz_0_0;

architecture stub of clock_wizard_clk_wiz_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_in1";
begin
end;

//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
//Date        : Sun Nov 19 18:42:59 2023
//Host        : W10-DEVELOP running 64-bit major release  (build 9200)
//Command     : generate_target clock_wizard_wrapper.bd
//Design      : clock_wizard_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module clock_wizard_wrapper
   (clk_out,
    sysclk);
  output clk_out;
  input sysclk;

  wire clk_out;
  wire sysclk;

  clock_wizard clock_wizard_i
       (.clk_out(clk_out),
        .sysclk(sysclk));
endmodule

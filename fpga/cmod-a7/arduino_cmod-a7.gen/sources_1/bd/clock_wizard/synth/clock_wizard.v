//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
//Date        : Sun Nov 19 18:42:59 2023
//Host        : W10-DEVELOP running 64-bit major release  (build 9200)
//Command     : generate_target clock_wizard.bd
//Design      : clock_wizard
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "clock_wizard,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=clock_wizard,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "clock_wizard.hwdef" *) 
module clock_wizard
   (clk_out,
    sysclk);
  output clk_out;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.SYSCLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.SYSCLK, CLK_DOMAIN clock_wizard_sysclk, FREQ_HZ 12000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input sysclk;

  wire clk_wiz_0_clk_out1;
  wire sysclk_1;

  assign clk_out = clk_wiz_0_clk_out1;
  assign sysclk_1 = sysclk;
  clock_wizard_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(sysclk_1),
        .clk_out1(clk_wiz_0_clk_out1));
endmodule

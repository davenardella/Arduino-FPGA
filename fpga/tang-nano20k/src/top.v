//***********************************************************************************************
// SPI Peripheral (slave) program
//-----------------------------------------------------------------------------------------------
// 2023 (c) Davide Nardella
// Released under MIT License
//***********************************************************************************************
module top(
    input wire sysclk,
    input wire push_btn_A,
    // key & leds
    output wire tm1638_stb,
    output wire tm1638_clk,
    inout wire tm1638_dio,
    // Arduino spi
    input wire spi_ss,
    input wire spi_sck,
    input wire spi_copi,
    output wire spi_cipo   
    );

    localparam SYSCLK_MHZ   = 27;   // System clock in MHz
    localparam WDOG_TIMEOUT = 2000; // Watchdog timeout(ms) (0: disabled)

    wire sysreset = push_btn_A;

//***********************************************************************************************
//  LED&KEY Driver Instance
//***********************************************************************************************

    wire numenable = 1;
    wire[31:0] number;

    wire[7:0] leds;
    wire[6:0] digits[0:7];
    wire[7:0] buttons;
    wire[7:0] dots = 8'b0000_0000;
      
    assign digits[7] = 7'd0;
    assign digits[6] = 7'd0;
    assign digits[5] = 7'd0;
    assign digits[4] = 7'd0;
    assign digits[3] = 7'd0;
    assign digits[2] = 7'd0;
    assign digits[1] = 7'd0;
    assign digits[0] = 7'd0;

    tm1638_driver #(.SYSCLK_MHZ(SYSCLK_MHZ)) // System clock in MHz 
    tm1638 (
        .sysclock(sysclk),        // System clock (route to the main clock line)
        .sysreset(sysreset),      // System reset (active high)
        .device_clk(tm1638_clk),  // route to clk physical line of tm1638 board
        .device_stb(tm1638_stb),  // route to stb physical line of tm1638 board
        .device_dio(tm1638_dio),  // route to dio physical line of tm1638 board 
        .D0(digits[0]),           // bitmap of Display 1 (leftmost) if numenable = 0
        .D1(digits[1]),           // bitmap of Display 2 if numenable = 0  
        .D2(digits[2]),           // bitmap of Display 3 if numenable = 0  
        .D3(digits[3]),           // bitmap of Display 4 if numenable = 0  
        .D4(digits[4]),           // bitmap of Display 5 if numenable = 0  
        .D5(digits[5]),           // bitmap of Display 6 if numenable = 0  
        .D6(digits[6]),           // bitmap of Display 7 if numenable = 0  
        .D7(digits[7]),           // bitmap of Display 8 (rightmost) if numenable = 0  
        .leds(leds),              // leds bitmap (bit 0 = leftmost, bit 7 = rightmost)
        .dots(dots),              // dots bitmap (bit 0 = leftmost, bit 7 = rightmost)
        .hexnumber(number),       // 32 bit hex number to display if numenable = 1
        .numenable(numenable),    // = 1 shows hexnumber, = 0 shows D0(leftmost)..D7(rightmost)
        .buttons(buttons)         // buttons bitmap (bit 0 = leftmost, bit 7 = rightmost)
    );
    
//***********************************************************************************************
//  SPI Driver Instance
//***********************************************************************************************
    wire[2047:0] copi_data;         // copi data Arduino -> FPGA
    reg [2047:0] cipo_data;         // cipo data FPGA -> Arduino

    wire busy;
    wire alarm;

    spi_driver #(.SYSCLK_MHZ(SYSCLK_MHZ),    // System clock in MHz 
                 .WDOG_TIMEOUT(WDOG_TIMEOUT))// Watchdog timeout(ms) (0: disabled)
    spi (
        .sysclock(sysclk),          // System clock (route to the main clock line)
        .sysreset(sysreset),        // Global reset
        .device_clk(spi_sck),       // SPI clock line
        .device_ss(spi_ss),         // SPI ss line
        .device_copi(spi_copi),     // SPI copi line
        .device_cipo(spi_cipo),     // SPI cipo line
        .copi_data(copi_data),      // copi data Arduino -> FPGA
        .cipo_data(cipo_data),      // cipo data FPGA -> Arduino
        .busy(busy),                // Driver busy
        .wdog_alarm(wdog_alarm)     // Watchdog alarm
    );

//----------------------------------------------------------
// DEMO CODE, delete/modify next lines in a real application
//----------------------------------------------------------
    // Loopback copi_data -> cipo_data
    reg[10:0] cnt = 11'd0;
    always @(posedge sysclk)
    begin
        cipo_data[cnt]<=copi_data[cnt];
        cnt<=cnt+11'd1;
    end
    
    // Data exchange counter
    reg[15:0] cnt_cycle = 16'd0;
    always @(posedge busy, posedge sysreset)
    begin
        if (sysreset)
            cnt_cycle <= 16'd0;
        else
            cnt_cycle <= cnt_cycle + 16'd1;
    end
    assign number = cnt_cycle;
// DEMO CODE END

//***********************************************************************************************
//  100 MHz clock generation, not used, it's here for your convenience
//***********************************************************************************************

    wire clk_100MHz;

    Gowin_rPLL pll(
        .clkout(clk_100MHz), // output 100 MHz clkout
        .clkin(sysclk)       // input System Clock 
    );

//----------------------------------------------------------
// DEMO CODE, delete/modify next lines in a real application
//----------------------------------------------------------
    // Blink a led to check that it's working
    reg[31:0] counter = 32'd0;
    reg blink;

    always @(posedge clk_100MHz)
    begin
        if (counter>=100000000) begin
            blink <= ~blink;
            counter <= 32'd0;
        end
        else
            counter <= counter + 32'd1;
    end   
    
    assign leds[0] = blink;
    assign leds[1] = wdog_alarm;
    assign leds[2] = 1'b0;
    assign leds[3] = 1'b0;
    assign leds[4] = 1'b0;
    assign leds[5] = 1'b0;
    assign leds[6] = 1'b0;
    assign leds[7] = 1'b0;
// DEMO CODE END

endmodule
//***********************************************************************************************
// SPI Peripheral (slave) driver
//-----------------------------------------------------------------------------------------------
// 2023 (c) Davide Nardella
// Released under MIT License
//***********************************************************************************************
module spi_driver(
    input wire sysclock,                // System clock
    input wire sysreset,                // System reset
    // SPI physical lines
    input wire device_clk,              // Route it to SPI sck
    input wire device_ss,               // Route it to SPI ss
    input wire device_copi,             // Route it to SPI copi
    output wire device_cipo,            // Route it to SPI cipo
    // Data exchange
    output reg[2047:0] copi_data,       // 256 bytes User Write Record Arduino -> FPGA
    input wire [2047:0] cipo_data,      // 256 bytes User Read Record FPGA -> Arduino
    output wire busy,                   // XFER in progress
    // Watchdog
    output reg wdog_alarm = 1'b0
);
    parameter SYSCLK_MHZ   = 27;        // How many MHz is System clock
    parameter WDOG_TIMEOUT = 2000;      // Whatcdog Timeout in millisec (0 disabled)           

    localparam TICK_KHZ = SYSCLK_MHZ * 1000;

     // Internal states
    localparam GET_OFS       = 1'b0;    // Get start bit                      
    localparam XCHG          = 1'b1;    // Data Exchange                          

    reg cipo = 1'b0;       // Internal  cipo
    reg cipo_next = 1'b0;  // Next cipo to send
    reg state = GET_OFS;   // FSM state

    reg[3:0] ofs_cnt;      // Offset bit counter
    reg[15:0] rec_cnt;     // Record bit counter
    
    wire reset = sysreset || device_ss; // Cycle reset condition

    // Rising edge spi_sck 
    always @(posedge device_clk, posedge reset)
    begin
        if (reset) 
        begin
            ofs_cnt <= 4'd15;
            rec_cnt <= 15'd0;
            cipo_next <= 1'b0;
            state <= GET_OFS;
        end
        else begin
            case (state)
                GET_OFS: begin
                    rec_cnt[ofs_cnt] <= device_copi;
                    cipo_next <= device_copi;
                    if (ofs_cnt == 4'd0) begin
                        state <= XCHG;
                    end
                    else
                        ofs_cnt <= ofs_cnt - 4'd1;
                end
                XCHG: begin                   
                    copi_data[rec_cnt] <= device_copi;
                    rec_cnt <= rec_cnt - 15'd1;
                end             
            endcase
        end
    end

    // Falling edge spi_sck : prepare next cipo
    always @(negedge device_clk)
    begin
        if (state == GET_OFS)
            cipo <= cipo_next;
        else
            cipo <= cipo_data[rec_cnt];
    end

    // Watchdog ----------------------------------------------------

    reg[31:0] clock_cnt = 32'd0;
    reg[15:0] wdog_cnt = 16'd0;
    wire wdog_reset = sysreset || !device_ss;

    // Whatchdog
    always @(posedge sysclock, posedge wdog_reset)
    begin
        if (wdog_reset) begin
            clock_cnt <= 32'd0;
            wdog_cnt <= 16'd0;
            wdog_alarm <= 1'b0;
        end
        else begin
            clock_cnt <= clock_cnt + 32'd1;
            if (clock_cnt >= TICK_KHZ) begin
                clock_cnt <= 32'd0;               
                wdog_cnt <= (WDOG_TIMEOUT > 0)?  wdog_cnt + 16'd1 : 16'd0;
            end
            wdog_alarm <= (wdog_cnt >= WDOG_TIMEOUT) ? 1'b1 : 1'b0;           
        end
    end

    assign device_cipo = device_ss ? 1'bz : cipo; // If not selected cipo = HighZ
    assign busy = !device_ss && (state == XCHG);

endmodule

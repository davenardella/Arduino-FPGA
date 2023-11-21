module tm1638_readbyte(
    input wire drvclk,  // 500 KHz driver clock
    input wire reset,   // reset
    input wire start,  
    output wire busy,
    output reg[7:0] data,
    //
    output reg dev_clk = 1,
    input wire dev_din
);

    // States
    localparam IDLE = 1'd0;
    localparam RECV = 1'd1;

    reg state = IDLE;
    reg[3:0] cnt = 4'd0;
    
    assign busy = (state == RECV);

    always @(posedge drvclk, posedge reset)
    begin
        if (reset) begin
            state <= IDLE;
            cnt <= 0;
            dev_clk <= 1;
            
            data <= 8'd0;
        end
        else begin
            if (state == IDLE) begin
                if (start) begin
                    cnt <= 0;
                    dev_clk <= 0;
                    state <= RECV;
                end
            end
            else begin // state == RECV
                if (!dev_clk) begin
                    data[cnt] <= dev_din;
                    dev_clk <= 1;
                    cnt <= cnt + 4'd1;
                end
                else begin
                    if (cnt < 4'd8) begin
                        dev_clk <= 0;
                    end
                    else 
                        state <= IDLE;
                end                                                          
            end          
        end
    end

endmodule
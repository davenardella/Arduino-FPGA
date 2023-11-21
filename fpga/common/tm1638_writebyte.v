module tm1638_writebyte(
    input wire drvclk,  // 500 KHz driver clock
    input wire reset,   // reset
    input wire start,  
    output wire busy,
    input wire [7:0] data,
    //
    output reg dev_clk = 1,
    output reg dev_dout = 1
);

    // States
    localparam IDLE = 1'd0;
    localparam SEND = 1'd1;

    reg state = IDLE;
    reg[3:0] cnt = 4'd0;
    
    assign busy = (state == SEND);

    always @(posedge drvclk, posedge reset)
    begin
        if (reset) begin
            state <= IDLE;
            cnt <= 0;
            dev_clk <= 1;
            dev_dout <= 1;
        end
        else begin
            if (state == IDLE) begin
                if (start) begin
                    cnt <= 0;
                    dev_clk <= 0;
                    dev_dout <= data[4'd0];
                    state <= SEND;
                end
            end
            else begin // state == SEND
                if (!dev_clk) begin
                    dev_clk <= 1;
                    cnt <= cnt + 4'd1;
                end
                else begin
                    if (cnt < 4'd8) begin
                        dev_dout <= data[cnt];
                        dev_clk <= 0;
                    end
                    else begin
                        state <= IDLE;
                        dev_dout <= 1;
                    end    
                end                                                          
            end          
        end
    end

endmodule
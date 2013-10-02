// Joseph Carlos (jcarlos)
//`default_nettype none

module top(input bit SYSCLK_P, SYSCLK_N,
           //input bit clock,
           input bit GPIO_SW_N, GPIO_SW_C,
           output bit GPIO_LED_0_LS, GPIO_LED_1_LS, GPIO_LED_2_LS, GPIO_LED_3_LS,
           output bit GPIO_LED_4_LS, GPIO_LED_5_LS, GPIO_LED_6_LS, GPIO_LED_7_LS);

    bit clock;
    bit reset;
    bit button_down;
    
    bit [7:0] count;
    
    bit pressed;
    bit increment;
    
    assign reset = GPIO_SW_C;
    assign button_down = GPIO_SW_N;

    assign {GPIO_LED_7_LS, GPIO_LED_6_LS, GPIO_LED_5_LS, GPIO_LED_4_LS,
            GPIO_LED_3_LS, GPIO_LED_2_LS, GPIO_LED_1_LS, GPIO_LED_0_LS} =
            count[7:0];
  
    IBUFDS #(.DIFF_TERM("TRUE"),
      .IBUF_LOW_PWR("TRUE"),
      .IOSTANDARD("DEFAULT"))
    clk_ibufds (.O(clock),
         .I(SYSCLK_P),
         .IB(SYSCLK_N));

    always @(posedge clock) begin
        if (reset) begin
            pressed <= 1'b0;
        end
        else if (button_down) begin
            pressed <= 1'b1;
        end
        else begin
            pressed <= 1'b0;
        end
    end

    assign increment = (~button_down) & pressed;

    always @(posedge clock) begin
        if (reset) begin
            count <= 8'd0;
        end
        else if (increment) begin
            count <= count + 8'd1;
        end
    end  
  
           
endmodule: top

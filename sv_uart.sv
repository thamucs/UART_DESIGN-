`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2026 13:41:21
// Design Name: 
// Module Name: sv_uart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sv_uart(

    );
    logic       clk;
        logic       rst;
        logic [7:0] data_in;
        logic       wr_en;
        logic       rdy_clr;
        logic       rdy;
        logic [7:0] data_out;
        logic       busy;
    
        top_uart_sv ut (
            .rst       (rst),
            .wr_en     (wr_en),
            .clk       (clk),
            .ready_clk (rdy_clr),
            .data_in   (data_in),
            .rdy       (rdy),
            .busy      (busy),
            .data_out  (data_out)
        );
    
        
        initial begin
            clk = 0;
            forever #5 clk = ~clk; 
        end
    
        
        task automatic send_byte(input logic [7:0] din);
            @(negedge clk);
            data_in = din;
            wr_en   = 1'b1;
            @(negedge clk);
            wr_en   = 1'b0;
        endtask
    
        task automatic clear_ready();
            @(negedge clk);
            rdy_clr = 1'b1;
            @(negedge clk);
            rdy_clr = 1'b0;
        endtask
     
        initial begin
          
            rst     = 0;
            data_in = 0;
            wr_en   = 0;
            rdy_clr = 0;
            
            rst = 1'b1;
            repeat(20) @(posedge clk);
            rst = 1'b0;
            repeat(5)  @(posedge clk);
   
            send_byte(8'h44);
            wait(!busy);
            wait(rdy);
            $display("[%0t] Data has been received : 0x%02H", $time, data_out); 
            clear_ready();
    
            send_byte(8'h56);
            wait(!busy);
            wait(rdy);
            $display("[%0t] Data has been received : 0x%02H", $time, data_out);
            clear_ready();
    
            #1000;
            $finish;
        end
endmodule

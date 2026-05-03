`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2026 20:20:19
// Design Name: 
// Module Name: receiver_sv
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


module receiver_sv(input logic clk,rst,rd_cr,clk_en,rx,
output logic [7:0] data_out,
output logic ready
    );
    typedef enum logic [1:0] {
            IDLE = 2'b00,
            DATA = 2'b01,
            STOP = 2'b10
        } state_t;
    
        state_t state;
    
        logic [3:0] sample;
        logic [2:0] index;  
        logic [7:0] temp_reg;
  
        always_ff @(posedge clk) begin
            if (rst) begin
                ready    <= 1'b0;
                data_out <= 8'h00;
                state    <= IDLE;
                sample   <= 4'h0;
                index    <= 3'h0;
                temp_reg <= 8'h00;
            end else begin
                if (rd_cr) begin
                    ready <= 1'b0;
                end
   
                if (clk_en) begin
                    case (state)
                        
                        IDLE: begin
                                                
                            if (rx == 1'b0) begin                           
                                if (sample == 4'd7) begin
                                    sample <= 4'd0;
                                    state  <= DATA;
                                    index  <= 3'd0;
                                end else begin
                                    sample <= sample + 4'b1;
                                end
                            end else begin
                                sample <= 4'd0; 
                            end
                        end
                           
                        DATA: begin
                           
                            if (sample == 4'd15) begin 
                                sample <= 4'd0;
                                temp_reg[index] <= rx;                                                               
                                if (index == 3'd7) begin
                                    state <= STOP;
                                end else begin
                                    index <= index + 3'd1;
                                end
                            end else begin
                                sample <= sample + 4'b1;
                            end
                        end
    
                        STOP: begin
                      
                            if (sample == 4'd15) begin 
                                data_out <= temp_reg; 
                                ready    <= 1'b1;     
                                state    <= IDLE;     
                                sample   <= 4'd0;
                            end else begin
                                sample <= sample + 4'b1;
                            end
                        end
    
                        default: begin
                            state <= IDLE;
                        end
                    endcase
                end
            end
            end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2026 14:33:33
// Design Name: 
// Module Name: transmitter_sv
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


module transmitter_sv(input logic clk,wr_en,en,rst,
input logic [7:0]data_in,
output logic tx,
output logic busy);
    typedef enum logic [1:0] {
        IDLE_STATE  = 2'b00,
        START_STATE = 2'b01,
        DATA_STATE  = 2'b10,
        STOP_STATE  = 2'b11
    } state_t;
    state_t state; 
    logic [2:0] index;
    logic [7:0] data;
    always_ff @(posedge clk) begin
        if (rst) begin
            tx    <= 1'b1;
            state <= IDLE_STATE;   
            index <= 3'h0;         
            data  <= 8'h00;        
        end else begin
            case (state)

                IDLE_STATE: begin
                    if (wr_en) begin
                        state <= START_STATE;
                        data  <= data_in;
                        index <= 3'h0;
                    end else begin
                        state <= IDLE_STATE;
                    end
                end

                START_STATE: begin
                    if (en) begin
                        tx    <= 1'b0;
                        state <= DATA_STATE;
                    end else begin
                        state <= START_STATE;
                    end
                end

                DATA_STATE: begin
                    if (en) begin
                        tx <= data[index];
                        if (index == 3'h7)
                            state <= STOP_STATE;
                        else
                            index <= index + 3'h1;
                    end
                end

                STOP_STATE: begin
                    if (en) begin
                        tx    <= 1'b1;
                        state <= IDLE_STATE;
                    end
                end

                default: begin
                    tx    <= 1'b1;
                    state <= IDLE_STATE;
                end

            endcase
        end
    end

    assign busy = (state != IDLE_STATE);
    
endmodule

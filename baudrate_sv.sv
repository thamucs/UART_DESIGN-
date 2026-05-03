`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2026 20:16:14
// Design Name: 
// Module Name: baudrate_sv
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


module baudrate_sv #(
    parameter int TX_MAX = 5208, 
    parameter int RX_MAX = 325   
)(
    input  logic clk,
    input  logic rst,
    output logic tx_en,
    output logic rx_en
);

    
    logic [12:0] counter_tx;
    logic [9:0]  counter_rx;

    
    always_ff @(posedge clk) begin
        if (rst) begin
            counter_tx <= 13'd0;         
        end else if (counter_tx == TX_MAX) begin
            counter_tx <= 13'd0;
        end else begin
            counter_tx <= counter_tx + 1'b1;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            counter_rx <= 10'd0;         
        end else if (counter_rx == RX_MAX) begin
            counter_rx <= 10'd0;
        end else begin
            counter_rx <= counter_rx + 1'b1;
        end
    end

    
    assign tx_en = (counter_tx == 13'd0);
    assign rx_en = (counter_rx == 10'd0);

endmodule

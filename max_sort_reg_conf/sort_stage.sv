(* keep_hierarchy = "yes" *)

module sort_stage import sort_pkg::*; (
    input  logic clk,                    
    input  logic rst_n,  
    input  logic i_enable,
    input  logic [M-1:0][N-1:0] i_chi,
    output logic [M-1:0][N-1:0] o_chi,
    output logic [N-1:0] o_y_q,
    output logic o_enable
);

logic [M-1:0][N-1:0] o_chi_light_next;
logic [M-1:0][N-1:0] o_chi_light_ff;
logic [M-1:0][N-1:0] o_chi_next;
logic [M-1:0] h_matrix_next; 
logic [M-1:0] h_matrix_ff; 
logic [N-1:0] o_y_q_next;
logic enable_next;
logic enable_ff;
logic enable_out;

light_core #(
) light_core_inst (
    .clk        (clk),
    .rst_n      (rst_n),
    .i_chi      (i_chi),
    .i_enable   (i_enable),
    .enable     (enable_next),
    .o_chi      (o_chi_light_next),
    .o_h_matrix (h_matrix_next)
);

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_chi_light_ff <= '0;
    h_matrix_ff    <= '0;
    enable_ff      <= 1'b0;
  end else if (enable_next) begin
    o_chi_light_ff <= o_chi_light_next;
    h_matrix_ff    <= h_matrix_next;  
    enable_ff      <= enable_next;
  end
end

dark_core #(
) dark_core_inst (
    .clk            (clk),
    .rst_n          (rst_n),
    .i_enable       (enable_ff),
    .i_h_ij         (h_matrix_ff),
    .i_chi          (o_chi_light_ff), 
    .o_enable       (enable_out),
    .o_y_q          (o_y_q_next),
    .o_chi_modified (o_chi_next)
);

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_y_q <= '0;
    o_chi <= '0;
    o_enable <= 1'b0;
  end else if (enable_out) begin
    o_y_q <= o_y_q_next;
    o_chi <= o_chi_next;  
    o_enable <= 1'b1;
  end
end

endmodule
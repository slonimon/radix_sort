(* keep_hierarchy = "yes" *)
module sort_wrapp import sort_pkg::*; (
    input  logic clk,                    
    input  logic rst_n,                
    input  logic [M-1:0][N-1:0] i_chi,
    output logic [W-1:0][N-1:0] o_y_q
);

logic [M-1:0][N-1:0] i_chi_ff;
logic [W-1:0][N-1:0] o_y_q_ff;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i_chi_ff <= '0;
        o_y_q <= '0;
    end else begin
        i_chi_ff <= i_chi;
        o_y_q <= o_y_q_ff;
    end
end

sort_top #(
) sort_top_inst_test (
    .clk    (clk),
    .rst_n  (rst_n),
    .i_chi  (i_chi_ff),
    .o_y_q  (o_y_q_ff)
);
endmodule
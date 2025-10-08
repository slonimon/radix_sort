// (* keep_hierarchy = "yes" *)
module sort_top import sort_pkg::*; (
    input  logic clk,                    
    input  logic rst_n,                
    input  logic [M-1:0][N-1:0] i_chi,
    output logic [W-1:0][N-1:0] o_y_q
);

logic [M-1:0][N-1:0] h_matrix; 
logic [W-1:0][N-1:0] y_q_stage;
logic [W-1:0][M-1:0][N-1:0] o_chi_stage;
logic [W-1:0][M-1:0][N-1:0] o_chi_stage_ff;

generate
    for (genvar i = 0; i <= W-1; i++) begin 
        if (i == 0) begin 
            sort_stage #(
            ) sort_stage_inst_0 (
                .i_chi  (i_chi),
                .o_chi  (o_chi_stage[i]),
                .o_y_q  (y_q_stage[i])
            );
            
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    o_chi_stage_ff[0] <= '0;
                    o_y_q[0] <= '0;
                end else begin
                    o_chi_stage_ff[0] <= o_chi_stage[0];
                    o_y_q[0] <= y_q_stage[0];
                end
            end
            
        end else begin
            sort_stage #(
            ) sort_stage_inst_q (
                .i_chi  (o_chi_stage_ff[i-1]),  
                .o_chi  (o_chi_stage[i]),
                .o_y_q  (y_q_stage[i])     
            );
            
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    o_chi_stage_ff[i] <= '0;
                    o_y_q[i] <= '0;
                end else begin
                    o_chi_stage_ff[i] <= o_chi_stage[i];
                    o_y_q[i] <= y_q_stage[i];
                end
            end
        end
    end
endgenerate

endmodule 


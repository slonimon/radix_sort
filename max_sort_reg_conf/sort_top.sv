(* keep_hierarchy = "yes" *)
module sort_top import sort_pkg::*; (
    input  logic clk,                    
    input  logic rst_n,                
    input  logic [M-1:0][N-1:0] i_chi,
    output logic [W-1:0][N-1:0] o_y_q
);

logic [W-2:0][M-1:0][N-1:0] o_chi_stage_ff;
logic [W-1:0][M-1:0][N-1:0] o_chi_stage;
logic [W-1:0][N-1:0] y_q_stage;
logic [W-1:0]o_enable;
logic i_enable;

assign i_enable = 1'b1;

generate
    for (genvar i = 0; i <= W-1; i++) begin 
        if (i == 0) begin 
            sort_stage #(
            ) sort_stage_inst_0 (
                .clk    (clk),
                .rst_n  (rst_n),
                .i_chi  (i_chi),
                .i_enable (i_enable),
                .o_chi  (o_chi_stage[i]),
                .o_enable (o_enable[i]),
                .o_y_q  (o_y_q[i]) 
            );  
        end else begin
            sort_stage #(
            ) sort_stage_inst_q (
                .clk    (clk),
                .rst_n  (rst_n),
                .i_chi  (o_chi_stage_ff[i-1]), 
                .i_enable (o_enable[i-1]), 
                .o_chi  (o_chi_stage[i]),
                .o_enable (o_enable[i]),
                .o_y_q  (o_y_q[i])   
            );
        end
    end
endgenerate

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_chi_stage_ff <= '0;
    end else begin
        o_chi_stage_ff <= o_chi_stage;
    end
end
            

endmodule 


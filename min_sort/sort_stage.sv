(* keep_hierarchy = "yes" *)

module sort_stage import sort_pkg::*; (
    input logic [M-1:0][N-1:0] i_chi,
    output logic [M-1:0][N-1:0] o_chi,
    output logic [N-1:0] o_y_q
);

logic [M-1:0][N-1:0] o_chi_light;
logic [N-1:0][M-1:0] h_matrix; 
logic [W-1:0] q;

assign q = 'd0;

light_core #(
) light_core_inst (
    .i_chi      (i_chi),
    .o_chi      (o_chi_light),
    .o_h_matrix (h_matrix)
);

dark_core #(
) dark_core_inst (
    .i_h_ij         (h_matrix[q]),
    .i_chi          (o_chi_light), 
    .o_y_q          (o_y_q),
    .o_chi_modified (o_chi)
);

endmodule
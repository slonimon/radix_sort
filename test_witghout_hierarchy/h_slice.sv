(* keep_hierarchy = "yes" *)

module h_slice import sort_pkg::*; (  
    input  logic [M-1:0] i_x_slice,  
    input  logic [M-1:0] i_h_next_slice, 
    output logic [M-1:0] o_h_slice 
);

logic [M-1:0] z_j;
logic [M-1:0] h_ij;
logic [M-1:0] h_bypass;

always_comb begin
    h_ij = i_h_next_slice & i_x_slice;
    z_j = {M{~|h_ij}};
    h_bypass = i_h_next_slice & z_j;
    o_h_slice = h_bypass | h_ij;
end

endmodule
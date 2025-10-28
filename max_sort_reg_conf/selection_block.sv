(* keep_hierarchy = "yes" *)

module selection_block import sort_pkg::*; (  
    input  logic i_g_i,
    input  logic [N-1:0] i_chi,
    output logic [N-1:0] o_chi,   
    output logic [N-1:0] o_xi
);

always_comb begin 
    case (i_g_i)
        1'b1 : o_chi = {N{1'b0}};
        1'b0 : o_chi = i_chi;    
        default: o_chi = i_chi;    
    endcase

    o_xi = i_chi & {N{i_g_i}};
end

endmodule
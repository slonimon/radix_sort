(* keep_hierarchy = "yes" *)

module g_slice (
    input  logic i_h_prev_slice, 
    input  logic i_h_i_slice,         
    input  logic i_tau_double_prev,  
    output logic o_tau_prev,  
    output logic o_g_i     
);

logic tau_prev;

always_comb begin 
    tau_prev = i_tau_double_prev | i_h_prev_slice;
    o_g_i = i_h_i_slice & ~tau_prev;
end

assign o_tau_prev = tau_prev;
endmodule
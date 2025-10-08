(* keep_hierarchy = "yes" *)

module dark_core import sort_pkg::*; (
    input logic [M-1:0] i_h_ij,           
    input logic [M-1:0][N-1:0] i_chi,  
    output logic [N-1:0] o_y_q,            
    output logic [M-1:0][N-1:0] o_chi_modified
);

logic [M-1:0] g_i;    
logic [M-3:0] o_tau; 
logic [1:0] g_i_comb;
logic [M-3:0] g_i_slice;
logic [M-1:0] bit_slice;     
logic [M-1:0][N-1:0] chi_sel;         
logic [M-1:0][N-1:0] xi_sel;  

always_comb begin 
    g_i_comb = {~i_h_ij[0] & i_h_ij[1], i_h_ij[0]};
end

always_comb begin 
    g_i = {g_i_slice, g_i_comb};
end

always_comb begin
    for (int q = 0; q < N; q++) begin       
        for (int l = 0; l < M; l++) begin   
            bit_slice[l] = xi_sel[l][q];    
        end
        o_y_q[q] = |bit_slice;
    end
end

always_comb begin 
    for (int k = 0; k < M; k++) begin       
         o_chi_modified[k] = chi_sel[k];
    end
end

generate
    for (genvar i = 2; i <= M-1; i++) begin 
      if (i == 2) begin  
          g_slice #(
          ) g_slice_inst (
              .i_h_prev_slice     (i_h_ij[i-1]),  
              .i_h_i_slice        (i_h_ij[i]),    
              .i_tau_double_prev  (i_h_ij[i-2]),
              .o_tau_prev         (o_tau[i-2]),    
              .o_g_i              (g_i_slice[i-2])  
          ); 
      end else begin
          g_slice #(
          ) g_slice_inst (
              .i_h_prev_slice     (i_h_ij[i-1]),  
              .i_h_i_slice        (i_h_ij[i]),    
              .i_tau_double_prev  (o_tau[i-3]),
              .o_tau_prev         (o_tau[i-2]),    
              .o_g_i              (g_i_slice[i-2])    
          );
      end
    end

    for (genvar j = 0; j <= M-1; j++) begin   
        selection_block #(
        ) selection_block_inst (
            .i_g_i  (g_i[j]),  
            .i_chi  (i_chi[j]),    
            .o_chi  (chi_sel[j]), 
            .o_xi   (xi_sel[j])  
        ); 
    end
endgenerate

endmodule

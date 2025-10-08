(* keep_hierarchy = "yes" *)

module light_core import sort_pkg::*; (  
    input  logic [M-1:0][N-1:0] i_chi,
    output logic [M-1:0][N-1:0] o_chi,   
    output logic [M-1:0][N-1:0] o_h_matrix
);

logic z_last;
logic [M-1:0][N-1:0] h_j_slice;
logic [N-1:0] h_slice;
logic [M-1:0][N-1:0] chi_transposed;

always_comb begin
    for (int k = 0; k < N; k++) begin      
        for (int q = 0; q < M; q++) begin   
            chi_transposed[q][k] = i_chi[k][q];
        end
    end
end

always_comb begin 
    z_last = {M{~|chi_transposed[N-1]}};
    h_j_slice[N-1] = z_last | chi_transposed[N-1];
    h_slice = h_j_slice[N-1];
end

for (genvar j = N-2; j >= 0; j--) begin 
  if (j == N - 2) begin  
      h_slice #(
      ) h_slice_inst (
          .i_x_slice      (chi_transposed[N-2]),  
          .i_h_next_slice (h_j_slice[N-1]),    
          .o_h_slice      (h_j_slice[j])  
      ); 
  end else begin
      h_slice #(
      ) h_slice_inst (
          .i_x_slice      (chi_transposed[j]),  
          .i_h_next_slice (h_j_slice[j+1]),    
          .o_h_slice      (h_j_slice[j])  
      );
  end
end

assign o_h_matrix = h_j_slice;
assign o_chi = i_chi;

endmodule
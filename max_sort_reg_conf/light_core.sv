(* keep_hierarchy = "yes" *)

module light_core import sort_pkg::*; (  
    input  logic clk,                    
    input  logic rst_n,  
    input  logic [M-1:0][N-1:0] i_chi,
    input  logic i_enable,
    output logic enable,
    output logic [M-1:0][N-1:0] o_chi,   
    output logic [M-1:0] o_h_matrix
);

logic [N-1:0][M-1:0] h_j_slice_next;
logic [N-1:0][M-1:0] chi_transposed;
logic [N-2:0][M-1:0] h_j_slice_ff;
logic [M-1:0] z_last_next;
logic [M-1:0] i_chi_msb;
logic [M-1:0] z_last_ff;
logic [M-1:0] h_slice;

always_comb begin
  for (int q = 0; q < M; q++) begin      
    for (int k = 0; k < N; k++) begin   
      chi_transposed[k][q] = i_chi[q][k];
    end
  end
end

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    z_last_ff <= '0;
  end else if (i_enable) begin
    z_last_ff <= z_last_next; 
  end
end

always_comb begin 
    for (int i1 = 0; i1 < M; i1++) begin
      i_chi_msb[i1] = i_chi[i1][N-1];
    end
    z_last_next = ~|i_chi_msb;  
end

for (genvar i1 = 0; i1 < M; i1++) begin 
    always_comb begin 
      h_slice[i1] = z_last_ff | i_chi[i1][N-1]; 
    end
end

assign h_j_slice_next[N-1] = h_slice;

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    h_j_slice_ff <= '0;
  end else begin
    h_j_slice_ff <= h_j_slice_next; 
  end
end


for (genvar j = N-2; j >= 0; j--) begin 
  if (j == N - 2) begin  
    h_slice #(
    ) h_slice_inst (
      .i_x_slice      (chi_transposed[N-2]),  
      .i_h_next_slice (h_j_slice_next[N-1]),    
      .o_h_slice      (h_j_slice_next[j])  
    ); 
  end else begin
    h_slice #(
    ) h_slice_inst (
      .i_x_slice      (chi_transposed[j]),  
      .i_h_next_slice (h_j_slice_ff[j+1]),    
      .o_h_slice      (h_j_slice_next[j])  
    );
  end
end

assign o_chi = i_chi;
assign o_h_matrix = h_j_slice_ff[0]; 
assign enable = (|o_h_matrix != 1'b0) ? 1'b1 :  1'b0;
endmodule


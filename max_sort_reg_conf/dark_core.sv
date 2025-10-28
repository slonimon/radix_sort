(* keep_hierarchy = "yes" *)

module dark_core import sort_pkg::*; (
    input  logic clk,                    
    input  logic rst_n,    
    input  logic i_enable,    
    input  logic [M-1:0] i_h_ij,           
    input  logic [M-1:0][N-1:0] i_chi, 
    output logic o_enable,
    output logic [N-1:0] o_y_q,            
    output logic [M-1:0][N-1:0] o_chi_modified
);

logic o_tau;
logic enable;
logic [1:0] g_i_comb;
logic [M-1:0] g_i_ff;
logic [M-1:0] g_i_next;   
logic [M-3:0] g_i_slice;
logic [M-1:0] bit_slice;  
logic [N-1:0] o_y_q_next;
logic [M-1:0][N-1:0] xi_sel;    
logic [M-1:0][N-1:0] chi_sel;         
logic [M-4:0] o_tau_prev_next; 
logic [M-4:0] i_tau_double_prev_ff;

assign g_i_comb = {~i_h_ij[0] & i_h_ij[1], i_h_ij[0]};
assign g_i_next = {g_i_slice, g_i_comb};

always_comb begin
  for (int q = 0; q < N; q++) begin       
    for (int l = 0; l < M; l++) begin   
      bit_slice[l] = xi_sel[l][q];     
    end
    o_y_q_next[q] = |bit_slice;    
  end
end

assign o_y_q = o_y_q_next;

always_comb begin if (enable) begin
  for (int k = 0; k < M; k++) begin       
    o_chi_modified[k] = chi_sel[k];
  end
end
end

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    i_tau_double_prev_ff <= '0;
    enable <= '0;
  end else begin
    i_tau_double_prev_ff <= o_tau_prev_next;
    enable <= i_enable;
  end
end
 
assign o_tau_prev_next[0] = o_tau;

for (genvar i = 2; i <= M-1; i++) begin 
  if (i == 2) begin  
    g_slice #(
    ) g_slice_inst (
      .i_h_prev_slice     (i_h_ij[i-1]),  
      .i_h_i_slice        (i_h_ij[i]),    
      .i_tau_double_prev  (i_h_ij[i-2]), 
      .o_tau_prev         (o_tau), 
      .o_g_i              (g_i_slice[i-2])  
    ); 
  end else begin
    g_slice #(
    ) g_slice_inst (
      .i_h_prev_slice     (i_h_ij[i-1]),  
      .i_h_i_slice        (i_h_ij[i]),    
      .i_tau_double_prev  (i_tau_double_prev_ff[i-3]), 
      .o_tau_prev         (o_tau_prev_next[i-2]), 
      .o_g_i              (g_i_slice[i-2])    
    );
  end
end

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    g_i_ff <= '0;
    o_enable <= '0;
  end else begin
    g_i_ff <= g_i_next;
    o_enable <= enable;
  end
end

for (genvar j = 0; j <= M-1; j++) begin   
  selection_block #(
  ) selection_block_inst (
    .i_g_i  (g_i_ff[j]),  
    .i_chi  (i_chi[j]),    
    .o_chi  (chi_sel[j]), 
    .o_xi   (xi_sel[j])  
  ); 
end

endmodule

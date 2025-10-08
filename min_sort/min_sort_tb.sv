module tb;
    import sort_pkg::*;
    
    logic clk;
    logic rst_n;
    logic [M-1:0][N-1:0] i_chi;
    logic [W-1:0][N-1:0] o_y_q;
    
    always #5 clk = ~clk;
  
    sort_top dut (
    .clk (clk),
    .rst_n (rst_n),
    .i_chi (i_chi), 
    .o_y_q (o_y_q)
    );
    
    initial begin
        clk = 0;
        rst_n = 0;
        i_chi = 'x;
        
        #20;
        rst_n = 1;
        
        i_chi = {4'b0110, 4'b0000, 4'b0101, 4'b0111};
        #100;
        
        $finish;
    end
    typedef bit [63:0] data_t;
endmodule
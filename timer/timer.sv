module timer(
       input clk,  // clock
       input rst,  // reset
       output reg [63:0] t // 64-bit output register of time
       );

  always_ff @(posedge clk or posedge rst)
    if(rst)
      t <= 0;
    else
      t <= t+1;
endmodule
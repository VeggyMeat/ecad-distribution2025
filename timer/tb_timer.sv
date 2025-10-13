module tb_timer(
        output logic clk,  // generated clock
        output logic rst,  // generated reset
        output [63:0] t    // test output
        );

  initial begin
    $dumpfile("tb_timer_trace.vcd"); // dump signal changes
    $dumpvars();                     // dump all variables in this module
    clk = 1;                         // value of clk at simulation step 0
    rst = 1;                         // value of rst at simulation step 0
    #20 rst = 0;                     // wait 20 simulation steps and then lower rst
    #100 $finish();                  // wait 100 simulation steps, then call $finish() to stop
  end

  // invert the clock every 5 simulation steps
  always #5 clk = !clk;

  // initatiate the design under test (DUT)
  timer dut(.clk(clk), .rst(rst), .t(t));

  // every negative edge of the clock, output the status
  always @(posedge clk)
    $display("sim_time=%4d      t=%4d", $time, t);
   
endmodule
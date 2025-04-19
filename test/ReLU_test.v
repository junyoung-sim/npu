`include "ReLU.v"
`include "TestUtils.v"

module Top();

  // verilator lint_off UNUSED
  logic clk;
  logic rst;
  // verilator lint_on UNUSED

  TestUtils t
  (
    .*
  );

  //==========================================================
  // DUT
  //==========================================================

  logic [15:0] relu_dut_in;
  logic [15:0] relu_dut_out;

  ReLU #(16) relu_dut
  (
    .in  (relu_dut_in),
    .out (relu_dut_out)
  );

  //==========================================================
  // Verification Tasks
  //==========================================================

  function automatic logic signed [15:0] rand_q8_8();
    return $urandom() & ((1 << 16) - 1);
  endfunction

  task check
  (
    input logic [15:0] relu_in,
    input logic [15:0] relu_out
  );

    relu_dut_in = relu_in;

    if(!t.failed) begin
      #8;
      if(t.n != 0) begin
        $display("%3d: %b.%b > %b.%b", t.cycles,
          relu_in[15:8], relu_in[7:0], relu_out[15:8], relu_out[7:0]);
      end
      `CHECK_EQ(relu_dut_out, relu_out);
      #2;
    end

  endtask

  //==========================================================
  // Test Cases
  //==========================================================

  logic signed [15:0] relu_in;
  logic        [15:0] relu_out;

  //----------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin("test_case_1_basic");

    check('h0100, 'h0100);
    check('hff00, 'h0000);

  endtask

  //----------------------------------------------------------

  task test_case_2_random();
    t.test_case_begin("test_case_2_random");

    for(int i = 0; i < 10000; i++) begin

      relu_in  = rand_q8_8();
      
      if(relu_in < 0)
        relu_out = 0;
      else
        relu_out = relu_in;

      check(relu_in, relu_out);

    end

  endtask

  //==========================================================
  // Main
  //==========================================================

  initial begin
    t.test_bench_begin(`__FILE__);

    if((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if((t.n <= 0) || (t.n == 2)) test_case_2_random();

    t.test_bench_end();
  end

endmodule
`ifndef RELU_V
`define RELU_V

module ReLU
#(
  parameter NBITS = 16
)(
  input  logic signed [NBITS-1:0] in,
  output logic        [NBITS-1:0] out
);

  assign out = in & {{(NBITS-1){~in[NBITS-1]}}, ~in[NBITS-1]};

endmodule

`endif
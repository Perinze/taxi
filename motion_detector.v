module motion_detector # (
  parameter DW = 32
) (
  input distance_pulse_10m,
  output stopping,
  input clk,
  input rst_n
);

// avg speed < 3.3 m/s
localparam STOP_THRESHOLD = 32'd3333;

wire [DW-1:0] cnt;

timer stopwatch (
  .enable(1'b1),
  .qout(cnt),
  .clk(clk),
  .rst_n(~distance_pulse_10m)
);

assign stopping = cnt > STOP_THRESHOLD;

endmodule
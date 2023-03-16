module wait_display # (
  parameter DW = 32,
  parameter CNT_6S = {DW{1'b1}}
) (
  input           enable,
  output [DW-1:0] display_duration,
  input           clk,
  input           rst_n
);

timer # (
  .MAX(CNT_6S)
) timer_6s (
  .enable(stopping),
  .irq(wait_pulse_6s),
  .clk(clk),
  .rst_n(rst_n)
);

reg [DW-1:0] duration;
wire [DW-1:0] duration_next;

assign duration_next = duration + 32'd1;

always @(posedge wait_pulse_6s or negedge rst_n) begin
  if (rst_n == 1'b0)
    duration <= 32'd0;
  else
    duration <= duration_next;
end

endmodule
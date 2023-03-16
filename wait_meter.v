module wait_meter # (
  parameter DW = 32,
  parameter CNT_3MIN = 32'd100,
  parameter PRICE_WAIT_1ST = 32'd0,
  parameter PRICE_WAIT_2ND = 32'd7,
  parameter PRICE_WAIT_3RD = 32'd10
) (
  input stopping,
  input is_stage_1st,
  input is_stage_2nd,
  input is_stage_3rd,
  output [DW-1:0] total_price
);

reg [DW-1:0] wait_total_price = {DW{1'b0}};
wire [DW-1:0] wait_total_price_next;
wire [DW-1:0] current_wait_unit_price;
wire wait_pulse_3min;
wire stopping;

timer # (
  .MAX(CNT_3MIN)
) timer_3min (
  .enable(stopping),
  .irq(wait_pulse_3min),
  .clk(clk),
  .rst_n(rst_n)
);

always @(posedge wait_pulse_3min or negedge rst_n) begin
  if (rst_n == 1'b0)
    wait_total_price <= {DW{1'b0}};
  else
    wait_total_price <= wait_total_price_next;
end

assign wait_total_price_next =
  wait_total_price + current_wait_unit_price;

assign current_wait_unit_price =
    ({DW{is_stage_1st}} & PRICE_WAIT_1ST)
  | ({DW{is_stage_2nd}} & PRICE_WAIT_2ND)
  | ({DW{is_stage_3rd}} & PRICE_WAIT_3RD);

assign total_price = wait_total_price;

endmodule
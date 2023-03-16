module distance_meter # (
  parameter DW = 32,
  parameter CNT_500M = 32'd100,
  parameter INITIAL_PRICE = 32'd80,
  parameter PRICE_DISTANCE_1ST = 32'd0,
  parameter PRICE_DISTANCE_2ND = 32'd14,
  parameter PRICE_DISTANCE_3RD = 32'd20
) (
  input pulse_10m,
  input is_stage_1st,
  input is_stage_2nd,
  input is_stage_3rd,
  output [DW-1:0] total_price
);
reg [DW-1:0] distance_total_price = INITIAL_PRICE;
wire [DW-1:0] distance_total_price_next;
wire [DW-1:0] current_distance_unit_price;
wire distance_pulse_500m;

timer # (
  .MAX(CNT_500M)
) counter_500m (
  .enable(1'b1),
  .irq(distance_pulse_500m),
  .clk(distance_pulse_10m),
  .rst_n(rst_n)
);

always @(posedge distance_pulse_500m or negedge rst_n) begin
  if (rst_n == 1'b0)
    distance_total_price <= INITIAL_PRICE;
  else
    distance_total_price <= distance_total_price_next;
end

assign distance_total_price_next =
  distance_total_price + current_distance_unit_price;

assign current_distance_unit_price =
    ({DW{is_stage_1st}} & PRICE_DISTANCE_1ST)
  | ({DW{is_stage_2nd}} & PRICE_DISTANCE_2ND)
  | ({DW{is_stage_3rd}} & PRICE_DISTANCE_3RD);

assign total_price = distance_total_price;

endmodule
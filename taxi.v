module taxi # (
  parameter DW = 32,
  parameter INITIAL_PRICE = 32'd80,
  parameter BORDER_1ST = 32'd400,
  parameter BORDER_2ND = 32'd1000,
  parameter PRICE_DISTANCE_1ST = 32'd0,
  parameter PRICE_DISTANCE_2ND = 32'd14,
  parameter PRICE_DISTANCE_3RD = 32'd20,
  parameter PRICE_WAIT_1ST = 32'd0,
  parameter PRICE_WAIT_2ND = 32'd7,
  parameter PRICE_WAIT_3RD = 32'd10,
  parameter CNT_6S = 32'd100,
  parameter CNT_500M = 32'd100,
  parameter CNT_3MIN = 32'd100
) (
  input           distance_pulse_10m,
  output [DW-1:0] distance,
  output [DW-1:0] duration,
  output [DW-1:0] total,
  input           clk, // 1kHz
  input           rst_n
);

// detect motion
wire stopping;
motion_detector md0 (
  .distance_pulse_10m(distance_pulse_10m),
  .stopping(stopping),
  .clk(clk),
  .rst_n(rst_n)
);

// wait time, for display only
wire [DW-1:0] display_duration;
wait_display # (
  .DW(DW),
  .CNT_6S(CNT_6S)
) wait_display0 (
  .enable(stopping),
  .display_duration(display_duration),
  .clk(clk),
  .rst_n(rst_n)
);

// distance, for display and stage
wire [DW-1:0] distance;
distance_accumulator da0 (
  .pulse(distance_pulse),
  .total(distance),
  .rst_n(rst_n)
);

// stage division
wire is_stage_1st;
wire is_stage_2nd;
wire is_stage_3rd;

assign is_stage_1st =
    distance <= BORDER_1ST;

assign is_stage_2nd =
    (~is_stage_1st)
  & (distance <= BORDER_2ND);

assign is_stage_3rd =
    (~is_stage_1st)
  & (~is_stage_2nd);

// distance meter
wire [DW-1:0] distance_total_price;
distance_meter # (
  .CNT_500M(CNT_500M)
) distance_meter0 (
  .pulse_10m(distance_pulse_10m),
  .is_stage_1st(is_stage_1st),
  .is_stage_2nd(is_stage_2nd),
  .is_stage_3rd(is_stage_3rd),
  .total_price(distance_total_price)
);

// wait meter
wire [DW-1:0] wait_total_price;
wait_meter # (
  .CNT_3MIN(CNT_3MIN)
) wait_meter0 (
  .stopping(stopping),
  .is_stage_1st(is_stage_1st),
  .is_stage_2nd(is_stage_2nd),
  .is_stage_3rd(is_stage_3rd),
  .total_price(wait_total_price)
);

// total price
assign total = distance_total_price + wait_total_price;
  
endmodule
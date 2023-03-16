`timescale 1ms/1ns
module taxi_test;

reg clk;
reg rst_n;

initial begin
    $dumpfile("taxi_test.vcd");
    $dumpvars(0, taxi_test);
end

always #(0.5)
  clk = ~clk;

initial begin
  clk <= 1'b0;
  rst_n <= 1'b0;
  #(1) rst_n <= 1'b1;
end

reg         distance_pulse_10m;
wire [31:0] distance;
wire [31:0] duration;
wire [31:0] total;

taxi taxi0 (
  .distance_pulse_10m(distance_pulse_10m),
  .distance(distance),
  .duration(duration),
  .total(total),
  .clk(clk),
  .rst_n(rst_n)
);

initial begin
  distance_pulse_10m <= 1'b0;

  #(7000) // 0 m/s
  // no pulse

  #(20000) // 0.5 m/s
  distance_pulse_10m <= 1'b1; #(1) distance_pulse_10m <= 1'b0;

  #(10000) // 1 m/s
  distance_pulse_10m <= 1'b1; #(1) distance_pulse_10m <= 1'b0;

  #(5000) // 2 m/s
  distance_pulse_10m <= 1'b1; #(1) distance_pulse_10m <= 1'b0;

  #(20000) // 0.5 m/s
  distance_pulse_10m <= 1'b1; #(1) distance_pulse_10m <= 1'b0;

  #(1000) // 10 m/s
  distance_pulse_10m <= 1'b1; #(1) distance_pulse_10m <= 1'b0;

  #(500) // 20 m/s
  distance_pulse_10m <= 1'b1; #(1) distance_pulse_10m <= 1'b0;

  #(250) // 40 m/s
  distance_pulse_10m <= 1'b1; #(1) distance_pulse_10m <= 1'b0;

  #(250) // 40 m/s
  distance_pulse_10m <= 1'b1; #(1) distance_pulse_10m <= 1'b0;

  #(250) // 40 m/s
  distance_pulse_10m <= 1'b1; #(1) distance_pulse_10m <= 1'b0;

  #(250) // 40 m/s
  distance_pulse_10m <= 1'b1; #(1) distance_pulse_10m <= 1'b0;

  #(500) // 20 m/s
  distance_pulse_10m <= 1'b1; #(1) distance_pulse_10m <= 1'b0;

  #(1000) // 10 m/s
  distance_pulse_10m <= 1'b1; #(1) distance_pulse_10m <= 1'b0;

  #(2000) // 5 m/s
  distance_pulse_10m <= 1'b1; #(1) distance_pulse_10m <= 1'b0;

  #(48000)
  $finish;
end

endmodule
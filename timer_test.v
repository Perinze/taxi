`timescale 1s/1ms
module timer_test;

reg clk;
reg rst_n;

initial begin
    $dumpfile("timer_test.vcd");
    $dumpvars(0, timer_test);
end

always #(0.5)
  clk = ~clk;

initial begin
  clk <= 1'b0;
  rst_n <= 1'b0;
  #(1) rst_n <= 1'b1;
end

reg       enable;
wire      irq;

timer # (
  .DW(8),
  .MAX(14)
) timer0 (
  .enable(enable),
  .irq(irq),
  .clk(clk),
  .rst_n(rst_n)
);

initial begin
  enable <= 1'b1;
  #(17)
  enable <= 1'b0;
  #(4)
  enable <= 1'b1;
  #(48)
  $finish;
end

endmodule
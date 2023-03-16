module timer # (
  parameter DW = 32,
  parameter MAX = 32'hffffffff
) (
  input           enable,
  output [DW-1:0] qout,
  output          irq,
  input           clk,
  input           rst_n
);

localparam addend = {{(DW-1){1'b0}}, 1'b1};

reg [DW-1:0] cnt;
wire [DW-1:0] cnt_added;
wire [DW-1:0] cnt_next;

assign irq = cnt == MAX;

assign cnt_added =
    ({DW{ irq}} & addend)
  | ({DW{~irq}} & (cnt + addend));

assign cnt_next =
    ({DW{ enable}} & cnt_added)
  | ({DW{~enable}} & cnt);

always @(posedge clk or negedge rst_n) begin
  if (rst_n == 1'b0)
    cnt <= {DW{1'b0}};
  else
    cnt <= cnt_next;
end

assign qout = cnt;

endmodule
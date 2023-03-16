module distance_accumulator # (
  parameter DW = 32
) (
  input pulse,
  output [DW-1:0] total,
  input rst_n
);

reg [DW-1:0] distance;

always @(posedge pulse or negedge rst_n) begin
  if (rst_n == 1'b0)
    distance <= 32'd0;
  else
    distance <= distance + 32'd1;
end

assign total = distance;

endmodule
module Random (clk, out);
    
	 input clk;
    output wire [15: 0] out;

    reg [31: 0] state = 0;

    always @(posedge clk) begin
        state <= state * 32'h343fd + 32'h269EC3;
    end

    assign out = (state >> 16) & 16'h7fff;

endmodule
module VGA_Render(valid, RGB, vga_R, vga_G, vga_B);

    input wire valid;
    input wire [7: 0] RGB;
    output wire [2: 0] vga_R, vga_G;
    output wire [1: 0] vga_B;

    assign vga_R = valid ? RGB[7: 5] : 3'b000;
    assign vga_G = valid ? RGB[4: 2] : 3'b000;
    assign vga_B = valid ? RGB[1: 0] : 2'b00;

endmodule

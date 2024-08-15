module tb_regs;

    localparam LENGTH = 18;
    reg clk;
    reg clk_en;
    reg rst;
    reg [LENGTH-1:0] in_signal;
    wire [LENGTH-1:0] out_signal_wire;
    wire [LENGTH-1:0] out_signal_reg;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

regs #(.USE_REG(0),.LENGTH(LENGTH),
    .RST_MODE("SYNC")) uut_wire (.clk(clk),.clk_en(clk_en),.rst(rst),.in_signal(in_signal),
                                .out_signal(out_signal_wire)
                               );
regs #(.USE_REG(1),.LENGTH(LENGTH),
    .RST_MODE("SYNC")) uut_reg (.clk(clk),.clk_en(clk_en),.rst(rst),.in_signal(in_signal),
                                .out_signal(out_signal_reg)
                                );

    initial begin
        clk_en = 0;
        rst = 0;
        in_signal = 0;
        rst = 1;
        #10;
        rst = 0;
        in_signal = 18'h3FFFF;
        clk_en = 1;
        #10;
        in_signal = 18'h00001;
        #10;
        in_signal = 18'h12345;
        #10;
        in_signal = 18'h54321;
        clk_en = 1;
        #20;
        in_signal = 18'h00002;
        #10;
        $stop;
    end
endmodule

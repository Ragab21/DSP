module regs(clk,clk_en,rst,in_signal,out_signal);
parameter USE_REG = 0;
parameter LENGTH = 18;
parameter RST_MODE = "SYNC";
input wire clk,clk_en;
input wire rst;
input wire [LENGTH-1:0] in_signal;
output reg [LENGTH-1:0] out_signal;

generate
    if (USE_REG == 1 && RST_MODE == "ASYNC") begin
        always @(posedge clk or posedge rst) begin
            if (rst)
                out_signal <= 0;
            else if (clk_en)
                out_signal <= in_signal;
        end
    end else if(USE_REG == 1 && RST_MODE == "SYNC") begin
    	always @(posedge clk) begin
            if (rst)
                out_signal <= 0;
            else if (clk_en)
                out_signal <= in_signal;
        end
    end else begin
        always @(*) begin
            out_signal = in_signal;
        end
    end
endgenerate

endmodule

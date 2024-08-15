module DSP(A,B,C,D,CARRYIN,M,P,CARRYOUT,CARRYOUTF,clk,OPMODE,
		   CEA,CEB,CEC,CED,CECARRYIN,CEM,CEOPMODE,CEP,
		   RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,
		   BCOUT,PCIN,BCIN,PCOUT);
parameter A0REG = 0;
parameter A1REG = 1;
parameter B0REG = 0;
parameter B1REG = 1;
parameter CREG = 1;
parameter DREG=1;
parameter MREG = 1;
parameter PREG = 1;
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL = "OPMODE5"; //string CARRYIN or OPMODE5 else out -> 0
parameter B_INPUT = "DIRECT"; //B input (attribute = DIRECT) or the cascaded input(BCIN) from the previous DSP48A1 slice (attribute = CASCADE).
parameter RSTTYPE = "SYNC";//send in instantiation

input [17:0]A,B,D;
input [47:0]C,PCIN;
input CARRYIN,clk,CEA,CEB,CEC,CED,CEM,CEP,CECARRYIN,CEOPMODE;
input [17:0]BCIN;
input RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;
input [7:0]OPMODE;

output [47:0]P;
output [35:0]M;
output [17:0]BCOUT;
output [47:0]PCOUT;
output CARRYOUT,CARRYOUTF;

wire [7:0]OPMODE_out;
wire [17:0]B_IN;
wire [17:0]D_out;
wire [17:0]B0_out; //D and B0 get added
wire [17:0]Pre_AS_out;
wire [17:0]M1_out;
wire [17:0]A0_out;
wire [47:0]C_out;
wire [17:0]A1_out;
wire [17:0]B1_out;
wire [35:0]Mult_out;
wire [35:0]M_out;//out of instan
reg [47:0]Mx_out;
reg [47:0]Mz_out;
wire [48:0]Post_AS_out;//[48] is for carryout
wire [47:0]P_out;
wire CYI_IN;
wire CYI_OUT;
wire CYO_OUT;//the in is Post_AS_out[48]
wire [47:0]D_CONC;

generate
	if(B_INPUT == "DIRECT") begin
		assign B_IN = B;
	end
	else if(B_INPUT == "CASCADE") begin
		assign B_IN = BCIN;
	end
endgenerate

generate
	if(CARRYINSEL == "OPMODE5") begin
		assign CYI_IN = OPMODE_out[5];
	end
	else if(CARRYINSEL == "CARRYIN") begin
		assign CYI_IN = CARRYIN;
	end
endgenerate

//--------------------------------Instantiations-------------------------\\


regs #(.USE_REG(OPMODEREG),.LENGTH(8),.RST_MODE(RSTTYPE)) OPMODE_REG (
    .clk(clk),
    .clk_en(CEOPMODE),
    .rst(RSTOPMODE),
    .in_signal(OPMODE),
    .out_signal(OPMODE_out)
);

regs #(.USE_REG(DREG),.LENGTH(18),.RST_MODE(RSTTYPE)) D_REG (
    .clk(clk),
    .clk_en(CED),
    .rst(RSTD),
    .in_signal(D),
    .out_signal(D_out)
);

regs #(.USE_REG(B0REG),.LENGTH(18),.RST_MODE(RSTTYPE)) B0_REG (
    .clk(clk),
    .clk_en(CEB),
    .rst(RSTB),
    .in_signal(B_IN),
    .out_signal(B0_out)
);

regs #(.USE_REG(A0REG),.LENGTH(18),.RST_MODE(RSTTYPE)) A0_REG (
    .clk(clk),
    .clk_en(CEA),
    .rst(RSTA),
    .in_signal(A),
    .out_signal(A0_out)
);

regs #(.USE_REG(CREG),.LENGTH(48),.RST_MODE(RSTTYPE)) C_REG (
    .clk(clk),
    .clk_en(CEC),
    .rst(RSTC),
    .in_signal(C),
    .out_signal(C_out)
);

regs #(.USE_REG(B1REG),.LENGTH(18),.RST_MODE(RSTTYPE)) B1_REG (
    .clk(clk),
    .clk_en(CEB),
    .rst(RSTB),
    .in_signal(M1_out),
    .out_signal(B1_out)
);

regs #(.USE_REG(A1REG),.LENGTH(18),.RST_MODE(RSTTYPE)) A1_REG (
    .clk(clk),
    .clk_en(CEA),
    .rst(RSTA),
    .in_signal(A0_out),
    .out_signal(A1_out)
);

regs #(.USE_REG(MREG),.LENGTH(36),.RST_MODE(RSTTYPE)) M_REG (
    .clk(clk),
    .clk_en(CEM),
    .rst(RSTM),
    .in_signal(Mult_out),
    .out_signal(M_out)
);

regs #(.USE_REG(CARRYINREG),.LENGTH(1),.RST_MODE(RSTTYPE)) CYI_REG (
    .clk(clk),
    .clk_en(CECARRYIN),
    .rst(RSTCARRYIN),
    .in_signal(CYI_IN),
    .out_signal(CYI_OUT)
);

regs #(.USE_REG(CARRYOUTREG),.LENGTH(1),.RST_MODE(RSTTYPE)) CYO_REG (
    .clk(clk),
    .clk_en(CECARRYIN),
    .rst(RSTCARRYIN),
    .in_signal(Post_AS_out[48]),
    .out_signal(CYO_OUT)
);

regs #(.USE_REG(PREG),.LENGTH(48),.RST_MODE(RSTTYPE)) P_REG (
    .clk(clk),
    .clk_en(CEP),
    .rst(RSTP),
    .in_signal(Post_AS_out[47:0]),
    .out_signal(P)
);

//------------------------------------------------------------------------\\


assign Pre_AS_out = (OPMODE_out[6])? D_out - B0_out : D_out + B0_out;
assign Post_AS_out = (OPMODE_out[7])? Mz_out - (Mx_out + CYI_OUT) : Mz_out + Mx_out + CYI_OUT;
assign M1_out = (OPMODE_out[4])? Pre_AS_out : B0_out;
assign Mult_out = B1_out * A1_out;
assign D_CONC = {D_out[11:0],A1_out[17:0],B1_out[17:0]};
assign BCOUT = B1_out;
assign M = M_out;
assign CARRYOUTF = CYO_OUT;
assign CARRYOUT = CYO_OUT;
assign PCOUT = P;

always @(*) begin
	case(OPMODE_out[3:2])
		2'b00 : Mz_out = 48'b0;
		2'b01 : Mz_out = PCIN;
		2'b10 : Mz_out = P;
		2'b11 : Mz_out = C_out;
	endcase
end

always @(*) begin
	case(OPMODE_out[1:0])
		2'b00 : Mx_out = 48'b0;
		2'b01 : Mx_out = {12'b000000000000,Mult_out};
		2'b10 : Mx_out = P;
		2'b11 : Mx_out = D_CONC;
	endcase
end

endmodule
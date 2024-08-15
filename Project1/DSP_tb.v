module tb_DSP;

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
parameter CARRYINSEL = "OPMODE5"; 
parameter B_INPUT = "DIRECT"; 
parameter RSTTYPE = "SYNC";

reg [17:0] A;
reg [17:0] B;
reg [17:0] D;
reg [47:0] C;
reg [47:0] PCIN;
reg CARRYIN;
reg clk;
reg CEA;
reg CEB;
reg CEC;
reg CED;
reg CEM;
reg CEP;
reg CECARRYIN;
reg CEOPMODE;
reg [17:0] BCIN;
reg RSTA;
reg RSTB;
reg RSTC;
reg RSTCARRYIN;
reg RSTD;
reg RSTM;
reg RSTOPMODE;
reg RSTP;
reg [7:0] OPMODE;


wire [47:0] P;
wire [35:0] M;
wire [17:0] BCOUT;
wire [47:0] PCOUT;
wire CARRYOUT;
wire CARRYOUTF;

wire [47:0] P2;
wire [35:0] M2;
wire [17:0] BCOUT2;
wire [47:0] PCOUT2;
wire CARRYOUT2;
wire CARRYOUTF2;
 
// Instantiate the DSP module
DSP #(.A0REG(A0REG),.A1REG(A1REG),.B0REG(B0REG),.B1REG(B1REG),.CREG(CREG),.DREG(DREG),.MREG(MREG),
    .PREG(PREG),.CARRYINREG(CARRYINREG),.CARRYOUTREG(CARRYOUTREG),.OPMODEREG(OPMODEREG),
    .CARRYINSEL(CARRYINSEL),.B_INPUT(B_INPUT),.RSTTYPE(RSTTYPE)
     ) dut (.A(A),.B(B),.C(C),.D(D),.CARRYIN(CARRYIN),.clk(clk),.CEA(CEA),.CEB(CEB),.CEC(CEC),.CED(CED),.CEM(CEM),
            .CEP(CEP),.CECARRYIN(CECARRYIN),.CEOPMODE(CEOPMODE),.BCIN(BCIN),.RSTA(RSTA),.RSTB(RSTB),.RSTC(RSTC),
            .RSTCARRYIN(RSTCARRYIN),.RSTD(RSTD),.RSTM(RSTM),.RSTOPMODE(RSTOPMODE),.RSTP(RSTP),.OPMODE(OPMODE),.P(P),.M(M),
            .BCOUT(BCOUT),.PCIN(PCIN),.PCOUT(PCOUT),.CARRYOUT(CARRYOUT),.CARRYOUTF(CARRYOUTF)
           );

DSP #(.A0REG(A0REG),.A1REG(A1REG),.B0REG(B0REG),.B1REG(B1REG),.CREG(CREG),.DREG(DREG),.MREG(MREG),
    .PREG(PREG),.CARRYINREG(CARRYINREG),.CARRYOUTREG(CARRYOUTREG),.OPMODEREG(OPMODEREG),
    .CARRYINSEL("CARRYIN"),.B_INPUT("CASCADE"),.RSTTYPE(RSTTYPE)
     ) dut_2 (.A(A),.B(B),.C(C),.D(D),.CARRYIN(CARRYIN),.clk(clk),.CEA(CEA),.CEB(CEB),.CEC(CEC),.CED(CED),.CEM(CEM),
            .CEP(CEP),.CECARRYIN(CECARRYIN),.CEOPMODE(CEOPMODE),.BCIN(BCIN),.RSTA(RSTA),.RSTB(RSTB),.RSTC(RSTC),
            .RSTCARRYIN(RSTCARRYIN),.RSTD(RSTD),.RSTM(RSTM),.RSTOPMODE(RSTOPMODE),.RSTP(RSTP),.OPMODE(OPMODE),.P(P2),.M(M2),
            .BCOUT(BCOUT2),.PCIN(PCIN),.PCOUT(PCOUT2),.CARRYOUT(CARRYOUT2),.CARRYOUTF(CARRYOUTF2)
           );


initial begin
    clk = 0;
    forever #2 clk = ~clk;
end

initial begin

    A = 0;
    B = 0;
    C = 0;
    D = 0;
    PCIN = 0;
    CARRYIN = 0;
    CEA = 0;
    CEB = 0;
    CEC = 0;
    CED = 0;
    CEM = 0;
    CEP = 0;
    CECARRYIN = 0;
    CEOPMODE = 0;
    BCIN = 0;
    RSTA = 0;
    RSTB = 0;
    RSTC = 0;
    RSTCARRYIN = 0;
    RSTD = 0;
    RSTM = 0;
    RSTOPMODE = 0;
    RSTP = 0;
    OPMODE = 0;

    @(negedge clk);
    RSTA = 1; RSTB = 1; RSTC = 1; RSTD = 1; RSTM = 1; RSTP = 1; RSTCARRYIN = 1; RSTOPMODE = 1;
    @(negedge clk);
    RSTA = 0; RSTB = 0; RSTC = 0; RSTD = 0; RSTM = 0; RSTP = 0; RSTCARRYIN = 0; RSTOPMODE = 0;
    @(negedge clk);
    CEA = 1;
    CEB = 1;
    CEC = 1;
    CED = 1;
    CEM = 1;
    CEP = 1;
    CECARRYIN = 1;
    CEOPMODE = 1;
    PCIN = 48'd5;
    CARRYIN = 1'b0;
    @(negedge clk);

    A = 18'd3;
    B = 18'd4;
    C = 48'd10;
    D = 18'd7;

    OPMODE = 8'b00011101;

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    if(PCOUT != 48'd43) begin
        $display("error first test");
        $stop;
    end
    @(negedge clk);

    A = 18'd6;
    B = 18'd8;
    C = 48'd20;
    D = 18'd14;
    OPMODE = 8'b00001010;

 
    @(negedge clk);
    @(negedge clk);

    if(PCOUT != 48'd86) begin
        $display("error second test");
        $stop;
    end
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    A = 18'd1;
    B = 18'd1;
    C = 48'd1;
    D = 18'd1;
    OPMODE = 8'b00000011;

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    if(PCOUT != {D,A,B}) begin
        $display("error third test");
        $stop;
    end
    @(negedge clk);

    A = 18'd2;
    B = 18'd9;
    C = 48'd10;
    D = 18'd11;
    BCIN = 18'd8;
    CARRYIN = 1'b1;
    PCIN = 48'd20;
    OPMODE = 8'b10000101;

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    if(PCOUT2 != 48'd3) begin
        $display("error cascade test");
        $stop;
    end
    @(negedge clk);
    $stop;
end

endmodule

module MIPS(clk,reset);

  input reset,clk;

  wire [31:0]insout,jpcnew;
  wire [4:0]rw,rt;
  wire [2:0]ALUctr;
  wire [1:0]nPC_sel;

  wire RegWr,RegDst,ExtOp,ALUSrc,MemWr,MemtoReg,zero;
  wire [31:0]busA,busB,busO,busE,busB1,DataO,busW;

  assign rt = (nPC_sel==2'b11)?5'b11111:insout[20:16];

  Control cu0(insout[31:26],insout[5:0],RegDst,ALUSrc,MemtoReg,RegWr,MemWr,nPC_sel,ExtOp,ALUctr,add8);
  ifu i1(clk,reset,nPC_sel,zero,insout,jpcnew);
  MUX2X5 M1(insout[20:16],insout[15:11],RegDst,rw);
  RegFile R1(clk,RegWr,busA,busB,busW,insout[25:21],rt,rw,jpcnew);
  ext E1(insout[15:0],ExtOp,busE);
  MUX2X32 M2(busB,busE,ALUSrc,busB1);
  ALU A1(busA,busB1,ALUctr,zero,busO);
  DataMemory D1(clk,MemWr,busB,busO,DataO);
  MUX2X32 M3(busO,DataO,MemtoReg,busW);
  
endmodule
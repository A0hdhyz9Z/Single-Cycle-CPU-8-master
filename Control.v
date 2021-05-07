  module Control(op,func,RegDst,ALUSrc,MemtoReg,RegWr,MemWr,nPC_sel,ExtOp,ALUctr,add8);

  input [5:0]op,func;     //界定具体指令
  
  output RegDst;      //仅有aadu,subu用到rd寄存器才会选择1
  output ALUSrc;      //控制ALU的输入是来自寄存器堆还是扩展单元
  output MemtoReg;
  output RegWr;
  output MemWr;
  output [1:0] nPC_sel;
  output ExtOp,add8;
  output [2:0] ALUctr;
  
  wire [2:0]ADD,Or,Subtract;


  assign RegDst = (op==6'b000000)?1:0;
  assign ALUSrc = (op==6'b000000||op==6'b000100)?0:1;     //addu,subu,beq选择0
  assign MemtoReg = (op==6'b100011)?1:0;      //仅有lw选择1
  assign RegWr = (op==6'b101011||op==6'b000100)?0:1;      //仅有sw,beq选择0
  assign MemWr = (op==6'b101011)?1:0;     //仅有sw选择0
  assign nPC_sel = (op==6'b000011)?2'b11:(op==6'b000010)?2'b10:(op==6'b000100)?2'b01:2'b00;
        //依次对应jal,j,beq

  assign ExtOp = (op==6'b001101)?0:1;     //ori指令选择0

  assign ADD = 3'b000;
  assign Subtract = 3'b001;
  assign Or = 3'b100;
  assign ALUctr = (op==6'b001111)?3'b011:(op==6'b001101)?Or:(func==6'b100011||op==6'b000100)?Subtract:ADD;
      //依次对应lui,ori,subu,addu

  endmodule

module ALU(busA,busB,ALUctr,zero,Out);

  input [31:0] busA,busB;
  input [2:0] ALUctr;     //可控制lui,ori,subu,addu
  output reg zero;
  output reg [31:0]Out;
  
  wire [31:0]A;
  wire [31:0]B;
  
  assign B = busB;
  assign A = busA;
  
  always@(busA,busB,ALUctr,A,B)
    begin
      case(ALUctr)      //addu
      3'b000:begin
        Out = A+B;
        zero = (Out==0)?1:0;
      end
      3'b001:begin      //subu
        Out = A-B;
        zero = (Out==0)?1:0;
      end
      3'b100:begin      //ori进行按位或运算
        Out = A|B;
        zero = (Out==0)?1:0;
      end
      3'b011:begin      //lui把一个16位的立即数填入到寄存器的高16位，写入rt
        Out = B<<16;
        zero = (Out==0)?1:0;
      end
    endcase
  end
endmodule
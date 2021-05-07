module RegFile(clk,RegWr,busA,busB,busW,RA,RB,RW,jpcnew);

  input [4:0] RA;     //相当于rs
  input [4:0] RB;     //相当于rt
  input [4:0] RW;     //rd或rt
  input [31:0] busW;
  input [31:0] jpcnew;      //连接自IFU
  input clk;
  input RegWr;      
  
  output [31:0] busA;
  output [31:0] busB;
  
  reg [31:0] register[0:31];  
    integer i;  
    initial begin  
      for (i = 0; i < 32; i = i+1) 
        register[i] <= 0;  
    end 
  
  assign busA = register[RA];
  assign busB = register[RB];
  
  always @(RegWr or RW or busW or posedge clk) 
    begin  
      if (RegWr && RW!=5'b0)      //addu,subu需要取rd,并且满足不能是零寄存器
        register[RW] = busW;      //rd = rs +/- rt
      if(RB==5'b11111) 
        register[RB] = jpcnew;      //rt写入j采用伪直接寻址即为 pc+4后的值+imm16左移2位变为28位数+00 所获得的32位地址码
    end  
endmodule
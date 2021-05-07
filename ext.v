module ext(imm,ExtOp,Extout);

  input [15:0] imm;
  input ExtOp;

  output [31:0]Extout;
  
    assign Extout[15:0] = imm;
    assign Extout[31:16] = ExtOp?(imm[15]?16'hffff:16'h0000):16'h0000;    
          //1为符号扩展
endmodule
module test;
  reg clk,reset;
  
  MIPS ct1(clk,reset);
  initial
    begin
      clk = 1;
      reset = 0;
      #5 reset = 1;
      #5 reset = 0;
    end
    always
    begin
      #30 clk=~clk;
    end
endmodule
module DataMemory(clk,MemWr,DataIn,Addr,DataOut);

  input clk,MemWr;
  input [31:0] DataIn,Addr;

  output reg [31:0]DataOut;

  reg [7:0]memory[0:1023];
  reg [31:0] address;
    
  integer i;  
  initial begin  
    for (i=0; i<1024; i=i+1) 
      memory[i] <= 0;  
  end  
  always @(MemWr or DataIn or Addr or posedge clk)  
    begin  
    address = Addr << 2;
    DataOut = (memory[address]<<24)+(memory[address+1]<<16)+(memory[address+2]<<8)+memory[address+3];
    if (MemWr == 1) 
      begin
        address = Addr << 2;
        memory[address] = DataIn[31:24];
        memory[address+1] = DataIn[23:16];
        memory[address+2] = DataIn[15:8];
        memory[address+3] = DataIn[7:0];
      end
    end
endmodule
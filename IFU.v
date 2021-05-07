module ifu(clk,reset,npc_sel,zero,insout,jpcnew);

  input clk,reset,zero;     //时钟，重置，0（用于比较）
  input [1:0]npc_sel;     //选择t0(addu,subu,ori,lw,sw)还是t1(beq)
  output [31:0]insout;      //输出的指令
  output [31:0]jpcnew;      //j指令后的新地址

  reg [31:0]pc;     //pc计数器
  wire [31:0] pcnew;    //pc计数器的新值
  wire [31:0] t1；      //传输beq指令的地址码=(pc+4)接imm16经符号位扩展后的32位后左移2位
  wire [31:0] t0;      //addu,subu,ori,lw,sw均采用pc+4的地址码
  wire [31:0] extout;     //传输imm16经符号位扩展后的32位后左移2位后的值(beq)
  wire [31:0] immext;     //传输imm16经符号位扩展后的32位的值(beq)
  wire [31:0] jbranch;      //传输j采用伪直接寻址即为 pc+4后的值+imm16左移2位变为28位数+00 所获得的32位地址码
  wire [31:0] jpcnew;     //执行j指令后pc的新值
  wire [15:0] imm16;      //16位立即数
  wire [25:0] imm26;      //26位立即数
  reg [7:0] im[1023:0];   //声明1KB的im(命令存储器)，8根线，包含1024个的数组
  
  initial begin
      $readmemh("code.txt",im);     //读取指令
  end
  
  assign insout = {im[pc[9:0]], im[pc[9:0]+1], im[pc[9:0]+2], im[pc[9:0]+3]};     
        //取指令，一次取8位，连续去四次，合计32位为一条指令
  assign imm16 = insout[15:0];      //传输指令第1位至第16位，用于lui,ori,sw,lw的立即数和beq的扩展
  assign imm26 = insout[25:0];      //传输指令第1位至第26位，用于j指令的26位的地址码
  assign immext = {{16{imm16[15]}},imm16};      
        //beq指令符号扩展，{16{imm16[15]}意为将imm16的第16位(即符号位)扩展16次，{{16{imm16[15]}},imm16}最后在连接imm16
  assign extout = immext<<2;      //beq,j都需要左移2位
  assign jbranch = {t0[31:28],imm26,2'b0};
        //j采用伪直接寻址即为 pc+4后的值+imm16左移2位变为28位数+00 
  
  always@(posedge clk,posedge reset)
  /*
    1、always语句有两种触发方式。第一种是电平触发，例如always @(a or b or c)，a、b、c均为变量，当其中一个发生变化时，下方的语句将被执行。
    2、第二种是沿触发，例如always @(posedge clk or negedge rstn)，即当时钟处在上升沿或下降沿时，语句被执行。
  */
  begin
    if(reset) pc = 32'h0000_3000;     //当Reset信号为高电平时（同步），重置PC为0x00003000
    else pc = pcnew;      //当时钟上升沿到来时将pcnew写入PC内部，并且输出
  end
    
  assign pcnew = (npc_sel==2'b10||npc_sel==2'b11)?jbranch:(npc_sel&&zero)?t1:t0;
assign jpcnew = pc+8;     //计算j指令后pc的新值
  assign t0 = pc+4;     //addu,subu,ori,lw,sw均采用pc+4的顺序寻址
  assign t1 = t0+extout;      //计算beq指令的地址码=(pc+4)接imm16经符号位扩展后的32位后左移2位
endmodule




module ifu(clk,reset,npc_sel,zero,insout,jpcnew);

  input clk,reset,zero;     //时钟，重置，0（用于比较）
  input [1:0]npc_sel;     //选择t0(addu,subu,ori,lw,sw)还是t1(beq)
  output [31:0]insout;      //输出的指令
  output [31:0]jpcnew;      //j指令后的新地址

  reg [31:0]pc;     //pc计数器
  wire [31:0] pcnew;    //pc计数器的新值
  wire [31:0] t1；      //传输beq指令的地址码=(pc+4)接imm16经符号位扩展后的32位后左移2位
  wire [31:0] t0;      //addu,subu,ori,lw,sw均采用pc+4的地址码
  wire [31:0] extout;     //传输imm16经符号位扩展后的32位后左移2位后的值(beq)
  wire [31:0] immext;     //传输imm16经符号位扩展后的32位的值(beq)
  wire [31:0] jbranch;      //传输j采用伪直接寻址即为 pc+4后的值+imm16左移2位变为28位数+00 所获得的32位地址码
  wire [31:0] jpcnew;     //执行j指令后pc的新值
  wire [15:0] imm16;      //16位立即数
  wire [25:0] imm26;      //26位立即数
  reg [7:0] im[1023:0];   //声明1KB的im(命令存储器)，8根线，包含1024个的数组
  
  initial begin
      $readmemh("code.txt",im);     //读取指令
  end
  
  assign insout = {im[pc[9:0]], im[pc[9:0]+1], im[pc[9:0]+2], im[pc[9:0]+3]};     
        //取指令，一次取8位，连续去四次，合计32位为一条指令
  assign imm16 = insout[15:0];      //传输指令第1位至第16位，用于lui,ori,sw,lw的立即数和beq的扩展
  assign imm26 = insout[25:0];      //传输指令第1位至第26位，用于j指令的26位的地址码
  assign immext = {{16{imm16[15]}},imm16};      
        //beq指令符号扩展，{16{imm16[15]}意为将imm16的第16位(即符号位)扩展16次，{{16{imm16[15]}},imm16}最后在连接imm16
  assign extout = immext<<2;      //beq,j都需要左移2位
  assign jbranch = {t0[31:28],imm26,2'b0};
        //j采用伪直接寻址即为 pc+4后的值+imm16左移2位变为28位数+00 
  
  always@(posedge clk,posedge reset)
  /*
    1、always语句有两种触发方式。第一种是电平触发，例如always @(a or b or c)，a、b、c均为变量，当其中一个发生变化时，下方的语句将被执行。
    2、第二种是沿触发，例如always @(posedge clk or negedge rstn)，即当时钟处在上升沿或下降沿时，语句被执行。
  */
  begin
    if(reset) pc = 32'h0000_3000;     //当Reset信号为高电平时（同步），重置PC为0x00003000
    else pc = pcnew;      //当时钟上升沿到来时将pcnew写入PC内部，并且输出
  end

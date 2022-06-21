
module main(pc,PC,a,clk ,ALU_result ,wr_data,rd_data ,Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch,PCsrc  );
input [31:0]pc;input clk;
output [31:0]ALU_result,wr_data,rd_data,PC;
/////////////////////////////////////////////////////////////////////////////////
output [31:0]a ;   // cau lenh 
wire [31:0]PCN;  // pc tiep theo 
wire [3:0]ALUop; 
output Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch,PCsrc;
wire [31:0] imm;reg [31:0] rs1 , rs2 , rd;
wire [31:0]mux_alu;wire zero;
reg [31:0]rb[31:0];
wire rst ;
reg rst1 ,rsss;
 always@(posedge clk )
begin 
if ( rst1==0) rsss<=0;
else begin 
rb[0]<=32'd0;rb[1]<=32'd0;rb[2]<=32'd0;rb[32'd3]<=32'd0;rb[32'd4]<=32'd0;rb[32'd5]<=32'd0;rb[32'd6]<=32'd0;rb[32'd7]<=32'd0;rb[32'd8]<=32'd0;rb[32'd9]<=32'd0;
rb[10]<=32'd0;rb[11]<=32'd0;rb[12]<=32'd0;rb[32'd13]<=32'd0;rb[32'd14]<=32'd0;rb[32'd15]<=32'd0;rb[32'd16]<=32'd0;rb[32'd17]<=32'd0;rb[32'd18]<=32'd0;rb[32'd19]<=32'd0;
rb[30]<=32'd0;rb[31]<=32'd0;
rst1 <=0;
end end
/////////////////////////////////////////////////////////////////////////////
inst_mem a2(pc , a);
assign rst=0;
assign ALUop = {a[30],a[14:12]};
imm a3(a ,imm);
controlunit u1(a,Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch);
always @(posedge clk ) 
begin 
  rs1<=rb[a[19:15]] ;
  rs2<=rb[a[24:20]] ;
end 
MUX a8( rs2 ,imm , mux_alu ,  ALUsrc);
ALU a9(rs1,mux_alu,ALUop,zero,ALU_result);
assign PCsrc =Branch & zero ;
PC a1(imm, PCsrc,pc,PC,clk,rst);
data_mem a10(clk,a,Memwrite, Memread , ALU_result,rs2 , rd_data);
MUX a11( ALU_result ,rd_data ,  wr_data ,  Memtoreg);
always @(posedge clk ) 
begin 
  if (Regwrite==1)
   rb[a[11:7]]<=wr_data ;
end 
endmodule 
module t_main ;
reg [31:0]pc;
reg clk;
wire [31:0]a;
wire Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch,PCsrc;
wire [31:0]ALU_result,wr_data,rd_data,PC;
parameter time_out = 100;
main u1(pc,PC,a,clk ,ALU_result ,wr_data,rd_data,Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch,PCsrc   ); 
initial $monitor($time," pc %h,pcn %h , a %h ,ALU_result %h ,wr_data  %h ,rd_data %h ,Regwrite %d, ALUsrc %d, Memtoreg %d, Memread %d, Memwrite %d, Branch %d,PCsrc %d " ,pc,PC,a,ALU_result ,wr_data,rd_data,Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch,PCsrc );
initial begin
	clk = 0;
end
always #5 clk = ~clk;
initial
begin 
#5 pc= 32'd4;
#20 pc = 32'd8;
#20 pc = 32'd16;
#20 pc= -20;
#300 $finish;
 end
endmodule
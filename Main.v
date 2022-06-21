module CPU(clk , pc,pc_imm,a,imm ,PCsrc,ALU_result2,rs1,rs2,rd,wr_data,rd_data,Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch,Cen,Ben,Aen,Jen,Jsel,ALUop,zero  );
input          clk ;
output [31:0]  pc,pc_imm;
output [31:0]  a,imm,ALU_result2,rs1,rs2,wr_data,rd_data ;
output         PCsrc,Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch,Cen,Ben,Aen,Jen,Jsel,zero;
output [10:0]  ALUop;
output [4:0]   rd;
//////////////////////////////////////////////////////
wire    [31:0]  pc_imm2,pc_imm1;
reg    [31:0]  pc_4,pc_imm;
reg            rst, rss;
reg            PCsrc;
wire   [31:0]  pc_4out,pc_out,pc,mux_alu1,mux_alu2,ALU_result,ALU_result1,ALU_result2;
reg    [31:0]  rs1,rs2;
wire           Regwrite,ALUsrc, Memtoreg, Memread, Memwrite, Branch,Cen,Ben,Aen,Jen,Jsel,zero;
wire   [10:0]  ALUop;
wire   [31:0]  imm,wr_data,wr_data1,wr_data2;
reg    [31:0]  rd_data,b,c,d;
reg    [31:0]  rb[31:0];
wire   [4:0]   rd;
reg [31:0]mem[1000:0];
///////////////////////////////////////////
always@(posedge clk )
begin 
  if ( rst==0) begin  
    rss  <= 0;
    pc_4 <= pc_4out;
    PCsrc<= Branch & zero;
    pc_imm <= pc_imm2;
  end 
  else begin 
      pc_imm <= 32'd0;
      pc_4   <= 32'd0;
      PCsrc  <= 32'd0; 
      rst    <= 0;
rb[0]<=32'd0;rb[1]<=32'd0;rb[2]<=32'd0;rb[32'd3]<=32'd0;rb[32'd4]<=32'd0;rb[32'd5]<=32'd0;rb[32'd6]<=32'd0;rb[32'd7]<=32'd0;rb[32'd8]<=32'd0;rb[32'd9]<=32'd0;
rb[10]<=32'd0;rb[11]<=32'd0;rb[12]<=32'd0;rb[32'd13]<=32'd0;rb[32'd14]<=32'd0;rb[32'd15]<=32'd0;rb[32'd16]<=32'd0;rb[32'd17]<=32'd0;rb[32'd18]<=32'd0;rb[32'd19]<=32'd0;
rb[20]<=32'd0;rb[21]<=32'd0;rb[22]<=32'd0;rb[32'd23]<=32'd0;rb[32'd24]<=32'd0;rb[32'd25]<=32'd0;rb[32'd26]<=32'd0;rb[32'd27]<=32'd0;rb[32'd28]<=32'd0;rb[32'd29]<=32'd0;
rb[30]<=32'd0;rb[31]<=32'd0;
  end
  if (Regwrite==1)
rb[rd]<=wr_data2 ;
  /*if (Memwrite ==1)
   mem[ALU_result]<=rs2 ;*/
 
   if (Memwrite ==1) begin 
           //  c<= { 24'd0,rs2[7:0]};
           //  d<= { 16'd0,rs2[15:0]};
                case(a[14:12])
3'b000 :   mem[ALU_result]<= { 24'd0,rs2[7:0]} ; // sb
3'b001 :   mem[ALU_result]<= { 16'd0,rs2[15:0]} ; // sh
//3'b010 :   mem[ALU_result]<=wr_data ;   // sw
default mem[ALU_result]<=rs2 ;   // sw
                endcase
              end 
   
end

//////////////////////////////////////////////////
MUX a1( pc_4 , pc_imm, pc ,PCsrc );
PC_4 a2(pc,pc_4out);
inst_mem a3(pc , a);
assign ALUop = {a[30],a[14:12],a[6:0]};
imm a4(a ,imm);
controlunit a5(a[6:0],Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch,Cen,Ben,Aen,Jen,Jsel);
///always @(*)
//begin 
 assign rs1 =rb[a[19:15]];
 assign rs2 =rb[a[24:20]];
//end
assign rd =a[11:7];
MUX a8( rs2 ,imm , mux_alu1 ,  ALUsrc);
MUX a9 ( rs1 ,pc , mux_alu2 ,  Aen);                 //// 4 lenh LUI AUIPC JAl

ALU a12(mux_alu2,mux_alu1,ALUop,zero,ALU_result);
assign pc_out = pc+4;                                //// 2 lenh JAL JALR
assign pc_imm1 = pc+imm;                             //// lenh JAL
//MUX a13 ( pc ,rs1 , mux_alu2 ,  Aen);
//data_mem a10(clk,Memwrite, Memread , ALU_result,rs2 , rd_data);

//assign  rd_data=mem[ALU_result];
assign b= mem[ALU_result];
assign  rd_data= (Memread ==1)?   ((a[14:12]==3'b000 )?{24'd0,b[7:0]}:
                                  ((a[14:12]==3'b001 )? {16'd0,b[15:0]}:
                                  ((a[14:12]==3'b100 )? {{24{b[7]}},b[7:0]}:
                                  ((a[14:12]==3'b101 )? {{16{b[15]}},b[15:0]}:mem[ALU_result])))):mem[ALU_result];
                                               
       
   /* if (Memread ==1)begin 
       if(a[14:12]==3'b011 )         assign rd_data=b;   // lw
       else if(a[14:12]==3'b000 )    assign rd_data={24'd0,b[7:0]};   // lb
       else if(a[14:12]==3'b010 )    assign rd_data={16'd0,b[15:0]};   // lh
       else if(a[14:12]==3'b100 )    assign rd_data={{24{b[7]}},b[7:0]};   // lbu
       else if(a[14:12]==3'b110 )    assign rd_data={{16{b[15]}},b[15:0]};   // lhu
        end     */ 
//assign 
//assign ALU_result2= (a[6:0]!=7'b0010111)?ALU_result:pc;
MUX u10(ALU_result,pc,ALU_result2,Cen); 
//assign ALU_result1= ((a[6:0]==7'b0110111)||(a[6:0]==7'b0010111))?imm:ALU_result2;  // LUI AUIPC
MUX u9(ALU_result2,pc_imm1,ALU_result1,Aen);
MUX u1(ALU_result1,rd_data,wr_data,Memtoreg);         //// chon gi?a giá tri doc tu mem voi ket qua alu 
MUX u2(wr_data,pc_out,wr_data1,Jsel);                //// 2 lenh JAL JALR luu pc+4 vao rd 
assign wr_data2 = (a[6:0]==7'b0110111)? imm:wr_data1;
//MUX u2(wr_data,wr_data2,wr_data1,Jsel);
MUX d46( pc_imm1,ALU_result, pc_imm2  , Jen);         // lenh jal, cac lenh nhay khac  hoac jalr 

endmodule

module t_CPU;
reg clk;
wire [31:0] pc,pc_imm,a,imm,ALU_result,rs1,rs2,wr_data,rd_data ;
wire [4:0]  rd;
wire        PCsrc,Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch,Cen,Ben,Aen,Jen,Jsel,zero;
wire [10:0] ALUop;
parameter time_out = 100;
CPU a4(clk, pc,pc_imm,a,imm,PCsrc,ALU_result,rs1,rs2,rd,wr_data,rd_data,Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch,Cen,Ben,Aen,Jen,Jsel,ALUop,zero);
initial begin
	clk = 0;
end
always #5 clk = ~clk;


endmodule

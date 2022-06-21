
module inst_mem(  rd_addr,inst);
input [31:0]rd_addr;
output reg[31:0]inst ;

reg [31:0]imem[10000:0];
assign imem[32'd4]=32'b000000000001_00011_001_00100_0110111;    //LUI 4 2^12      
assign imem[32'd8]=32'b000000000000_00000_111_00011_0010011;    //ANDI 3 0 0
assign imem[32'd12]=32'b000000000001_00011_000_00001_0010011;   //ADDI 1 3 1 
assign imem[32'd16]=32'b000000000000_01000_111_00101_0010011;   //AND 5 6 0 
assign imem[32'd20]=32'b000000001111_00001_000_10000_0010011;   //ADDI 16 1 15
assign imem[32'd24]=32'b000000000001_00101_000_00110_0110011;   //ADD 6 5 1
assign imem[32'd28]=32'b000000000001_00110_000_00111_0110011;   //ADD 7 6 1 
assign imem[32'd32]=32'b000000000111_00011_000_00010_0100011;   //SB 3 7 2        luu gt o rb[1] vao rb[3]+2 trong mem 
assign imem[32'd36]=32'b000000000010_00011_000_00010_0000011;   //LB 2 1 1
assign imem[32'd40]=32'b000000000101_00011_111_01010_0110011;   //AND 10 3 2
assign imem[32'd44]=32'b000100000000_00000_000_01110_1101111;   //JAL 14 256
assign imem[32'h12c]=32'b000000000111_00010_000_11000_1100011;  //BEQ 16 1 2
assign imem[32'h144]=32'b000000010000_00011_000_00110_0100011;  //SB 3 16 6 
assign imem[32'h148]=32'b000000010000_00111_010_10001_0110011;  //SLT 16 1 15
assign imem[32'h14c]=32'b010000010000_01110_000_10011_0110011;  //SUB 1 3 19 
assign imem[32'h150]=32'b010000000111_01110_101_10100_0110011;  //SRL 1 3 20
assign imem[32'h154]=32'b000111111000_00011_000_01001_1100111;  //JALR 3 9 504
assign imem[32'h1f8]=32'b000000000000_00000_001_01101_0010111;  //AUIPC 13 4096
assign imem[32'h11f8]=32'b000000000100_01001_110_01011_0110011;   //XOR 9 4 11
   
//assign imem[32'd52]=32'b000000000001_00011_001_00100_1100011;
//assign imem[32'd40]=32'b000000000001_00011_001_00010_0000011;
//assign imem[32'd44]=32'b000000010000_00011_000_00110_1101111;
/*assign imem[32'd20]=32'b000000000011_00001_000_01010_0110011;
assign imem[32'd24]=32'b000000000011_00001_000_00111_0110011;
assign imem[32'd28]=32'b000000000001_00000_000_11100_1100011;*/
always @(* ) 
begin 
  if (rd_addr[1:0] ==2'b00)
   inst<=imem[rd_addr[31:0]] ;
  else 
   inst<='hz ;
end 

endmodule
module t_inst_mem ;
reg [31:0]rd_addr;
wire [31:0]inst;
parameter time_out = 100;
inst_mem u1(  rd_addr,inst);
initial $monitor($time," rd_addr %h ,inst %h " ,rd_addr,inst );

initial
begin 
#5 rd_addr= 32'd8;
#20 rd_addr = 32'd51;
#20 rd_addr = 32'd16;
#20 rd_addr= -20;
#300 $finish;
 end
endmodule

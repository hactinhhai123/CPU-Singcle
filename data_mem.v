
module data_mem(clk,a, mem_wr , mem_rd , addr ,wr_data , rd_data);
input [31:0]addr,a;
input mem_wr , mem_rd,clk ; 
input [31:0] wr_data;
output reg[31:0]rd_data ;

reg [31:0]mem[31:0];
reg [31:0]b,c,d;
always @(* ) 
begin 
  if (mem_rd ==1)begin
               b<=mem[addr];
                case (a[14:12])
       3'b011 :   rd_data<=b;   // lw
       3'b000 :   rd_data<={24'd0,b[7:0]};   // lb
       3'b010 :   rd_data<={16'd0,b[15:0]};   // lh
       3'b100 :   rd_data<={{24{b[7]}},b[7:0]};   // lbu
       3'b110 :   rd_data<={{16{b[15]}},b[15:0]};   // lhu
    
                endcase
                 end 
  else if (mem_wr ==1) begin 
             c<= { 24'd0,wr_data[7:0]};
             d<= { 16'd0,wr_data[15:0]};
                case(a[14:12])
3'b000 :   mem[addr]<= c ; // sb
3'b001 :   mem[addr]<= d  ; // sh
3'b010 :   mem[addr]<=wr_data ;   // sw
                endcase
              end 
end
endmodule
module t_data_mem;
reg [31:0]addr;
reg clk , mem_wr , mem_rd;
reg [31:0]wr_data;
wire [31:0]rd_data;
parameter time_out = 100;
data_mem U1(clk, mem_wr , mem_rd , addr ,wr_data , rd_data); 
initial $monitor($time," mem_wr %d  ,mem_rd %d , addr  %h,wr_data %d , rd_data %d" , mem_wr , mem_rd , addr ,wr_data , rd_data);
initial begin
	clk = 0;
end
always #5 clk = ~clk;
initial
begin 
#5 mem_wr = 1;  mem_rd = 0; 
addr = 32'd10;
wr_data=32'd120;
#20 mem_wr = 0;  mem_rd = 0; 
addr = 32'd10;
wr_data=32'd120;
#20 mem_wr = 1;  mem_rd = 0; 
addr = 32'd14;
wr_data=32'd120;
#20 mem_wr = 0;  mem_rd = 1; 
addr = 32'd14;
wr_data=32'd120;
#300 $finish;
 end
endmodule

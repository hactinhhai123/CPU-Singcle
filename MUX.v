module MUX(a , b ,c , s);
input [31:0]a;
input [31:0]b;
input s;
output [31:0]c ;
//assign c= (s==1)?a:b; 
assign c= (s==0)?a:b;
endmodule
module t_MUX;
reg [31:0]a;
reg [31:0]b;
reg s;
wire [31:0]c;
parameter time_out = 100;
MUX u1(a , b ,c , s);
//initial $monitor($time," pc %h , a %h ,ALU_result %h ,wr_data  %h ,rd_data %h ,Regwrite %d, ALUsrc %d, Memtoreg %d, Memread %d, Memwrite %d, Branch %d,PCsrc %d " ,pc,a,ALU_result ,wr_data,rd_data,Regwrite, ALUsrc, Memtoreg, Memread, Memwrite, Branch,PCsrc );
initial begin
	#10 a = 0; 
    b=1;
 s=0;

end

endmodule

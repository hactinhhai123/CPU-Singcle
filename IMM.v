

/******** Instruction Memmory Block ********/
module IMEM( addr, data
	     );

input		[31:0]addr;
output	reg	[31:0]data;

/********* Instruction Memmory *************/
wire [9:0] pWord;wire [1:0] pByte;
reg [31:0] IMEM [1023:0];
assign pWord = addr[11:2];
assign pByte = addr[1:0];
initial begin
$readmemh("E:/TestCode/pipeline_test.txt",IMEM);
end
always@(addr)
              if(pByte == 2'b00 ) data <=IMEM[pWord];
              else data <= 'hz;
    
		//data <= {IMEM[addr],IMEM[addr+1],IMEM[addr+2],IMEM[addr+3]};






endmodule

module t_im;
reg [31:0]in;
wire [31:0]out;
parameter time_out = 100;
IMEM a23( in , out );

initial
begin 
#5 in = 0;  
#20 in=32'd4;
#20 in=32'd8;
#20 in=32'd12;
#300 $finish;
 end
endmodule

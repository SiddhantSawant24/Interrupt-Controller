`include "ic.v"
module tb;
parameter NO_OF_PERIPHERALS=16;
parameter WIDTH=$clog2(NO_OF_PERIPHERALS);
parameter S_NO_INTERRUPT=3'b001;
parameter S_ACTIVE_INTERRUPT=3'b010;
parameter S_INTERRUPT_GIVEN_TO_THE_PROCESSOR_FS=3'b100;

//APB Ports
reg pclk_i,prst_i,pwrite_en_i,pvalid_i;
reg [WIDTH-1:0] pwdata_i,paddr_i;

wire [WIDTH-1:0]prdata_o;
wire [WIDTH-1:0]pready_o;

//INTC Ports
reg [NO_OF_PERIPHERALS-1:0]interrupt_active_i;
reg interrupt_serviced_i;

wire [WIDTH-1:0]interrupt_to_be_serviced_o;
wire interrupt_valid_o;

//Declaring Priority Registers
wire[WIDTH-1:0] priority_reg[NO_OF_PERIPHERALS-1:0];

integer i;

//internal registers
wire [2:0] present_state,next_state;
wire first_check_flag;
wire [WIDTH-1:0]interrupt_priority_value,highest_priority_interrupt_peripheral;

reg [500*8:0] testcase;

ic dut(.*);

always #5 pclk_i=~pclk_i;

task reset();
	begin
	pwrite_en_i=0;
	pvalid_i=0;
	pwdata_i=0;
	paddr_i=0;
	interrupt_active_i=0;
	interrupt_serviced_i=0;
	end
endtask

task write1();
	begin
	for(i=0;i<NO_OF_PERIPHERALS;i=i+1)begin
		@(posedge pclk_i);
		pwrite_en_i=1;
		paddr_i=i;
		pwdata_i=i;
		pvalid_i=1;
			wait(pready_o==1);
		end
	@(posedge pclk_i);
	reset();
	interrupt_active_i=$random();
	end
endtask

task write2();
	begin
	for(i=0;i<NO_OF_PERIPHERALS;i=i+1)begin
		@(posedge pclk_i);
		pwrite_en_i=1;
		paddr_i=i;
		pwdata_i=NO_OF_PERIPHERALS-1-i;
		pvalid_i=1;
			wait(pready_o==1);
		end
	@(posedge pclk_i);
	reset();
	interrupt_active_i=$random();
	end
endtask

task write3();
	begin
	for(i=0;i<NO_OF_PERIPHERALS;i=i+1)begin
		@(posedge pclk_i);
		pwrite_en_i=1;
		paddr_i=i;
		pwdata_i=1'b1;
		pvalid_i=1;
			wait(pready_o==1);
		end
	@(posedge pclk_i);
	reset();
	interrupt_active_i=$random();
	end
endtask


initial begin
pclk_i=0;
prst_i=1;
reset();
#30;
prst_i=0;
$value$plusargs("testcase=%s",testcase);
	case (testcase)
		"Lowest_peri_Lowest_val":begin
			write1();
		end

		"Lowest_peri_Highest_val":begin
			write2();
		end

		"First_come_First_serve":begin
			write3();
		end
	endcase	
end

//Processor Modelling
always @(posedge pclk_i)begin
	if(interrupt_to_be_serviced_o)begin //There are interrupts
	#30; //Interrupt will take time to reach the processor
	interrupt_active_i[interrupt_to_be_serviced_o]=0;
	interrupt_serviced_i=1;
	@(posedge pclk_i);
	interrupt_serviced_i=0; // Now take next interrupt;
end
end

initial begin
#1000;
$finish();
end

endmodule



		








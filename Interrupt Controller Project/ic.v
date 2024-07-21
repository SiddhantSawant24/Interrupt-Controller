module ic (pclk_i,prst_i,paddr_i,pwdata_i,prdata_o,pwrite_en_i,pvalid_i,pready_o,interrupt_active_i,interrupt_serviced_i,interrupt_to_be_serviced_o,interrupt_valid_o);
parameter NO_OF_PERIPHERALS=16;
parameter WIDTH=$clog2(NO_OF_PERIPHERALS);
parameter S_NO_INTERRUPT=3'b001;
parameter S_ACTIVE_INTERRUPT=3'b010;
parameter S_INTERRUPT_GIVEN_TO_THE_PROCESSOR_FS=3'b100;

//APB Ports
input pclk_i,prst_i,pwrite_en_i,pvalid_i;
input [WIDTH-1:0] pwdata_i,paddr_i;

output reg [WIDTH-1:0]prdata_o;
output reg [WIDTH-1:0]pready_o;

//INTC Ports
input [NO_OF_PERIPHERALS-1:0]interrupt_active_i;
input interrupt_serviced_i;

output reg [WIDTH-1:0]interrupt_to_be_serviced_o;
output reg interrupt_valid_o;

//Declaring Priority Registers
reg [WIDTH-1:0] priority_reg[NO_OF_PERIPHERALS-1:0];

integer i;

//internal registers
reg [2:0] present_state,next_state;
reg first_check_flag;
reg [WIDTH-1:0]interrupt_priority_value,highest_priority_interrupt_peripheral;

always @(posedge pclk_i)begin
	if (prst_i)begin
		prdata_o=0;
		pready_o=0;
		first_check_flag=1;
		interrupt_priority_value=0;
		highest_priority_interrupt_peripheral=0;
		interrupt_to_be_serviced_o=0;
		interrupt_valid_o=0;
		present_state=S_NO_INTERRUPT;
		next_state=S_NO_INTERRUPT;
			for(i=0;i<NO_OF_PERIPHERALS;i=i+1)begin
			priority_reg[i]=0;
			end
		end

	else begin
		if(pvalid_i)begin
			pready_o=1;
			if(pwrite_en_i)begin
				priority_reg[paddr_i]=pwdata_i;
			end
			else begin
				prdata_o=priority_reg[paddr_i];
			end
		end
		
		else begin
			pready_o=0;
		end
	end
end

//Handling the interrupt

always @(posedge pclk_i)begin
	if (prst_i!=1)begin
		case (present_state) 
			S_NO_INTERRUPT:begin
				if(interrupt_active_i!=0)begin
					next_state=S_ACTIVE_INTERRUPT;
					first_check_flag=1;
				end
				else begin
					next_state=S_NO_INTERRUPT;
				end
			end

			S_ACTIVE_INTERRUPT:begin
				for(i=0;i<NO_OF_PERIPHERALS;i=i+1)begin
					if(interrupt_active_i[i])begin
						if(first_check_flag)begin
							interrupt_priority_value=priority_reg[i];
							highest_priority_interrupt_peripheral=i;
							first_check_flag=0;
						end

						else begin
							if(interrupt_priority_value<priority_reg[i])begin
								interrupt_priority_value=priority_reg[i];
								highest_priority_interrupt_peripheral=i;
							end
						end
					end
				end
				interrupt_to_be_serviced_o=highest_priority_interrupt_peripheral;
				interrupt_valid_o=1;

				next_state=S_INTERRUPT_GIVEN_TO_THE_PROCESSOR_FS;
				end

			S_INTERRUPT_GIVEN_TO_THE_PROCESSOR_FS:begin
				if(interrupt_serviced_i)begin
					interrupt_to_be_serviced_o=0;
					interrupt_valid_o=0;
					interrupt_priority_value=0;
					highest_priority_interrupt_peripheral=0;
						if(interrupt_active_i!=0)begin
							next_state=S_ACTIVE_INTERRUPT;
						end

						else begin
							next_state=S_NO_INTERRUPT;
						end
				end
			end
		endcase
	end
end

always @(next_state)begin
present_state=next_state;
end
endmodule



	





		
		



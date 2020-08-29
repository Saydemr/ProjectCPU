// ProjectCPU 2020
// ABDULLAH SAYDEMIR
//      S014646
//       CS 240
//    Submitted to
//   FATIH UGURDAG

`timescale 1ns / 1ps
module projectCPU2020(
  clk,
  rst,
  wrEn,
  data_fromRAM,
  addr_toRAM,
  data_toRAM,
  PC,
  W
);

input clk, rst;

input wire[15:0] data_fromRAM;
output reg [15:0] data_toRAM;
output reg wrEn;

// 12 can be made smaller so that it fits in the FPGA
output reg [12:0] addr_toRAM;
output reg [12:0] PC; // This has been added as an output for TB purposes
output reg [15:0] W; // This has been added as an output for TB purposes

reg [2:0] state, stateNext;
reg [12:0] PCNext;
reg [2:0] inst, instNext;
reg [15:0] WNext;
//reg [3:0] rot, rotNext;


always @(posedge clk) begin
	state <= #1 stateNext;
	PC    <= #1 PCNext;
	inst  <= #1 instNext;
	W     <= #1 WNext;
	//rot   <= #1 rotNext;

end

always @(*) begin
		stateNext  = state;
		PCNext     = PC;
		instNext   = inst;
		WNext      = W;
		wrEn       = 0;
		addr_toRAM = 0;
		data_toRAM = 0;
		//rotNext    = rot;
		
	if (rst) begin
		stateNext  = 0;
		PCNext     = 0;
		instNext   = 0;
		WNext      = 0;
		wrEn       = 0;
		addr_toRAM = 0;
		data_toRAM = 0;
	//	rotNext    = 0;
		
	end else begin
		case (state)
			0: begin
				PCNext     = PC;
				instNext   = inst;
				addr_toRAM = PC;
				WNext      = W;
				wrEn       = 0;
				data_toRAM = 0;
				stateNext  = 1;
				//rotNext    = rot;
				
			
			end
			1: begin
			
				instNext   = data_fromRAM[15:13];
				addr_toRAM = data_fromRAM[12:0];
				//rotNext    = rot;
				WNext      = W;
				if (data_fromRAM[12:0] == 13'b0000000000000) begin
					addr_toRAM = 13'b0000000000010;
					data_toRAM = 0;
					wrEn       = 0;
					PCNext     = PC;
					stateNext  = 3;
				end else begin
				
					if (instNext == 3'b110) begin
						data_toRAM = W;
						wrEn       = 1;
						PCNext     = PC + 1;
						stateNext  = 0;
					
					end else begin
						data_toRAM = 0;
						wrEn       = 0;
						PCNext     = PC;
						stateNext  = 2;
					
					end
				end
			end
			2: begin
				//rotNext    = data_fromRAM[3:0];
				stateNext  = 0;
				wrEn       = 0;
				data_toRAM = 0;
				addr_toRAM = 0;
				instNext   = inst;
				if (instNext == 3'b000) begin
					
					WNext      = W + data_fromRAM;
					PCNext     = PC + 1;
				
				end else if (instNext == 3'b001) begin
					
					WNext      = (~( W | data_fromRAM));
					PCNext     = PC + 1;
				end else if (instNext == 3'b010) begin
					
					if (data_fromRAM < 16) begin
						WNext = W >> data_fromRAM;
					end else if (data_fromRAM < 32) begin
						WNext = W << (data_fromRAM[3:0]);
					end else if (data_fromRAM < 48) begin
							WNext = ((W >> data_fromRAM[3:0]) | (W << (16- data_fromRAM[3:0])));
					end else begin
						WNext = ((W << data_fromRAM[3:0]) | (W >> (16- data_fromRAM[3:0])));
					end
					PCNext     = PC + 1;
				end else if (instNext == 3'b011) begin
					
					WNext  = (W > data_fromRAM) ? 1 : 0;
					PCNext = PC + 1;
				
				end else if (instNext == 3'b100) begin
					
					PCNext = (data_fromRAM == 0) ? (PC+2) : (PC+1);
					WNext  = W;
					
				end else if (instNext == 3'b101) begin
					
					WNext  = data_fromRAM;
					PCNext = PC + 1;
				
				end else if (instNext == 3'b111) begin
					
					PCNext = data_fromRAM[12:0];
					WNext  = W;
					
				end
			end
			
			3: begin
				
				addr_toRAM = data_fromRAM;
				instNext   = inst;
				WNext      = W;
				//rotNext    = rot;
				if (instNext == 3'b110) begin
					data_toRAM = W;
					wrEn       = 1;
					PCNext     = PC + 1;
					stateNext  = 0;
				end else begin
					PCNext     = PC;
					data_toRAM = 0;
					wrEn       = 0;
					stateNext = 2;
				end
			end
				
		endcase
end
end
endmodule


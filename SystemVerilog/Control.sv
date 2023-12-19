// control decoder
module Control #(parameter opwidth = 3, mcodebits = 5)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  output logic RegDst, Branch, 
     MemtoReg, MemWrite, ALUSrc, RegWrite, Done, Li,
  output logic[opwidth-1:0] ALUOp);	   // for up to 8 ALU operations
  
  logic [1:0] t;
  logic [2:0] opcode;

  assign t = instr[4:3];
  assign opcode = instr[2:0];

always_comb begin
// defaults
  Done = 'b0;
  Li = 0;
  RegDst 	=   'b0;   // 1: not in place  just leave 0
  Branch 	=   'b0;   // 1: branch (jump)
  MemWrite  =	'b0;   // 1: store to memory
  ALUSrc 	=	'b0;   // 1: immediate  0: second reg file output
  RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
  MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  ALUOp	    =   'b111; // y = a+0;
// sample values only -- use what you need
  case(t)
    
  'b00: begin  //ALU
    ALUOp = opcode;
    case(opcode)
      3'b000: begin
        //RegDst = 1;
        //ALUSrc = 1;
      end
      3'b001: begin
        //RegDst = 1;
        //ALUSrc = 1;
      end
      3'b010: begin
        RegDst = 1;
      end
      3'b011: begin
        RegDst = 1;
      end
    endcase
  end
    
  'b01: begin  //Branching
    Branch = 1;
    RegWrite = 0;
  end
    
  'b10: begin  //load, store, DONE
    case(opcode)
      3'b000: begin
        MemtoReg = 1;
      end
      3'b001: begin
        MemWrite = 1;
        RegWrite = 0;
      end
      default: Done = 1;
    endcase
  end
      
    'b11: begin //load immediate
      Li = 1;
    end
endcase

end
	
endmodule
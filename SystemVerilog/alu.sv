// combinational -- no clock
// sample -- change as desired
module alu(
  input[2:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  input      sc_i,       // shift_carry in
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               pari,     // reduction XOR (output)
			   zero      // NOR (output)
);

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    
  zero = inA == inB;
  pari = ^rslt;
  case(alu_cmd)
    3'b000: begin // left_shift
      rslt = inB << inA;
    end
    3'b001: begin // right_shift
      rslt = inB >> inA;
    end
    3'b010: begin // move
	  rslt = inA;
    end
    3'b011: begin // increment
	  rslt = inB + 1;
    end
    3'b100: begin // add
	  rslt = inA + inB;
    end
    3'b101: begin // bitwise XOR
	  rslt = inA ^ inB;
    end
    3'b110: begin // reduction XOR (parity)
      rslt[0] = ^inB;
    end
    3'b111: begin // AND
	  rslt = inA & inB;
    end
  endcase
end
   
endmodule
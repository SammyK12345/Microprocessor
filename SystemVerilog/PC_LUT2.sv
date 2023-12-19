module PC_LUT #(parameter D=12)(
  input       [ 2:0] addr,	   // target 4 values
  output logic[D-1:0] target);

  always_comb case(addr)
    3'b000: target = 4;
    3'b001: target = 94;
    3'b010: target = 100;
    3'b011: target = 118;
    3'b100: target = 121;
    3'b101: target = -5;
    3'b110: target = -15;
    3'b111: target = -50;
	default: target = 0;  // hold PC  
  endcase

endmodule

/*

	   pc = 4    0000_0000_0100	  4
	             1111_1111_1111	 -1

                 0000_0000_0011   3

				 (a+b)%(2**12)


   	  1111_1111_1011      -5
      0000_0001_0100     +20
	  1111_1111_1111      -1
	  0000_0000_0000     + 0


  */

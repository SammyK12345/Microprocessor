module PC_LUT #(parameter D=12)(
  input       [ 2:0] addr,	   // target 4 values
  output logic[D-1:0] target);

  always_comb case(addr)
    3'b000: target = 9;
    3'b001: target = 23;
    3'b010: target = 38;
    3'b011: target = 53;
    3'b100: target = 75;
    3'b101: target = 101;
    3'b110: target = 110;
    3'b111: target = 125;
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

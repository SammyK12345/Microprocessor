// sample top level design
module top_level(
  input        clk, reset, 
  output logic done);
  parameter D = 12,             // program counter width
    A = 3;             		  // ALU command bit width
  wire[D-1:0] target, 			  // jump 
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   datA,datB,		  // from RegFile
  			  muxA,
              muxB,
  			  muxC,
  			  muxD,
			  rslt,               // alu output
  			  load_immed,
              immed;
  logic sc_in,   				  // shift/carry out from/to ALU
   		pariQ,              	  // registered parity flag from ALU
		zeroQ;                    // registered zero flag from ALU 
  wire  relj;                     // from control to PC; relative jump enable
  wire  pari,
        zero,
		sc_clr,
		sc_en,
        MemWrite, MemtoReg,
        ALUSrc;		              // immediate switch
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[3:0] rd_addrA, rd_addrB;    // address pointers to reg_file
  
  logic[7:0] regfile_dat;
  logic Li;
  logic dumb;
  logic RegDst;
  logic [7:0] dat_out;
  logic absj;
  logic Branch;
  assign relj = 0;

  assign muxA = RegDst? mach_code[3:0]:'b0;
  assign muxC = MemtoReg? dat_out : rslt;
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
		 .reljump_en (relj),
		 .absjump_en (absj),
		 .target           ,
		 .prog_ctr          );

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (.addr  (mach_code[6:4]),
         .target          );   

// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);

// control decoder
  Control ctl1(.instr(mach_code[8:4]),
  .RegDst, 
  .Branch  , 
  .MemWrite , 
  .ALUSrc   , 
  .RegWrite   ,     
  .MemtoReg,
               .Done(done),
               .Li,
  .ALUOp(alu_cmd));

  assign rd_addrA = 'b0;
  assign rd_addrB = mach_code[3:0];
  //assign alu_cmd  = mach_code[6:4];

  reg_file #(.pw(4)) rf1(.dat_in(muxD),	   // loads, most ops
              .clk         ,
              .wr_en   (RegWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (muxA),      // in place operation
              .datA_out(datA),
              .datB_out(datB)); 

  assign muxB = ALUSrc? mach_code[3:0] : datB;

  alu alu1(.alu_cmd,
         .inA    (datA),
		 .inB    (muxB),
		 .sc_i   (sc),   // output from sc register
		 .rslt       ,
		 .sc_o   (sc_o), // input to sc register
		 .pari,
		 .zero  );  

  dat_mem dm1(.dat_in(datA)  ,  // from reg_file
             .clk           ,
			 .wr_en  (MemWrite), // stores
			 .addr   (datB),
             .dat_out);

// registered flags from ALU
  always_ff @(posedge clk) begin
    pariQ <= pari;
	//zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end
  
   assign load_immed = mach_code[6:0];
    
   assign muxD = Li? load_immed : muxC;
   assign absj = !zero & Branch;
    
  //assign done = prog_ctr == 125;
 
endmodule
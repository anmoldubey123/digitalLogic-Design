`timescale 1ns / 1ps

module tb_decoder;

    reg e, a, b, c;
    wire d0, d1, d2, d3, d4, d5, d6, d7;

    // dut: design under test
    decoder dut (.e(e), .a(a), .b(b), .c(c), .d0(d0), .d1(d1), .d2(d2), .d3(d3), .d4(d4), .d5(d5), .d6(d6), .d7(d7)); 

    // test without checker
    initial begin 
        e = 0; a = 0; b = 0; c = 0;
        #10                
        e = 0; a = 0; b = 0; c = 0;
        #10
        e = 0; a = 0; b = 0; c = 1;
        #10
        e = 0; a = 0; b = 1; c = 0;
        #10
        e = 0; a = 0; b = 1; c = 1;
        #10
        e = 0; a = 1; b = 0; c = 0;
        #10
        e = 0; a = 1; b = 0; c = 1;
        #10
        e = 0; a = 1; b = 1; c = 0;
        #10
        e = 0; a = 1; b = 1; c = 1;
        #10
        e = 1; a = 0; b = 0; c = 0;
        #10
        e = 1; a = 0; b = 0; c = 1;
        #10
        e = 1; a = 0; b = 1; c = 0;
        #10
        e = 1; a = 0; b = 1; c = 1;
        #10
        e = 1; a = 1; b = 0; c = 0;
        #10
        e = 1; a = 1; b = 0; c = 1;
        #10
        e = 1; a = 1; b = 1; c = 0;
        #10
        e = 1; a = 1; b = 1; c = 1;
        #10
        $finish;

    end

//   // test with checker
//   wire [7:0] data_all = {d0,d1,d2,d3,d4,d5,d6,d7};
//   reg test_error;
//   reg test_pass;
//
//   initial begin 
//       e = 0; a = 0; b = 0; c = 0;
//       #1;
//       // checker
//       if(data_all===8'b0000_0000)begin test_pass=1; test_error=0; end
//       else begin                      test_pass=0; test_error=1; end
//       #9; test_pass=0; test_error=0;
//               
//       e = 1; a = 0; b = 0; c = 0;
//       #1;
//       // checker
//       if(data_all===8'b1000_0000)begin test_pass=1; test_error=0; end
//       else begin                      test_pass=0; test_error=1; end
//       #9; test_pass=0; test_error=0;
//       e = 1; a = 0; b = 0; c = 1;
//       #1;
//       // checker
//       if(data_all===8'b0100_0000)begin test_pass=1; test_error=0; end
//       else begin                      test_pass=0; test_error=1; end
//       #9; test_pass=0; test_error=0;
//       e = 1; a = 0; b = 1; c = 0;
//       #1;
//       // checker
//       if(data_all===8'b0010_0000)begin test_pass=1; test_error=0; end
//       else begin                      test_pass=0; test_error=1; end
//       #9; test_pass=0; test_error=0;
//               
//       $finish;
//
//   end

endmodule

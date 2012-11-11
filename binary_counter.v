
module binary_counter(/*AUTOARG*/
   // Outputs
   led,
   // Inputs
   clk, reset, event0, event1
   );

   input              clk;
   input              reset;

   input              event0;
   input              event1;
   
   output wire [7:0]  led;

   reg [7:0]          count;
   
   always @(posedge clk or posedge reset)
     begin
     if (reset)
       count <= 8'b0;
     else
       begin
       if (event0)
         count <= count + 1'b1;
       else if (event1)
         count <= count - 1'b1;
       end
     end

   assign led = count;

endmodule // binary_counter


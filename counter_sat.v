
// Free running saturating counter

module counter_sat(/*AUTOARG*/
   // Outputs
   count,
   // Inputs
   clk, clear
   );

   parameter WIDTH = 10;
   
   input                    clk;
   input                    clear;
   
   output reg [WIDTH-1:0]   count;
   
   always @(posedge clk)
     begin
     if (clear) // SYNCHRONOUS clear signal
       count <= 'b0;
     else 
       begin
       if (count[WIDTH-1] == 1'b0)
         count <= count + 1'b1;
       end // else: !if(clear)
     end // always @ (posedge clk)
        
endmodule
                   

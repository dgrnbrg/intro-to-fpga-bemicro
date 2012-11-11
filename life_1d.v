//
// 1-dimensional game of LIFE
//
// See http://mathworld.wolfram.com/ElementaryCellularAutomaton.html for more details
//
// Rule 30: 00011110
//
// Cell(n+1) Cell(n) Cell(n-1) NextGeneration
//     1        1        1           0
//     1        1        0           0
//     1        0        1           0
//     1        0        0           1
//     0        1        1           1
//     0        1        0           1
//     0        0        1           1
//     0        0        0           0
//

module life_1d(/*AUTOARG*/
   // Outputs
   led,
   // Inputs
   clk, reset, event0, event1
   );

   parameter [7:0] RULENUM = 30;
   
   input              clk;
   input              reset;

   input              event0;
   input              event1;

   output wire [7:0]  led;

   reg [7:0]          life_state;
   reg                mode; // 0 = count, 1 = run
   reg [25:0]         delay_cntr;

   // synthesis translate_off
   // Tick once every 5 cycles in simulation
   always @(negedge clk)
     if (delay_cntr >= 26'h4)
       delay_cntr = 26'h3ffffff;
   // synthesis translate_on
   
   always @(posedge clk or posedge reset)
     begin
     if (reset)
       begin
       life_state <= 8'b0;
       mode <= 1'b0;
       end
     else
       begin
       if (mode == 1'b0) // Count
         begin
         if (event0)
           life_state <= life_state + 1;

         if (event1)
           begin
           mode <= 1'b1;
           delay_cntr <= 'b0;
           end
         end
       
       else // run
         begin
         if (&delay_cntr) // reduction AND function
           begin
           life_state[7] <= next_value({life_state[0], life_state[7:6]});
           life_state[6] <= next_value(life_state[7:5]);
           life_state[5] <= next_value(life_state[6:4]);
           life_state[4] <= next_value(life_state[5:3]);
           life_state[3] <= next_value(life_state[4:2]);
           life_state[2] <= next_value(life_state[3:1]);
           life_state[1] <= next_value(life_state[2:0]);
           life_state[0] <= next_value({life_state[1:0], life_state[7]});
           end

         delay_cntr <= delay_cntr + 1'b1;
                                        
         if (event1)
           mode <= 1'b0;
         
         end // else: !if(mode == 1'b0)
       end // else: !if(reset)
     end // always @ (posedge clk or reset)

   assign led = life_state;

function next_value;
   input [2:0] current_value;
  begin
  case (current_value)
    3'b111: next_value = RULENUM[7];
    3'b110: next_value = RULENUM[6];
    3'b101: next_value = RULENUM[5];
    3'b100: next_value = RULENUM[4];
    3'b011: next_value = RULENUM[3];
    3'b010: next_value = RULENUM[2];
    3'b001: next_value = RULENUM[1];
    3'b000: next_value = RULENUM[0];
  endcase // case (current_value)
  end
endfunction
   
endmodule // life_1d


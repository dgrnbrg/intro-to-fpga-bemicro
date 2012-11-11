
module bemicro_top(
   // General
   input    wire  CLK_FPGA_50M,
   input    wire  CPU_RST_N,

   // Temp. Sensor I/F
   output   wire  TEMP_CS_N,
   output   wire  TEMP_SC,       
   output   wire  TEMP_MOSI,
   input    wire  TEMP_MISO,
	
	   // Mobile DDR I/F
   /*output   wire  RAM_A0,
   output   wire  RAM_A1,
   output   wire  RAM_A2,
   output   wire  RAM_A3,
   output   wire  RAM_A4,
   output   wire  RAM_A5,
   output   wire  RAM_A6,
   output   wire  RAM_A7,
   output   wire  RAM_A8,
   output   wire  RAM_A9,
   output   wire  RAM_A10,
   output   wire  RAM_A11,
   output   wire  RAM_A12,
   output   wire  RAM_A13,
   output   wire  RAM_BA0,
   output   wire  RAM_BA1,
   output   wire  RAM_CK_N,
   output   wire  RAM_CK_P,
   output   wire  RAM_CKE,
   output   wire  RAM_CS_N,
   output   wire  RAM_WS_N,
   output   wire  RAM_RAS_N,
   output   wire  RAM_CAS_N,
   inout    wire  RAM_D0,
   inout    wire  RAM_D1,
   inout    wire  RAM_D2,
   inout    wire  RAM_D3,
   inout    wire  RAM_D4,
   inout    wire  RAM_D5,
   inout    wire  RAM_D6,
   inout    wire  RAM_D7,
   inout    wire  RAM_D8,
   inout    wire  RAM_D9,
   inout    wire  RAM_D10,
   inout    wire  RAM_D11,
   inout    wire  RAM_D12,
   inout    wire  RAM_D13,
   inout    wire  RAM_D14,
   inout    wire  RAM_D15,
   output   wire  RAM_LDM,
   output   wire  RAM_UDM,
   inout    wire  RAM_LDQS,
   inout    wire  RAM_UDQS,*/

   // Misc
   input    wire  RECONFIG_SW1,
   input    wire  RECONFIG_SW2,
   input    wire  PBSW_N,
   output   wire  F_LED0,
   output   wire  F_LED1,
   output   wire  F_LED2,
   output   wire  F_LED3,
   output   wire  F_LED4,
   output   wire  F_LED5,
   output   wire  F_LED6,
   output   wire  F_LED7
   );

   wire             clk; // 50 MHz
   wire [1:0]       pb; // Pushbuttons
   wire [7:0]       temp_sensor; // Temperature sensor
   
   reg [7:0]  led;
	
	assign clk = CLK_FPGA_50M;
	assign pb = {~CPU_RST_N, ~PBSW_N};
	assign {F_LED0,F_LED1,F_LED2,F_LED3,F_LED4,F_LED5,F_LED6,F_LED7} = ~led;

/*	
	reg [24:0] counter_2hz;

	wire [7:0] myleds;
   binary_counter bc0(.clk(clk), .reset(0), .event0(counter_2hz == 0), .event1(0), .led(myleds));
	
	
   always @(posedge clk) begin
	    if (counter_2hz != 25_000_000)
				counter_2hz <= counter_2hz + 1;
		 else
				counter_2hz <= 0;
		led <= myleds;
   end
	*/
	
// --------------------------------------------------------------------------------

   // ----------
   // STATE BITS
   // ----------
   
   localparam STATE_BITS = 4;
   localparam
     FCN0    = 0,
     FCN1    = 1,
     FCN2    = 2,
     FCN3    = 3;

   reg [STATE_BITS-1:0] state;

   // synthesis translate_off
   reg [20*8-1:0]       state_str;
   always @(state)
     begin
     case (state)
       'b1 << FCN0   : state_str = "FCN0";
       'b1 << FCN1   : state_str = "FCN1";
       'b1 << FCN2   : state_str = "FCN2";
       'b1 << FCN3   : state_str = "FCN3";
       default       : state_str = "UNKNOWN";
     endcase // case (state)
     end
   // synthesis translate_on
   
// --------------------------------------------------------------------------------

   // -----------
   // RESET LOGIC
   // -----------

   reg [19:0]   reset_cnt;
   
   always @(posedge clk)
     if (!reset_cnt[19])
       reset_cnt <= reset_cnt + 1'b1;

   wire         reset = ~reset_cnt[19];

// --------------------------------------------------------------------------------

   // Synchronize pushbutton inputs to input clock

   // NOTE: Each button is asynchronous to all others.  THIS DOES NOT WORK to
   //   synchronize an input bus to a clock domain.
   reg [1:0]    pb_s0, pb_s1, pb_in;
   always @(posedge clk)
     begin
     pb_s0 <= pb;
     pb_s1 <= pb_s0;
     pb_in <= pb_s1;
     end
   
// --------------------------------------------------------------------------------
   
   wire [7:0]   led0, led1, led2, led3;
   wire [25:0]  pb0_cntr, pb1_cntr;

   // Only allow pushbuttons to trigger every so often
   // Create a saturating counter that resets when pb is pressed

   counter_sat #(26) PB0_CNTR(
                              // Outputs
                              .count            (pb0_cntr),
                              // Inputs
                              .clk              (clk),
                              .clear            (pb_in[0]));
        
   counter_sat #(26) PB1_CNTR(
                              // Outputs
                              .count            (pb1_cntr),
                              // Inputs
                              .clk              (clk),
                              .clear            (pb_in[1]));


   // What will each of these conditions synthesize to?
   wire pb0_saturated = pb0_cntr[25]; // Saturates after .336 seconds
   wire pb1_saturated = (pb1_cntr[25:0] > 26'he4e1c0) ? 1'b1 : 1'b0; // Saturates after .300 seconds

   wire pb0_event = pb_in[0] && pb0_saturated && ~pb_in[1];
   wire pb1_event = pb_in[1] && pb1_saturated && ~pb_in[0];
   wire pb2_event = pb_in[0] && pb_in[1] && (pb0_saturated || pb1_saturated);
   
// --------------------------------------------------------------------------------

   // --------------------------------
   // STATE MACHINE - NEXT STATE LOGIC
   // --------------------------------
   
   always @(posedge clk or posedge reset) // TODO: Put a PLL here
     begin
     if (reset) // Asynchronous reset signal
       begin
       state <= 'b1;
       end
     else
       begin
       if (pb2_event)
         state <= {state[2:0], state[3]};
       end
     end

// --------------------------------------------------------------------------------

   // -----------------------------
   // STATE MACHINE - CONTROL LOGIC
   // -----------------------------

   // Several different ways to assign values to a signal

   // Combined declaration and assignment
   wire fcn0_event0 = state[FCN0] & pb0_event;
   wire fcn0_event1 = state[FCN0] & pb1_event;
   wire fcn1_event0 = state[FCN1] & pb0_event;
   wire fcn1_event1 = state[FCN1] & pb1_event;

   // Assignment down below inside of a begin/end block
   reg  fcn2_event0, fcn2_event1;

   // Seperate declaration and assignment
   wire fcn3_event0, fcn3_event1;
   assign fcn3_event0 = state[FCN3] & pb0_event;
   assign fcn3_event1 = state[FCN3] & pb1_event;

   always @*
     begin
     fcn2_event0 = 1'b0;
     fcn2_event1 = 1'b0;
     case(1'b1) // synthesis full_case parallel_case
       state[FCN0]:
         begin
         led[7:0] = led0[7:0];
         end
       state[FCN1]:
         begin
         led[7:0] = led1[7:0];
         end
       state[FCN2]:
         begin
         fcn2_event0 = pb0_event;
         fcn2_event1 = pb1_event;
         led[7:0] = led2[7:0];
         end
       state[FCN3]:
         begin
         led[7:0] = led3[7:0];
         end
     endcase // case (1'b1)
     end // always @ *

// --------------------------------------------------------------------------------

   // ----------------
   // MODULE INSTANCES
   // ----------------
   
   binary_counter counter0(
                           // Outputs
                           .led                 (led0[7:0]),
                           // Inputs
                           .clk                 (clk),
                           .reset               (reset),
                           .event0              (fcn0_event0),
                           .event1              (fcn0_event1));
   
   gray_counter counter1(
                         // Outputs
                         .led           (led1[7:0]),
                         // Inputs
                         .clk           (clk),
                         .reset         (reset),
                         .event0        (fcn1_event0),
                         .event1        (fcn1_event1));
   
   life_1d life_1d_0(
                     // Outputs
                     .led               (led2[7:0]),
                     // Inputs
                     .clk               (clk),
                     .reset             (reset),
                     .event0            (fcn2_event0),
                     .event1            (fcn2_event1));
   
   life_1d #(150) life_1d_1(
                            // Outputs
                            .led                (led3[7:0]),
                            // Inputs
                            .clk                (clk),
                            .reset              (reset),
                            .event0             (fcn3_event0),
                            .event1             (fcn3_event1));
   
	
endmodule // bemicro_top

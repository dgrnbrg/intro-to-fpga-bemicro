
// Testbench for bemicro demo

`timescale 1 ps / 1 ps
`define WAIT(_cycles) repeat(_cycles) @(posedge clk)
`define PB0 @(negedge clk) pb[0]=1;@(negedge clk) pb[0]=0;`WAIT(20)
`define PB1 @(negedge clk) pb[1]=1;@(negedge clk) pb[1]=0;`WAIT(20)
`define PB2 @(negedge clk) pb[0]=1;pb[1]=1;@(negedge clk) pb[0]=0;pb[1]=0;`WAIT(20)

module bemicro_tb();

   reg              clk;
   reg [2:0]        pb;
   reg [7:0]        temp_sensor;

	wire [7:0]		  led_activelow;
   wire [7:0]       led;
	assign led = ~led_activelow;
   
   // Generate clock signal
   always
     begin
     #20 clk = 1'b0;
     #20 clk = 1'b1;
     end

   // Reduce time to wait for reset to deassert
   initial
     begin
     @(negedge clk);
     bemicro_top.reset_cnt = 20'h7fff0;
     bemicro_top.PB0_CNTR.count = 26'h2000000;
     bemicro_top.PB1_CNTR.count = 26'h2000000;
     end

   // Shorten some counters for simulation
   always @(negedge clk)
     begin
     if (bemicro_top.PB0_CNTR.count == 0)
       bemicro_top.PB0_CNTR.count = 26'h1fffff0;
     
     if (bemicro_top.PB1_CNTR.count == 0)
       bemicro_top.PB1_CNTR.count = 26'h1fffff0;
     end // always @ (negedge clk)

   
   
   // Run the simulation
   
   
   initial
     begin
     pb = 3'b000;
     temp_sensor = 8'h0;

     // Wait 20 cycles to come out of reset
     `WAIT(20);
     // Start in binary counter
     `PB0;
     `PB0;
     `PB1;
     `PB2; // Gray counter
     `PB0;
     `PB2; // Life
     `PB0; // Set to one
     `PB1; // Run life simulation
     `WAIT(50);
     `PB2; // Life 2
     `PB0; // Set to one
     `PB1; // Run life simulation
     `WAIT(50);
       
     $stop();
     
     end

   bemicro_top bemicro_top(
		//don't connect dip switches
		.RECONFIG_SW1(),
		.RECONFIG_SW2(),
		
		//leds (active low)
		.F_LED0(led_activelow[0]),
		.F_LED1(led_activelow[1]),
		.F_LED2(led_activelow[2]),
		.F_LED3(led_activelow[3]),
		.F_LED4(led_activelow[4]),
		.F_LED5(led_activelow[5]),
		.F_LED6(led_activelow[6]),
		.F_LED7(led_activelow[7]),
		
		//clock
		.CLK_FPGA_50M(clk),
		
		//the buttons (active low)
		.PBSW_N(~pb[1]),
		.CPU_RST_N(~pb[0]),

		// Temp. Sensor I/F
		.TEMP_CS_N(),
		.TEMP_SC(),       
		.TEMP_MOSI(),
		.TEMP_MISO()
	);
   
endmodule
  

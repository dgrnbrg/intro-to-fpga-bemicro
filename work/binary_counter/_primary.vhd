library verilog;
use verilog.vl_types.all;
entity binary_counter is
    port(
        led             : out    vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        event0          : in     vl_logic;
        event1          : in     vl_logic
    );
end binary_counter;

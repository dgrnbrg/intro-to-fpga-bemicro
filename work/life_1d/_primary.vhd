library verilog;
use verilog.vl_types.all;
entity life_1d is
    generic(
        RULENUM         : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1, Hi0)
    );
    port(
        led             : out    vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        event0          : in     vl_logic;
        event1          : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of RULENUM : constant is 2;
end life_1d;

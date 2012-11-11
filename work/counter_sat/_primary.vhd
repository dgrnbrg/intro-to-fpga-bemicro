library verilog;
use verilog.vl_types.all;
entity counter_sat is
    generic(
        WIDTH           : integer := 10
    );
    port(
        count           : out    vl_logic_vector;
        clk             : in     vl_logic;
        clear           : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end counter_sat;

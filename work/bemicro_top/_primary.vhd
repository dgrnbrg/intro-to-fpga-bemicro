library verilog;
use verilog.vl_types.all;
entity bemicro_top is
    port(
        CLK_FPGA_50M    : in     vl_logic;
        CPU_RST_N       : in     vl_logic;
        TEMP_CS_N       : out    vl_logic;
        TEMP_SC         : out    vl_logic;
        TEMP_MOSI       : out    vl_logic;
        TEMP_MISO       : in     vl_logic;
        RECONFIG_SW1    : in     vl_logic;
        RECONFIG_SW2    : in     vl_logic;
        PBSW_N          : in     vl_logic;
        F_LED0          : out    vl_logic;
        F_LED1          : out    vl_logic;
        F_LED2          : out    vl_logic;
        F_LED3          : out    vl_logic;
        F_LED4          : out    vl_logic;
        F_LED5          : out    vl_logic;
        F_LED6          : out    vl_logic;
        F_LED7          : out    vl_logic
    );
end bemicro_top;

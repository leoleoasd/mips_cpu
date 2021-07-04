library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        a               : in     vl_logic_vector(31 downto 0);
        b               : in     vl_logic_vector(31 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0);
        zero            : out    vl_logic;
        overflow        : out    vl_logic;
        ge_than_zero    : out    vl_logic;
        sel             : in     vl_logic_vector(1 downto 0)
    );
end alu;

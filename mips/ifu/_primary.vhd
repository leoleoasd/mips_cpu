library verilog;
use verilog.vl_types.all;
entity ifu is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        npc_sel         : in     vl_logic_vector(1 downto 0);
        npc             : in     vl_logic_vector(31 downto 0);
        inst            : out    vl_logic_vector(31 downto 0);
        pc              : out    vl_logic_vector(31 downto 0)
    );
end ifu;

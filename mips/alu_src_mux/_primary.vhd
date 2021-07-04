library verilog;
use verilog.vl_types.all;
entity alu_src_mux is
    port(
        GPRData         : in     vl_logic_vector(31 downto 0);
        ExtData         : in     vl_logic_vector(31 downto 0);
        sel             : in     vl_logic;
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end alu_src_mux;

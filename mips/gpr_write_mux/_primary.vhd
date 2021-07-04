library verilog;
use verilog.vl_types.all;
entity gpr_write_mux is
    port(
        alu             : in     vl_logic_vector(31 downto 0);
        memory          : in     vl_logic_vector(31 downto 0);
        pc              : in     vl_logic_vector(31 downto 0);
        sel             : in     vl_logic_vector(1 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end gpr_write_mux;

library verilog;
use verilog.vl_types.all;
entity gpr_write_addr_mux is
    port(
        sel             : in     vl_logic_vector(1 downto 0);
        rt              : in     vl_logic_vector(4 downto 0);
        rd              : in     vl_logic_vector(4 downto 0);
        \out\           : out    vl_logic_vector(4 downto 0)
    );
end gpr_write_addr_mux;

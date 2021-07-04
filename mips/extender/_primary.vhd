library verilog;
use verilog.vl_types.all;
entity extender is
    port(
        \in\            : in     vl_logic_vector(15 downto 0);
        sel             : in     vl_logic_vector(1 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end extender;

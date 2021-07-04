library verilog;
use verilog.vl_types.all;
entity decoder is
    port(
        inst            : in     vl_logic_vector(31 downto 0);
        dec_inst        : out    vl_logic_vector(5 downto 0);
        rs              : out    vl_logic_vector(4 downto 0);
        rt              : out    vl_logic_vector(4 downto 0);
        rd              : out    vl_logic_vector(4 downto 0);
        shamt           : out    vl_logic_vector(4 downto 0);
        imm             : out    vl_logic_vector(15 downto 0)
    );
end decoder;

library verilog;
use verilog.vl_types.all;
entity gpr is
    port(
        clk             : in     vl_logic;
        write_en        : in     vl_logic;
        of_write_en     : in     vl_logic;
        overflow        : in     vl_logic;
        read_addr_1     : in     vl_logic_vector(4 downto 0);
        read_addr_2     : in     vl_logic_vector(4 downto 0);
        write_addr      : in     vl_logic_vector(4 downto 0);
        write_data      : in     vl_logic_vector(31 downto 0);
        read_data_1     : out    vl_logic_vector(31 downto 0);
        read_data_2     : out    vl_logic_vector(31 downto 0)
    );
end gpr;

library verilog;
use verilog.vl_types.all;
entity controller is
    port(
        dec_inst        : in     vl_logic_vector(5 downto 0);
        zero            : in     vl_logic;
        reg_write_en    : out    vl_logic;
        reg_of_en       : out    vl_logic;
        mem_write_en    : out    vl_logic;
        alu_sel         : out    vl_logic_vector(1 downto 0);
        gpr_write_addr_sel: out    vl_logic_vector(1 downto 0);
        gpr_write_data_sel: out    vl_logic_vector(1 downto 0);
        alu_src_ctl     : out    vl_logic;
        ext_ctl         : out    vl_logic_vector(1 downto 0);
        npc_sel         : out    vl_logic_vector(1 downto 0);
        halt_sig        : out    vl_logic
    );
end controller;

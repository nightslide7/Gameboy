library verilog;
use verilog.vl_types.all;
entity AC97 is
    port(
        square_wave_enable: in     vl_logic;
        sample_no       : in     vl_logic;
        ac97_bitclk     : in     vl_logic;
        ac97_sdata_in   : in     vl_logic;
        ac97_sdata_out  : out    vl_logic;
        ac97_sync       : out    vl_logic;
        ac97_reset_b    : out    vl_logic;
        flash_wait      : in     vl_logic;
        flash_d         : in     vl_logic_vector(15 downto 0);
        flash_a         : out    vl_logic_vector(23 downto 0);
        flash_adv_n     : out    vl_logic;
        flash_ce_n      : out    vl_logic;
        flash_clk       : out    vl_logic;
        flash_oe_n      : out    vl_logic;
        flash_we_n      : out    vl_logic;
        square_sample   : out    vl_logic_vector(19 downto 0);
        strobe          : out    vl_logic
    );
end AC97;

library verilog;
use verilog.vl_types.all;
entity AC97Conf is
    port(
        ac97_bitclk     : in     vl_logic;
        ac97_strobe     : in     vl_logic;
        ac97_out_slot1  : out    vl_logic_vector(19 downto 0);
        ac97_out_slot1_valid: out    vl_logic;
        ac97_out_slot2  : out    vl_logic_vector(19 downto 0);
        ac97_out_slot2_valid: out    vl_logic
    );
end AC97Conf;

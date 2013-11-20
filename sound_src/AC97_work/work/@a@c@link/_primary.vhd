library verilog;
use verilog.vl_types.all;
entity ACLink is
    port(
        ac97_bitclk     : in     vl_logic;
        ac97_sdata_in   : in     vl_logic;
        ac97_sdata_out  : out    vl_logic;
        ac97_sync       : out    vl_logic;
        ac97_reset_b    : out    vl_logic;
        ac97_strobe     : out    vl_logic;
        ac97_out_slot1  : in     vl_logic_vector(19 downto 0);
        ac97_out_slot1_valid: in     vl_logic;
        ac97_out_slot2  : in     vl_logic_vector(19 downto 0);
        ac97_out_slot2_valid: in     vl_logic;
        ac97_out_slot3  : in     vl_logic_vector(19 downto 0);
        ac97_out_slot3_valid: in     vl_logic;
        ac97_out_slot4  : in     vl_logic_vector(19 downto 0);
        ac97_out_slot4_valid: in     vl_logic;
        ac97_out_slot5  : in     vl_logic_vector(19 downto 0);
        ac97_out_slot5_valid: in     vl_logic;
        ac97_out_slot6  : in     vl_logic_vector(19 downto 0);
        ac97_out_slot6_valid: in     vl_logic;
        ac97_out_slot7  : in     vl_logic_vector(19 downto 0);
        ac97_out_slot7_valid: in     vl_logic;
        ac97_out_slot8  : in     vl_logic_vector(19 downto 0);
        ac97_out_slot8_valid: in     vl_logic;
        ac97_out_slot9  : in     vl_logic_vector(19 downto 0);
        ac97_out_slot9_valid: in     vl_logic;
        ac97_out_slot10 : in     vl_logic_vector(19 downto 0);
        ac97_out_slot10_valid: in     vl_logic;
        ac97_out_slot11 : in     vl_logic_vector(19 downto 0);
        ac97_out_slot11_valid: in     vl_logic;
        ac97_out_slot12 : in     vl_logic_vector(19 downto 0);
        ac97_out_slot12_valid: in     vl_logic
    );
end ACLink;

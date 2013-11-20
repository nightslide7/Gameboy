library verilog;
use verilog.vl_types.all;
entity SquareWave is
    generic(
        bitclk_rate     : vl_logic_vector(0 to 19) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0)
    );
    port(
        ac97_bitclk     : in     vl_logic;
        ac97_strobe     : in     vl_logic;
        freq            : in     vl_logic_vector(19 downto 0);
        sample          : out    vl_logic_vector(19 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of bitclk_rate : constant is 1;
end SquareWave;

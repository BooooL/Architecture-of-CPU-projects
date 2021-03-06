-- ====================================================================
--
--	File Name:		Testbench_Output_Selector.vhd
--	Description: test bench for Output_Selector unit
--
--
--	Date:			02/04/2018
--	Designer:		Maor Assayag, Refael Shetrit
--
-- ====================================================================

LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity Testbench_Output_Selector is
end Testbench_Output_Selector;

architecture behavior of Testbench_Output_Selector is

 -- Component Declaration
 component Output_Selector is
     generic(N: positive := 8); --defualt value for N is 8
     port (
        SEL:             in  std_logic;
        FLAG_en :        in  std_logic;
        arithmetic_LO:   in  signed (N-1 downto 0);
        arithmetic_HI:   in  signed (N-1 downto 0);
        arithmetic_FLAG: in signed (5 downto 0);
        shift_LO :       in  signed (N-1 downto 0);
        LO :             out signed (N-1 downto 0);
        HI :             out signed (N-1 downto 0);
        STATUS :         out signed (5 downto 0));
 end component;

 constant N : integer := 8;
 signal SEL : std_logic := '0';
 signal FLAG_en : std_logic := '0';
 signal arithmetic_LO, arithmetic_HI, shift_LO, LO, HI :signed((N-1) downto 0);
 signal arithmetic_FLAG, STATUS: signed(5 downto 0);

begin
----------------------------------------
  uut :  Output_Selector  generic map(N)
    port map (SEL, FLAG_en, arithmetic_LO, arithmetic_HI, arithmetic_FLAG, shift_LO, LO, HI, STATUS);

  stim: process
  begin
    wait for 10 ns;
      arithmetic_LO <= "00001111";
      arithmetic_HI <= "11110000";
      arithmetic_FLAG <= "101010";
      shift_LO <= "00111100";
      wait for 50 ns;

      FLAG_en <= '1'; -- OPP = SUB
      wait for 50 ns;

      FLAG_en <= '0';
      SEL <= '1';
      arithmetic_LO <= "00000011";
      arithmetic_HI <= "11000000";
      shift_LO <= "00110000";
    wait for 10 ns;
  end process stim;
----------------------------------------
end behavior;

--EndOfFile

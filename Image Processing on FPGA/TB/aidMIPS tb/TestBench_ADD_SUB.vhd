-- ====================================================================
--
--	File Name:		TestBench_ADD_SUB.vhd
--	Description: test bench for ADD & SUB opp
--
--
--	Date:			12/04/2018
--	Designers:		Maor Assayag, Refael Shetrit
--
-- ====================================================================

LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity Testbench_ADD_SUB is
end Testbench_ADD_SUB;

architecture behavior of Testbench_ADD_SUB is

 -- Component Declaration
 component ADD_SUB
    generic (N: integer := 8 ); --defualt value for N is 8
    port(
        addORsub :   in std_logic;
       A :     in signed ((N-1) downto 0);
       B :     in signed ((N-1) downto 0);
       SUM :   out signed ((N-1) downto 0));
  end component;

  constant N : integer := 8;
  signal OPP : std_logic := '0';
  signal x, y, result : signed((N-1) downto 0) ;
 

  begin
  ----------------------------------------
   uut :  ADD_SUB  generic map(N)
     port map (OPP, x, y, result);

   stim: process
   begin
     wait for 100 ns;
     x <= "11111110", "10000001" after 50 ns, "00001100" after 100 ns,"11111110" after 150 ns,"00000000" after 200 ns;
     y <= "11111101", "00000011" after 50 ns, "00000010" after 100 ns,"00000100" after 150 ns,"00000011" after 200 ns;
     OPP <= '1' after 50 ns;
     wait for 50 ns;
   end process stim;
  ----------------------------------------
  end behavior;

  --EndOfFile

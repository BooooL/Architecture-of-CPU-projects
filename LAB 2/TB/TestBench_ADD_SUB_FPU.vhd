-- ====================================================================
--
--	File Name:		Testbench_ADD_SUB_FPU.vhd
--	Description: test bench for ADD_SUB_FPU
--
--
--	Date:			29/04/2018
--	Designer's:		Maor Assayag, Refael Shetrit
--
-- ====================================================================

LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity Testbench_ADD_SUB_FPU is
end Testbench_ADD_SUB_FPU;

architecture behavior of Testbench_ADD_SUB_FPU is

 -- Component Declaration
 component ADD_SUB_FPU
     generic(N: integer := 32); --defualt value for N is 32
     Port(
        OPP : in std_logic;
        A :     in signed((N-1) downto 0);
        B :     in signed((N-1) downto 0);
        SUM :   out signed((N-1) downto 0));
 end component;

signal N : integer := 32;
 signal OPP :  std_logic := '0';
 signal A :    signed((N-1) downto 0);
 signal B :    signed((N-1) downto 0);
 signal SUM :  signed((N-1) downto 0);
 signal sign : std_logic;
 signal fraction : signed(22 downto 0);
 signal exponent : signed(7 downto 0);

begin
----------------------------------------
  uut :  ADD_SUB_FPU
    port map (OPP,A,B,SUM);

  sign <= SUM(31);
  fraction <= SUM(22 downto 0);
  exponent <= SUM(30 downto 23);

  stim: process
  begin
    wait for 50 ns;
    A <= "00000001100000000000000000000011" ;
    B <= "00000000100000000000000000000001" ;
    wait for 20 ns;

    A <= "00000001100000000000000000000011" ;
    B <= "00000001100000000000000000000011" ;
    wait for 20 ns;

    A <= "00000010000000000000000000000100" ;
    B <= "00000001100000000000000000000011" ;
    wait for 20 ns;

    A <= "00000001100000000000000000000011" ;
    B <= "00000010000000000000000000000100" ;
    wait for 50 ns;
  end process stim;
----------------------------------------
end behavior;

--EndOfFile

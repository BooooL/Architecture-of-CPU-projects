-- ====================================================================
--
--	File Name:		Testbench_slt_FPU.vhd
--	Description: test bench for slt_FPU
--
--
--	Date:			22/05/2018
--	Designer's:		Maor Assayag, Refael Shetrit
-- ====================================================================

LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity Testbench_slt_FPU is
end Testbench_slt_FPU;

architecture behavior of Testbench_slt_FPU is

 -- Component Declaration
 component slt_FPU
     generic(N: integer := 32); --defualt value for N is 32
     Port(
       A :     in signed((N-1) downto 0);
       B :     in signed((N-1) downto 0);
       result :   out std_logic);
 end component;

 signal A :    signed(31 downto 0);
 signal B :    signed(31 downto 0);
 signal result : std_logic;
 signal expected : std_logic;
begin
----------------------------------------
  uut :  slt_FPU
    port map (A,B,result);

  stim: process
  begin
    wait for 50 ns;
    A <= "01000011100000000000000000000000" ; -- 256
    B <= "01000011000000000000000000000011" ; -- 128.00005
    expected <= '0';
    wait for 20 ns;

    A <= "01000011000000000000000000000011" ; -- 128.00005
    B <= "01000011100000000000000000000000" ; -- 256
    expected <= '1';
    wait for 20 ns;

    A <= "01000011010000000000000000000011" ; -- 192.00005
    B <= "01000011000000000000000000000110" ; -- 128.00009
    expected <= '0';
    wait for 20 ns;

    A <= "01000011100000000000000000000000" ; -- 256
    B <= "11000011000000000000000000000011" ; -- (-128.00005)
    expected <= '0';
    wait for 20 ns;

    A <= "11000011000000000000000000000011" ; -- (-128.00005)
    B <= "01000011100000000000000000000000" ; -- 256
    expected <= '1';
    wait for 20 ns;

    A <= "11000011100000000000000000000000" ; -- (-256)
    B <= "01000011000000000000000000000011" ; -- (-128.00005)
    expected <= '1';

    A <= "01000011000000000000000000000011" ; -- (-128.00005)
    B <= "11000011100000000000000000000000" ; -- (-256)
    expected <= '0';
    wait for 20 ns;
  end process stim;
----------------------------------------
end behavior;

--EndOfFile
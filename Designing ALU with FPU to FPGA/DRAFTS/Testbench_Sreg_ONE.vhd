-- ====================================================================
--
--	File Name:		Testbench_SHR_ONER.vhd
--	Description:	test bench for Shift righ : input : N bits A ,output : N bits S
--
--
--	Date:			03/04/2018
--	Designer:		Maor Assayag, Refael Shetrit
--
-- ====================================================================

LIBRARY ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.ALL;

ENTITY Testbench_Sreg_one IS
END Testbench_Sreg_one;

ARCHITECTURE behavior OF Testbench_Sreg_one IS

 -- Component Declaration

 component Sreg_one
 generic(N: integer := 8); --defualt value for N is 8
 port (
      A :inout signed(N-1 downto 0)
 );
end component;

 constant N : integer := 8;
 --Inputs
 signal A : signed((N-1) downto 0) ;
begin
----------------------------------------
   -- Instantiate the Unit Under Test (UUT)
   sreg_comp : Sreg_one PORT MAP (
   A => A
   );

   -- Stimulus process
   stim: process
   begin
     wait for 100 ns;
     A <= "10010010", "00010101" after 50 ns, "00001100" after 100 ns,"00001111" after 150 ns;
     wait for 50 ns;
  end process stim;
----------------------------------------
end behavior;

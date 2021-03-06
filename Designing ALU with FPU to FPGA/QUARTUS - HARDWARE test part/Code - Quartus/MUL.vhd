-- ====================================================================
--
--	File Name:		MUL.vhd
--	Description:	MUL command, currently support N bit's
--
--
--	Date:			02/04/2018
--	Designers:		Maor Assayag, Refael Shetrit
--
-- ====================================================================

-- libraries decleration
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

 -- entity Definition
entity MUL is
    generic(N: integer := 8); --defualt value for N is 8
    Port(
       A :     in signed(N-1 downto 0);
       B :     in signed(N-1 downto 0);
       result: out signed(2*N-1 downto 0));
end MUL;

 -- Architecture Definition
architecture gate_level of MUL is

begin
  ----------------------------------------
  MUL_proc : process(A,B)
  variable  tmp : signed (2*N - 1 downto 0);
  begin
    tmp := A*B;
    result <= tmp;
  end process;
----------------------------------------
end gate_level;

--EndOfFile

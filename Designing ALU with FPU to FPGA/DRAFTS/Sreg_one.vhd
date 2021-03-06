-- ====================================================================
--
--	File Name:		SHR_ONE.vhd
--	Description:	1 bit right
--
--
--	Date:			03/04/2018
--	Designer:		Maor Assayag, Refael Shetrit
--
-- ====================================================================

-- libraries decleration
library ieee;
use ieee.numeric_std.all;

 -- entity Definition
entity Sreg_ont is
  generic(N: integer := 8); --defualt value for N is 8
      Port (
          A :inout signed(N-1 downto 0)
          );
end Sreg_ont;

 -- Architecture Definition
architecture gate_level of Sreg_ont is
  signal Aout : signed(N-1 downto 0);
begin
     loopforshift: for i in N-1 downto 1 generate
       Aout(N-i-1) <= A(N-i);
     end generate;
     Aout(N-1) <= A(N-1) ; -- signed numbers
     A <= Aout;
end gate_level;

--EndOfFile

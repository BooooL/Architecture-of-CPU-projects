-- ====================================================================
--
--	File Name:		LeadingZeroes_counter.vhd
--	Description: return the number X after removing the leading zeroes from it.
--
--
--	Date:			10/04/2018
--	Designer's:		Maor Assayag, Refael Shetrit
--
-- ====================================================================

-- libraries decleration
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

 -- entity Definition
entity LeadingZeroes_counter is
    port (
       Cin: in  std_logic;
       X :  in  signed (21 downto 0);
       dir: out std_logic;
       Y  : out signed (5 downto 0));
end LeadingZeroes_counter;

 -- Architecture Definition
architecture Behavioral of LeadingZeroes_counter is
begin
----------------------------------------
dir <= not Cin; -- if Cin=0 then dir=1->left
process(Cin,X)
variable count : integer;
begin
  if Cin='1' then
    Y <= "000001";
  else
    count := 0;
  for i in 21 downto 0 loop
    if X(i)='1' then
      exit;
    end if;
    count := count + 1;
  end loop;
   Y <= to_signed(count,7)(5 downto 0);
  end if;
end process;
----------------------------------------
end Behavioral;

--EndOfFile
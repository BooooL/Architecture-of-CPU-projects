--25.5.14
--Boris Braginsky
--==========Library===========
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
use ieee.std_logic_arith.all;


entity mux is
port(
	oRed, oGreen, oBlue: in std_logic_vector(11 downto 0);
	gray: in std_logic_vector(11 downto 0);
	out_R: out std_logic_vector(11 downto 0);
	out_G: out std_logic_vector(11 downto 0);
	out_B: out std_logic_vector(11 downto 0);
	switch1,switch2,switch3, iCLK, iRST: in std_logic);
end mux;


architecture behv of mux is


begin


process(iCLK, iRST)
begin
	if(iRST = '0') then
		out_R	<=	"000000000000";
		out_G	<=	"000000000000";
		out_B	<=	"000000000000";
	else
		if (switch1 = '1') then
			out_R <= oRed;
			out_G <= oGreen;
			out_B <= oBlue;
		elsif (switch2 ='1') then
			out_R <= gray;
			out_G <= gray;
			out_B <= gray;
		end if;
	end if;
end process;

end behv;

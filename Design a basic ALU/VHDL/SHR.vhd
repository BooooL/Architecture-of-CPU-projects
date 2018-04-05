-- ====================================================================
--
--	File Name:		SHR.vhd
--	Description:	Shift right command, currently support N bit's
--
--
--	Date:			02/04/2018
--	Designer:		Maor Assayag, Refael Shetrit
--
-- TODO : 1.test bench
-- ====================================================================

-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
-- use ieee.Std_logic_arith.all;

 -- entity Definition
entity SHR is
    generic(N: integer := 8); --defualt value for N is 8
    port(
       A :     in std_logic_vector(N-1 downto 0);
       B :     in std_logic_vector(N-1 downto 0);
       Shift :   out std_logic_vector(N-1 downto 0)
       );
end SHR;

 -- Architecture Definition
architecture gate_level of SHR is
  component SHR_ONE port (
      A :in std_logic_vector(N-1 downto 0);
      Aout : out std_logic_vector(N-1 downto 0)
      );
  end component;

--
-- signal tmp : std_logic_vector (N-1 downto 0) := "10100101";
-- signal tmp2 : integer := conv_integer(B);
-- signal tmp3 : std_logic_vector (N-1 downto 0) ;
begin
  process(A,B)
        variable tmp : integer := conv_integer(B);
        variable tmp2 : std_logic_vector(N-1 downto 0) :=A;
begin
-- ----------------------------------------
-- -- Shift <= std_logic_vector(A srl conv_integer(B));
        loopforshift: for i in 0 to tmp loop
              SHR_ONE port map (tmp2,tmp2);
        end loop;
        Shift <= tmp2;
end process
----------------------------------------
end gate_level;

--EndOfFile

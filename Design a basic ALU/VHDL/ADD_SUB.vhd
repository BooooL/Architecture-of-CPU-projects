-- ====================================================================
--
--	File Name:		ADD_SUB.vhd
--	Description:	ADD & SUB command, currently support N bit's
--                 addORsub = 0 for ADD, 1 for SUB
--
--
--	Date:			02/04/2018
--	Designer:		Maor Assayag, Refael Shetrit
--
-- ====================================================================

-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


 -- entity Definition
entity ADD_SUB is
    generic(N: positive := 8); --defualt value for N is 8
    port(
       addORsub :   in std_logic;
       FLAG : inout std_logic_vector(7 downto 0);
       A :     in signed ((N-1) downto 0);
       B :     in signed ((N-1) downto 0);
       SUM :   out signed ((N-1) downto 0)
       );
end ADD_SUB;

 -- Architecture Definition
architecture gate_level of ADD_SUB is
component twoscomplement
  generic (N : positive := 8 );
  Port (
     X : in  signed (N-1 downto 0);
     Y : out signed (N-1 downto 0)
  );
end component;

component MUX_addORsub
  generic (N : positive := 8 );
  Port (
     SEL: in  std_logic;
     Y1 : in  signed (N-1 downto 0);
     Y2 : in  signed (N-1 downto 0);
     Y  : out signed (N-1 downto 0)
  );
end component;

component ADD
  generic (N : positive := 8 );
  Port(
     A :     in signed((N-1) downto 0);
     B :     in signed((N-1) downto 0);
     SUM :   out signed((N-1) downto 0);
     CARRY : out std_logic
  );
end component;

signal B_2, B_final, temp, tempSUM,tempSUM2 : signed (N-1 downto 0);
signal tempCarry ,CARRY: std_logic;
begin
----------------------------------------
  stage_0 : twoscomplement generic map(N)
   port map (X => B, Y => B_2);

  stage_1 :  ADD  generic map(N)
    port map (A => A,B => B,SUM => tempSUM2,CARRY => CARRY); -- A+B

  stage_2 :  ADD  generic map(N)
    port map (A => A,B => B_2,SUM => tempSUM,CARRY => tempCarry); -- A-B

  stage_3 : MUX_addORsub generic map(N)
   port map (SEL => addORsub, Y1 => tempSUM2, Y2 => tempSUM,Y =>SUM); -- SUM = (A-B) OR (A+B)

  FLAG(0) <= '1'; -- is A=B ?
  eachBit : for i in 0 to (N-1) generate
        stage_i : FLAG(0) <= FLAG(0) AND (NOT tempSUM(i));
    end generate;
  FLAG(1) <= NOT FLAG(0); -- A!=B
  FLAG(2) <= NOT B_final(N-1);--A >= B if tempSUM(N-1)=0 then
  FLAG(3) <= FLAG(2) AND FLAG(1); -- A>B if A>=B & A!=B
  FLAG(4) <= NOT FLAG(3);-- A<=B if !(A>B)
  FLAG(5) <= FLAG(4) AND FLAG(1); -- A<B if (A<=B & A!=B)
----------------------------------------
end gate_level;

--EndOfFile

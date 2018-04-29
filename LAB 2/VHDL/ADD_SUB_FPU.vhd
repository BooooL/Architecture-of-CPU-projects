-- ====================================================================
--
--	File Name:		ADD_SUB_FPU.vhd
--	Description:	ADD\SUB command, currently support N bit's IEEE Standard 754 Floating Point Numbers
--  Floating Point Components       Sign   	Exponent  	Fraction
--               Single Precision 	1 [31] 	8 [30–23] 	23 [22–00]
--               OPP=1 -> SUB, OPP=0 -> ADD
--
--	Date:			29/04/2018
--	Designer:		Maor Assayag, Refael Shetrit
--
-- TODO : test bench
-- ====================================================================

-- libraries decleration
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

 -- entity Definition
entity ADD_SUB_FPU is
    generic(N: integer := 32); --defualt value for N is 32
    Port(
       OPP : in std_logic;
       A :     in signed((N-1) downto 0);
       B :     in signed((N-1) downto 0);
       SUM :   out signed((N-1) downto 0);
       Cout :  out std_logic);
end ADD_SUB_FPU;

 -- Architecture Definition
architecture gate_level of ADD_SUB_FPU is

-- Components
component ADD_SUB
    generic(N: positive := 8); --defualt value for N is 8
    port(
       addORsub :  in std_logic;
       A :     in signed ((N-1) downto 0);
       B :     in signed ((N-1) downto 0);
       SUM :   out signed ((N-1) downto 0);
       Cout  :  out std_logic);
end component;

component Swap
    generic(N: positive := 8); --defualt value for N is 8
    port (
       SEL: in  std_logic;
       Y1 : in  signed (N-1 downto 0);
       Y2 : in  signed (N-1 downto 0);
       Out1  : out signed (N-1 downto 0);
       Out2 :  out signed (N-1 downto 0));
end component;

component shift_unit
    generic(N: integer := 8); --defualt value for N is 8
    port(
       dir :    in std_logic;
       A :      in signed(N-1 downto 0);
       B :      in signed(5 downto 0);
       result : out signed(N-1 downto 0));
end component;



--floating point components extraction signals
signal signA: std_logic;
signal signB: std_logic;
signal expA: signed(7 downto 0);
signal expB: signed(7 downto 0);
signal fractionA: signed(22 downto 0); -- original value
signal fractionB: signed(22 downto 0); -- original value

--temp connection signals
signal expDiff: signed(7 downto 0); -- exponentA - exponentB
signal fraction1: signed(22 downto 0); -- First number fraction
signal fraction2: signed(22 downto 0); -- Second number fraction after alignment
signal temp_fraction2: signed(22 downto 0); -- Second number fraction before alignment
signal SUBorADD: std_logic;
signal carryFractions: std_logic;
signal tempFraction_result : signed(22 downto 0);

begin
----------------------------------------
    signA <= A(31);
    signB <= B(31);
    expA <= A(30 downto 23);
    expB <= B(30 downto 23);
    fractionA <= A(22 downto 0);
    fractionB <= B(22 downto 0);
    SUBorADD <= OPP xor A(31) xor B(31);

    -- Find the difference between the Exponent of A and B : expA - expB, default N=8 bits
    stage_0 : ADD_SUB
              port map ('1', expA, expB, expDiff);

    -- Exponent alligenment preparation : Prepare the fraction of the Number with the min exponent to be shifted
    -- if expDiff(7)=0 -> exponentA-exponentB > 0, shift right fraction B.
    stage_1 : Swap generic map (23)
              port map (expDiff(7), fractionA, fractionB, fraction1, temp_fraction2);

    -- Exponent alligenment : shift right the fraction of the Number with the min exp
    stage_2 : shift_unit generic map(23)
              port map ('1', temp_fraction2, expDiff(5 downto 0), fraction2);

    -- Add/Sub the fractions, save the carry and the temp result for the next step
    stage_3 : ADD_SUB generic map(23)
              port map (SUBorADD, fraction1, fraction2, tempFraction_result, carryFractions);

    -- Remove leading zeroes from the current fraction result, e.g : result = 001110, then result should be 111000
    -- find out how much leading zeros are there
    --stage_4 :
----------------------------------------
end gate_level;

--EndOfFile
-- ====================================================================
--
--	File Name:		ALU.vhd
--	Description: ALU_TOP design
--
--	Date:			11/04/2018
--	Designers:  Maor Assayag, Refael Shetrit
-- ====================================================================

-- libraries decleration
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

 -- entity Definition
entity ALU is
    generic(N: positive := 8); --defualt value for N is 8
    port (
       clk:     in  std_logic;
       FPU_SW  :  in  std_logic; -- switch 16-bit MSB\LSB of FPU_UNIT output
       OPP:     in  std_logic_vector (3 downto 0);
       A:       in  signed (N-1 downto 0);
       B :      in  signed (N-1 downto 0);
       LO :     out signed (N-1 downto 0);
       HI :     out signed (N-1 downto 0);
       STATUS : out signed (5 downto 0));
end ALU;

 -- Architecture Definition
architecture structural of ALU is

component Output_Selector
    generic(N: positive := 8); --defualt value for N is 8
    port (
       SEL:             in  std_logic;
       FPU_SEL :        in  std_logic; -- SHIFT UNIT or FPU UNIT
       FPU_SW :         in  std_logic; -- FPU MSB bits or LSB bits
       FLAG_en :        in  std_logic;
       arithmetic_LO:   in  signed (N-1 downto 0);
       arithmetic_HI:   in  signed (N-1 downto 0);
       arithmetic_FLAG: in  signed (5 downto 0);
       shift_LO :       in  signed (N-1 downto 0);
       FPU_result :     in  signed (31 downto 0);
       LO :             out signed (N-1 downto 0);
       HI :             out signed (N-1 downto 0);
       STATUS :         out signed (5 downto 0));
end component;

component Arithmetic_Unit
    generic(N: positive := 8); --defualt value for N is 8
    port(
      clk : in std_logic;
      A  : in signed(N-1 downto 0);
      B  : in signed(N-1 downto 0);
      OPP : in std_logic_vector (2 downto 0);
      LO : out signed (N-1 downto 0);
      HI : out signed (N-1 downto 0);
      FLAGS : out signed(5 downto 0);
      FLAG_en : out std_logic); -- FLAG_en :if OPP=SUB then -> '1' else -> '0'
end component;

component shift_unit
    generic(N: integer := 8); --defualt value for N is 8
    port(
       dir :    in std_logic;
       A :      in signed(N-1 downto 0);
       B :      in signed(5 downto 0);
       result : out signed(N-1 downto 0));
end component;

component FPU_Unit
    generic(N: positive := 32); --defualt value for N is 8
    port(
        OPP : in std_logic_vector (2 downto 0);
        A  : in signed(N-1 downto 0);
        B  : in signed(N-1 downto 0);
        result : out signed (N-1 downto 0));
end component;

component MUX_Nbits
    generic(N: positive := 8); --defualt value for N is 8
    port (
       SEL: in  std_logic;
       Y1 : in  signed (N-1 downto 0);
       Y2 : in  signed (N-1 downto 0);
       Y  : out signed (N-1 downto 0));
end component;

component FloatingPointConvertor
    generic(N: positive := 8); --defualt value for N is 8
    port (
       A : in  signed (N-1 downto 0);
       B : in  signed (N-1 downto 0);
       Out1  : out signed (31 downto 0);
       Out2 :  out signed (31 downto 0));
end component;

-- global signals
signal FLAGS :   signed(5 downto 0) := (others => '0');
signal FLAG_en : std_logic := '0';

-- temp results from the units
signal arithmetic_LO : signed(N-1 downto 0);
signal arithmetic_HI : signed(N-1 downto 0);
signal shift_LO : signed(N-1 downto 0);
signal FPU_result : signed(31 downto 0);
signal FPU_SEL : std_logic;
signal A_FPU : signed(31 downto 0);
signal B_FPU : signed(31 downto 0);

begin
----------------------------------------
FPU_SEL <= OPP(2) or OPP(1); --select between SHIFT unit & FPU unit. SHIFT OPP : 1000,1001, FPU MUL : 1100, FPU ADD: 1010.
ArithmeticUnit : Arithmetic_Unit generic map (N) port map (clk, A, B, OPP(2 downto 0), arithmetic_LO, arithmetic_HI, FLAGS, FLAG_en);
FloatinPointConvert : FloatingPointConvertor port map (A(7 downto 0), B(7 downto 0), A_FPU, B_FPU);
FPUUnit :       FPU_Unit port map (OPP(2 downto 0), A_FPU, B_FPU, FPU_result);
ShiftUnit :      shift_unit      generic map (N) port map (OPP(0), A, B(5 downto 0), shift_LO);
OutputSelector : Output_Selector generic map (N) port map (OPP(3), FPU_SEL, FPU_SW, FLAG_en, arithmetic_LO, arithmetic_HI, FLAGS, shift_LO, FPU_result, LO, HI, STATUS);
----------------------------------------
end structural;

--EndOfFile

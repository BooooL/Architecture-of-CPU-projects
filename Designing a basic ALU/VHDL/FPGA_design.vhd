-- ====================================================================
--
--	File Name:		FPGA_design.vhd
--	Description: FPGA_design
--
--	Date:			11/04/2018
--	Designers:  Maor Assayag, Refael Shetrit
--
-- ====================================================================

-- libraries decleration
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

 -- entity Definition
entity FPGA_design is
    generic(N: positive := 8); --defualt value for N is 8
    port (
       clk:     in  std_logic;
       numin:   in  signed (N-1 downto 0);
       KEY0:    in  std_logic;
       KEY1:    in  std_logic;
       KEY2:    in  std_logic;
       KEY3:    in  std_logic;
       LO_1 :     out std_logic_vector (6 downto 0);
       LO_2 :     out std_logic_vector (6 downto 0);
       HI_1 :     out std_logic_vector (6 downto 0);
       HI_2 :     out std_logic_vector (6 downto 0);
       STATUS : out std_logic_vector (5 downto 0));
end FPGA_design;

 -- Architecture Definition
architecture structural of FPGA_design is
-------- register for part 1
  component reg_8bit
  port (
      clk : in std_logic;
      en : in std_logic;
      rst : in std_logic;
      d : in signed(7 DOWNTO 0);
      q : out signed(7 DOWNTO 0));
 end component;

------- ALU for part 2
component ALU
port (
   clk:     in  std_logic;
   OPP:     in  std_logic_vector (3 downto 0);
   A:       in  signed (N-1 downto 0);
   B :      in  signed (N-1 downto 0);
   LO :     out signed (N-1 downto 0);
   HI :     out signed (N-1 downto 0);
   STATUS : out signed (5 downto 0));
end component;

------- display_7_segment for part 3
component display_7_segment
port (
        q        : in std_logic_vector (7 downto 0);
        segment1 : out std_logic_vector (6 downto 0);
        segment2 : out std_logic_vector (6 downto 0));
end component;


 signal q_Anumber : signed(N-1 downto 0);
 signal q_Bnumber : signed(N-1 downto 0);
 signal q_OPnumber : signed(N-1 downto 0);
 signal LO : signed(N-1 downto 0);
 signal HI : signed(N-1 downto 0);
 signal STATUS_from_ALU : signed (5 downto 0);
begin
----------------------------------------
----------registers
A_number: reg_8bit port map (clk, KEY0,KEY3, numin, q_Anumber);
OP_number: reg_8bit port map (clk, KEY1,KEY3, numin, q_OPnumber);
B_number: reg_8bit port map (clk, KEY2,KEY3, numin, q_Bnumber);

---------------ALU
ALU_op: ALU port map (clk, std_logic_vector(q_OPnumber(3 downto 0)),q_Anumber, q_Bnumber, LO,HI,STATUS_from_ALU);


------------convert to 7 segment
convert_7_segment_1: display_7_segment port map (std_logic_vector(LO),LO_1, LO_2);
convert_7_segment_2: display_7_segment port map (std_logic_vector(HI),HI_1,HI_2);


----------------------------------------
end structural;

--EndOfFile

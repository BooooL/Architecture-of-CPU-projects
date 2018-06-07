-- VHDL Entity MIPS.MIPS_tb.symbol
--
-- Created:
--          by - kolaman.UNKNOWN (KOLAMAN-PC)
--          at - 09:22:45 17/02/2013
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2011.1 (Build 18)
--


ENTITY MIPS_tb IS
-- Declarations

END MIPS_tb ;

--
-- VHDL Architecture MIPS.MIPS_tb.struct
--
-- Created:
--          by - kolaman.UNKNOWN (KOLAMAN-PC)
--          at - 09:22:45 17/02/2013
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2011.1 (Build 18)
--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

LIBRARY work;

ARCHITECTURE struct OF MIPS_tb IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL ALU_result_out  : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
   SIGNAL Branch_out      : STD_LOGIC;
   SIGNAL Instruction_out : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
   SIGNAL Memwrite_out    : STD_LOGIC;
   SIGNAL PC              : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
   SIGNAL Regwrite_out    : STD_LOGIC;
   SIGNAL Zero_out        : STD_LOGIC;
   SIGNAL clock           : STD_LOGIC;
   SIGNAL read_data_1_out : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
   SIGNAL read_data_2_out : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
   SIGNAL button_GPIO           : STD_LOGIC;
   SIGNAL reset           : STD_LOGIC;
   SIGNAL write_data_out  : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL LO_1              : STD_LOGIC_VECTOR( 6 DOWNTO 0 );
SIGNAL LO_2              : STD_LOGIC_VECTOR( 6 DOWNTO 0 );
SIGNAL HI_1              : STD_LOGIC_VECTOR( 6 DOWNTO 0 );
SIGNAL HI_2              : STD_LOGIC_VECTOR( 6 DOWNTO 0 );

   -- Component Declarations
   COMPONENT MIPS
		PORT( reset, clock,button_GPIO					: IN 	STD_LOGIC;
					-- Output important signals to pins for easy display in Simulator
					PC								: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
					ALU_result_out, read_data_1_out, read_data_2_out, write_data_out,
						Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
					Branch_out, Zero_out, Memwrite_out,
					Regwrite_out					: OUT 	STD_LOGIC ;
				  LO_1    			    :     out  std_logic_vector (6 downto 0);
			     LO_2    				 :     out  std_logic_vector (6 downto 0);
			     HI_1    				 :     out  std_logic_vector (6 downto 0);
			     HI_2   				 :     out  std_logic_vector (6 downto 0));
   END COMPONENT;
   COMPONENT MIPS_tester
   PORT (
		button_GPIO  : out std_LOGIC;
      ALU_result_out  : IN     STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
      Branch_out      : IN     STD_LOGIC ;
      Instruction_out : IN     STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
      Memwrite_out    : IN     STD_LOGIC ;
      PC              : IN     STD_LOGIC_VECTOR ( 9 DOWNTO 0 );
      Regwrite_out    : IN     STD_LOGIC ;
      Zero_out        : IN     STD_LOGIC ;
      read_data_1_out : IN     STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
      read_data_2_out : IN     STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
      write_data_out  : IN     STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
      clock           : OUT    STD_LOGIC ;
      reset           : OUT    STD_LOGIC 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : MIPS USE ENTITY work.mips;
   FOR ALL : MIPS_tester USE ENTITY work.mips_tester;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_0 : MIPS
      PORT MAP (
         reset           => reset,
         clock           => clock,
         button_GPIO => button_GPIO,
         PC              => PC,
         ALU_result_out  => ALU_result_out,
         read_data_1_out => read_data_1_out,
         read_data_2_out => read_data_2_out,
         write_data_out  => write_data_out,
         Instruction_out => Instruction_out,
         Branch_out      => Branch_out,
         Zero_out        => Zero_out,
         Memwrite_out    => Memwrite_out,
         Regwrite_out    => Regwrite_out,
         LO_1 => LO_1,
         LO_2 => LO_2,
         HI_1 => HI_1,
         HI_2 => HI_2
      );
   U_1 : MIPS_tester
      PORT MAP (
			button_GPIO => button_GPIO,
         ALU_result_out  => ALU_result_out,
         Branch_out      => Branch_out,
         Instruction_out => Instruction_out,
         Memwrite_out    => Memwrite_out,
         PC              => PC,
         Regwrite_out    => Regwrite_out,
         Zero_out        => Zero_out,
         read_data_1_out => read_data_1_out,
         read_data_2_out => read_data_2_out,
         write_data_out  => write_data_out,
         clock           => clock,
         reset           => reset
      );

END struct;

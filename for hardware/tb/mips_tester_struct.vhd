-- VHDL Entity MIPS.MIPS_tester.interface
--
-- Created:
--          by - kolaman.UNKNOWN (KOLAMAN-PC)
--          at - 09:22:44 17/02/2013
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2011.1 (Build 18)
--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MIPS_tester IS
   PORT(
		button_GPIO  : out std_LOGIC;
      ALU_result_out  : IN     STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
      Branch_out      : IN     STD_LOGIC;
      Instruction_out : IN     STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
      Memwrite_out    : IN     STD_LOGIC;
      PC              : IN     STD_LOGIC_VECTOR ( 9 DOWNTO 0 );
      Regwrite_out    : IN     STD_LOGIC;
      Zero_out        : IN     STD_LOGIC;
      read_data_1_out : IN     STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
      read_data_2_out : IN     STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
      write_data_out  : IN     STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
      clock           : OUT    STD_LOGIC;
      reset           : OUT    STD_LOGIC
   );

-- Declarations

END MIPS_tester ;

--
-- VHDL Architecture MIPS.MIPS_tester.struct
--
-- Created:
--          by - kolaman.UNKNOWN (KOLAMAN-PC)
--          at - 09:22:44 17/02/2013
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2011.1 (Build 18)
--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;


ARCHITECTURE struct OF MIPS_tester IS

   -- Architecture declarations

   -- Internal signal declarations


   -- ModuleWare signal declarations(v1.9) for instance 'U_0' of 'clk'
   SIGNAL mw_U_0clk : std_logic;
   SIGNAL mw_U_0disable_clk : boolean := FALSE;

   -- ModuleWare signal declarations(v1.9) for instance 'U_1' of 'pulse'
   SIGNAL mw_U_1pulse : std_logic :='0';


BEGIN

   -- ModuleWare code(v1.9) for instance 'U_0' of 'clk'
   u_0clk_proc: PROCESS
   BEGIN
      WHILE NOT mw_U_0disable_clk LOOP
         mw_U_0clk <= '0', '1' AFTER 70 ns;
         WAIT FOR 140 ns;
      END LOOP;
      WAIT;
   END PROCESS u_0clk_proc;
   mw_U_0disable_clk <= TRUE AFTER 120000 ns;
   clock <= mw_U_0clk;

   -- ModuleWare code(v1.9) for instance 'U_1' of 'pulse'
   reset <= mw_U_1pulse;
   u_1pulse_proc: PROCESS
   BEGIN
		button_GPIO <= 
		'0',
		'1' AFTER 100000 ns;
      mw_U_1pulse <=
         '0',
         '1' AFTER 70 ns,
         '0' AFTER 145 ns;
      WAIT;
    END PROCESS u_1pulse_proc;

   -- Instance port mappings.

END struct;
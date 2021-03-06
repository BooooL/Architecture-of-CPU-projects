-- ====================================================================
--
--	File Name:		MIPS.vhd
--	Description:	Top Level Structural Model for MIPS Processor Core
--
--
--	Date:			30/05/2018
--	Designers:		Maor Assayag, Refael Shetrit
--
-- ====================================================================

-- libraries decleration
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

 -- entity Definition
ENTITY MIPS IS
		PORT( reset, clock_in,button_GPIO					: IN 	STD_LOGIC;
					-- Output important signals to pins for easy display in Simulator
					PC								: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
					ALU_result_out, read_data_1_out, read_data_2_out, write_data_out,
						Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
					Branch_out, Zero_out, Memwrite_out,
					Regwrite_out					: OUT 	STD_LOGIC ;
					mips_int              : In 	STD_LOGIC ;
				  LO_1    			    :     out  std_logic_vector (6 downto 0);
			     LO_2    				 :     out  std_logic_vector (6 downto 0);
			     HI_1    				 :     out  std_logic_vector (6 downto 0);
			     HI_2   				 :     out  std_logic_vector (6 downto 0));
		END 	MIPS;

 -- Architecture Definition
ARCHITECTURE structure OF MIPS IS
---------------------------------PLL
	 component PLL port(
	      areset		: IN STD_LOGIC  := '0';
		   inclk0		: IN STD_LOGIC  := '0';
		       c0		: OUT STD_LOGIC ;
		    locked		: OUT STD_LOGIC );
    end component;


		-- regs
		component N_dff
		generic(N: integer := 8); --defualt value for N is 8
		port (
				clk : in std_logic;
				enable : in std_logic;
				rst : in std_logic;
				D : in STD_LOGIC_VECTOR(N-1 downto 0);
				Q : out STD_LOGIC_VECTOR(N-1 downto 0));
		end component;

	COMPONENT Ifetch
   	     PORT(	Instruction			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		PC_plus_4_out 			: OUT  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        		Add_result 					: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
						Branch_Beq_f 			: IN 	STD_LOGIC;
 					  Branch_Bne_f 			: IN 	STD_LOGIC;
						Zero 								: IN 	STD_LOGIC;
						mips_int 						: in std_logic;
        		PC_out 							: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        		clock,reset ,data_hazard_en_fetch				: IN 	STD_LOGIC );
	END COMPONENT;


	COMPONENT  Execute_branch IS
		PORT(	Read_data_1_branch 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
					Read_data_2_branch 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
					Sign_extend_branch 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
					ALUOp_branch 		  	: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
					ALUSrc_branch 			  : IN 	STD_LOGIC;
					Zero_branch 		     	: OUT	STD_LOGIC;
					Add_Result_branch 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
					PC_plus_4_branch 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
					clock, reset	: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT Idecode
 	     PORT(	read_data_1 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		read_data_2 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
						old_Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		Instruction 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		read_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		ALU_result 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		RegWrite, MemtoReg 	: IN 	STD_LOGIC;
        		RegDst 				: IN 	STD_LOGIC;
        		Sign_extend 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		clock, reset,button_GPIO		: IN 	STD_LOGIC ;
				LO_1    			    :     out  std_logic_vector (6 downto 0);
			   LO_2    				 :     out  std_logic_vector (6 downto 0);
			   HI_1    				 :     out  std_logic_vector (6 downto 0);
			   HI_2   				 :     out  std_logic_vector (6 downto 0));
	END COMPONENT;

	COMPONENT control
	     PORT( 	Opcode 				: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
             	RegDst 				: OUT 	STD_LOGIC;
             	ALUSrc 				: OUT 	STD_LOGIC;
             	MemtoReg 			: OUT 	STD_LOGIC;
             	RegWrite 			: OUT 	STD_LOGIC;
             	MemRead 			: OUT 	STD_LOGIC;
             	MemWrite 			: OUT 	STD_LOGIC;
							Branch_Beq 		: OUT 	STD_LOGIC;
						  Branch_Bne 		: OUT 	STD_LOGIC;
             	ALUop 				: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
							data_hazard 		 : in 	STD_LOGIC;
             	clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT  Execute
   	     PORT(	Read_data_1 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
                Read_data_2 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Sign_Extend 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Function_opcode		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
               	ALUOp 				: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
               	ALUSrc 				: IN 	STD_LOGIC;
               	ALU_Result 			: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT dmemory
	     PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		address 			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        		write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		MemRead, Memwrite 	: IN 	STD_LOGIC;
        		Clock,reset			: IN 	STD_LOGIC );
	END COMPONENT;

			component dff_1bit
					  port (
								clk : in std_logic;
								en : in std_logic;
								rst : in std_logic;
								d : in std_logic;
								q : out std_logic);
		 end component;

		 component HAZARD
	   port (
						 Instruction_IF 		 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
						 Instruction_ID 		 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
					 	Instruction_EXE 		 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
					 	Instruction_MEM 		 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
					 	MEM_read_EXE  : IN 	STD_LOGIC;
					 	MEM_read_mem  : IN 	STD_LOGIC;
						MEM_read_ID  : IN 	STD_LOGIC;
						RegWrite_EXE  : IN 	STD_LOGIC;
						RegWrite_mem  : IN 	STD_LOGIC;
						RegWrite_ID  : IN 	STD_LOGIC;
					 	data_hazard_en 		 : OUT 	STD_LOGIC;
					 	Branch_en 		       : OUT 	STD_LOGIC;
					 	Branch_beq_hazard  : IN 	STD_LOGIC;
					 	Branch_bne_hazard  : IN 	STD_LOGIC;
					 	branch_zero        : IN 	STD_LOGIC;
					 	clock, reset	   : IN 	STD_LOGIC
	   );
	  end component;

					-- declare signals used to connect VHDL components
	SIGNAL PC_plus_4_1 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL PC_plus_4_2 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL PC_plus_4_3 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );


	SIGNAL read_data_1_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_1_3 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL read_data_2_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2_3 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2_4 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );


	SIGNAL Sign_Extend_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend_3 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );


	SIGNAL Add_result_1 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );

	SIGNAL ALU_result_2		  : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_result_3 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_result_4 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );


	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_fromMem 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_4 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL ALUSrc_control 			: STD_LOGIC;
	SIGNAL ALUSrc_3 		      	: STD_LOGIC;


	SIGNAL Branch_control_Beq 			      : STD_LOGIC;
	SIGNAL Branch_control_Bne 			      : STD_LOGIC;

	SIGNAL RegDst_2 			: STD_LOGIC;
	SIGNAL RegDst_3 			: STD_LOGIC;
	SIGNAL RegDst_4 			: STD_LOGIC;
	SIGNAL RegDst_control 			: STD_LOGIC;


	SIGNAL Regwrite_2 		: STD_LOGIC;
	SIGNAL Regwrite_3 		: STD_LOGIC;
	SIGNAL Regwrite_4 		: STD_LOGIC;
	SIGNAL Regwrite_control 		: STD_LOGIC;


	SIGNAL Zero_1 			  : STD_LOGIC;


	SIGNAL MemWrite_control 		: STD_LOGIC;
	SIGNAL MemWrite_3 		: STD_LOGIC;
	SIGNAL MemWrite_4 		: STD_LOGIC;


	SIGNAL MemtoReg_2 		: STD_LOGIC;
	SIGNAL MemtoReg_3		: STD_LOGIC;
	SIGNAL MemtoReg_4 		: STD_LOGIC;
	SIGNAL MemtoReg_control 		: STD_LOGIC;


	SIGNAL MemRead_control 			: STD_LOGIC;
	SIGNAL MemRead_3 			      : STD_LOGIC;
	SIGNAL MemRead_4 			      : STD_LOGIC;


	SIGNAL ALUop_control 			: STD_LOGIC_VECTOR(  1 DOWNTO 0 );
	SIGNAL ALUop_2  			: STD_LOGIC_VECTOR(  1 DOWNTO 0 );
	SIGNAL ALUop_3 			      : STD_LOGIC_VECTOR(  1 DOWNTO 0 );

	SIGNAL Instruction_1		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_2		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_3		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_4		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_old		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL data_hazard_en 		: STD_LOGIC;
	SIGNAL Branch_en 		: STD_LOGIC;


	SIGNAL clock 		: STD_LOGIC;

BEGIN
----------------------------------------
					-- copy important signals to output pins for easy
					-- display in Simulator
   Instruction_out 	<= Instruction_1;
   ALU_result_out 	<= ALU_result_2;
   read_data_1_out 	<= read_data_1_2;
   read_data_2_out 	<= read_data_2_2;
   write_data_out  	<= read_data_2 WHEN MemtoReg_2 = '1' ELSE ALU_result_4;
   Branch_out 		<= Branch_control_Beq Or Branch_control_Bne ;
   Zero_out 		<= Zero_1;
   RegWrite_out 	<= Regwrite_2;
   MemWrite_out 	<= MemWrite_4;

-------------------- pll
	  m1: PLL port map(
	     inclk0 => clock_in,
		  c0 => clock
	   );





----------------------- HAZARD
	HAZ :  HAZARD
		port map (
						Instruction_IF 	    => Instruction_1,
						Instruction_ID 	    => Instruction_2,
					   Instruction_EXE 		=> Instruction_3,
				 	   Instruction_MEM 		=> Instruction_4,
						MEM_read_EXE   =>   MemRead_3,
					   MEM_read_mem    =>   MemRead_4,
					  	MEM_read_ID => MemRead_control,
						RegWrite_EXE => Regwrite_3,
						RegWrite_mem => Regwrite_4,
						RegWrite_ID => Regwrite_control,
						data_hazard_en => data_hazard_en,
						Branch_en => Branch_en,
						Branch_beq_hazard => Branch_control_Beq,
						Branch_bne_hazard => Branch_control_Bne,
						branch_zero	=> Zero_1,
						clock => clock,
						reset => reset
	);

	-- connect the 5 MIPS components
	------------------------------- 1
  IFE : Ifetch
	PORT MAP (	Instruction 	=> Instruction_1,
    	    	PC_plus_4_out 	=> PC_plus_4_1,
						Add_result 			=> Add_result_1,
						Branch_Beq_f 					=> Branch_control_Beq,
						Branch_Bne_f 					=> Branch_control_Bne,
						Zero 						=> Zero_1,
						mips_int =>    mips_int,
						PC_out 					=> PC,
						clock 					=> clock,
						reset 					=> reset,
						data_hazard_en_fetch => data_hazard_en );

--          Ife/dec
	 Instruction_A: N_dff generic map(32) port map (clock, data_hazard_en, Branch_en or (NOT data_hazard_en), Instruction_1, Instruction_2);
	 PC_plus_4_A: N_dff generic map(10) port map (clock, data_hazard_en, Branch_en or (NOT data_hazard_en), PC_plus_4_1, PC_plus_4_2);

 ---------------------------------     2
   ID : Idecode
   	PORT MAP (	read_data_1 	=> read_data_1_2,
        		read_data_2 	=> read_data_2_2,
						old_Instruction =>Instruction_old,
        		Instruction 	=> Instruction_2,
        		read_data 		=> read_data_2,
						ALU_result 		=> ALU_result_2,
						RegWrite 		=> Regwrite_2,
						MemtoReg 		=> MemtoReg_2,
						RegDst 			=> RegDst_2,
						Sign_extend 	=> Sign_Extend_2,
        		clock 			=> clock,
						reset 			=> reset,
					button_GPIO => button_GPIO,
				   LO_1 => LO_1,
				   LO_2 => LO_2,
				   HI_1 => HI_1,
				   HI_2 => HI_2	);

   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction_2( 31 DOWNTO 26 ),
				RegDst 			=> RegDst_control,
				ALUSrc 			=> ALUSrc_control,
				MemtoReg 		=> MemtoReg_control,
				RegWrite 		=> Regwrite_control,
				MemRead 		=> MemRead_control,
				MemWrite 		=> MemWrite_control,
				Branch_Beq 			=> Branch_control_Beq,
				Branch_Bne 			=> Branch_control_Bne,
				ALUop 			=> ALUop_control,
				data_hazard => data_hazard_en,
        clock 			=> clock,
				reset 			=> reset );

		 EXE_brn: Execute_branch
				PORT MAP(	Read_data_1_branch =>	read_data_1_2,
							Read_data_2_branch => read_data_2_2,
							Sign_extend_branch 		=> Sign_Extend_2,
							ALUOp_branch 		=> ALUop_control,
							ALUSrc_branch 		=> ALUSrc_control,
							Zero_branch 		     	=> Zero_1,
							Add_Result_branch 	=> Add_result_1,
							PC_plus_4_branch 		=> PC_plus_4_2,
							clock	=> clock,
							 reset		=> reset
							  );

		--          dec/EX
	 Instruction_B: N_dff generic map(32) port map (clock, '1', reset, Instruction_2, Instruction_3);
	 read_data_1_B: N_dff generic map(32) port map (clock, '1', reset, read_data_1_2, read_data_1_3);
	 read_data_2_B: N_dff generic map(32) port map (clock, '1', reset, read_data_2_2, read_data_2_3);
	 Sign_Extend_2_B: N_dff generic map(32) port map (clock, '1', reset, Sign_Extend_2, Sign_Extend_3);
	 ALUop_control_B: N_dff generic map(2) port map (clock, '1', reset, ALUop_control, ALUop_3);
	 Regwrite_control_B: dff_1bit port map (clock, '1', reset, Regwrite_control, Regwrite_3);
	 MemtoReg_control_B: dff_1bit port map (clock, '1', reset, MemtoReg_control, MemtoReg_3);
	 RegDst_control_B: dff_1bit port map (clock, '1', reset, RegDst_control, RegDst_3);
	 MemWrite_control_B: dff_1bit port map (clock, '1', reset, MemWrite_control, MemWrite_3);
	 ALUSrc_control_B: dff_1bit port map (clock, '1', reset, ALUSrc_control, ALUSrc_3);
	 MemRead_control_B: dff_1bit port map (clock, '1', reset, MemRead_control, MemRead_3);

----------------------------------- 3
   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1_3,
             		Read_data_2 	=> read_data_2_3,
								Sign_extend 	=> Sign_Extend_3,
                Function_opcode	=> Instruction_3( 5 DOWNTO 0 ),
								ALUOp 			=> ALUop_3,
								ALUSrc 			=> ALUSrc_3,
                ALU_Result		=> ALU_result_3,
                Clock			=> clock,
								Reset			=> reset );

		Instruction_C: N_dff generic map(32) port map (clock, '1', reset, Instruction_3, Instruction_4);
		ALU_result_C: N_dff generic map(32) port map (clock, '1', reset, ALU_result_3, ALU_result_4);
		read_data_2_C: N_dff generic map(32) port map (clock, '1', reset, read_data_2_3, read_data_2_4);
		Regwrite_control_C: dff_1bit port map (clock, '1', reset, Regwrite_3, Regwrite_4);
		MemtoReg_control_C: dff_1bit port map (clock, '1', reset, MemtoReg_3, MemtoReg_4);
		RegDst_control_C: dff_1bit port map (clock, '1', reset, RegDst_3, RegDst_4);
		MemWrite_C: dff_1bit port map (clock, '1', reset, MemWrite_3, MemWrite_4);
		MemRead_control_C: dff_1bit port map (clock, '1', reset, MemRead_3, MemRead_4);

-------------------------------- 4
   MEM:  dmemory
	PORT MAP (	read_data 		=> read_data_4,
							address 		=> ALU_result_4 (9 DOWNTO 2),--jump memory address by 4
							write_data 		=> read_data_2_4,
							MemRead 		=> MemRead_4,
							Memwrite 		=> MemWrite_4,
              clock 			=> clock,
							reset 			=> reset );

		Instruction_D: N_dff generic map(32) port map (clock, '1', reset, Instruction_4, Instruction_old);
		read_data_D: N_dff generic map(32) port map (clock, '1', reset, read_data_4, read_data_2);
		ALU_result_D: N_dff generic map(32) port map (clock, '1', reset, ALU_result_4, ALU_result_2);
		Regwrite_control_D: dff_1bit port map (clock, '1', reset, Regwrite_4, Regwrite_2);
		MemtoReg_control_D: dff_1bit port map (clock, '1', reset, MemtoReg_4, MemtoReg_2);
		RegDst_control_D: dff_1bit port map (clock, '1', reset, RegDst_4, RegDst_2);
----------------------------------------
END structure;

--EndOfFile

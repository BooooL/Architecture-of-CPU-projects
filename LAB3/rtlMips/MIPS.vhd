				-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MIPS IS

	PORT( reset, clock					: IN 	STD_LOGIC;
		-- Output important signals to pins for easy display in Simulator
		PC								: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		ALU_result_out, read_data_1_out, read_data_2_out, write_data_out,
     	Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Branch_out, Zero_out, Memwrite_out,
		Regwrite_out					: OUT 	STD_LOGIC );
END 	MIPS;

ARCHITECTURE structure OF MIPS IS

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
        		Branch 							: IN 	STD_LOGIC;
        		Zero 								: IN 	STD_LOGIC;
        		PC_out 							: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        		clock,reset 				: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT Idecode
 	     PORT(	read_data_1 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		read_data_2 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		Instruction 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		read_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		ALU_result 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		RegWrite, MemtoReg 	: IN 	STD_LOGIC;
        		RegDst 				: IN 	STD_LOGIC;
        		Sign_extend 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT control
	     PORT( 	Opcode 				: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
             	RegDst 				: OUT 	STD_LOGIC;
             	ALUSrc 				: OUT 	STD_LOGIC;
             	MemtoReg 			: OUT 	STD_LOGIC;
             	RegWrite 			: OUT 	STD_LOGIC;
             	MemRead 			: OUT 	STD_LOGIC;
             	MemWrite 			: OUT 	STD_LOGIC;
             	Branch 				: OUT 	STD_LOGIC;
             	ALUop 				: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
             	clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT  Execute
   	     PORT(	Read_data_1 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
                Read_data_2 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Sign_Extend 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Function_opcode		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
               	ALUOp 				: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
               	ALUSrc 				: IN 	STD_LOGIC;
               	Zero 				: OUT	STD_LOGIC;
               	ALU_Result 			: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Add_Result 			: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
               	PC_plus_4 			: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
               	clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;


	COMPONENT dmemory
	     PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		address 			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        		write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		MemRead, Memwrite 	: IN 	STD_LOGIC;
        		Clock,reset			: IN 	STD_LOGIC );
	END COMPONENT;

					-- declare signals used to connect VHDL components
	SIGNAL PC_plus_4_1 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL PC_plus_4_2 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL PC_plus_4_3 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );


	SIGNAL read_data_1_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_1_3 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL read_data_2_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2_3 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL Sign_Extend 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL Add_result_1 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL Add_result_3 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );

	SIGNAL ALU_result_2		  : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_result_3 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_result_4 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );


	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_4 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL ALUSrc 			: STD_LOGIC;

	SIGNAL Branch_1 			: STD_LOGIC;
	SIGNAL Branch_2 			: STD_LOGIC;

	SIGNAL RegDst_2 			: STD_LOGIC;
	SIGNAL RegDst_3 			: STD_LOGIC;
	SIGNAL RegDst_4 			: STD_LOGIC;
	SIGNAL RegDst_control 			: STD_LOGIC;


	SIGNAL Regwrite_2 		: STD_LOGIC;
	SIGNAL Regwrite_3 		: STD_LOGIC;
	SIGNAL Regwrite_4 		: STD_LOGIC;
	SIGNAL Regwrite_control 		: STD_LOGIC;


	SIGNAL Zero_1 			  : STD_LOGIC;
	SIGNAL Zero_3 			  : STD_LOGIC;

	SIGNAL MemWrite 		: STD_LOGIC;

	SIGNAL MemtoReg_2 		: STD_LOGIC;
	SIGNAL MemtoReg_3		: STD_LOGIC;
	SIGNAL MemtoReg_4 		: STD_LOGIC;
	SIGNAL MemtoReg_control 		: STD_LOGIC;


	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL ALUop 			: STD_LOGIC_VECTOR(  1 DOWNTO 0 );
	SIGNAL Instruction_1		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_2		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Instruction_3		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );


BEGIN
					-- copy important signals to output pins for easy
					-- display in Simulator
   Instruction_out 	<= Instruction_1;
   ALU_result_out 	<= ALU_result_2;
   read_data_1_out 	<= read_data_1_2;
   read_data_2_out 	<= read_data_2_2;
   write_data_out  	<= read_data WHEN MemtoReg_2 = '1' ELSE ALU_result;
   Branch_out 		<= Branch_1;
   Zero_out 		<= Zero_1;
   RegWrite_out 	<= Regwrite_2;
   MemWrite_out 	<= MemWrite;
					-- connect the 5 MIPS components

					------------------------------- 1
  IFE : Ifetch
	PORT MAP (	Instruction 	=> Instruction_1,
    	    	PC_plus_4_out 	=> PC_plus_4_1,
						Add_result 			=> Add_result_1,
						Branch 					=> Branch_1,
						Zero 						=> Zero,
						PC_out 					=> PC,
						clock 					=> clock,
						reset 					=> reset );

--          Ife/dec
	 Instruction_A: N_dff generic map(32) port map (clock, '1', reset, Instruction_1, Instruction_2);
	 PC_plus_4_A: N_dff generic map(10) port map (clock, '1', reset, PC_plus_4_1, PC_plus_4_2);

 ---------------------------------     2
   ID : Idecode
   	PORT MAP (	read_data_1 	=> read_data_1_2,
        		read_data_2 	=> read_data_2_2,
        		Instruction 	=> Instruction_2,
        		read_data 		=> read_data_2,
						ALU_result 		=> ALU_result_2,
						RegWrite 		=> Regwrite_2,
						MemtoReg 		=> MemtoReg_2,
						RegDst 			=> RegDst,
						Sign_extend 	=> Sign_extend,
        		clock 			=> clock,
						reset 			=> reset );


   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction_2( 31 DOWNTO 26 ),
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg_control,
				RegWrite 		=> Regwrite_control,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				Branch 			=> Branch_2,
				ALUop 			=> ALUop,
        clock 			=> clock,
				reset 			=> reset );

		--          dec/EX
	 Instruction_B: N_dff generic map(32) port map (clock, '1', reset, Instruction_2, Instruction_3);
	 PC_plus_4_B: N_dff generic map(10) port map (clock, '1', reset, PC_plus_4_2, PC_plus_4_3);
	 read_data_1_B: N_dff generic map(32) port map (clock, '1', reset, read_data_1_2, read_data_1_3);
	 read_data_2_B: N_dff generic map(32) port map (clock, '1', reset, read_data_2_2, read_data_2_3);
	 Branch_B: N_dff generic map(1) port map (clock, '1', reset, Branch_2, Branch_1);
	 Regwrite_control_B: N_dff generic map(1) port map (clock, '1', reset, Regwrite_control, Regwrite_3);
	 MemtoReg_control_B: N_dff generic map(1) port map (clock, '1', reset, MemtoReg_control, MemtoReg_3);




----------------------------------- 3

   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1_3,
             		Read_data_2 	=> read_data_2_3,
								Sign_extend 	=> Sign_extend,
                Function_opcode	=> Instruction_3( 5 DOWNTO 0 ),
								ALUOp 			=> ALUop,
								ALUSrc 			=> ALUSrc,
								Zero 			=> Zero_3,
                ALU_Result		=> ALU_result_3,
								Add_Result 		=> Add_result_3,
								PC_plus_4		=> PC_plus_4_3,
                Clock			=> clock,
								Reset			=> reset );


		Add_result_C: N_dff generic map(8) port map (clock, '1', reset, Add_result_3, Add_result_1);
		Zero_C: N_dff generic map(1) port map (clock, '1', reset, Zero_3, Zero_1);
		ALU_result_C: N_dff generic map(32) port map (clock, '1', reset, ALU_result_3, ALU_result_4);
		Regwrite_control_C: N_dff generic map(1) port map (clock, '1', reset, Regwrite_3, Regwrite_4);
		MemtoReg_control_C: N_dff generic map(1) port map (clock, '1', reset, MemtoReg_3, MemtoReg_4);



-------------------------------- 4
   MEM:  dmemory
	PORT MAP (	read_data 		=> read_data_4,
							address 		=> ALU_result_4 (9 DOWNTO 2),--jump memory address by 4
							write_data 		=> read_data_2,
							MemRead 		=> MemRead,
							Memwrite 		=> MemWrite,
              clock 			=> clock,
							reset 			=> reset );



  	read_data_D: N_dff generic map(32) port map (clock, '1', reset, read_data_4, read_data_2);
		ALU_result_D: N_dff generic map(32) port map (clock, '1', reset, ALU_result_4, ALU_result_2);
		Regwrite_control_D: N_dff generic map(1) port map (clock, '1', reset, Regwrite_3, Regwrite_2);
		MemtoReg_control_D: N_dff generic map(1) port map (clock, '1', reset, MemtoReg_4, MemtoReg_2);


END structure;

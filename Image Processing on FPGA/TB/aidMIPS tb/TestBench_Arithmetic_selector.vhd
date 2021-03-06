-- ====================================================================
--
--	File Name:		Testbench_Arithmetic_selector.vhd
--	Description: test bench for Arithmetic_selector unit
--
--
--	Date:			11/04/2018
--	Designer:		Maor Assayag, Refael Shetrit
--
-- ====================================================================

LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity Testbench_Arithmetic_selector is
end Testbench_Arithmetic_selector;

architecture behavior of Testbench_Arithmetic_selector is

 -- Component Declaration
 component Arithmetic_selector
   generic(N: positive := 8); --defualt value for N is 8
     port(
     clk : in std_logic;
     OPP :   in std_logic_vector (2 downto 0);
     MUL_result : in signed (2*N-1 downto 0);
     MAX_MIN_LO : in signed ((N-1) downto 0);
     ADD_SUB_result : in signed (2*N-1 downto 0);
     HI : out signed ((N-1) downto 0);
     LO : out signed ((N-1) downto 0);
     FLAG_en : out std_logic); -- FLAG_en :if OPP=SUB then -> '1' else -> '0'
 end component;

constant N : integer := 8;
signal clk :  std_logic := '0';
signal OPP :    std_logic_vector (2 downto 0);
signal MUL_result :  signed (2*N-1 downto 0);
signal MAX_MIN_LO :  signed ((N-1) downto 0);
signal ADD_SUB_result :  signed (2*N-1 downto 0);
signal HI :  signed ((N-1) downto 0);
signal LO :  signed ((N-1) downto 0);
signal FLAG_en :  std_logic; -- FLAG_en :if OPP=SUB then -> '1' else -> '0'
begin
----------------------------------------
  uut :  Arithmetic_selector  generic map(N)
    port map (clk,OPP,MUL_result,MAX_MIN_LO,ADD_SUB_result,HI,LO,FLAG_en);

  stim: process
  begin
    wait for 10 ns;
      clk <= '1';
      OPP <= "100";
      MUL_result <= "0000000011110000";
      MAX_MIN_LO <= "00111100";
      ADD_SUB_result <= "0000000011111111";
      
    wait for 10 ns;
    clk <= '0';
    OPP <= "100";
    
    wait for 10 ns;
    clk <= '1';
    OPP <= "000";
    
    wait for 10 ns;
    clk <= '0';
    OPP <= "001";
    
    wait for 10 ns;
    clk <= '1';
    OPP <= "001";
    
    wait for 10 ns;
    clk <= '0';
    OPP <= "001";
    
    wait for 10 ns;
    clk <= '1';
    OPP <= "010";
    
    wait for 10 ns;
    clk <= '0';
    OPP <= "010";
    
    wait for 10 ns;
    clk <= '1';
    OPP <= "011";
    
     wait for 10 ns;
    clk <= '0';
    OPP <= "011";
    
    wait for 10 ns;
    clk <= '1';
    OPP <= "101";
    
    wait for 10 ns;
    clk <= '0';
    OPP <= "101";
    
    wait for 10 ns;
    clk <= '1';
    OPP <= "110";
    
    wait for 10 ns;
    clk <= '0';
    OPP <= "110";
    
    wait for 10 ns;
    clk <= '1';
    OPP <= "111";
  end process stim;
----------------------------------------
end behavior;

--EndOfFile

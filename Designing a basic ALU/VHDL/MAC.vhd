-- ====================================================================
--
--	File Name:		MAC.vhd
--	Description:	MAC command
--
--
--	Date:			10/04/2018
--	Designer:		Maor Assayag, Refael Shetrit
--
-- TODO : check test bench
-- ====================================================================

-- libraries decleration
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


 -- entity Definition
entity MAC is
    generic(N: integer := 8); --defualt value for N is 8
    Port(
       mac_rst : in std_logic;
       A :     in signed((N-1) downto 0);
       B :     in signed((N-1) downto 0);
       MACHI :   in signed((N-1) downto 0);
       MACLO : in signed((N-1) downto 0);
       HI :   out signed((N-1) downto 0);
       LO : out signed((N-1) downto 0));
end MAC;

 -- Architecture Definition
architecture gate_level of MAC is
  component ADD_SUB
     generic (N: integer := 8 ); --defualt value for N is 8
     port(
       addORsub :   in std_logic;
       FLAG : inout signed(5 downto 0);
       A :     in signed ((N-1) downto 0);
       B :     in signed ((N-1) downto 0);
       SUM :   out signed ((N-1) downto 0)
      );
   end component;

  component MUL
     generic (N: integer := 8 ); --defualt value for N is 8
     port(
         A :     in signed((N-1) downto 0);
         B :     in signed((N-1) downto 0);
         HI :   out signed((N-1) downto 0);
         LO : out signed((N-1) downto 0)
      );
   end component;

   component MUX_Nbits
       generic(N: positive := 8); --defualt value for N is 8
       port (
          SEL: in  std_logic;
          Y1 : in  signed (N-1 downto 0);
          Y2 : in  signed (N-1 downto 0);
          Y  : out signed (N-1 downto 0));
   end component;

    signal MULHI,MULLO : signed((N-1) downto 0) ;
    signal MULT,MAC,SUM: signed((2*N-1) downto 0) ;
    signal FLAGs: signed (5 downto 0) := "000000";
    signal zeroes : signed(N-1 downto 0) := (others => '0');
begin
  ----------------------------------------
  MULFUN :  MUL  generic map(N)
    port map (A,B,MULT (2*N-1 downto N),MULT (N-1 downto 0));
-- MAC_proc : process
-- begin
--   wait on MACHI;
--   wait on MACLO;
  MAC (2*N-1 downto N) <= MACHI;
  MAC (N-1 downto 0) <= MACLO;
-- end process;

  ADDFUN :  ADD_SUB  generic map(2*N)
    port map ('0', FLAGs, MULT,MAC,SUM);
-- MAC_proc2 : process
-- begin
--   wait on SUM;
MUX_LO : MUX_Nbits generic map (N) port map (mac_rst, SUM(N-1 downto 0), zeroes, LO);
MUX_HI : MUX_Nbits generic map (N) port map (mac_rst, SUM(2*N-1 downto N), zeroes, HI);
-- end process;
-- ----------------------------------------
end gate_level;

--EndOfFile

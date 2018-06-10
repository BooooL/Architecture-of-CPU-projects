--==========Library===========
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity Sobel is
port(
	oSobel						: out  	std_logic_vector(11 downto 0);
	iX_Cont,	iY_Cont			: in 	 	std_logic_vector(15 downto 0);
	gray_in							: in 		std_logic_vector(11 downto 0);
	oDVAL							: out 	std_logic;
	iDVAL, iCLK, iRST			: in 		std_logic);
end Sobel;


architecture rtl of Sobel is

	TYPE 	 cat_counter IS ARRAY ( 0 TO 9 ) OF integer;
	TYPE 	 lookup_table IS ARRAY ( 0 TO 24 ) OF integer ;

	TYPE		line_shift IS ARRAY ( 0 to 639 ) OF 	STD_LOGIC_VECTOR( 11 DOWNTO 0 );
	SIGNAL   line_shift1,line_shift2,line_shift3,line_shift4						: 	line_shift;
	signal   look                     : lookup_table  := (0,-4,-3,-3,-2,-2,-2,-1,-1,-1,-1,-1,-1,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0);
	signal 	x, y 											: 	std_logic_vector(15 downto 0);
	signal  counter										: cat_counter;
	signal 	sumSobel 									: 	std_LOGIC_VECTOR(11 downto 0);


	BEGIN
	x <= '0' & iX_Cont (15 downto 1);
	y <= '0' & iY_Cont (15 downto 1);

		PROCESS(iCLK,iRST)
			variable m11 			: integer;
			variable m12 			: integer;
			variable m13 			: integer;
			variable m14 			: integer;
			variable m15 			: integer;
			variable m16 			: integer;

			variable m21 			: integer;
			variable m22 			: integer;
			variable m23 			: integer;
			variable m24 			: integer;
			variable m25 			: integer;
			variable m26 			: integer;

			variable m31 			: integer;
			variable m32 			: integer;
			variable m33 			: integer;
			variable m34 			: integer;
			variable m35 			: integer;
			variable m36 			: integer;

			variable m41 			: integer;
			variable m42 			: integer;
			variable m43 			: integer;
			variable m44 			: integer;
			variable m45 			: integer;
			variable m46 			: integer;

			variable m51 			: integer;
			variable m52 			: integer;
			variable m53 			: integer;
			variable m54 			: integer;
			variable m55 			: integer;
			variable m56 			: integer;


			variable yInt 			: integer;
			variable xInt 			: integer;
			variable absY		  	: integer;

			variable sum		: integer;

			constant Col 			: integer := 640;


			BEGIN
				IF(rising_edge(iCLK )) THEN
					yInt := CONV_INTEGER(y);
					xInt := CONV_INTEGER(x);


					IF(iRST = '0') then
						FOR i IN 0 TO 639 LOOP
						  line_shift4(i)		<= (others => '0');
							line_shift4(i)		<= (others => '0');
							line_shift3(i)		<= (others => '0');
							line_shift2(i)		<= (others => '0');
							line_shift1(i)		<= (others => '0');
						END LOOP;

						oSobel <= (others => '1');


					ELSIF (iDVAL = '1') THEN

						M56 := M55;
						M55 := M54;
						M54 := M53;
						M53 := M52;
						M52 := M51;
						M51 := to_integer(unsigned(line_shift4(0)));

						M46 := M45;
						M45 := M44;
						M44 := M43;
						M43 := M42;
						M42 := M41;
						M41 := to_integer(unsigned(line_shift3(0)));

						M36 := M35;
						M35 := M34;
						M34 := M33;
						M33 := M32;
						M32 := M31;
						M31 := to_integer(unsigned(line_shift2(0)));

						M26 := M25;
						M25 := M24;
						M24 := M23;
						M23 := M22;
						M22 := M21;
						M21 := to_integer(unsigned(line_shift1(0)));

						M16 := M15;
						M15 := M14;
						M14 := M13;
						M13 := M12;
						M12 := M11;
						M11 := to_integer(unsigned(gray_in));

						counter(M55*9/4096) <= counter(M55*9/4096) +1;
						counter(M54*9/4096) <= counter(M54*9/4096) +1;
						counter(M53*9/4096) <= counter(M53*9/4096) +1;
						counter(M52*9/4096) <= counter(M52*9/4096) +1;
						counter(M51*9/4096) <= counter(M51*9/4096) +1;

						counter(M45*9/4096) <= counter(M45*9/4096) +1;
						counter(M44*9/4096) <= counter(M44*9/4096) +1;
						counter(M43*9/4096) <= counter(M43*9/4096) +1;
						counter(M42*9/4096) <= counter(M42*9/4096) +1;
						counter(M41*9/4096) <= counter(M41*9/4096) +1;

						counter(M35*9/4096) <= counter(M35*9/4096) +1;
						counter(M34*9/4096) <= counter(M34*9/4096) +1;
						counter(M33*9/4096) <= counter(M33*9/4096) +1;
						counter(M32*9/4096) <= counter(M32*9/4096) +1;
						counter(M31*9/4096) <= counter(M31*9/4096) +1;

						counter(M25*9/4096) <= counter(M25*9/4096) +1;
						counter(M24*9/4096) <= counter(M24*9/4096) +1;
						counter(M23*9/4096) <= counter(M23*9/4096) +1;
						counter(M22*9/4096) <= counter(M22*9/4096) +1;
						counter(M21*9/4096) <= counter(M21*9/4096) +1;

						counter(M15*9/4096) <= counter(M15*9/4096) +1;
						counter(M14*9/4096) <= counter(M14*9/4096) +1;
						counter(M13*9/4096) <= counter(M13*9/4096) +1;
						counter(M12*9/4096) <= counter(M12*9/4096) +1;
						counter(M11*9/4096) <= counter(M11*9/4096) +1;



						FOR i IN 1 TO Col-1 LOOP
							line_shift1(i-1) <= line_shift1(i);
							line_shift2(i-1) <= line_shift2(i);
							line_shift3(i-1) <= line_shift3(i);
							line_shift4(i-1) <= line_shift4(i);

						end loop;
						line_shift1(Col-1)<=std_LOGIC_VECTOR(to_unsigned(M16,12));
						line_shift2(Col-1)<=std_LOGIC_VECTOR(to_unsigned(M26,12));
						line_shift3(Col-1)<=std_LOGIC_VECTOR(to_unsigned(M36,12));
						line_shift4(Col-1)<=std_LOGIC_VECTOR(to_unsigned(M46,12));




						en : for i in 0 to 9 loop
								sum := sum +look(counter(i))*counter(i)/25;
								counter(i) <= 0;
						end loop;
						sum := -1*sum;
						oSobel <= std_logic_vector(to_unsigned(sum,12));


					END IF;
				END IF;
			END PROCESS;
END rtl;
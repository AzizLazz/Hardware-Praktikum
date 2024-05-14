--------------------------------------------------------------------------------
--	Schaltung fuer das Zaehlen von Einsen in einem 16-Bit-Vektor, realisiert
-- 	als Baum von Addierern.
--------------------------------------------------------------------------------
--	Datum:		??.??.2013
--	Version:	?.??
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ArmRegisterBitAdder is
	Port (
		RBA_REGLIST 	: in  std_logic_vector(15 downto 0);
		RBA_NR_OF_REGS 	: out  std_logic_vector(4 downto 0)
	);
end entity ArmRegisterBitAdder;


architecture structure of ArmRegisterBitAdder is

signal sum_2_bit , sum_2_bit_2 ,sum_2_bit_3 ,sum_2_bit_4 ,sum_2_bit_5 ,sum_2_bit_6 ,sum_2_bit_8 ,sum_2_bit_7 : unsigned (1 downto 0) ;
signal sum_4_bit , sum_4_bit_2 , sum_4_bit_3 , sum_4_bit_4  : unsigned (2 downto 0) ;
signal sum_8_bit , sum_8_bit_2 :unsigned (3 downto 0) ;
signal result :unsigned (4 downto 0) ;
signal reg :unsigned (15 downto 0) ;

begin

reg <= unsigned(RBA_REGLIST) ;

 sum_2_bit <= ( '0' & reg(0) )  +  ( '0' & reg(1) ) ; 
 sum_2_bit_2 <= ( '0' & reg(2) )  +  ( '0' & reg(3) ) ; 
 sum_2_bit_3 <= ( '0' & reg(4) )  +  ( '0' & reg(5) ) ; 
 sum_2_bit_4 <= ( '0' & reg(6) )  +  ( '0' & reg(7) ) ; 
 sum_2_bit_5 <= ( '0' & reg(8) )  +  ( '0' & reg(9) ) ; 
 sum_2_bit_6 <= ( '0' & reg(10) )  +  ( '0' & reg(11) ) ; 
 sum_2_bit_7 <= ( '0' & reg(12) )  +  ( '0' & reg(13) ) ; 
 sum_2_bit_8 <= ( '0' & reg(14) )  +  ( '0' & reg(15) ) ; 

sum_4_bit <= ( '0' & sum_2_bit )  +  ( '0' & sum_2_bit_2 ) ;
sum_4_bit_2 <= ( '0' & sum_2_bit_3 )  +  ( '0' & sum_2_bit_4 ) ;
sum_4_bit_3 <= ( '0' & sum_2_bit_5 )  +  ( '0' & sum_2_bit_6 ) ;
sum_4_bit_4 <= ( '0' & sum_2_bit_7 )  +  ( '0' & sum_2_bit_8 ) ;

sum_8_bit <= ( '0' & sum_4_bit )  +  ( '0' & sum_4_bit_2 ) ;
sum_8_bit_2 <= ( '0' & sum_4_bit_3 )  +  ( '0' & sum_4_bit_4 ) ;

result <= ( '0' & sum_8_bit ) + ( '0' & sum_8_bit_2 ) ;
RBA_NR_OF_REGS <= std_logic_vector(result) ; 



end architecture structure;

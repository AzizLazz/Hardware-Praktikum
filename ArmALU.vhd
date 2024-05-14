--------------------------------------------------------------------------------
--	ALU des ARM-Datenpfades
--------------------------------------------------------------------------------
--	Datum:		??.??.14
--	Version:	?.?
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.ArmTypes.all;

entity ArmALU is
    Port ( ALU_OP1 		: in	std_logic_vector(31 downto 0);
           ALU_OP2 		: in 	std_logic_vector(31 downto 0);           
    	   ALU_CTRL 	: in	std_logic_vector(3 downto 0);
    	   ALU_CC_IN 	: in	std_logic_vector(1 downto 0);
		   ALU_RES 		: out	std_logic_vector(31 downto 0);
		   ALU_CC_OUT	: out	std_logic_vector(3 downto 0)
   	);
end entity ArmALU;

architecture behave of ArmALU is

signal result, OP2NEG : std_logic_vector (31 downto 0) ;
signal check_zeros : std_logic_vector (31 downto 0) := (others => '0' ) ;
signal carry , not_carry : integer ;
signal alu_cc :std_logic_vector (3 downto 0) ;
signal c_1 , v_1 ,c_2 ,v_2 ,c_3 ,v_3 :std_logic ;

signal C_SUB : std_logic_vector(32 downto 0);

begin

carry <= 1 when ALU_CC_IN(1) ='1' else 0 ;
not_carry <= 0 when ALU_CC_IN(1) ='1' else 1 ;
with ALU_CTRL select
    result <= (ALU_OP1 and ALU_OP2) when "0000", 
    -- AND
              (ALU_OP1 xor ALU_OP2) when "0001", 
              -- XOR
              (std_logic_vector(signed(ALU_OP1) - signed(ALU_OP2))) when "0010", 
              -- SUB
              (std_logic_vector(signed(ALU_OP2) - signed(ALU_OP1))) when "0011", 
              -- RSB
              (std_logic_vector(signed(ALU_OP1) + signed(ALU_OP2))) when "0100", 
              -- ADD
              (std_logic_vector(signed(ALU_OP1) + signed(ALU_OP2) + carry)) when "0101", 
              -- ADC
              (std_logic_vector(signed(ALU_OP1) - signed(ALU_OP2) - not_carry)) when "0110", 
              -- SBC
              (std_logic_vector(signed(ALU_OP2) - signed(ALU_OP1) - not_carry)) when "0111", 
              -- RSC
              (ALU_OP1 and ALU_OP2) when "1000", 
              -- TST
              (ALU_OP1 xor ALU_OP2) when "1001", 
              -- TEQ
              (std_logic_vector(signed(ALU_OP1) - signed(ALU_OP2))) when "1010", 
              -- CMP
              (std_logic_vector(signed(ALU_OP1) + signed(ALU_OP2))) when "1011", 
              -- CMN
              (ALU_OP1 or ALU_OP2) when "1100", 
              -- ORR
              (ALU_OP2) when "1101", 
              -- MOV
              (ALU_OP1 and (not ALU_OP2)) when "1110", -- BIC
              (not ALU_OP2) when "1111",
               -- MVN
              (others => '0' ) when others ;
               


--Addition 
c_1 <= ((ALU_OP1(31) and ALU_OP2(31)) or (not ALU_OP1(31) and ALU_OP2(31) and not result(31)) or (ALU_OP1(31) and not ALU_OP2(31) and not result(31)));
-- c=an ·bn +!an ·bn ·!zn +an ·!bn ·!zn
v_1 <= (   not(ALU_OP1(31)) and not(ALU_OP2(31)) and result(31)  )   or    (    (ALU_OP1(31)) and (ALU_OP2(31)) and not(result(31))  ) ;
--v=!an ·!bn ·zn +an ·bn ·!zn



--OP2NEG <= std_logic_vector(not signed(ALU_OP2) + 1);
--C_SUB <= std_logic_vector(signed('0' & ALU_OP1) + signed('0' & OP2NEG));

--Substraktion
c_2 <= '1' ;
v_2 <= (     ALU_OP1(31) and not( ALU_OP2(31) ) and not( result(31) )    ) or (   not( ALU_OP1(31) )  and ( ALU_OP2(31) ) and result(31)   )  ;


-- Reverse Substraktion
c_3 <= '1' ;
v_3 <=  (     ALU_OP2(31) and not( ALU_OP1(31) ) and not( result(31) )    ) or (   not( ALU_OP2(31) )  and ( ALU_OP1(31) ) and result(31)   )   ;



alu_cc(3) <= result(31) ;
-- alu_cc(2) <= not (result or check_zeros) ;
alu_cc(2) <= '1' when result = check_zeros else  '0' ;
with ALU_CTRL select
    alu_cc(1) <= c_1 when "0100" ,
                 c_1 when "0101" ,
                 c_1 when "1011" ,
                 --add
                 c_2 when "0010" ,
                 c_2 when "0110" ,
                 c_2 when "1010" ,
                 --subst
                 c_3 when "0011" ,
                 c_3 when "0111" ,
                 --reverse_subst
                 ALU_CC_IN(1) when others  ;
                 
with ALU_CTRL select
    alu_cc(0) <= v_1 when "0100" ,
                 v_1 when "0101" ,
                 v_1 when "1011" ,
                 --add
                 v_2 when "0010" ,
                 v_2 when "0110" ,
                 v_2 when "1010" ,
                 --subs
                 v_3 when "0011" ,
                 v_3 when "0111" ,
                 --reverse_subst
                 ALU_CC_IN(0) when others  ;




ALU_CC_OUT <= alu_cc ;
ALU_RES <= result ; 

end architecture behave;

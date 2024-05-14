--------------------------------------------------------------------------------
-- 	Barrelshifter fuer LSL, LSR, ASR, ROR mit Shiftweiten von 0 bis 3 (oder 
--	generisch n-1) Bit. 
--------------------------------------------------------------------------------
--	Datum:		??.??.2013
--	Version:	?.?
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity ArmBarrelShifter is
--------------------------------------------------------------------------------
--	Breite der Operanden (n) und die Zahl der notwendigen
--	Multiplexerstufen (m) um Shifts von 0 bis n-1 Stellen realisieren zu
--	koennen. Es muss gelten: ???
--------------------------------------------------------------------------------
	generic (OPERAND_WIDTH : integer := 32;	
			 SHIFTER_DEPTH : integer := 5
	 );
	port ( 	OPERAND 	: in std_logic_vector(OPERAND_WIDTH-1 downto 0);	
    		MUX_CTRL 	: in std_logic_vector(1 downto 0);
    		AMOUNT 		: in std_logic_vector(SHIFTER_DEPTH-1 downto 0);	
    		ARITH_SHIFT : in std_logic; 
    		C_IN 		: in std_logic;
           	DATA_OUT 	: out std_logic_vector(OPERAND_WIDTH-1 downto 0);	
    		C_OUT 		: out std_logic
	);
end entity ArmBarrelShifter;

architecture structure of ArmBarrelShifter is


type level is array(SHIFTER_DEPTH downto 0) of std_logic_vector(OPERAND_WIDTH -1 downto 0);
signal temp : level;

signal nullSig : std_logic_vector(OPERAND_WIDTH-1 downto 0) := (others => '0');
signal 	arith : std_logic_vector(OPERAND_WIDTH-1 downto 0);

--type carry_out_level is array(SHIFTER_DEPTH downto 0) of std_logic;
--signal carry_out : carry_out_level;

begin

arith <= (others => OPERAND(OPERAND_WIDTH-1));
temp(0) <= OPERAND;

--shift_depth 1

--temp(1) <=  temp(0)(OPERAND_WIDTH-2 downto 0) & nullSig(0 downto 0) when MUX_CTRL = "01" and AMOUNT(0) = '1' else 
--         nullSig(0 downto 0) & temp(0)(OPERAND_WIDTH-1 downto 1) when MUX_CTRL ="10" and ARITH_SHIFT = '0' and AMOUNT(0) = '1' else
--         arith(0 downto 0) & temp(0)(OPERAND_WIDTH-1 downto 1) when MUX_CTRL = "10" and ARITH_SHIFT = '1' and AMOUNT(0) = '1' else
--         temp(0)(0 downto 0) & temp(0)(OPERAND_WIDTH-1 downto 1) when  MUX_CTRL = "11" and AMOUNT(0) = '1' else
--         temp(0); --MUX_CTRL = "00"
                    

----shift_depth 2

--temp(2) <=  temp(1)(OPERAND_WIDTH-3 downto 0) & nullSig(1 downto 0) when MUX_CTRL = "01" and AMOUNT(1) = '1' else
--         nullSig(1 downto 0) & temp(1)(OPERAND_WIDTH-1 downto 2) when MUX_CTRL = "10" and ARITH_SHIFT = '0' and AMOUNT(1) = '1' else
--         arith(1 downto 0) & temp(1)(OPERAND_WIDTH-1 downto 2) when MUX_CTRL = "10" and ARITH_SHIFT = '1' and AMOUNT(1) = '1' else
--         temp(1)(1 downto 0) & temp(1)(OPERAND_WIDTH-1 downto 2) when MUX_CTRL = "11" and AMOUNT(1) = '1' else
--         temp(1);

--carry_out(2) <= '1';     -- falsch


depth: for i in 1 to SHIFTER_DEPTH generate 

    temp(i) <=  temp(i-1)(OPERAND_WIDTH-1 - 2**(i-1) downto 0 ) & nullSig(2**(i-1)-1 downto 0) when MUX_CTRL = "01" and AMOUNT(i-1) = '1' else
             nullSig(2**(i-1)-1 downto 0) & temp(i-1)(OPERAND_WIDTH-1 downto 0 + 2**(i-1)) when MUX_CTRL = "10" and ARITH_SHIFT = '0' and AMOUNT(i-1) = '1' else
             arith(2**(i-1)-1 downto 0) & temp(i-1)(OPERAND_WIDTH-1 downto 0 + 2**(i-1)) when MUX_CTRL = "10" and ARITH_SHIFT = '1' and AMOUNT(i-1) = '1' else
             temp(i-1)(2**(i-1)-1 downto 0) & temp(i-1)(OPERAND_WIDTH-1 downto 0 + 2**(i-1)) when MUX_CTRL = "11" and AMOUNT(i-1) = '1' else
             temp(i-1);

 end generate depth;
 
 C_OUT <=      C_IN when to_integer(unsigned(AMOUNT)) = 0 OR MUX_CTRL = "00" else
               OPERAND(OPERAND_WIDTH - to_integer(unsigned(AMOUNT))) when MUX_CTRL = "01" else
               OPERAND(to_integer(unsigned(AMOUNT))-1); -- rechtsshift arit oder nicht arit oder rechtsrotation


DATA_OUT <= temp(SHIFTER_DEPTH);
end architecture structure;


--use std.textio.all;
library ieee;

use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
--library work;
--use work.TB_Tools.all;

entity ArmBarrelShifter4Bit_tb is
	generic(	
		OPERAND_WIDTH	: integer := 4;
		SHIFTER_DEPTH	: integer := 2
	 );
end entity ArmBarrelShifter4Bit_tb;

architecture behave of ArmBarrelShifter4Bit_tb is 

component ArmBarrelShifter
	generic(
		OPERAND_WIDTH : integer;
		SHIFTER_DEPTH : integer
	);	
	port(
		    OPERAND		: in std_logic_vector(3 downto 0);
		    MUX_CTRL	: in std_logic_vector(1 downto 0);
		    AMOUNT		: in std_logic_vector(1 downto 0);
		    ARITH_SHIFT : in std_logic;
		    C_IN		: in std_logic;          
		    DATA_OUT	: out std_logic_vector(3 downto 0);
		    C_OUT		: out std_logic
	    );
	end component ArmBarrelShifter;
	
	
	signal	OPERAND		: std_logic_vector(OPERAND_WIDTH-1 downto 0);
	signal	MUX_CTRL	: std_logic_vector(1 downto 0)	:= (others => '0') ;
	signal	AMOUNT		: std_logic_vector(SHIFTER_DEPTH-1 downto 0) := (others => '0');
	signal	ARITH_SHIFT	: std_logic := '0';
	signal	C_IN		: std_logic := '0';
	signal	DATA_OUT	: std_logic_vector(OPERAND_WIDTH-1 downto 0);
	signal	C_OUT	    : std_logic;
	
	
begin
	SHIFTER : ArmBarrelShifter
	generic map(
			   OPERAND_WIDTH => 4,
			   SHIFTER_DEPTH => 2
		   )
	port map(
			OPERAND		=> OPERAND,
			MUX_CTRL	=> MUX_CTRL,
			AMOUNT		=> AMOUNT,
			ARITH_SHIFT	=> ARITH_SHIFT,
			C_IN		=> C_IN,
			DATA_OUT	=> DATA_OUT,
			C_OUT		=> C_OUT
		);	
		
	tb : process
    begin
 
    wait for 10 ns;
    OPERAND <= "1001";
 
 -- nothing denn MUC_CTRL = "00"     
	wait for 10 ns ; 
    AMOUNT <= "01";
    wait for 10 ns ;
    AMOUNT <= "10";
    C_IN <= '1';
    wait for 10 ns ;
	AMOUNT <= "11";
    C_IN <= '0';
    
-- ---------------------------------------------------	
-- ---------------------------------------------------	
	
-- left shifter	

-- 1001
	wait for 10 ns ;
	MUX_CTRL <= "01";
	AMOUNT <= "00";
	C_IN <= '1';
	wait for 10 ns ;
	AMOUNT <= "01";
	C_IN <= '0';
-- 0010
	wait for 10 ns ;
	AMOUNT <= "10";
-- 0100	
	wait for 10 ns ;
	AMOUNT <= "11";
-- 1000


-- ---------------------------------------------------	
-- ---------------------------------------------------


-- right shifter
	
--1001
	wait for 10 ns ;
	MUX_CTRL <= "10";
	AMOUNT <= "00";	
	wait for 10 ns ;
	AMOUNT <= "01";	
--0100
	wait for 10 ns ;
	AMOUNT <= "10";
	C_IN <= '1';
--0010	
	wait for 10 ns ;
	AMOUNT <= "11";
	C_IN <= '0';
--0001

	
-- ---------------------------------------------------	
-- ---------------------------------------------------		
	
-- right shifter arith
	
--1001
	wait for 10 ns ;
	AMOUNT <= "00";
	ARITH_SHIFT <= '1' ;	
	wait for 10 ns ;
	AMOUNT <= "01";	
--1100
	wait for 10 ns ;
	AMOUNT <= "10";	
--1110
	wait for 10 ns ;
	AMOUNT <= "11";
--1111
	
-- ---------------------------------------------------	
-- ---------------------------------------------------		
	
-- rotate	
	
	wait for 10 ns ;
	MUX_CTRL <= "11";
	AMOUNT <= "00";
	ARITH_SHIFT <= '0';
	C_IN <= '1';
	wait for 10 ns ;
	AMOUNT <= "01";
	C_IN <= '0';
	wait for 10 ns ;
	AMOUNT <= "10";	
	wait for 10 ns ;
	AMOUNT <= "11";
	
-- ---------------------------------------------------
-- ---------------------------------------------------
    wait for 10 ns;
    MUX_CTRL <= "00";
    AMOUNT <= "00";
    C_IN <= '1';
    wait for 10 ns;
    OPERAND <= "0111";
    AMOUNT <= "10";
    wait for 20 ns;
    AMOUNT <= "11";
    OPERAND <= "0000";
    C_IN <= '0';
    wait for 10 ns;
    AMOUNT <= "00";
    
    

	

	
	
	wait for 10 ns ;
	
	wait ;
	
	end process ;
	
end architecture behave;    	
	 
     	
    	 
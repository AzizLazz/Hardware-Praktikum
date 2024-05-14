--------------------------------------------------------------------------------
--	Wrapper um Basys3-Blockram fuer den RAM des HWPR-Prozessors.
--------------------------------------------------------------------------------
--	Datum:		23.05.2022
--	Version:	1.1
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity ArmRAMB_4kx32 is
	generic(
--------------------------------------------------------------------------------
--	SELECT_LINES ist fuer das HWPR irrelevant, wird aber in einer
--	komplexeren Variante dieses Speichers zur Groessenauswahl
--	benoetigt. Im Hardwarepraktikum bitte ignorieren und nicht aendern.
--------------------------------------------------------------------------------
		SELECT_LINES : natural range 0 to 2 := 1);
    port(
		RAM_CLK	: in  std_logic;
        ENA		: in  std_logic;
		ADDRA	: in  std_logic_vector(11 downto 0);
        WEB		: in  std_logic_vector(3 downto 0);
        ENB		: in  std_logic;
		ADDRB	: in  std_logic_vector(11 downto 0);
        DIB		: in  std_logic_vector(31 downto 0);
        DOA		: out  std_logic_vector(31 downto 0);
        DOB		: out  std_logic_vector(31 downto 0));
end entity ArmRAMB_4kx32;

architecture behavioral of ArmRAMB_4kx32 is
type ram_type is array (4095 downto 0) of std_logic_vector(31 downto 0);
signal RAM4k : ram_type;


begin
 

 process(RAM_CLK)
 begin 
    if(rising_edge(RAM_CLK)) then
	   
            if ENA = '1' then
                DOA <= RAM4k(to_integer(unsigned(ADDRA)));
            end if;
            
            if ENB = '1' then
                DOB <= RAM4k(to_integer(unsigned(ADDRB)));
            end if;
            
            for i in 3 downto 0 loop
                if WEB(i) = '1' then
                    RAM4k(to_integer(unsigned(ADDRB))) (((i+1)*8)-1 downto i*8) <= DIB(((i+1)*8)-1 downto i*8);
                end if;
            end loop;
            
        end if;
    end process;

end architecture behavioral;


--------------------------------------------------------------------------------
--	16-Bit-Register zur Steuerung der Auswahl des naechsten Registers
--	bei der Ausfuehrung von STM/LDM-Instruktionen. Das Register wird
--	mit der Bitmaske der Instruktion geladen. Ein Prioritaetsencoder
--	(Modul ArmPriorityVectorFilter) bestimmt das Bit mit der hochsten 
--	Prioritaet. Zu diesem Bit wird eine 4-Bit-Registeradresse erzeugt und
--	das Bit im Register geloescht. Bis zum Laden eines neuen Datums wird
--	mit jedem Takt ein Bit geloescht bis das Register leer ist.	
--------------------------------------------------------------------------------
--	Datum:		??.??.2013
--	Version:	?.??
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity ArmLdmStmNextAddress is
	port(
		SYS_RST			: in std_logic;
		SYS_CLK			: in std_logic;	
		LNA_LOAD_REGLIST 	: in std_logic;
		LNA_HOLD_VALUE 		: in std_logic;
		LNA_REGLIST 		: in std_logic_vector(15 downto 0);
		LNA_ADDRESS 		: out std_logic_vector(3 downto 0);
		LNA_CURRENT_REGLIST_REG : out std_logic_vector(15 downto 0)
	    );
end entity ArmLdmStmNextAddress;

architecture behave of ArmLdmStmNextAddress is

	component ArmPriorityVectorFilter
		port(
			PVF_VECTOR_UNFILTERED	: in std_logic_vector(15 downto 0);
			PVF_VECTOR_FILTERED	: out std_logic_vector(15 downto 0)
		);
	end component ArmPriorityVectorFilter;

signal unfiltered : std_logic_vector (15 downto 0) := (others => '0') ;
signal filtered : std_logic_vector (15 downto 0) ;
signal hochster_prio , i : integer := 0 ; 

begin
	CURRENT_REGLIST_FILTER : ArmPriorityVectorFilter
		port map(
			PVF_VECTOR_UNFILTERED	=> unfiltered ,
			PVF_VECTOR_FILTERED	=> filtered 
		);

--process(i)
--begin
--for i in 0 to 15 loop
--   if filtered(i) = '1' then
--      hochster_prio <= i;
--      exit;  
--   end if;
--end loop; 
--end process;

hochster_prio <=   0 when filtered(0) = '1' else
                   1 when filtered(1) = '1' else
                   2 when filtered(2) = '1' else
                   3 when filtered(3) = '1' else
                   4 when filtered(4) = '1' else
                   5 when filtered(5) = '1' else
                   6 when filtered(6) = '1' else
                   7 when filtered(7) = '1' else
                   8 when filtered(8) = '1' else
                   9 when filtered(9) = '1' else
                   10 when filtered(10) = '1' else
                   11 when filtered(11) = '1' else
                   12 when filtered(12) = '1' else
                   13 when filtered(13) = '1' else
                   14 when filtered(14) = '1' else
                   15 when filtered(15) = '1' else
                   0;

process (SYS_CLK,SYS_RST) 
    begin 
    
        if (rising_edge(SYS_CLK)) then 
            if SYS_RST = '1' then 
               unfiltered <= (others => '0');
            end if ; 
        
            if LNA_LOAD_REGLIST = '1' then
                unfiltered <= LNA_REGLIST ;
            end if ;
            
            if LNA_LOAD_REGLIST = '0' and LNA_HOLD_VALUE = '0' then 
                unfiltered(hochster_prio) <= '0' ; 
            end if ;
    
    
        end if ;

end process ;

LNA_ADDRESS <= "0000" when hochster_prio = 0 else
               "0001" when hochster_prio = 1 else
               "0010" when hochster_prio = 2 else
               "0011" when hochster_prio = 3 else
               "0100" when hochster_prio = 4 else
               "0101" when hochster_prio = 5 else
               "0110" when hochster_prio = 6 else
               "0111" when hochster_prio = 7 else
               "1000" when hochster_prio = 8 else
               "1001" when hochster_prio = 9 else
               "1010" when hochster_prio = 10 else
               "1011" when hochster_prio = 11 else
               "1100" when hochster_prio = 12 else
               "1101" when hochster_prio = 13 else
               "1110" when hochster_prio = 14 else
               "1111" when hochster_prio = 15 else
               "0000";
               
LNA_CURRENT_REGLIST_REG <= unfiltered ; 

end architecture behave;

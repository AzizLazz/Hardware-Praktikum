--------------------------------------------------------------------------------
--	Schnittstelle zur Anbindung des RAM an die Busse des HWPR-Prozessors
--------------------------------------------------------------------------------
--	Datum:		??.??.2013
--	Version:	?.?
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.ArmConfiguration.all;
use work.armtypes.all;

entity ArmMemInterface is
	generic(
--------------------------------------------------------------------------------
--	Beide Generics sind fuer das HWPR nicht relevant und koennen von
--	Ihnen ignoriert werden.
--------------------------------------------------------------------------------
		SELECT_LINES				: natural range 0 to 2 := 1;
		EXTERNAL_ADDRESS_DECODING_INSTRUCTION : boolean := false);
	port (  RAM_CLK	:  in  std_logic;
		--	Instruction-Interface	
       		IDE		:  in std_logic;	
			IA		:  in std_logic_vector(31 downto 2);
			ID		: out std_logic_vector(31 downto 0);	
			IABORT	: out std_logic;
		--	Data-Interface
			DDE		:  in std_logic;
			DnRW	:  in std_logic;
			DMAS	:  in std_logic_vector(1 downto 0);
			DA 		:  in std_logic_vector(31 downto 0);
			DDIN	:  in std_logic_vector(31 downto 0);
			DDOUT	: out std_logic_vector(31 downto 0);
			DABORT	: out std_logic);
end entity ArmMemInterface;

architecture behave of ArmMemInterface is	

signal web : std_logic_vector(3 downto 0);
signal addr_b : std_logic_vector(13 downto 2);
signal doa : std_logic_vector(31 downto 0);
signal dob : std_logic_vector(31 downto 0);

signal isUnaligned : std_logic;

begin	

    ARM4K_Instance: entity work.ArmRAMB_4kx32 (behavioral)
        port map (
            RAM_CLK => RAM_CLK,
            ENA =>IDE ,
            ADDRA =>IA(13 downto 2) ,
            WEB => web,
            ENB => DDE,
            ADDRB => addr_b, -- nie gesetzt
            DIB => DDIN,
            DOA => doa,
            DOB => dob );

addr_b <= DA(13 downto 2) ;

 with IDE select
  ID <=   doa when '1',
          (others => 'Z') when others;
    
        
DDOUT <= dob when (DDE = '1' and DnRW = '0') else (others => 'Z');
    
    IABORT <= 'Z' when IDE = '0' else 
    '1' when IDE = '1' and (  to_integer(unsigned(IA))*4 < to_integer(unsigned(INST_LOW_ADDR))  or to_integer(unsigned(IA))*4 > to_integer(unsigned(INST_HIGH_ADDR)) ) else 
    '0';                             
    


    DABORT <=   'Z' when DDE = '0'          
                else '0' ; 
                
    
                -- fehlt
    -- '1' when DDE = '1' and 


    process(DnRW, DMAS,DA)  -- alignment check fehlt
    begin
      if DnRW = '0' then 
         web <= (others => '0');
      elsif DMAS = DMAS_BYTE then         
           case DA(1 downto 0) is
                when "00" => web <= "0001";
                when "01" => web <= "0010";
                when "10" => web <= "0100";
                when others => web <= "1000";
            end case; 
      elsif DMAS = DMAS_HWORD then 
            case DA(1 downto 0) is
                when "00" => web <= "0011";
                when "10" => web <= "1100" ;
                when others => web <= "0000" ;  -- handle unaligned
            end case ;
      else 
          -- check unalgined
            web <= (others => '1');   --DMAS_WORD type 
      end if; 
   
    end process ;
end architecture behave;

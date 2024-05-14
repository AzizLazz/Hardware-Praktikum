------------------------------------------------------------------------------
--	Registerspeichers des ARM-SoC
------------------------------------------------------------------------------
--	Datum:		16.05.2022
--	Version:	0.2
------------------------------------------------------------------------------

library work;
use work.ArmTypes.all;
use work.ArmRegAddressTranslation.all;
use work.ArmConfiguration.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ArmRegfile is
	Port ( REF_CLK 		: in std_logic;
	       REF_RST 		: in  std_logic;

	       REF_W_PORT_A_ENABLE	: in std_logic;
	       REF_W_PORT_B_ENABLE	: in std_logic;
	       REF_W_PORT_PC_ENABLE	: in std_logic;

	       REF_W_PORT_A_ADDR 	: in std_logic_vector(4 downto 0);
	       REF_W_PORT_B_ADDR 	: in std_logic_vector(4 downto 0);

	       REF_R_PORT_A_ADDR 	: in std_logic_vector(4 downto 0);
	       REF_R_PORT_B_ADDR 	: in std_logic_vector(4 downto 0);
	       REF_R_PORT_C_ADDR 	: in std_logic_vector(4 downto 0);

	       REF_W_PORT_A_DATA 	: in std_logic_vector(31 downto 0);
	       REF_W_PORT_B_DATA 	: in std_logic_vector(31 downto 0);
	       REF_W_PORT_PC_DATA 	: in std_logic_vector(31 downto 0);

	       REF_R_PORT_A_DATA 	: out std_logic_vector(31 downto 0);
	       REF_R_PORT_B_DATA 	: out std_logic_vector(31 downto 0);
	       REF_R_PORT_C_DATA 	: out std_logic_vector(31 downto 0)
       );
end entity ArmRegfile;


architecture behavioral of ArmRegfile is

signal pc_reg  :std_logic_vector(3 downto 0) := "1111" ;

type reg_type is array(30 downto 0) of std_logic_vector(31 downto 0);
signal regstr : reg_type;


signal A_PORT_A_DATA : std_logic_vector(31 downto 0);
signal A_PORT_B_DATA : std_logic_vector(31 downto 0);
signal A_PORT_C_DATA : std_logic_vector(31 downto 0);
	
signal B_PORT_A_DATA : std_logic_vector(31 downto 0);
signal B_PORT_B_DATA : std_logic_vector(31 downto 0);
signal B_PORT_C_DATA : std_logic_vector(31 downto 0);
	
signal PC_PORT_A_DATA : std_logic_vector(31 downto 0);
signal PC_PORT_B_DATA : std_logic_vector(31 downto 0);
signal PC_PORT_C_DATA : std_logic_vector(31 downto 0);

signal DOD_A : std_logic_vector(31 downto 0);
signal DOD_B : std_logic_vector(31 downto 0);
signal DOD_PC : std_logic_vector(31 downto 0);


signal W_PORT_A_ENABLE : std_logic;
signal W_PORT_B_ENABLE : std_logic;
signal W_PORT_PC_ENABLE : std_logic;
	
begin




--------------------------------------------------------------------------------
--	Auswahl und Einstellung der Registerspeicher-Implementierung
--	Version 2 des Registerspeichers nutzt Distributed RAM
--	Im HWPTI wird Version 2 implementiert, die ARM_SIM_LIB stellt
--	zu Debugging-Zwecken auch Version 1 zur Verfügung
--------------------------------------------------------------------------------
	REGFILE_VERSION : if USE_REGFILE_V2 generate
		-- Registerspeicher auf Basis von Distributed RAM
	
W_PORT_A_ENABLE <= REF_W_PORT_A_ENABLE ;
            W_PORT_B_ENABLE    <= '1'  when  (REF_W_PORT_B_ENABLE = '1') and (REF_W_PORT_A_ENABLE = '0' or not (REF_W_PORT_A_ADDR = REF_W_PORT_B_ADDR)) else
                               '0'  ;
            W_PORT_PC_ENABLE <=  '1'  when (REF_W_PORT_PC_ENABLE = '1') and (REF_W_PORT_A_ENABLE = '0' or not (unsigned(REF_W_PORT_A_ADDR) = 15)) 
                               and (REF_W_PORT_B_ENABLE = '0' or not (unsigned(REF_W_PORT_B_ADDR) = 15))  else
                               '0'  ;	


A : for i in 1 to 16 generate 
RAM32 : entity work.RAM32M
port map (         WCLK =>  REF_CLK,
	               ADDRA => REF_R_PORT_A_ADDR , 
	               ADDRB => REF_R_PORT_B_ADDR ,
	               ADDRC => REF_R_PORT_C_ADDR ,
	               ADDRD => REF_W_PORT_A_ADDR ,
	               DID => REF_W_PORT_A_DATA(2*i-1 downto 2*i-2),     
	               DOA => A_PORT_A_DATA(2*i-1 downto 2*i-2) ,
	               DOB => A_PORT_B_DATA(2*i-1 downto 2*i-2) ,
	               DOC => A_PORT_C_DATA(2*i-1 downto 2*i-2) ,
	               DOD => DOD_A(i * 2 - 1 downto i * 2 - 2),
	               WED => REF_W_PORT_A_ENABLE );
end generate A ;

B : for i in 1 to 16 generate 
RAM32 : entity work.RAM32M
port map (         WCLK =>  REF_CLK,
	               ADDRA => REF_R_PORT_A_ADDR , 
	               ADDRB => REF_R_PORT_B_ADDR ,
	               ADDRC => REF_R_PORT_C_ADDR ,
	               ADDRD => REF_W_PORT_A_ADDR ,
	               DID =>  REF_W_PORT_B_DATA(2*i-1 downto 2*i-2),   
	               DOA => B_PORT_A_DATA(2*i-1 downto 2*i-2) ,
                   DOB => B_PORT_B_DATA(2*i-1 downto 2*i-2) ,
                   DOC => B_PORT_C_DATA(2*i-1 downto 2*i-2) ,
	               DOD => DOD_B(i * 2 - 1 downto i * 2 - 2),
	               WED => REF_W_PORT_B_ENABLE );
end generate B ;

PC : for i in 1 to 16 generate 
RAM32 : entity work.RAM32M
port map (         WCLK =>  REF_CLK,
	               ADDRA => REF_R_PORT_A_ADDR , 
	               ADDRB => REF_R_PORT_B_ADDR ,
	               ADDRC => REF_R_PORT_C_ADDR ,
	               ADDRD => REF_W_PORT_A_ADDR ,
	               DID => REF_W_PORT_PC_DATA(i * 2 - 1 downto i * 2 - 2),    
	               DOA => PC_PORT_A_DATA(2*i-1 downto 2*i-2) ,
                   DOB => PC_PORT_B_DATA(2*i-1 downto 2*i-2) ,
                   DOC => PC_PORT_C_DATA(2*i-1 downto 2*i-2) , 
	               DOD => DOD_PC(i * 2 - 1 downto i * 2 - 2),
	               WED => REF_W_PORT_PC_ENABLE );
end generate PC ;


	
process(REF_CLK)
   begin

    if rising_edge(REF_CLK) then
       if REF_W_PORT_A_ENABLE = '1' then 
          regstr(to_integer(unsigned(REF_R_PORT_A_ADDR))) <= "01" ;
       end if ; 
       if REF_W_PORT_B_ENABLE = '1' then 
          regstr(to_integer(unsigned(REF_R_PORT_B_ADDR))) <= "10" ;
       end if ;
       if REF_W_PORT_PC_ENABLE = '1' then 
          regstr(to_integer(unsigned(pc_reg))) <= "11" ;     
       end if ;

    end if;

  end process ;



--if (regstr(to_integer(unsigned(REF_R_PORT_A_ADDR))) = "01") then 
--    REF_R_PORT_A_DATA <= A_PORT_A_DATA ;
--  elsif (regstr(to_integer(unsigned(REF_R_PORT_A_ADDR))) = "10") then 
  --  REF_R_PORT_A_DATA <= B_PORT_A_DATA ;
  --else 
  --  REF_R_PORT_A_DATA <= C_PORT_A_DATA ;
--  end if;
      
      
--  if (regstr(to_integer(unsigned(REF_R_PORT_B_ADDR))) = "01") then 
--    REF_R_PORT_B_DATA <= A_PORT_B_DATA ;
--  elsif (regstr(to_integer(unsigned(REF_R_PORT_B_ADDR))) = "10") then 
--    REF_R_PORT_B_DATA <= B_PORT_B_DATA ;
--  else 
 --   REF_R_PORT_B_DATA <= C_PORT_B_DATA ;
 -- end if ; 
          
--  if (regstr(to_integer(unsigned(REF_R_PORT_C_ADDR))) = "01") then 
--    REF_R_PORT_C_DATA <= A_PORT_C_DATA ;
 -- elsif (regstr(to_integer(unsigned(REF_R_PORT_C_ADDR))) = "10") then 
  --  REF_R_PORT_C_DATA <= B_PORT_C_DATA ;
 -- else 
 --   REF_R_PORT_C_DATA <= C_PORT_C_DATA ;
 -- end if ; 

                 
end generate;	
end architecture;

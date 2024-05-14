--------------------------------------------------------------------------------
--	Prioritaetsencoder fuer das Finden des niederwertigsten
-- 	gesetzten Bits in einem 16-Bit-Vektor.
--------------------------------------------------------------------------------
--	Datum:		??.??.2013
--	Version:	?.??
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity ArmPriorityVectorFilter is
	port(
		PVF_VECTOR_UNFILTERED	: in std_logic_vector(15 downto 0);
		PVF_VECTOR_FILTERED	: out std_logic_vector(15 downto 0)
	    );
end entity ArmPriorityVectorFilter;

architecture structure of ArmPriorityVectorFilter is

begin

 process(PVF_VECTOR_UNFILTERED)
    begin
        for i in 0 to 15 loop
            if PVF_VECTOR_UNFILTERED(i) = '1' then
                PVF_VECTOR_FILTERED <= (others => '0');
                PVF_VECTOR_FILTERED(i) <= '1';
                exit;
             elsif i = 15 then 
             PVF_VECTOR_FILTERED <= (others => '0');
             exit ;
            end if;
        end loop;
    end process;


end architecture structure;


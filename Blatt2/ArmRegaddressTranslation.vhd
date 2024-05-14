------------------------------------------------------------------------------
--	Paket fuer die Funktionen zur die Abbildung von ARM-Registeradressen
-- 	auf Adressen des physischen Registerspeichers (5-Bit-Adressen)
------------------------------------------------------------------------------
--	Datum:		05.11.2013
--	Version:	0.1
------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
library work;
use work.ArmTypes.all;


package ArmRegaddressTranslation is
  
	function get_internal_address(
		EXT_ADDRESS: std_logic_vector(3 downto 0); 
		THIS_MODE: std_logic_vector(4 downto 0); 
		USER_BIT : std_logic) 
	return std_logic_vector;

end package ArmRegaddressTranslation;

package body ArmRegAddressTranslation is


function get_internal_address(
	EXT_ADDRESS: std_logic_vector(3 downto 0);
	THIS_MODE: std_logic_vector(4 downto 0); 
	USER_BIT : std_logic) 
	return std_logic_vector 
is

--------------------------------------------------------------------------------		
--	Raum fuer lokale Variablen innerhalb der Funktion
--------------------------------------------------------------------------------


variable ruckgab    :std_logic_vector(4 downto 0);
variable undef      :std_logic_vector(4 downto 0) := "11111";
variable new_addr   :std_logic_vector(4 downto 0);


begin
--------------------------------------------------------------------------------		
--	Functionscode
--------------------------------------------------------------------------------		


if (unsigned(EXT_ADDRESS) > 15) then
    return undef;
else
    new_addr := "0" & EXT_ADDRESS;
end if;

if (USER_BIT = '1') or (unsigned(EXT_ADDRESS) < 8) or (unsigned(EXT_ADDRESS) = 15) then
    return new_addr;
end if;

if THIS_MODE = USER or THIS_MODE = SYSTEM then
    return new_addr;
end if;

if (THIS_MODE = FIQ) then
    if (unsigned(EXT_ADDRESS) > 7) and (unsigned(EXT_ADDRESS) < 15) then
        return std_logic_vector(unsigned(new_addr) + 8);   -- x xxxx + 1000
    else
        return new_addr;
    end if;
end if;

if (unsigned(EXT_ADDRESS) < 13) or (unsigned(EXT_ADDRESS) = 15) then
    return new_addr;
end if;

if (THIS_MODE = IRQ) then
    return std_logic_vector(unsigned(new_addr) + 10);      -- 1010
end if;

if (THIS_MODE = SUPERVISOR) then
    return std_logic_vector(unsigned(new_addr) + 12);
end if;

if (THIS_MODE = ABORT) then
    return std_logic_vector(unsigned(new_addr) + 16);
end if;

if (THIS_MODE = UNDEFINED) then
    return std_logic_vector(unsigned(new_addr) + 14);
end if;


return undef;



end function get_internal_address;
	 
end package body ArmRegAddressTranslation;

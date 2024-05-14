--------------------------------------------------------------------------------
-- PISO-Schieberegister als mögliche Grundlage für die Implementierung der RS232-
-- Schnittstelle im Hardwarepraktikum
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PISOShiftReg is
	generic(
		WIDTH	 : integer := 8
	);
	port(
		CLK	     : in std_logic;
		CLK_EN	 : in std_logic;
		LOAD	 : in std_logic;
		D_IN	 : in std_logic_vector(WIDTH-1 downto 0);
		D_OUT	 : out std_logic;
		LAST_BIT : out std_logic
	);
end entity PISOShiftReg;

architecture behavioral of PISOShiftReg is
signal shift_reg : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
signal counter : integer := 0;
begin
    
    process(CLK, LOAD)
    begin
        if rising_edge(CLK) and CLK_EN = '1' then
            if LOAD = '1' then
                shift_reg <= D_IN;
            elsif LOAD = '0' then
                --D_OUT <= shift_reg(0);
                shift_reg(WIDTH-1 downto 0) <= '0' & shift_reg(WIDTH-1 downto 1);
                counter <= counter + 1;
                if counter < WIDTH-1 then
                    LAST_BIT <= '0' ;
                else 
                    LAST_BIT <='1';
                    counter <= 0;
                end if;  
            end if;
        end if;
    end process;
    D_OUT <= shift_reg(0);
    --1111  c0
    
    --0111  c1
    --0011  c2
    --0001  c3
    --0000
end architecture behavioral;

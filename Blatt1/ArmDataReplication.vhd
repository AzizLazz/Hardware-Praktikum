--------------------------------------------------------------------------------
--	Datenreplikationseinheit fuer den Kern des ARM-SoC
--------------------------------------------------------------------------------
--	Datum:		29.10.2013
--	Version:	0.1
--------------------------------------------------------------------------------
--	Die Datenreplikationseinheit kann in der EX- oder MEM-Stufe
--	verwendet werden. In der gegenwaertigen Pipeline bietet sich die 
--	EX-Stufe an, Worte werden unveraendert weitergegeben,
--	Halbworte (immer die niederwertigen 16 Bit eines Datums aus einem ARM-
--	Register) werden auf dem niederwertigen und hochwertigen Halbwort
--	des Datenbus ausgegeben und Bytes auf alle 4 Bytes des Datenbus
--	repliziert. Auf diese Weise kann ohne weitere Anpassungen
--	in Little Endian und Big Endian Speicher geschrieben werden.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.armtypes.all;

entity ArmDataReplication is
	port (	DRP_INPUT	: in	std_logic_vector(31 downto 0);
		 	DRP_DMAS	: in	std_logic_vector(1 downto 0);
		 	DRP_OUTPUT	: out	std_logic_vector(31 downto 0)
	);
end entity ArmDataReplication;

architecture behave of ArmDataReplication is
--signal DMAS : std_logic_vector(1 downto 0) := DMAS_WORD;
begin
process(DRP_INPUT, DRP_DMAS) begin
    if DRP_DMAS = DMAS_WORD or DRP_DMAS = DMAS_RESERVED then
        DRP_OUTPUT <= DRP_INPUT;
    
    elsif DRP_DMAS = DMAS_HWORD then
        DRP_OUTPUT(15 downto 0) <= DRP_INPUT(15 downto 0);
        DRP_OUTPUT(31 downto 16) <= DRP_INPUT(15 downto 0);
    elsif DRP_DMAS = DMAS_BYTE then
        DRP_OUTPUT(7 downto 0) <= DRP_INPUT(7 downto 0);
        DRP_OUTPUT(15 downto 8) <= DRP_INPUT(7 downto 0);
        DRP_OUTPUT(23 downto 16) <= DRP_INPUT(7 downto 0);
        DRP_OUTPUT(31 downto 24) <= DRP_INPUT(7 downto 0);
    end if;
end process;
end architecture behave;

--------------------------------------------------------------------------------
--	Testbench-Vorlage des HWPR-Bitaddierers.
--------------------------------------------------------------------------------
--	Datum:		??.??.2013
--	Version:	?.??
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
--	In TB_TOOLS kann, wenn gewuenscht die Funktion SLV_TO_STRING() zur
--	Ermittlung der Stringrepraesentation eines std_logic_vektor verwendet
--	werden und SEPARATOR_LINE fuer eine horizontale Trennlinie in Ausgaben.
--------------------------------------------------------------------------------
library work;
use work.TB_TOOLS.all;

entity ArmRegisterBitAdder_TB is
end ArmRegisterBitAdder_TB;

architecture testbench of ArmRegisterBitAdder_tb is 

	component ArmRegisterBitAdder
	port(
		RBA_REGLIST	: in std_logic_vector(15 downto 0);          
		RBA_NR_OF_REGS	: out std_logic_vector(4 downto 0)
		);
	end component ArmRegisterBitAdder;

signal REGLIST : std_logic_vector(15 downto 0) := (others => '0') ;
signal NR_OF_REGS : std_logic_vector(4 downto 0);
	
begin
--	Unit Under Test
	UUT: ArmRegisterBitAdder port map(
		RBA_REGLIST	=> REGLIST,
		RBA_NR_OF_REGS	=> NR_OF_REGS
	);


--	Testprozess
	tb : process is
variable errors : Integer := 0 ; 
	begin
	wait for 100 ns;
    -----------------------------------------------        
            REGLIST <= (others => '0') ;
            wait for 11 ns;
            assert (NR_OF_REGS = "00000") report "test failed for input 0" severity error;
            if ((not(NR_OF_REGS = "00000")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;    
        
--2
            REGLIST <= (others => '0') ;
            REGLIST(3) <= '1' ;
            wait for 11 ns;
            assert (NR_OF_REGS = "00001") report "test failed for nbr of reg 1" severity error;
            if ((not(NR_OF_REGS = "00001")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if; 
 --3           
            REGLIST <= (others => '0') ;
            REGLIST(15) <= '1' ;
            wait for 11 ns;
            assert (NR_OF_REGS = "00001") report "test failed for nbr of reg 1" severity error;
            if ((not(NR_OF_REGS = "00001")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;             
            
--4
            REGLIST <= (others => '0') ;
            REGLIST(15) <= '1' ;
            REGLIST(3) <= '1' ;
            wait for 11 ns;
            assert (NR_OF_REGS = "00010") report "test failed for nbr of reg 2" severity error;
            if ((not(NR_OF_REGS = "00010")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;
            
--5            
             REGLIST <= (others => '0') ;
            REGLIST(15) <= '1' ;
            REGLIST(3) <= '1' ;
            REGLIST(5) <= '1' ;
            wait for 11 ns;
            assert (NR_OF_REGS = "00011") report "test failed for nbr of reg 3" severity error;
            if ((not(NR_OF_REGS = "00011")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;           
 --6           
            REGLIST <= (others => '0') ;
            REGLIST(15) <= '1' ;
            REGLIST(3) <= '1' ;
            REGLIST(8) <= '1' ;
            REGLIST(9) <= '1' ;
            wait for 11 ns;
            assert (NR_OF_REGS = "00100") report "test failed for nbr of reg 4" severity error;
            if ((not(NR_OF_REGS = "00100")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;            

--7
            REGLIST <= (others => '0') ;
            REGLIST(15) <= '1' ;
            REGLIST(3) <= '1' ;
            REGLIST(2) <= '1' ;
            REGLIST(1) <= '1' ;
            REGLIST(0) <= '1' ;
            wait for 11 ns;
            assert (NR_OF_REGS = "00101") report "test failed for nbr of reg 5" severity error;
            if ((not(NR_OF_REGS = "00101")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;
 --8           
            REGLIST <= (others => '0') ;
            REGLIST(15) <= '1' ;
            REGLIST(3) <= '1' ;
            REGLIST(2) <= '1' ;
            REGLIST(1) <= '1' ;
            REGLIST(0) <= '1' ;
            REGLIST(10) <= '1' ;
            wait for 11 ns;
            assert (NR_OF_REGS = "00110") report "test failed for nbr of reg 6" severity error;
            if ((not(NR_OF_REGS = "00110")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;
 --9
             REGLIST <= (others => '0') ;
            REGLIST(15) <= '1' ;
             REGLIST(3) <= '1' ;
             REGLIST(2) <= '1' ;
             REGLIST(1) <= '1' ;
             REGLIST(0) <= '1' ;
             REGLIST(7) <= '1' ;
             REGLIST(8) <= '1' ;
            wait for 11 ns;
            assert (NR_OF_REGS = "00111") report "test failed for nbr of reg 7" severity error;
            if ((not(NR_OF_REGS = "00111")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;
--10
            REGLIST <= (others => '0') ;
            REGLIST(15) <= '1' ;
            REGLIST(3) <= '1' ;
            REGLIST(2) <= '1' ;
            REGLIST(1) <= '1' ;
            REGLIST(0) <= '1' ;
            REGLIST(7) <= '1' ;
            REGLIST(8) <= '1' ;
            REGLIST(10) <= '1' ;
            wait for 11 ns;
            assert (NR_OF_REGS = "01000") report "test failed for nbr of reg 8" severity error;
            if ((not(NR_OF_REGS = "01000")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;
--11
            REGLIST <= (others => '1') ;
            wait for 11 ns;
            assert (NR_OF_REGS = "10000") report "test failed for input 16" severity error;
            if ((not(NR_OF_REGS = "10000")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;
--12
            REGLIST <= (others => '1') ;
            REGLIST(8) <= '0' ;
            wait for 11 ns;
            assert (NR_OF_REGS = "01111") report "test failed for input 15" severity error;
            if ((not(NR_OF_REGS = "01111")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;
--13            
            REGLIST <= (others => '1') ;
            REGLIST(8) <= '0' ;
            REGLIST(10) <= '0' ;
            wait for 11 ns;
            assert (NR_OF_REGS = "01110") report "test failed for input 14" severity error;
            if ((not(NR_OF_REGS = "01110")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;

--14
            REGLIST <= (others => '1') ;
            REGLIST(8) <= '0' ;
            REGLIST(10) <= '0' ;
            REGLIST(0) <= '0' ;

            wait for 11 ns;
            assert (NR_OF_REGS = "01101") report "test failed for input 13" severity error;
            if ((not(NR_OF_REGS = "01101")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;
--15
            REGLIST <= (others => '1') ;
            REGLIST(8) <= '0' ;
            REGLIST(10) <= '0' ;
            REGLIST(0) <= '0' ;
            REGLIST(1) <= '0' ;
            wait for 11 ns;
            assert (NR_OF_REGS = "01100") report "test failed for input 12" severity error;
            if ((not(NR_OF_REGS = "01100")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;
--16            
            REGLIST <= (others => '1') ;
            REGLIST(8) <= '0' ;
            REGLIST(10) <= '0' ;
            REGLIST(0) <= '0' ;
            REGLIST(1) <= '0' ;
            REGLIST(2) <= '0' ;
            wait for 11 ns;
            assert (NR_OF_REGS = "01011") report "test failed for input 11" severity error;
            if ((not(NR_OF_REGS = "01011")) or (not(NR_OF_REGS'stable(10 ns)))) then
                errors := errors + 1;
            end if;       
            
                                        
if (errors = 0) then
			report " success . no errors"; 
		else
			report " testbench failed : " & integer'image(errors) & " errors ";
		end if;
		report SEPARATOR_LINE;	
		report " EOT (END OF TEST) - Diese Fehlermeldung stoppt den Simulator unabhaengig von tatsaechlich aufgetretenen Fehlern!" severity failure; 
--	Unbegrenztes Anhalten des Testbench Prozess
		wait;
	end process tb;
end architecture testbench;

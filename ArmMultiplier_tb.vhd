library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.ArmTypes.all;

entity ArmMultiplier_TB is
end entity ArmMultiplier_TB;

architecture behavioral of ArmMultiplier_TB is

    component ArmMultiplier is
        Port (
            MUL_OP1 	: in  STD_LOGIC_VECTOR (31 downto 0);
            MUL_OP2 	: in  STD_LOGIC_VECTOR (31 downto 0);
            MUL_RES 	: out  STD_LOGIC_VECTOR (31 downto 0)
        );
    end component ArmMultiplier;

    signal op1 : std_logic_vector(31 downto 0);
    signal op2 : std_logic_vector(31 downto 0);
    signal result : std_logic_vector(31 downto 0);
    signal halt_tb : boolean;

begin

    dut: ArmMultiplier
    port map (
        MUL_OP1 => op1,
        MUL_OP2 => op2,
        MUL_RES => result
    );

    -- Clock process
    process
    begin
        wait for 10 ns; -- Initial wait
        while NOT halt_tb loop
            wait for 10 ns; -- Clock period
        end loop;
        wait;
    end process;

    -- Stimulus process
    process
    begin
        op1 <= x"00000001"; -- Set operand 1 to 1
        op2 <= x"00000002"; -- Set operand 2 to 2
        wait for 10 ns;
        op1 <= x"00000003"; -- Set operand 1 to 3
        op2 <= x"00000004"; -- Set operand 2 to 4
        wait for 10 ns;
        op1 <= x"0000000A"; -- Set operand 1 to 10
        op2 <= x"00000005"; -- Set operand 2 to 5
        wait for 10 ns;
        op1 <= x"FFFFFFFF"; -- -1 * -1 = 1
        op2 <= x"FFFFFFFF";
        wait for 10 ns;
        op1 <= x"F0000000";
        op2 <= x"0F000000";
        wait for 10 ns;
        op1 <= x"0000000F";
        op2 <= x"F0000000"; 
        wait for 10 ns;
        
        halt_tb <= true; -- Stop the simulation
        wait;
        
        -- report
    end process;

end architecture behavioral;

--------------------------------------------------------------------------------
--	Shifter des HWPR-Prozessors, instanziiert einen Barrelshifter.
--------------------------------------------------------------------------------
--	Datum:		??.??.2013
--	Version:	?.?
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.ArmTypes.all;

entity ArmShifter is
    port (
        SHIFT_OPERAND  : in  std_logic_vector(31 downto 0);
        SHIFT_AMOUNT   : in  std_logic_vector(7 downto 0);
        SHIFT_TYPE_IN  : in  std_logic_vector(1 downto 0);
        SHIFT_C_IN     : in  std_logic;
        SHIFT_RRX      : in  std_logic;
        SHIFT_RESULT   : out std_logic_vector(31 downto 0);
        SHIFT_C_OUT    : out std_logic    		
    );
end entity ArmShifter;

architecture behave of ArmShifter is
    component ArmBarrelShifter is
        generic (
            OPERAND_WIDTH : integer;
            SHIFTER_DEPTH : integer
        );
        port (
            OPERAND       : in  std_logic_vector(3 downto 0);
            MUX_CTRL      : in  std_logic_vector(1 downto 0);
            AMOUNT        : in  std_logic_vector(1 downto 0);
            ARITH_SHIFT   : in  std_logic;
            C_IN          : in  std_logic;          
            DATA_OUT      : out std_logic_vector(3 downto 0);
            C_OUT         : out std_logic
        );
    end component ArmBarrelShifter;

    signal SHIFT_OPERAND_REG : std_logic_vector(31 downto 0);
    signal SHIFT_RESULT_REG  : std_logic_vector(31 downto 0);
    signal SHIFT_C_OUT_REG   : std_logic;

    signal MUX_CTRL          : std_logic_vector(1 downto 0);
    signal AMOUNT            : std_logic_vector(1 downto 0);
    signal ARITH_SHIFT       : std_logic;
    signal C_IN              : std_logic;
    signal DATA_OUT          : std_logic_vector(3 downto 0);
    signal C_OUT             : std_logic;

begin

    SHIFT_OPERAND_REG <= SHIFT_OPERAND;

    SHIFT_LOGIC: process (SHIFT_OPERAND_REG, SHIFT_AMOUNT, SHIFT_TYPE_IN, SHIFT_C_IN, SHIFT_RRX)
    begin
        case SHIFT_TYPE_IN is
            when "00" => -- SH_LSL
                if to_integer(unsigned(SHIFT_AMOUNT)) <= 31 then
                    MUX_CTRL <= "00";
                    AMOUNT <= SHIFT_AMOUNT(1 downto 0);
                    ARITH_SHIFT <= '0';
                    C_IN <= SHIFT_C_IN;
                    ArmBarrelShifter: ArmBarrelShifter
                        generic map (
                            OPERAND_WIDTH => 32,
                            SHIFTER_DEPTH => 5
                        )
                        port map (
                            OPERAND   => SHIFT_OPERAND_REG(3 downto 0),
                            MUX_CTRL  => MUX_CTRL,
                            AMOUNT    => AMOUNT,
                            ARITH_SHIFT => ARITH_SHIFT,
                            C_IN      => C_IN,
                            DATA_OUT  => DATA_OUT,
                            C_OUT     => C_OUT
                        );
                    SHIFT_RESULT_REG <= SHIFT_OPERAND_REG(31 downto 4) & DATA_OUT;
                    SHIFT_C_OUT_REG <= C_OUT;
                else
                    SHIFT_RESULT_REG <= (others => '0');
                    SHIFT_C_OUT_REG <= SHIFT_C_IN;
                end if;
            when "01" => -- SH_LSR
                if to_integer(unsigned(SHIFT_AMOUNT)) <= 31 then
                    MUX_CTRL <= "01";
                    AMOUNT <= SHIFT_AMOUNT(1 downto 0);
                    ARITH_SHIFT <= '0';
                    C_IN <= SHIFT_C_IN;
                    ArmBarrelShifter: ArmBarrelShifter
                        generic map (
                            OPERAND_WIDTH => 32,
                            SHIFTER_DEPTH => 5
                        )
                        port map (
                            OPERAND   => SHIFT_OPERAND_REG(3 downto 0),
                            MUX_CTRL  => MUX_CTRL,
                            AMOUNT    => AMOUNT,
                            ARITH_SHIFT => ARITH_SHIFT,
                            C_IN      => C_IN,
                            DATA_OUT  => DATA_OUT,
                            C_OUT     => C_OUT
                        );
                    SHIFT_RESULT_REG <= SHIFT_OPERAND_REG(31 downto 4) & DATA_OUT;
                    SHIFT_C_OUT_REG <= C_OUT;
                else
                    SHIFT_RESULT_REG <= (others => '0');
                    SHIFT_C_OUT_REG <= SHIFT_C_IN;
                end if;
            when "10" => -- SH_ASR
                if to_integer(unsigned(SHIFT_AMOUNT)) <= 31 then
                    MUX_CTRL <= "10";
                    AMOUNT <= SHIFT_AMOUNT(1 downto 0);
                    ARITH_SHIFT <= '1';
                    C_IN <= SHIFT_C_IN;
                    ArmBarrelShifter: ArmBarrelShifter
                        generic map (
                            OPERAND_WIDTH => 32,
                            SHIFTER_DEPTH => 5
                        )
                        port map (
                            OPERAND   => SHIFT_OPERAND_REG(3 downto 0),
                            MUX_CTRL  => MUX_CTRL,
                            AMOUNT    => AMOUNT,
                            ARITH_SHIFT => ARITH_SHIFT,
                            C_IN      => C_IN,
                            DATA_OUT  => DATA_OUT,
                            C_OUT     => C_OUT
                        );
                    SHIFT_RESULT_REG <= SHIFT_OPERAND_REG(31 downto 4) & DATA_OUT;
                    SHIFT_C_OUT_REG <= C_OUT;
                else
                    if SHIFT_OPERAND_REG(31) = '1' then
                        SHIFT_RESULT_REG <= (others => '1');
                    else
                        SHIFT_RESULT_REG <= (others => '0');
                    end if;
                    SHIFT_C_OUT_REG <= SHIFT_OPERAND_REG(31);
                end if;
            when "11" => -- SH_ROR
                if to_integer(unsigned(SHIFT_AMOUNT)) <= 31 then
                    MUX_CTRL <= "11";
                    AMOUNT <= SHIFT_AMOUNT(1 downto 0);
                    ARITH_SHIFT <= '0';
                    C_IN <= SHIFT_C_IN;
                    ArmBarrelShifter: ArmBarrelShifter
                        generic map (
                            OPERAND_WIDTH => 32,
                            SHIFTER_DEPTH => 5
                        )
                        port map (
                            OPERAND   => SHIFT_OPERAND_REG(3 downto 0),
                            MUX_CTRL  => MUX_CTRL,
                            AMOUNT    => AMOUNT,
                            ARITH_SHIFT => ARITH_SHIFT,
                            C_IN      => C_IN,
                            DATA_OUT  => DATA_OUT,
                            C_OUT     => C_OUT
                        );
                    SHIFT_RESULT_REG <= SHIFT_OPERAND_REG(31 downto 4) & DATA_OUT;
                    SHIFT_C_OUT_REG <= C_OUT;
                else
                    SHIFT_RESULT_REG <= SHIFT_OPERAND_REG;
                    SHIFT_C_OUT_REG <= SHIFT_C_IN;
                end if;
            when others => -- SH_RRX or invalid
                if SHIFT_RRX = '1' then
                    MUX_CTRL <= "11";
                    AMOUNT <= "00";
                    ARITH_SHIFT <= '0';
                    C_IN <= SHIFT_OPERAND_REG(0);
                    ArmBarrelShifter: ArmBarrelShifter
                        generic map (
                            OPERAND_WIDTH => 32,
                            SHIFTER_DEPTH => 5
                        )
                        port map (
                            OPERAND   => SHIFT_OPERAND_REG(3 downto 0),
                            MUX_CTRL  => MUX_CTRL,
                            AMOUNT    => AMOUNT,
                            ARITH_SHIFT => ARITH_SHIFT,
                            C_IN      => C_IN,
                            DATA_OUT  => DATA_OUT,
                            C_OUT     => C_OUT
                        );
                    SHIFT_RESULT_REG <= SHIFT_OPERAND_REG(31 downto 4) & DATA_OUT;
                    SHIFT_C_OUT_REG <= C_OUT;
                else
                    SHIFT_RESULT_REG <= SHIFT_OPERAND_REG;
                    SHIFT_C_OUT_REG <= SHIFT_C_IN;
                end if;
        end case;
    end process;
    
    SHIFT_RESULT <= SHIFT_RESULT_REG;
    SHIFT_C_OUT <= SHIFT_C_OUT_REG;

end architecture behave;


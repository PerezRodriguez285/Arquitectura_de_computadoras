-- Sumador completo de 1 bit
library IEEE;
use IEEE.std_logic_1164.all;

entity test is
end entity;

architecture arch tes is

    component Sumador_1 is
        port (
            sum, cout : out std_logic;
            a, b, cin : in std_logic
        );
    end component;

    signal testInVector : std_logic_vector (2 downto 0);
    signal testSum, testCout : std_logic;

begin

    unit_under_test: oneBitFullAdder port map (
        sum => testSum,
        cout => testCout,
        cin => testInVector(2),
        a => testInVector(1),
        b => testInVector(0)
    );

    generate_signals : process
    begin
        testInVector <= "000"; wait for 10 ns;
        testInVector <= "001"; wait for 10 ns;
        testInVector <= "010"; wait for 10 ns;
        testInVector <= "011"; wait for 10 ns;
        testInVector <= "100"; wait for 10 ns;
        testInVector <= "101"; wait for 10 ns;
        testInVector <= "110"; wait for 10 ns;
        testInVector <= "111"; wait for 10 ns;
        wait;
    end process;

end architecture;
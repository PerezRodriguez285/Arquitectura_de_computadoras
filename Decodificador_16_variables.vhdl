library IEEE;
use IEEE.std_logic_1164.all;

entity decoder4to16 is
    port (
        y16, y15, y14, y13, y12, y11, y10, y9, y8, y7, y6, y5, y4, y3, y2, y1 : out std_logic;
        x4, x3, x2, x1 : in std_logic
    );
end entity;

architecture arch of decoder4to16 is

    signal outVect : std_logic_vector (16 downto 1);
    signal inVect : std_logic_vector (4 downto 1);

begin

    y16 <= outVect(16);
    y15 <= outVect(15);
    y14 <= outVect(14);
    y13 <= outVect(13);
    y12 <= outVect(12);
    y11 <= outVect(11);
    y10 <= outVect(10);
    y9 <= outVect(9);
    y8 <= outVect(8);
    y7 <= outVect(7);
    y6 <= outVect(6);
    y5 <= outVect(5);
    y4 <= outVect(4);
    y3 <= outVect(3);
    y2 <= outVect(2);
    y1 <= outVect(1);

    inVect(4) <= x4;
    inVect(3) <= x3;
    inVect(2) <= x2;
    inVect(1) <= x1;

    outVect <=
        "0000011101111111" when inVect = "0000" else
        "0000011111111111" when inVect = "0001" else
        "0000010100000010" when inVect = "0010" else
        "0000000110110010" when inVect = "0011" else

        "0000100111010101" when inVect = "0100" else
        "0000010010101111" when inVect = "0101" else
        "0000011010011101" when inVect = "0110" else
        "0000111011010001" when inVect = "0111" else

        "0101001010111010" when inVect = "1000" else
        "0101010101000111" when inVect = "1001" else
        "0101100000111010" when inVect = "1010" else
        "0101110010111011" when inVect = "1011" else

        "0011111001111111" when inVect = "1100" else
        "0011100100101111" when inVect = "1101" else
        "0011110010011011" when inVect = "1110" else
        "0011010001101111" when inVect = "1111" else

        -- Si no es una señal bien definida..
        "UUUUUUUUUUUUUUUU";
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end entity;

architecture arch of testbench is
    component decoder4to16 is
        port (
            y16, y15, y14, y13, y12, y11, y10, y9, y8, y7, y6, y5, y4, y3, y2, y1 : out std_logic;
            x4, x3, x2, x1 : in std_logic
        );
    end component;

    signal outVect : std_logic_vector (16 downto 1);
    signal inVect : std_logic_vector (4 downto 1);

begin

    unit_under_test: component decoder4to16 port map (
        y16 => outVect(16),
        y15 => outVect(15),
        y14 => outVect(14),
        y13 => outVect(13),
        y12 => outVect(12),
        y11 => outVect(11),
        y10 => outVect(10),
        y9 => outVect(9),
        y8 => outVect(8),
        y7 => outVect(7),
        y6 => outVect(6),
        y5 => outVect(5),
        y4 => outVect(4),
        y3 => outVect(3),
        y2 => outVect(2),
        y1 => outVect(1),

        x4 => inVect(4),
        x3 => inVect(3),
        x2 => inVect(2),
        x1 => inVect(1)
    );

    decode_signals_process : process
    begin
        inVect <= "0000"; wait for 10 ns;
        inVect <= "0001"; wait for 10 ns;
        inVect <= "0010"; wait for 10 ns;
        inVect <= "0011"; wait for 10 ns;
        inVect <= "0100"; wait for 10 ns;
        inVect <= "0101"; wait for 10 ns;
        inVect <= "0110"; wait for 10 ns;
        inVect <= "0111"; wait for 10 ns;
        inVect <= "1000"; wait for 10 ns;
        inVect <= "1001"; wait for 10 ns;
        inVect <= "1010"; wait for 10 ns;
        inVect <= "1011"; wait for 10 ns;
        inVect <= "1100"; wait for 10 ns;
        inVect <= "1101"; wait for 10 ns;
        inVect <= "1110"; wait for 10 ns;
        inVect <= "1111"; wait for 10 ns;
        wait;
    end process;

end architecture;
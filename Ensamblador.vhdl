library IEEE;
use IEEE.std_logic_1164.all;

entity Qs is
    port (
        valueOut : out std_logic_vector (63 downto 0);
        valueIn : in std_logic_vector (63 downto 0);
        reset, clock, load : in std_logic
    );
end entity;

architecture arch_loadRegister64 of Qs is

    signal auxValueOut : std_logic_vector (63 downto 0);

begin

    valueOut <= auxValueOut;

    identifier : process (clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                auxValueOut <= x"0000000000000000";
            elsif load = '1' then
                auxValueOut <= valueIn;
            end if;
        end if;
    end process;

end architecture;

library IEEE;
use IEEE.std_logic_1164.all;

entity Memoria is
end entity;

architecture arch_loadRegister64 of Memoria is

    component loadRegister64 is
        port (
            valueOut : out std_logic_vector (63 downto 0);
            valueIn : in std_logic_vector (63 downto 0);
            reset, clock, load : in std_logic
        );
    end component;

    signal testReset, testClock, testLoad : std_logic := '0';
    signal testValueOut, testValueIn : std_logic_vector (63 downto 0);
    signal tics : integer := 0;

begin

    testing_unit: loadRegister64 port map (
        valueOut => testValueOut,
        valueIn => testValueIn,
        reset => testReset,
        clock => testClock,
        load => testLoad
    );

    generate_100Mhzs_clock : process
    begin

        report "Tic tac..";
        testClock <= not testClock;
        wait for 5 ns; -- Tiempo de espera en un flanco de reloj.

        if testClock = '1' then tics <= tics + 1; end if;
        if tics >= 10 then wait; end if;

    end process;

    generate_signals : process
    begin

        testReset <= '1'; testValueIn <= x"00000000FFFFFFFF";

        wait for 5 ns;
        testReset <= '0'; wait for 10 ns;
        testLoad <= '1'; wait for 10 ns;

        testValueIn <= x"000000000000000A"; wait for 10 ns;
        testValueIn <= x"000000000000000B"; wait for 10 ns;
        testValueIn <= x"000000000000000C"; wait for 10 ns;

        testLoad <= '0'; wait for 10 ns;

        testReset <= '1'; wait for 10 ns;
        testReset <= '0'; wait for 10 ns;

        wait;

    end process;

end architecture;

library IEEE;
use IEEE.std_logic_1164.all;

entity Decodificador is
    port (
        -- Tiene 4 pines de entrada y 16 de salida.
        y : out std_logic_vector (15 downto 0);
        x : in std_logic_vector (3 downto 0);
        enable : in std_logic
    );
end entity;

architecture arch_decoder4x16 of Decodificador is
begin

    identifier : process(enable)
    begin
        if enable = '1' then
            if x = "0000" then
                y <= "0000000000000001";
            elsif x = "0001" then
                y <= "0000000000000010";
            elsif x = "0010" then
                y <= "0000000000000100";
            elsif x = "0011" then
                y <= "0000000000001000";
            elsif x = "0100" then
                y <= "0000000000010000";
            elsif x = "0101" then
                y <= "0000000000100000";
            elsif x = "0110" then
                y <= "0000000001000000";
            elsif x = "0111" then
                y <= "0000000010000000";
            elsif x = "1000" then
                y <= "0000000100000000";
            elsif x = "1001" then
                y <= "0000001000000000";
            elsif x = "1010" then
                y <= "0000010000000000";
            elsif x = "1011" then
                y <= "0000100000000000";
            elsif x = "1100" then
                y <= "0001000000000000";
            elsif x = "1101" then
                y <= "0010000000000000";
            elsif x = "1110" then
                y <= "0100000000000000";
            elsif x = "1111" then
                y <= "1000000000000000";
            else
                -- Si no es una señal bien definida..
                y <= "UUUUUUUUUUUUUUUU";
            end if;
        else
            y <= "0000000000000000";
        end if;

    end process;

end architecture;

library IEEE;
use IEEE.std_logic_1164.all;

entity MemoriaDatos is
    port (
        readData : out std_logic_vector (63 downto 0);
        writeData : in std_logic_vector (63 downto 0);

        writeAddress : in std_logic_vector (3 downto 0);
        writeEnable : in std_logic;

        readAddress : in std_logic_vector (3 downto 0);
        readEnable : in std_logic;

        mainReset : in std_logic;
        mainClock : in std_logic
    );
end entity;

architecture arch_registerFile16x64 of MemoriaDatos is

    component loadRegister64 is
        port (
            valueOut : out std_logic_vector (63 downto 0);
            valueIn : in std_logic_vector (63 downto 0);
            reset, clock, load : in std_logic
        );
    end component;

    component decoder4x16 is
        port (
            -- Tiene 4 pines de entrada y 16 de salida.
            y : out std_logic_vector (15 downto 0);
            x : in std_logic_vector (3 downto 0);
            enable : in std_logic
        );
    end component;

    signal enableRegisterToWrite : std_logic_vector (15 downto 0);
    signal enableRegisterToRead : std_logic_vector (15 downto 0);

begin

    -- Decodificador para la escritura en registro que corresponda.
    decode_write_address : decoder4x16 port map (
        y => enableRegisterToWrite,
        x => writeAddress,
        enable => writeEnable
    );
    -- Decodificador para leer el registro.
    decode_read_address : decoder4x16 port map (
        y => enableRegisterToRead,
        x => readAddress,
        enable => readEnable
    );

    -- Los 16 registros, del R0 al R15.
    register_R0 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(0)
    );
    register_R1 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(1)
    );
    register_R2 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(2)
    );
    register_R3 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(3)
    );
    register_R4 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(4)
    );
    register_R5 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(5)
    );
    register_R6 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(6)
    );
    register_R7 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(7)
    );
    register_R8 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(8)
    );
    register_R9 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(9)
    );
    register_R10 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(10)
    );
    register_R11 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(11)
    );
    register_R12 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(12)
    );
    register_R13 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(13)
    );
    register_R14 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(14)
    );
    register_R15 : loadRegister64 port map (
        valueOut => readData,
        valueIn => writeData,
        reset => mainReset,
        clock => mainClock,
        load => enableRegisterToWrite(15)
    );

end architecture;

library IEEE;
use IEEE.std_logic_1164.all;

entity Memoriarom is
end entity;

architecture arch_lMemoriarom_tb of Memoriarom is

    component loadRegister64 is
        port (
            valueOut : out std_logic_vector (63 downto 0);
            valueIn : in std_logic_vector (63 downto 0);
            reset, clock, load : in std_logic
        );
    end component;

    signal testReset, testClock, testLoad : std_logic := '0';
    signal testValueOut, testValueIn : std_logic_vector (63 downto 0);
    signal tics : integer := 0;

begin

    testing_unit: loadRegister64 port map (
        valueOut => testValueOut,
        valueIn => testValueIn,
        reset => testReset,
        clock => testClock,
        load => testLoad
    );

    generate_100Mhzs_clock : process
    begin

        report "Tic tac..";
        testClock <= not testClock;
        wait for 5 ns; -- Tiempo de espera en un flanco de reloj.

        if testClock = '1' then tics <= tics + 1; end if;
        if tics >= 10 then wait; end if;

    end process;

    generate_signals : process
    begin

        testReset <= '1'; testValueIn <= x"00000000FFFFFFFF";

        wait for 5 ns;
        testReset <= '0'; wait for 10 ns;
        testLoad <= '1'; wait for 10 ns;

        testValueIn <= x"000000000000000A"; wait for 10 ns;
        testValueIn <= x"000000000000000B"; wait for 10 ns;
        testValueIn <= x"000000000000000C"; wait for 10 ns;

        testLoad <= '0'; wait for 10 ns;

        testReset <= '1'; wait for 10 ns;
        testReset <= '0'; wait for 10 ns;

        wait;

    end process;

end architecture;

testbench
library IEEE;
use IEEE.std_logic_1164.all;

entity registerFile16x64_tb is
end entity;

architecture arch_registerFile16x64_tb of registerFile16x64_tb is

    component registerFile16x64 is
        port (
            readData : out std_logic_vector (63 downto 0);
            writeData : in std_logic_vector (63 downto 0);

            writeAddress : in std_logic_vector (3 downto 0);
            writeEnable : in std_logic;

            readAddress : in std_logic_vector (3 downto 0);
            readEnable : in std_logic;

            mainReset : in std_logic;
            mainClock : in std_logic
        );
    end component;

    signal testReadData, testWriteData : std_logic_vector (63 downto 0) := x"0000000000000000";
    signal testWriteAddress, testReadAddress : std_logic_vector (3 downto 0) := x"0";
    signal testWriteEnable, testReadEnable : std_logic := '0';
    signal testReset, testClock : std_logic := '0';

    signal tics : integer := 0;

begin

    testing_unit : registerFile16x64 port map (
        readData => testReadData,
        writeData => testWriteData,
        writeAddress => testWriteAddress,
        writeEnable => testWriteEnable,
        readAddress => testReadAddress,
        readEnable => testReadEnable,
        mainReset => testReset,
        mainClock => testClock
    );

    generate_100Mhzs_clock : process
    begin

        -- Haciendo el tic tac del reloj..
        report "Tic tac..";
        testClock <= not testClock;
        wait for 5 ns;

        -- Contamos tics para hacer sólo unos cuantos.
        if testClock = '1' then tics <= tics + 1; end if;
        if tics >= 20 then wait; end if;

    end process;

    generate_signals : process
    begin

        wait for 5 ns;

        testReset <= '1'; wait for 10 ns; testReset <= '0';

        -- Escribimos algo en R1 y R2..

        testWriteEnable <= '1';
        testWriteData <= x"000000000000AAAA";
        testWriteAddress <= "0011";
        wait for 10 ns;
        testWriteEnable <= '0';
        testWriteData <= x"0000000000000000";
        wait for 10 ns;

        testWriteEnable <= '1';
        testWriteData <= x"000000000000BBBB";
        testWriteAddress <= "0010";
        wait for 10 ns;
        testWriteEnable <= '0';
        testWriteData <= x"0000000000000000";
        wait for 10 ns;

        -- Simulando cargas y lecturas en registros para la
        -- operación en ensamblador:
        -- R3 <- R1 + R2

        -- Lectura de R1
        testReadEnable <= '1'; testReadAddress <= "0011"; wait for 10 ns;
        testReadEnable <= '0'; wait for 10 ns;

        -- Lectura de R2
        testReadEnable <= '1'; testReadAddress <= "0010"; wait for 10 ns;
        testReadEnable <= '0'; wait for 10 ns;

        -- Esperamos resultado de la operación
        wait for 30 ns;

        -- Escribimos un resultado en R3
        testWriteEnable <= '1';
        testWriteData <= x"0000000000016665";
        testWriteAddress <= "0011"; wait for 10 ns;
        testWriteEnable <= '0'; wait for 10 ns;

        wait;
    end process;

end architecture;
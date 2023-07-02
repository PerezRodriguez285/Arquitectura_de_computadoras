-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
  port (
         a  : in std_logic_vector(7 downto 0);
         b  : in std_logic_vector(7 downto 0);
         Op : in std_logic_vector(1 downto 0);
         s  : out std_logic_vector(7 downto 0)
  );
end entity;

architecture RTL of ALU is
begin
  process(a,b,Op)
  begin
    case Op is
      when "00" =>
        s  <= std_logic_vector(unsigned(a) + unsigned(b));
      when "01" =>
        s  <= std_logic_vector(unsigned(a) - unsigned(b));
      when "10" =>
        s <= a and b;
      when others =>
        s <= a or b;
    end case;
  end process;
end architecture;

-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity test is
end entity;

architecture tb of test is
component ALU is
  port (
         a      : in std_logic_vector(7 downto 0);
         b      : in std_logic_vector(7 downto 0);
         Op 	: in std_logic_vector(1 downto 0);
         s      : out std_logic_vector(7 downto 0)
  );
end component;

signal  a_s      : std_logic_vector(7 downto 0);
signal  b_s      : std_logic_vector(7 downto 0);
signal  Op_s 	 : std_logic_vector(1 downto 0);
signal  s_s      : std_logic_vector(7 downto 0);

begin
  UUT: alu port map(a_s, b_s, Op_s, s_s);
  a_s <= "00010001", "01100101" after 5 ns;
  b_s <= "00100011", "00000010" after 5 ns, "00111001" after 20 ns;
  Op_s <= "00", "10" after 5 ns;

end architecture;
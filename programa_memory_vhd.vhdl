-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use std.textio.all;

entity rom is
 port( Q1 : in std_logic;
       --index_inst : in std_logic_vector(12 downto 0);
       inst : out std_logic_vector(13 downto 0)
     );
end rom;
architecture behav of rom is
 type eeprom_mem is array(0 to 255) of std_logic_vector(13 downto 0);
 signal eeprom : eeprom_mem;
 signal init_flag : boolean := false;
begin
 process(Q1)
  file program : text;
  variable ptr_line : line;
  variable get_line : std_logic_vector(13 downto 0);
  variable index, i : integer := 0;
 begin
  if rising_edge(Q1) then
  if init_flag = false then
  file_open(program, "D:\\program_memory.txt", read_mode);
  while not(endfile(program)) loop
   readline(program, ptr_line);
   read(ptr_line, get_line);
   eeprom(index) <= get_line;
   index := index + 1;
  end loop;
  init_flag <= true;
  file_close(program);
  i := index;
  while (i <= 255) loop
   eeprom(i) <= "11111111111111";
   i := i + 1;
  end loop;
  i := 0;
  else
   --inst <= eeprom(conv_integer(index_inst));
   if i < index then
   inst <= eeprom(i);
   i := i + 1;
   end if;
  end if;
 end if;
 end process;
end behav;

-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
entity testbench is

end testbench;

architecture arch of testbench is
component rom is
 port( Q1 : in std_logic;
       --index_inst : in std_logic_vector(12 downto 0);
       inst : out std_logic_vector(13 downto 0)
     );
end component;
 signal clk: std_logic;
 signal instruction: std_logic_vector(13 downto 0);
begin
 rom01: rom port map(clk,instruction);
 process
 begin
  clk <= '0';
  wait for 10ps;
  clk <= '1';
  wait for 10ps;
  clk <= '0';
  wait for 10ps;
  clk <= '1';
  wait for 10ps;
  clk <= '0';
  wait for 10ps;
  clk <= '1';
  wait for 10ps;
  clk <= '0';
  wait for 10ps;
  clk <= '1';
  wait for 10ps;
  clk <= '0';
  wait for 10ps;
  clk <= '1';
  wait for 10ps;
  clk <= '0';
  wait for 10ps;
  clk <= '1';
  wait for 10ps;
  
  clk <= '0';
  wait;
 end process;
end arch;
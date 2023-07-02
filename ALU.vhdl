library IEEE;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;

entity ALU_tb is
end entity;

architecture prueba of ALU_tb is
component ALU is
	port
	(
		A,B	 : in  std_logic_vector(3 downto 0);	
		opcode   : in  std_logic_vector(2 downto 0);
		Cout     : out std_logic;
		Yout	 : out std_logic_vector(3 downto 0)
	);
end component;

signal A: std_logic_vector(3 downto 0) := "1011";
signal B: std_logic_vector(3 downto 0) := "1001";
signal opcode: std_logic_vector(2 downto 0) := (others=>'0');
signal Cout: std_logic := '0';
signal Resul: std_logic_vector(3 downto 0) := (others=>'0');


begin
  ULA: ALU port map(A,B,opcode,Cout,Resul);

   A <= "1001" after 80 ns;
   B <= "0001" after 80 ns;
   opcode <= opcode + '1' after 80 ns; 
end architecture;

codigo principal

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ALU is
 port(
	A, B : in std_logic_vector(3 downto 0);
	opcode : in std_logic_vector(2 downto 0);
	cout : out std_logic;
	Yout : out std_logic_vector(3 downto 0)
);
end ALU;

architecture concurrente of ALU is
signal Y_tmp : std_logic_vector(4 downto 0) := (others => '0');
begin
	with opcode(2 downto 0) select
		Y_tmp <=  ('0' & A) when "000",
		          ('0' & B) when "001",
			  ('0' & A) and ('0' & B) when "010", 
			  ('0' & A) or  ('0' & B) when "011",
			  ('0' & A) + B   when "100",
		          ('0' & A) + '1' when "101",
			  ('0' & A) - '1' when "110", 
			  ('0' & A) - B   when others;
Cout <= Y_tmp(4);
Yout <= Y_tmp(3 downto 0);

end concurrente;
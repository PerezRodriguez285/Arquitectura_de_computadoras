-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
entity Qs is 
port(
	clk: in std_logic;
    Q1: out std_logic;
    Q2: out std_logic;
    Q3: out std_logic;
    Q4: out std_logic);
end Qs;
architecture behavioral of Qs is
signal Q: std_logic_vector(3 downto 0):="0001";
begin 
process(clk)
	begin 
    	if rising_edge(clk) then 
        	Q <= Q rol 1;
        end if;
  end process;
  Q1 <= Q(0);
  Q2 <= Q(1);
  Q3 <= Q(2);
  Q4 <= Q(3);
end ;

-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
entity rom is 
GENERIC(
	bits: INTEGER := 14;
    words: INTEGER := 8);
PORT(
	Q1 : in std_logic;
    inst : out std_logic_vector(bits-1 downto 0));
    
end rom;
architecture behavioral of rom is
TYPE vector_array is array(0 to words-1) of std_logic_vector(bits-1 downto 0);
signal addr: INTEGER RANGE 0 to words-1 := 0;
CONSTANT MEMORY : vector_array := ("00000000000000",
								   "01010101010101",
                                   "00110011001100",
                                   "11100011100011",
                                   "11000110001100",
                                   "11111110000000",
                                   "10101010101010",
                                   "11111111111111");
begin 
process(Q1)
	begin
    	if rising_edge(Q1) then 
        	inst <= memory(addr);
            addr <= addr+1;
        end if;
   end process;
end behavioral;
                   
library IEEE;
use IEEE.std_logic_1164.all;
entity union is 
port(
	clk: in std_logic;
    inst: out std_logic_vector(13 downto 0));
end union;
architecture behavioral of union is
	component Qs is
    port(
    	clk: in std_logic;
        Q1: out std_logic;
        Q2: out std_logic;
        Q3: out std_logic;
        Q4: out std_logic);
end component;
component rom is 
	GENERIC(bits: INTEGER := 14;
    		words: INTEGER :=8);
    PORT(Q1: in std_logic;
    	inst: out std_logic_vector(bits-1 downto 0));
    end component;
   	signal WQ : std_logic_vector(3 downto 0);
begin 
	Qs0 : Qs port map(clk,WQ(0),WQ(1),WQ(2),WQ(3));
    rom0 : rom port map(WQ(0),inst);
end behavioral;
    
-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
entity testbench is
	--entity
end testbench;
architecture behavioral of testbench is
	component union is
    	port(
        	clk : in std_logic;
            inst0: out std_logic_vector(13 downto 0));
    end component;
signal clk: std_logic;
signal inst: std_logic_vector(13 downto 0);
begin
union0: union port map(clk,inst);
process
	variable i : INTEGER := 0;
begin
	while(i<=10) loop
    	clk <= '0';
        wait for 1 ps;
        clk <= '1';
        wait for 1 ps;
        i := i+1;
    end loop;
--clear
		clk <= '0';
        wait;
     end process;
end behavioral;
            
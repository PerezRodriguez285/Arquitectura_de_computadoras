-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity sumador is
	port(
    	A,B: in std_logic_vector(3 downto 0);
        ci: in std_logic;
        co: out std_logic;
        s: out std_logic_vector(3 downto 0)
    );
end sumador;

architecture recurrente of sumador is
signal c: std_logic_vector(4 downto 0);
begin
	process(A,B,c,ci)
    begin
    	c(0)<=ci;
        for i in 0 to 3 loop
        	s(i)<=(A(i) xor B(i)) xor c(i);
            c(i+1)<=((A(i)and B(i))or (A(i)and c(i))) or (B(i)and c(i));
            end loop;
     end process;
     co<=c(4);
end recurrente;
        
        	
-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity mult4bits is
	port(
    A,B: in std_logic_vector(3 downto 0);
    m: out std_logic_vector(7 downto 0)
    );
end mult4bits;

architecture mmm of mult4bits is
signal f,g,h,i,j,k: std_logic_vector(4 downto 1);
signal s,q,r: std_logic_vector(3 downto 0);
signal ci,co,c1,c2,ro: std_logic;
component sumador
	port(
    A,B: in std_logic_vector(3 downto 0);
    ci: in std_logic;
    co: out std_logic;
    s: out std_logic_vector(3 downto 0)
    );
end component;

begin
	ci<='0';
    ro<= A(0) AND B(0);
    g(1)<=A(0) AND B(1);
    g(2)<=A(0) AND B(2);
    g(3)<=A(0) AND B(3);
    g(4)<='0';
    
    f(1)<=A(1) AND B(0);
    f(2)<=A(1) AND B(1);
    f(3)<=A(1) AND B(2);
    f(4)<=A(1) AND B(3);
    
    h(1)<=A(2) AND B(0);
    h(2)<=A(2) AND B(1);
    h(3)<=A(2) AND B(2);
    h(4)<=A(2) AND B(3);
    
    j(1)<=A(3) AND B(0);
    j(2)<=A(3) AND B(1);
    j(3)<=A(3) AND B(2);
    j(4)<=A(3) AND B(3);
    
    sum1: sumador port map(f,g,ci,c1,s);
    i(1)<=s(1);
    i(2)<=s(2);
    i(3)<=s(3);
    i(4)<=c1;
    
    sum2: sumador port map(h,i,ci,c2,q);
    k(1)<=q(1);
    k(2)<=q(2);
    k(3)<=q(3);
    k(4)<=c2;
    
    sum3: sumador port map(j,k,ci,co,r);
    m(0)<=ro;
    m(1)<=s(0);
    m(2)<=q(0);
    m(3)<=r(0);
    m(4)<=r(1);
    m(5)<=r(2);
    m(6)<=r(3);
    m(7)<=co;
end mmm;
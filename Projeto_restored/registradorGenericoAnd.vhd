
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registradorGenericoAnd is
    generic (
        larguraDados : natural := 8
    );
    port (
		 DIN : in std_logic_vector(larguraDados-1 downto 0);
		 escrita : in std_logic;
		 blocos : in std_logic;
	    enderecos : in std_logic;
		 entrada_not : in std_logic;
		 CLK,RST : in std_logic;
		 
       DOUT : out std_logic_vector(larguraDados-1 downto 0)
--       ENABLE : in std_logic;
       
        );
end entity;

architecture comportamento of registradorGenericoAnd is

		 signal ENABLE: std_logic;

begin
	 
	 ENABLE <= escrita and blocos and enderecos and not(entrada_not);
    
    process(RST, CLK)
    begin
		  
        
        if (RST = '1') then
            DOUT <= (others => '0');    
        else
            if (rising_edge(CLK)) then
                if (ENABLE = '1') then
                        DOUT <= DIN;
                end if;
            end if;
        end if;
    end process;
end architecture;
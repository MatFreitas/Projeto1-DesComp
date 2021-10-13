
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registradorGenericoHex is
    generic (
        larguraDados : natural := 8
    );
    port (
		 DIN : in std_logic_vector(larguraDados-1 downto 0);
		 escrita : in std_logic;
		 blocos : in std_logic;
	    endereco : in std_logic;
		 endereco_de_dados : in std_logic;
		 CLK,RST : in std_logic;
		 
       DOUT : out std_logic_vector(larguraDados-1 downto 0)
--       ENABLE : in std_logic;
       
        );
end entity;

architecture comportamento of registradorGenericoHex is

		 signal ENABLE: std_logic;

begin
	 
	 ENABLE <= escrita and blocos and endereco and endereco_de_dados;
    
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity triStateVector is
   generic (
         dataWidth: natural := 8
 
    );
    port
    (
        entrada   : in std_logic_vector(dataWidth-1 downto 0);
        habilita : in std_logic;
        saida: out std_logic_vector(dataWidth-1 downto 0)
    );
end entity;

architecture rtl of triStateVector is
   
begin
   
  
	saida <= entrada when (habilita='1') else (others => 'Z');
end architecture;
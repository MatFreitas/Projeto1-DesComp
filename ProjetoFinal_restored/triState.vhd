library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity triState is
   generic (
         dataWidth: natural := 8
 
    );
    port
    (
        entrada   : in std_logic;
        habilita : in std_logic;
        saida: out std_logic
    );
end entity;

architecture rtl of triState is
   
begin
   
  
	saida <= entrada when (habilita='1') else 'Z';
end architecture;
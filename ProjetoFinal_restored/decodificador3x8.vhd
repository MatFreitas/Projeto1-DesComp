library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity decodificador3x8 is
  generic   (
    saida_WIDTH  : natural :=  64
);
  port   (
    -- Input ports
    
	 E0  :  in  std_logic;
	 E1  :  in  std_logic;
	 E2  :  in  std_logic;
	 
    -- Output ports
	 
    S0:  out  std_logic;
	 S1:  out  std_logic;
	 S2:  out  std_logic;
	 S3:  out  std_logic;
	 S4:  out  std_logic;
	 S5:  out  std_logic;
	 S6:  out  std_logic;
	 S7:  out  std_logic
	 
  );
end entity;

architecture arch_name of decodificador3x8 is
	 
		 
begin

	S0 <= '1' when E2='0' and E1='0' and E0='0' else '0';
	S1 <= '1' when E2='0' and E1='0' and E0='1' else '0';
	S2 <= '1' when E2='0' and E1='1' and E0='0' else '0';
	S3 <= '1' when E2='0' and E1='1' and E0='1' else '0';
	S4 <= '1' when E2='1' and E1='0' and E0='0' else '0';
	S5 <= '1' when E2='1' and E1='0' and E0='1' else '0';
	S6 <= '1' when E2='1' and E1='1' and E0='0' else '0';
	S7 <= '1' when E2='1' and E1='1' and E0='1' else '0';
		  
end architecture;
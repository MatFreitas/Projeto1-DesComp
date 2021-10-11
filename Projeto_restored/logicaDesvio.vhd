library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity logicaDesvio is
  generic   (
    mux_WIDTH  : natural :=  2
  );
  port   (
    -- Input ports
    JMP_LD : in std_logic;
	 RET_LD : in std_logic;
	 JSR_LD : in std_logic;
	 JEQ_LD : in std_logic;
	 flag_LD : in std_logic;
    -- Output ports
    MUX_LD : out std_logic_vector(mux_WIDTH-1 downto 0)
  );
end entity;

architecture arch_name of logicaDesvio is
	 
    	 
		 
begin
	
	MUX_LD <= "00" when JMP_LD = '0' and RET_LD = '0' and	JSR_LD = '0' and (JEQ_LD = '0' or (JEQ_LD = '1' and flag_LD = '0')) else
				 "01" when JMP_LD = '1' or (JEQ_LD = '1' and flag_LD = '1') or JSR_LD = '1' else
				 "10" when RET_LD = '1' else
				 "11";
	
end architecture;
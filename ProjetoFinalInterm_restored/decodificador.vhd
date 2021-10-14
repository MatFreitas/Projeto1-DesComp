library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity decodificador is
  generic   (
    opCode_WIDTH  : natural :=  4;
    sinaisControle_WIDTH  : natural :=  7
  );
  port   (
    -- Input ports
    opCode  :  in  std_logic_vector(opCode_WIDTH-1 downto 0);
    -- Output ports
    sinaisControle:  out  std_logic_vector(sinaisControle_WIDTH-1 downto 0)
  );
end entity;

architecture arch_name of decodificador is
	 constant NOP    : std_logic_vector(opCode_WIDTH-1 downto 0) := "0000";
    constant LDA    : std_logic_vector(opCode_WIDTH-1 downto 0) := "0001";
    constant SOMA   : std_logic_vector(opCode_WIDTH-1 downto 0) := "0010";
    constant SUB    : std_logic_vector(opCode_WIDTH-1 downto 0) := "0011";
	 constant LDI    : std_logic_vector(opCode_WIDTH-1 downto 0) := "0100";
	 constant STA    : std_logic_vector(opCode_WIDTH-1 downto 0) := "0101";
	 constant JMP    : std_logic_vector(opCode_WIDTH-1 downto 0) := "0110";
	 constant JEQ    : std_logic_vector(opCode_WIDTH-1 downto 0) := "0111";
	 constant CEQ    : std_logic_vector(opCode_WIDTH-1 downto 0) := "1000";
	 constant JSR    : std_logic_vector(opCode_WIDTH-1 downto 0) := "1001";
	 constant RET    : std_logic_vector(opCode_WIDTH-1 downto 0) := "1010";
	 
    
alias habEscritaMEM      : std_logic 
       is sinaisControle(0);
		 
alias habLeituraMEM      : std_logic 
       is sinaisControle(1);
		 	 
alias habFlagIgual      : std_logic 
       is sinaisControle(2);
		 
alias operacao      : std_logic_vector 
       is sinaisControle(4 downto 3);
		 
alias habilita_A      : std_logic 
       is sinaisControle(5);
		 
alias selMUX      : std_logic 
       is sinaisControle(6);
		 
alias JEQ_Dec      : std_logic 
       is sinaisControle(7);

alias JSR_Dec      : std_logic 
       is sinaisControle(8);

alias RET_Dec      : std_logic 
       is sinaisControle(9);
		 
alias SelMUX_JMP    : std_logic 
		 is sinaisControle(10);
		 
alias habEscritaRet    : std_logic 
		 is sinaisControle(11);		 
		 
		 
begin
	habEscritaMEM <= '1' when opCode = STA else '0';
	habLeituraMEM <= '1' when opCode = LDA or opCode = CEQ or opCode = SOMA or opCode = SUB else '0';
	habFlagIgual  <= '1' when opCode = CEQ  else '0';
	operacao <= "00" when opCode = SUB or opCode = CEQ else 
					"01" when opCode = SOMA  else 
					"10" when opCode = LDI  else
					"11";
	habilita_A <= '1' when opCode = LDA or opCode = SOMA or opCode = SUB or opCode = LDI or opCode = CEQ else '0';
	selMUX <= '1' when opCode = LDI else '0';
	JEQ_Dec <= '1' when opCode = JEQ else '0';
	JSR_Dec <= '1' when opCode = JSR else '0';
	RET_Dec <= '1' when opCode = RET else '0';
	SelMUX_JMP <= '1' when opCode = JMP else '0';
	habEscritaRet <= '1' when opCode = JSR else '0';
		  
end architecture;
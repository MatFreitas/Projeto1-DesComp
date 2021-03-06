library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Projeto is
  generic   (
    DATA_WIDTH  : natural :=  8;
    ADDR_WIDTH  : natural :=  8;
	 larguraDados : natural := 8;
	 larguraAddRom : natural := 9;
	 simulacao : boolean := FALSE 
	
  );

  port   (
	 CLOCK_50 : in std_logic;
    KEY: in std_logic_vector(3 downto 0);
	 FPGA_RESET_N: in std_logic;
	 SW: in std_logic_vector(9 downto 0);
	 
	 re_out : out std_logic;
	 we_out : out std_logic;
	 
	 Habilita_RAM : out std_logic;
	 saida_Ram_Key1: out std_logic;
	 habilita_sw8_out : out std_logic;
	 saida_flipflop_key1: out std_logic;
	 
	 LEDR :  out std_logic_vector (9 downto 0);
	 HEX0 :  out  std_logic_vector(6 downto 0);
	 HEX1 :  out  std_logic_vector(6 downto 0);
	 HEX2 :  out  std_logic_vector(6 downto 0);
	 HEX3 :  out  std_logic_vector(6 downto 0);
	 HEX4 :  out  std_logic_vector(6 downto 0);
	 HEX5 :  out  std_logic_vector(6 downto 0);
	 
	 ULA_OUT :  out std_logic_vector(larguraDados-1 downto 0);
	 dataOUT :  out  std_logic_vector(DATA_WIDTH-1 downto 0);
	 PC_OUT  :   out std_logic_vector(larguraAddRom-1 downto 0)
	 
  );
end entity;


architecture arch_name of Projeto is

    signal Instrucao : std_logic_vector (14 downto 0);
	 signal CPU_ROM : std_logic_vector (8 downto 0);
	 signal RAM_CPU : std_logic_vector (7 downto 0);	 
	 signal RD_CPU_RAM: std_logic;
	 signal WR_CPU_RAM: std_logic;
	 signal DATA_CPU_RAM:  std_logic_vector (7 downto 0);
	 signal DATA_ADD: std_logic_vector (8 downto 0);
	 signal CLOCK_KEY0 : std_logic;
	 signal CLOCK_KEY1 : std_logic;
	 signal saida0_dec: std_logic;
	 signal saida1_dec: std_logic;
	 signal saida2_dec: std_logic;
	 signal saida3_dec: std_logic;
	 signal saida4_dec: std_logic;
	 signal saida5_dec: std_logic;
	 signal saida6_dec: std_logic;
	 signal saida7_dec: std_logic;
	 
	 
	 signal saida0_dec2: std_logic;
	 signal saida1_dec2: std_logic;
	 signal saida2_dec2: std_logic;
	 signal saida3_dec2: std_logic;
	 signal saida4_dec2: std_logic;
	 signal saida5_dec2: std_logic;
	 signal saida6_dec2: std_logic;
	 signal saida7_dec2: std_logic;
	 signal habilita_key0: std_logic;
	 signal habilita_key1: std_logic;
	 signal habilita_key2: std_logic;
	 signal habilita_key3: std_logic;
	 signal habilita_RESET: std_logic;
	 signal habilita_sw0_sw7: std_logic;
	 signal habilita_sw8: std_logic;
	 signal habilita_sw9: std_logic;
	 signal limpaLeitura_Key0: std_logic;
	 signal limpaLeitura_Key1: std_logic;
	 signal Saida_Debouncer_Tristate_Key0: std_logic;
	 signal Saida_Debouncer_Tristate_Key1: std_logic;
	 signal reg_out_hex0: std_logic_vector (3 downto 0);
	 signal reg_out_hex1: std_logic_vector (3 downto 0);
	 signal reg_out_hex2: std_logic_vector (3 downto 0);
	 signal reg_out_hex3: std_logic_vector (3 downto 0);
	 signal reg_out_hex4: std_logic_vector (3 downto 0);
	 signal reg_out_hex5: std_logic_vector (3 downto 0);

begin

gravar:  if simulacao generate

--CLOCK_KEY0 <= KEY(0);
--CLOCK_KEY1 <= KEY(1);
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => CLOCK_KEY0);

detectorSub1: work.edgeDetector(bordaSubida)
			port map (clk => CLOCK_50, entrada => (not KEY(1)), saida => CLOCK_KEY1);
			
end generate;




	CPU : entity work.CPU  generic map (larguraDados => larguraDados)
          port map (CLK=>CLOCK_50, INSTRUCAO_IN=> Instrucao,  ROM_ADD=> CPU_ROM, RAM_DADOS=> RAM_CPU, Escrita=> WR_CPU_RAM, Leitura=>RD_CPU_RAM, Saida_REG=>DATA_CPU_RAM, Data_Add=> DATA_ADD, Saida_ULA_out=> ULA_OUT);
			 
	DECODIFICADOR3X8_BLOCO : entity work.decodificador3x8 
          port map (E0=> DATA_ADD(6) , E1=> DATA_ADD(7), E2=> DATA_ADD(8), S0=>saida0_dec, S1=>saida1_dec, S2=>saida2_dec, S3=>saida3_dec, S4=>saida4_dec, S5=>saida5_dec, S6=>saida6_dec, S7=> saida7_dec );
			 
	DECODIFICADOR3X8_ENDERECO : entity work.decodificador3x8 
          port map (E0=> DATA_ADD(0) , E1=> DATA_ADD(1), E2=> DATA_ADD(2), S0=>saida0_dec2, S1=>saida1_dec2, S2=>saida2_dec2, S3=>saida3_dec2, S4=>saida4_dec2, S5=>saida5_dec2, S6=>saida6_dec2, S7=> saida7_dec2 );
	
	FF1 : entity work.registradorFlipFlopAnd
			 port map (DIN => DATA_CPU_RAM(0), escrita => WR_CPU_RAM, blocos => saida4_dec, enderecos=> saida2_dec2, entrada_not=> DATA_ADD(5), CLK => CLOCK_50, RST => '0', DOUT => LEDR(9));

	FF2 : entity work.registradorFlipFlopAnd
			 port map (DIN => DATA_CPU_RAM(0), escrita => WR_CPU_RAM, blocos => saida4_dec, enderecos=> saida1_dec2, entrada_not=> DATA_ADD(5), CLK => CLOCK_50, RST => '0', DOUT => LEDR(8));

	REG_LEDR : entity work.registradorGenericoAnd generic map (larguraDados => larguraDados)
			 port map (DIN => DATA_CPU_RAM, escrita => WR_CPU_RAM, blocos => saida4_dec, enderecos=> saida0_dec2, entrada_not=> DATA_ADD(5), CLK => CLOCK_50, RST => '0', DOUT => LEDR(7 downto 0));
	
	REG_HEX0 : entity work.registradorGenericoHex generic map (larguraDados => 4)
			 port map (DIN => DATA_CPU_RAM(3 downto 0), escrita => WR_CPU_RAM, blocos => saida4_dec, endereco=> saida0_dec2, endereco_de_dados=> DATA_ADD(5), CLK => CLOCK_50, RST => '0', DOUT => reg_out_hex0);
	
	REG_HEX1 : entity work.registradorGenericoHex generic map (larguraDados => 4)
			 port map (DIN => DATA_CPU_RAM(3 downto 0), escrita => WR_CPU_RAM, blocos => saida4_dec, endereco=> saida1_dec2, endereco_de_dados=> DATA_ADD(5), CLK => CLOCK_50, RST => '0', DOUT => reg_out_hex1);
			 
	REG_HEX2 : entity work.registradorGenericoHex generic map (larguraDados => 4)
			 port map (DIN => DATA_CPU_RAM(3 downto 0), escrita => WR_CPU_RAM, blocos => saida4_dec, endereco=> saida2_dec2, endereco_de_dados=> DATA_ADD(5), CLK => CLOCK_50, RST => '0', DOUT => reg_out_hex2);
	
	REG_HEX3 : entity work.registradorGenericoHex generic map (larguraDados => 4)
			 port map (DIN => DATA_CPU_RAM(3 downto 0), escrita => WR_CPU_RAM, blocos => saida4_dec, endereco=> saida3_dec2, endereco_de_dados=> DATA_ADD(5), CLK => CLOCK_50, RST => '0', DOUT => reg_out_hex3);
			 
	REG_HEX4 : entity work.registradorGenericoHex generic map (larguraDados => 4)
			 port map (DIN => DATA_CPU_RAM(3 downto 0), escrita => WR_CPU_RAM, blocos => saida4_dec, endereco=> saida4_dec2, endereco_de_dados=> DATA_ADD(5), CLK => CLOCK_50, RST => '0', DOUT => reg_out_hex4);
			 
	REG_HEX5 : entity work.registradorGenericoHex generic map (larguraDados => 4)
			 port map (DIN => DATA_CPU_RAM(3 downto 0), escrita => WR_CPU_RAM, blocos => saida4_dec, endereco=> saida5_dec2, endereco_de_dados=> DATA_ADD(5), CLK => CLOCK_50, RST => '0', DOUT => reg_out_hex5);
			 
	
	HEX0_OUT :  entity work.conversorHex7Seg
        port map(dadoHex => reg_out_hex0,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => HEX0);
					  
	HEX1_OUT :  entity work.conversorHex7Seg
        port map(dadoHex => reg_out_hex1,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => HEX1);
					  
	HEX2_OUT :  entity work.conversorHex7Seg
        port map(dadoHex => reg_out_hex2,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => HEX2);
					  
					  
	HEX3_OUT :  entity work.conversorHex7Seg
        port map(dadoHex => reg_out_hex3,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => HEX3);
					  
	HEX4_OUT :  entity work.conversorHex7Seg
        port map(dadoHex => reg_out_hex4,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => HEX4);
					  
	HEX5_OUT :  entity work.conversorHex7Seg
        port map(dadoHex => reg_out_hex5,
                 apaga =>  '0',
                 negativo => '0',
                 overFlow =>  '0',
                 saida7seg => HEX5);
	
	ROM1 : entity work.memoriaROM   
				 port map (Endereco => CPU_ROM, Dado => Instrucao);
				 
	RAM1 : entity work.memoriaRAM   generic map (dataWidth => 8, addrWidth => 6)
				 port map (addr => DATA_ADD(5 downto 0),habilita => saida0_dec, we => WR_CPU_RAM, re => RD_CPU_RAM, dado_in => DATA_CPU_RAM, dado_out => RAM_CPU, clk => CLOCK_50);

	
	TRISTATE_KEY0 : entity work.triState   generic map (dataWidth => 1)
				 port map (entrada =>Saida_Debouncer_Tristate_Key0, habilita => habilita_key0, saida =>RAM_CPU(0)  );
				 
	TRISTATE_KEY1 : entity work.triState   generic map (dataWidth => 1)
				 port map (entrada =>Saida_Debouncer_Tristate_Key1, habilita => habilita_key1, saida =>RAM_CPU(0)  );
				 
	TRISTATE_KEY2 : entity work.triState   generic map (dataWidth => 1)
				 port map (entrada =>KEY(2), habilita => habilita_key2, saida =>RAM_CPU(0)  );
				 
	TRISTATE_KEY3 : entity work.triState   generic map (dataWidth => 1)
				 port map (entrada =>KEY(3), habilita => habilita_key3, saida =>RAM_CPU(0)  );
				 
	TRISTATE_KEY4 : entity work.triState   generic map (dataWidth => 1)
				 port map (entrada =>FPGA_RESET_N, habilita => habilita_RESET, saida =>RAM_CPU(0)  );
				 
	TRISTATE_SW0_SW7 : entity work.triStateVector   generic map (dataWidth => 8)
				 port map (entrada =>SW(7 downto 0), habilita => habilita_sw0_sw7, saida =>RAM_CPU  );
	
	TRISTATE_SW8 : entity work.triState   generic map (dataWidth => 1)
				 port map (entrada =>SW(8), habilita => habilita_Sw8, saida =>RAM_CPU(0)  );
				 
	TRISTATE_SW9 : entity work.triState   generic map (dataWidth => 1)
				 port map (entrada =>SW(9), habilita => habilita_Sw9, saida =>RAM_CPU(0)  );
		 
	FF_KEY0 : entity work.registradorFlipFlop   generic map (larguraDados => 1)
          port map (DIN => '1', DOUT => Saida_Debouncer_Tristate_Key0, ENABLE => '1', CLK => CLOCK_KEY0, RST => limpaLeitura_Key0);
			 
	 
	FF_KEY1 : entity work.registradorFlipFlop   generic map (larguraDados => 1)
          port map (DIN => '1', DOUT => Saida_Debouncer_Tristate_Key1, ENABLE => '1', CLK => CLOCK_KEY1, RST => limpaLeitura_Key1);
				 
	
	habilita_key0 <= saida5_dec and saida0_dec2 and RD_CPU_RAM and DATA_ADD(5);
	habilita_key1 <= saida5_dec and saida1_dec2 and RD_CPU_RAM and DATA_ADD(5);
	habilita_key2 <= saida5_dec and saida2_dec2 and RD_CPU_RAM and DATA_ADD(5);
	habilita_key3 <= saida5_dec and saida3_dec2 and RD_CPU_RAM and DATA_ADD(5);
	habilita_RESET <= saida5_dec and saida4_dec2 and RD_CPU_RAM and DATA_ADD(5);
	
	habilita_sw0_sw7 <= saida5_dec and saida0_dec2 and RD_CPU_RAM and not(DATA_ADD(5));
	habilita_sw8 <= saida5_dec and saida1_dec2 and RD_CPU_RAM and not(DATA_ADD(5));
	habilita_sw9 <= saida5_dec and saida2_dec2 and RD_CPU_RAM and not(DATA_ADD(5));
	
	
	
	dataOUT      <= DATA_CPU_RAM;
	Habilita_RAM <= saida0_dec;
	PC_OUT       <= CPU_ROM;
	re_out       <= RD_CPU_RAM;
	we_out       <= WR_CPU_RAM;
	
	saida_flipflop_key1 <= Saida_Debouncer_Tristate_Key1;
	
	habilita_sw8_out <= habilita_sw8;
	
	limpaLeitura_Key0 <= DATA_ADD(0) and DATA_ADD(1) and DATA_ADD(2) and DATA_ADD(3) and DATA_ADD(4) and DATA_ADD(5) and DATA_ADD(6) and DATA_ADD(7) and DATA_ADD(8);

	limpaLeitura_Key1 <= not (DATA_ADD(0)) and DATA_ADD(1) and DATA_ADD(2) and DATA_ADD(3) and DATA_ADD(4) and DATA_ADD(5) and DATA_ADD(6) and DATA_ADD(7) and DATA_ADD(8);

end architecture;
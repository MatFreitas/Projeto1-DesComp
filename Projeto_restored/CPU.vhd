library ieee;
use ieee.std_logic_1164.all;

entity CPU is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8;
				larguraAddRom : natural := 9;
				larguraDadosRom : natural := 13;
        simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLK : in std_logic;
	 INSTRUCAO_IN: in std_logic_vector (12 downto 0);
	 RAM_DADOS: in  std_logic_vector (7 downto 0);
--    KEY: in std_logic_vector(3 downto 0);
--	 
--	 Barramento_Enderecos: out std_logic_vector(8 downto 0);
--	 Barramento_Dados: out std_logic_vector(larguraDados-1 downto 0);
--	 Saida_Acumulador: out std_logic_vector (larguraDados-1 downto 0);
--	 saidaMUX: out std_logic_vector (larguraAddRom-1 downto 0);
--	 flagIgual: out std_logic
	 ROM_ADD :out  std_logic_vector (larguraAddRom-1 downto 0);
	 Escrita : out std_logic;
    Leitura : out std_logic;
	 Saida_REG: out std_logic_vector (larguraDados-1 downto 0);
	 Data_Add: out std_logic_vector (8 downto 0);
	 Saida_ULA_out : out std_logic_vector (larguraDados-1 downto 0)

  );
end entity;


architecture arquitetura of CPU is

-- Faltam alguns sinais:
  signal chavesX_ULA_B : std_logic_vector (larguraDados-1 downto 0);
  
  signal REG1_ULA_A : std_logic_vector (larguraDados-1 downto 0);
  signal Saida_ULA : std_logic_vector (larguraDados-1 downto 0);
  signal Sinais_Controle : std_logic_vector (11 downto 0);
  signal PC_ROM : std_logic_vector (larguraAddRom-1 downto 0);
  signal Somador_PC : std_logic_vector (larguraAddRom-1 downto 0);
  signal End_Ret: std_logic_vector (larguraAddRom-1 downto 0);
--  signal CLK : std_logic;
  signal SelMUX : std_logic;
  signal SelMUX_JMP : std_logic;
  signal Habilita_A : std_logic;
  signal Reset_A : std_logic;
  signal Flag_Dec : std_logic;
  signal Operacao_ULA : std_logic_vector (1 downto 0);
  signal SomadorMUX_JMP : std_logic_vector (8 downto 0);
  signal ULA_Flag : std_logic;
--  signal opCode_DEC : std_logic_vector (3 downto 0);

  signal Instrucao : std_logic_vector (12 downto 0);
  signal MUX_ULA_B : std_logic_vector (larguraDados-1 downto 0);
  signal Saida_Dados : std_logic_vector (larguraDados-1 downto 0);
  signal habEscrita : std_logic;
  signal habLeitura : std_logic;
  signal habFlagIgual : std_logic; 
  signal JEQ : std_logic;
  signal JSR : std_logic;
  signal RET : std_logic;
  signal habEscritaRet : std_logic;
  signal Saida_LD : std_logic_vector (1 downto 0);
  

begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
--gravar:  if simulacao generate
--CLK <= KEY(0);
--else generate
--detectorSub0: work.edgeDetector(bordaSubida)
--        port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => CLK);
--end generate;

-- O port map completo do MUX.
MUX1 :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => Saida_Dados, 
                 entradaB_MUX =>  Instrucao(7 downto 0),
                 seletor_MUX => SelMUX,
                 saida_MUX => MUX_ULA_B);

-- O port map completo do Acumulador.
REG1 : entity work.registradorGenerico   generic map (larguraDados => larguraDados)
          port map (DIN => Saida_ULA, DOUT => REG1_ULA_A, ENABLE => Habilita_A, CLK => CLK, RST => '0');

PC : entity work.registradorGenerico   generic map (larguraDados => larguraAddRom)
          port map (DIN => Somador_PC, DOUT => PC_ROM, ENABLE => '1', CLK => CLK, RST => '0');
			 
SOMADOR :  entity work.somaConstante  generic map (larguraDados => larguraAddRom, constante => 1)
        port map( entrada => PC_ROM, saida => SomadorMUX_JMP);
			 
-- O port map completo da ULA:
ULA1 : entity work.ULASomaSub  generic map(larguraDados => larguraDados)
          port map (entradaA => REG1_ULA_A, entradaB => MUX_ULA_B, saida => Saida_ULA, seletor => Operacao_ULA, flagCompara => ULA_Flag);

---- Falta acertar o conteudo da ROM (no arquivo memoriaROM.vhd)
--ROM1 : entity work.memoriaROM   generic map (dataWidth => larguraDadosRom, addrWidth => larguraAddRom)
--          port map (Endereco => PC_ROM, Dado => Instrucao);
--			 
--RAM1 : entity work.memoriaRAM   generic map (dataWidth => 8, addrWidth => 8)
--          port map (addr => Instrucao(7 downto 0),habilita => Instrucao(8), we => habEscrita, re => habLeitura, dado_in => REG1_ULA_A, dado_out => Saida_Dados, clk => CLK);

DEC : entity work.decodificador 	generic map (opCode_WIDTH => 4, sinaisControle_WIDTH => 12)	
			 port map (opCode => Instrucao(12 downto 9), sinaisControle => Sinais_Controle);
			 
MUX2 :  entity work.muxGenerico3x1  generic map (larguraDados => larguraDados + 1)
        port map( entradaA_MUX => SomadorMUX_JMP, 
                 entradaB_MUX =>  Instrucao(8 downto 0),
					  entradaC_MUX=>  End_Ret,
					  entradaD_MUX=> "000000000",
                 seletor_MUX => Saida_LD , 
                 saida_MUX => Somador_PC);

REG_FLAG : entity work.registradorFlipFlop   generic map (larguraDados => 1)
          port map (DIN => ULA_Flag, DOUT => Flag_Dec, ENABLE => habFlagIgual, CLK => CLK, RST => '0');			


REG_RET : entity work.registradorGenerico   generic map (larguraDados => 9)
          port map (DIN => SomadorMUX_JMP, DOUT =>  End_Ret, ENABLE => habEscritaRet, CLK => CLK, RST => '0');			 

LOG_DES : entity work.logicaDesvio generic map (mux_WIDTH=> 2)			
			port map (JMP_LD => selMUX_JMP, RET_LD => RET ,JSR_LD => JSR, JEQ_LD => JEQ, flag_LD => Flag_Dec, MUX_LD => Saida_LD);			
			

habEscritaRet <= Sinais_Controle(11);			
selMUX_JMP <= Sinais_Controle(10);
RET <= Sinais_Controle(9);
JSR <= Sinais_Controle(8);
JEQ <= Sinais_Controle(7);		 
SelMUX <= Sinais_Controle(6);
Habilita_A <= Sinais_Controle(5);
Operacao_ULA <= Sinais_Controle(4 downto 3);
habFlagIgual <= Sinais_Controle(2);
habLeitura <= Sinais_Controle(1);
habEscrita <= Sinais_Controle(0);
Saida_Dados <= RAM_DADOS;

Instrucao<= INSTRUCAO_IN;
Escrita<=habEscrita;
Leitura<= habLeitura;
ROM_ADD<= PC_ROM;
Saida_REG <= REG1_ULA_A;
Data_Add <= Instrucao(8 downto 0);

Saida_ULA_out <= Saida_ULA;

--Saida_Acumulador <= REG1_ULA_A;
--Barramento_Dados <= REG1_ULA_A;
--Barramento_Enderecos <= Instrucao(8 downto 0);
--saidaMUX <=  Somador_PC;
--flagIgual <= Flag_Dec;



end architecture;
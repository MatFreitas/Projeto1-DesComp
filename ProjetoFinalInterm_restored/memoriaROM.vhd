library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 15;
          addrWidth: natural := 9;
			 opCode_WIDTH: natural := 4
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

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
	 

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
		
        -- MEM[6] guarda valor 1 (incremento e comparação)
        -- MEM[7] guarda valor 10 (limite por display ) 
        -- MEM[8] guarda valor 0 (comparação)
        -- MEM[9] guarda valor 0 (flag inibir contagem)
        -- MEM[10] guarda valor 0 (overflow)
        -- MEM[11] guarda limite contagem unidades
        -- MEM[12] guarda limite contagem dezenas
        -- MEM[13] guarda limite contagem centenas
        -- MEM[14] guarda limite contagem milhares
        -- MEM[15] guarda limite contagem dezenas de milhares
        -- MEM[16] guarda limite contagem centenas de milhares
		
        -- Setup
        tmp(0)  := LDI & "00" & '0' & x"01"; -- LDI 0
        tmp(1)  := STA & "00" & '1' & x"20"; -- STA 288	(HEX 0)
    	tmp(2)  := STA & "00" & '1' & x"21"; -- STA 289 (HEX 1)
        tmp(3)  := STA & "00" & '1' & x"22"; -- STA 290 (HEX 2)
        tmp(4)  := STA & "00" & '1' & x"23"; -- STA 291 (HEX 3)
        tmp(5)  := STA & "00" & '1' & x"24"; -- STA 292 (HEX 4) 
        tmp(6)  := STA & "00" & '1' & x"25"; -- STA 293 (HEX 5)
        tmp(7)  := STA & "00" & '1' & x"00"; -- STA 256 (LEDR0~LEDR7)
        tmp(8)  := STA & "00" & '1' & x"01"; -- STA 257 (LEDR8)
        tmp(9)  := STA & "00" & '1' & x"02"; -- STA 258 (LEDR9)
        tmp(10) := STA & "00" & '0' & x"00"; -- STA 0 (MEM[0]) -- unidades
        tmp(11) := STA & "00" & '0' & x"01"; -- STA 1 (MEM[1]) -- dezenas
        tmp(12) := STA & "00" & '0' & x"02"; -- STA 2 (MEM[2]) -- centenas
        tmp(13) := STA & "00" & '0' & x"03"; -- STA 3 (MEM[3]) -- milhares
        tmp(14) := STA & "00" & '0' & x"04"; -- STA 4 (MEM[4]) -- dezenas de milhares
        tmp(15) := STA & "00" & '0' & x"05"; -- STA 5 (MEM[5]) -- centenas de milhares        
        tmp(16) := LDI & "00" & '0' & x"01"; -- LDI 1
        tmp(17) := STA & "00" & '0' & x"06"; -- STA 6 (MEM[6])
        tmp(18) := LDI & "00" & '0' & x"0A"; -- LDI 10
        tmp(19) := STA & "00" & '0' & x"07"; -- STA 7 (MEM[7])
        tmp(20) := LDI & "00" & '0' & x"00"; -- LDI 0
        tmp(21) := STA & "00" & '0' & x"08"; -- STA 8 (MEM[8])  
        tmp(22) := STA & "00" & '0' & x"09"; -- STA 9 (MEM[9])  
        tmp(23) := STA & "00" & '0' & x"0A"; -- STA 10 (MEM[10])

        tmp(24) := STA & "00" & '0' & x"0B"; -- STA 11 (MEM[11])
        tmp(25) := STA & "00" & '0' & x"0C"; -- STA 12 (MEM[12])
        tmp(26) := STA & "00" & '0' & x"0D"; -- STA 13 (MEM[13])
        tmp(27) := STA & "00" & '0' & x"0E"; -- STA 14 (MEM[14])
        tmp(28) := STA & "00" & '0' & x"0F"; -- STA 15 (MEM[15])
        tmp(29) := STA & "00" & '0' & x"10"; -- STA 16 (MEM[10])
		  
--		  tmp(30) := STA & "00" & '1' & x"FF"; -- STA 511
--        tmp(31) := LDA & "00" & '1' & x"60"; -- LDA 352	
--        tmp(32) := CEQ & "00" & '0' & x"08"; -- CEQ 8	
--        tmp(33) := JEQ & "00" & '0' & x"26"; -- JEQ 38	
--		  tmp(34) := JSR & "00" & '0' & x"35"; -- JSR  53 (subrotina escrever valores)
--		  tmp(35) := NOP & "00" & '0' & x"00"; -- NOP
--		  tmp(36) := JSR & "00" & '0' & x"71"; -- JSR 113 (subrotina escrever valores)
--		  tmp(37) := NOP & "00" & '0' & x"00"; -- NOP
--		  
----		  tmp(38)  := LDA & "00" & '1' & x"64"; -- LDA 356	
----        tmp(39)  := CEQ & "00" & '0' & x"06"; -- CEQ 6	
----        tmp(40)  := JEQ & "00" & '0' & x"2D"; -- JEQ 45
----		  tmp(41) := JSR & "00" & '0' & x"C7"; -- JSR 199 (subrotina escrever valores)
----		  tmp(42) := NOP & "00" & '0' & x"00"; -- NOP
----		  tmp(43) := JSR & "00" & '0' & x"71"; -- JSR 113 (subrotina escrever valores)
----		  tmp(44) := NOP & "00" & '0' & x"00"; -- NOP
--		  
--		  tmp(38) := LDI & "00" & '0' & x"00"; -- LDI 0
--		  tmp(39) := STA & "00" & '1' & x"FE"; -- STA 510
--		  tmp(40) := LDA & "00" & '1' & x"61"; -- LDA 353	
--        tmp(41) := CEQ & "00" & '0' & x"08"; -- CEQ 8	
--        tmp(42) := JEQ & "00" & '0' & x"2D"; -- JEQ 45
--		  tmp(43) := JSR & "00" & '0' & x"7E"; -- JSR 126 (subrotina escrever LIMITE)
--		  tmp(44) := NOP & "00" & '0' & x"00"; -- NOP
--		  tmp(45) := JSR & "00" & '0' & x"A9"; -- JSR 169 (Verificar se o limite de contagem foi alcançado)
--        tmp(46) := NOP & "00" & '0' & x"00"; -- NOP
--		  
--		  tmp(47) := JMP & "00" & '0' & x"1E"; -- JMP 30 Desviar para o **INÍCIO**.
		

        -- Loop
        -- INÍCIO:
		  tmp(30)  := LDA & "00" & '1' & x"60"; -- LDA 352
        tmp(31)  := STA & "00" & '1' & x"FF"; -- STA 511
        tmp(32)  := CEQ & "00" & '0' & x"08"; -- CEQ 8	
        tmp(33)  := JEQ & "00" & '0' & x"24"; -- JEQ 36	
        tmp(34)  := JSR & "00" & '0' & x"35"; -- JSR 53 (subrotina incremento valor)	
        tmp(35)  := NOP & "00" & '0' & x"00"; -- NOP
        tmp(36)  := JSR & "00" & '0' & x"71"; -- JSR 113 (subrotina escrever valores)
        tmp(37)  := NOP & "00" & '0' & x"00"; -- NOP
        

		  tmp(38)  := LDA & "00" & '1' & x"61"; -- LDA 353
        tmp(39)  := STA & "00" & '1' & x"FE"; -- STA 510
        tmp(40)  := CEQ & "00" & '0' & x"08"; -- CEQ 8	
        tmp(41)  := JEQ & "00" & '0' & x"2C"; -- JEQ 44
        tmp(42)  := JSR & "00" & '0' & x"7E"; -- JSR 126 (configuração do limite de incremento)	
        tmp(43)  := NOP & "00" & '0' & x"00"; -- NOP
        tmp(44)  := JSR & "00" & '0' & x"A9"; -- JSR 169 (Verificar se o limite de contagem foi alcançado)
        tmp(45)  := NOP & "00" & '0' & x"00"; -- NOP



        tmp(46)  := STA & "00" & '1' & x"FF"; -- STA 511
        tmp(47)  := LDA & "00" & '1' & x"64"; -- LDA 356
        tmp(48)  := CEQ & "00" & '0' & x"08"; -- CEQ 8	
        tmp(49)  := JEQ & "00" & '0' & x"34"; -- JEQ 52
        tmp(50)  := JSR & "00" & '0' & x"C7"; -- JSR 199 (desviar para a sub-rotina de reiniciar contagem)	
        tmp(51)  := NOP & "00" & '0' & x"00"; -- NOP
        tmp(52)  := JMP & "00" & '0' & x"1E"; -- JMP 30 Desviar para o **INÍCIO**.
      
        
        -- Subrotina incremento valor...
        tmp(53)  := LDA & "00" & '0' & x"09"; -- LDA 9
        tmp(54)  := CEQ & "00" & '0' & x"08"; -- CEQ 8
        tmp(55)  := JEQ & "00" & '0' & x"39"; -- JEQ 57
        tmp(56)  := RET & "00" & '0' & x"00"; -- RET
        tmp(57)  := LDA & "00" & '0' & x"00"; -- LDA MEM[0]
        tmp(58)  := SOMA & "00" & '0' & x"06"; -- SOMA 6 (Incrementa)
		  tmp(59)  := STA & "00" & '0' & x"00"; -- STA MEM[0]
		  
--
        -- Compara unidade com dez
        tmp(60)  := CEQ & "00" & '0' & x"07"; -- CEQ 7 (Compara com dez)
        tmp(61)  := JEQ & "00" & '0' & x"3F"; -- JEQ 63
        tmp(62)  := RET & "00" & '0' & x"00"; -- RET
        tmp(63)  := LDI & "00" & '0' & x"00"; -- LDI 0
        tmp(64)  := STA & "00" & '0' & x"00"; -- STA 0 (Escreve zero nas unidades)
        tmp(65)  := LDA & "00" & '0' & x"01"; -- LDA 1 (Pega o valor das dezenas)
        tmp(66)  := SOMA & "00" & '0' & x"06"; -- SOMA 6 (Incrementa)
        tmp(67)  := STA & "00" & '0' & x"01"; -- STA 1 (Escreve valor nas dezenas)
        
        -- Compara dezena com dez
        tmp(68)  := CEQ & "00" & '0' & x"07"; -- CEQ 7 (Compara com dez)
        tmp(69)  := JEQ & "00" & '0' & x"48"; -- JEQ 72
        tmp(70) := NOP & "00" & '0' & x"00"; -- NOP
        tmp(71)  := RET & "00" & '0' & x"00"; -- RET
        tmp(72)  := LDI & "00" & '0' & x"00"; -- LDI 0
        tmp(73)  := STA & "00" & '0' & x"01"; -- STA 1 (Escreve zero nas dezenas)
        tmp(74)  := LDA & "00" & '0' & x"02"; -- LDA 2 (Pega o valor das centenas)
        tmp(75)  := SOMA & "00" & '0' & x"06"; -- SOMA 6 (Incrementa)
        tmp(76)  := STA & "00" & '0' & x"02"; -- STA 2 (Escreve valor nas centenas)

        -- Compara centena com dez
        tmp(77)  := CEQ & "00" & '0' & x"07"; -- CEQ 7 (Compara com dez)
        tmp(78)  := JEQ & "00" & '0' & x"51"; -- JEQ 81
        tmp(79) := NOP & "00" & '0' & x"00"; -- NOP
        tmp(80)  := RET & "00" & '0' & x"00"; -- RET
        tmp(81)  := LDI & "00" & '0' & x"00"; -- LDI 0
        tmp(82)  := STA & "00" & '0' & x"02"; -- STA 2 (Escreve zero nas centenas)
        tmp(83)  := LDA & "00" & '0' & x"03"; -- LDA 3 (Pega o valor das milhares)
        tmp(84)  := SOMA & "00" & '0' & x"06"; -- SOMA 6 (Incrementa)
        tmp(85)  := STA & "00" & '0' & x"03"; -- STA 3 (Escreve valor nas milhares)

        -- Compara milhares com dez
        tmp(86)  := CEQ & "00" & '0' & x"07"; -- CEQ 7 (Compara com dez)
        tmp(87)  := JEQ & "00" & '0' & x"5A"; -- JEQ 90
        tmp(88) := NOP & "00" & '0' & x"00"; -- NOP
        tmp(89)  := RET & "00" & '0' & x"00"; -- RET
        tmp(90)  := LDI & "00" & '0' & x"00"; -- LDI 0
        tmp(91)  := STA & "00" & '0' & x"03"; -- STA 3 (Escreve zero nas milhares)
        tmp(92)  := LDA & "00" & '0' & x"04"; -- LDA 4 (Pega o valor das dezenas milhares)
        tmp(93)  := SOMA & "00" & '0' & x"06"; -- SOMA 6 (Incrementa)
        tmp(94)  := STA & "00" & '0' & x"04"; -- STA 4 (Escreve valor nas dezenas milhares)

        -- Compara dezenas de milhares com dez
        tmp(95)  := CEQ & "00" & '0' & x"07"; -- CEQ 7 (Compara com dez)
        tmp(96)  := JEQ & "00" & '0' & x"63"; -- JEQ 99
        tmp(97) := NOP & "00" & '0' & x"00"; -- NOP
        tmp(98)  := RET & "00" & '0' & x"00"; -- RET
        tmp(99)  := LDI & "00" & '0' & x"00"; -- LDI 0
        tmp(100)  := STA & "00" & '0' & x"04"; -- STA 4 (Escreve zero nas dezenas de milhares)
        tmp(101)  := LDA & "00" & '0' & x"05"; -- LDA 5 (Pega o valor das centenas milhares)
        tmp(102)  := SOMA & "00" & '0' & x"06"; -- SOMA 6 (Incrementa)
        tmp(103) := STA & "00" & '0' & x"05"; -- STA 5 (Escreve valor nas centenas milhares)

        -- Compara centenas de milhares com dez
        tmp(104)  := CEQ & "00" & '0' & x"07"; -- CEQ 7 (Compara com dez)
        tmp(105)  := JEQ & "00" & '0' & x"6C"; -- JEQ 108
        tmp(106) := NOP & "00" & '0' & x"00"; -- NOP
        tmp(107)  := RET & "00" & '0' & x"00"; -- RET
        tmp(108)  := LDI & "00" & '0' & x"01"; -- LDI 1
        tmp(109)  := STA & "00" & '0' & x"09"; -- STA 9 (Escreve zero na flag)
        tmp(110)  := STA & "00" & '0' & x"0A"; -- STA 10 (liga o overflow)
        tmp(111)  := RET & "00" & '0' & x"00"; -- RET
        tmp(112)  := NOP & "00" & '0' & x"00"; -- NOP


        
        -- Subrotina escrever nos displays...
        --HEX0
        tmp(113)  := LDA & "00" & '0' & x"00"; -- LDA 0
        tmp(114)  := STA & "00" & '1' & x"20"; -- STA 288
        --HEX1
        tmp(115)  := LDA & "00" & '0' & x"01"; -- LDA 1
        tmp(116)  := STA & "00" & '1' & x"21"; -- STA 289
        --HEX2
        tmp(117)  := LDA & "00" & '0' & x"02"; -- LDA 2
        tmp(118)  := STA & "00" & '1' & x"22"; -- STA 290
        --HEX3
        tmp(119)  := LDA & "00" & '0' & x"03"; -- LDA 3
        tmp(120)  := STA & "00" & '1' & x"23"; -- STA 291        
        --HEX4
        tmp(121)  := LDA & "00" & '0' & x"04"; -- LDA 4
        tmp(122)  := STA & "00" & '1' & x"24"; -- STA 292
        --HEX5
        tmp(123)  := LDA & "00" & '0' & x"05"; -- LDA 5
        tmp(124)  := STA & "00" & '1' & x"25"; -- STA 293
    
        tmp(125)  := RET & "00" & '0' & x"00"; -- RET 30
        




        -- Subrotina limite incremento... NAO ESQUECER O RET 
        -- UNIDADE
		  tmp(126)  := LDI & "00" & '0' & x"01"; -- LDI 1
        tmp(127)  := STA & "00" & '1' & x"00"; -- STA 256 (LEDR0~LEDR7)
		  
        tmp(128)  := LDA & "00" & '1' & x"40"; --LDA 320
        tmp(129)  := STA & "00" & '0' & x"0B"; --STA 11 
        --Aguarda o pressionamento de KEY1

        tmp(130)  := STA & "00" & '1' & x"FF"; -- STA 510
        tmp(131)  := LDA & "00" & '1' & x"61"; --LDA 353 
        tmp(132)  := CEQ & "00" & '0' & x"0B"; --CEQ 8
        tmp(133)  := JEQ & "00" & '0' & x"83"; --JEQ 131

        --DEZENA
        tmp(134)  := LDA & "00" & '1' & x"40"; --LDA 320
        tmp(135)  := STA & "00" & '0' & x"0C"; --STA 12 
        --Aguarda o pressionamento de KEY1

        tmp(136)  := STA & "00" & '1' & x"FF"; -- STA 511
        tmp(137)  := LDA & "00" & '1' & x"61"; --LDA 353 
        tmp(138)  := CEQ & "00" & '0' & x"0B"; --CEQ 8
        tmp(139)  := JEQ & "00" & '0' & x"89"; --JEQ 137
        
        --CENTENA
        tmp(140)  := LDA & "00" & '1' & x"40"; --LDA 320
        tmp(141)  := STA & "00" & '0' & x"0D"; --STA 13 
        --Aguarda o pressionamento de KEY1

        tmp(142)  := STA & "00" & '1' & x"FE"; -- STA 510
        tmp(143)  := LDA & "00" & '1' & x"61"; --LDA 353 
        tmp(144)  := CEQ & "00" & '0' & x"0B"; --CEQ 8
        tmp(145)  := JEQ & "00" & '0' & x"8F"; --JEQ 143

        --MILHARES
        tmp(146)  := LDA & "00" & '1' & x"40"; --LDA 320
        tmp(147)  := STA & "00" & '0' & x"0E"; --STA 14 
        --Aguarda o pressionamento de KEY1

        tmp(148)  := STA & "00" & '1' & x"FE"; -- STA 510
        tmp(149)  := LDA & "00" & '1' & x"61"; --LDA 353 
        tmp(150)  := CEQ & "00" & '0' & x"0B"; --CEQ 8
        tmp(151)  := JEQ & "00" & '0' & x"95"; --JEQ 149

        -- DEZENA DE MILHARES
        tmp(152)  := LDA & "00" & '1' & x"40"; --LDA 320
        tmp(153)  := STA & "00" & '0' & x"0F"; --STA 15 
        --Aguarda o pressionamento de KEY1

        tmp(154)  := STA & "00" & '1' & x"FE"; -- STA 510
        tmp(155)  := LDA & "00" & '1' & x"61"; --LDA 353 
        tmp(156)  := CEQ & "00" & '0' & x"0B"; --CEQ 8
        tmp(157)  := JEQ & "00" & '0' & x"9B"; --JEQ 155

        -- CENTENA DE MILHARES
        tmp(158)  := LDA & "00" & '1' & x"40"; --LDA 320
        tmp(159)  := STA & "00" & '0' & x"0F"; --STA 16 
        --Aguarda o pressionamento de KEY1

        tmp(160)  := STA & "00" & '1' & x"FE"; -- STA 510
        tmp(161)  := LDA & "00" & '1' & x"61"; --LDA 353 
        tmp(162)  := CEQ & "00" & '0' & x"0B"; --CEQ 8
        tmp(163)  := JEQ & "00" & '0' & x"A1"; --JEQ 161
		  tmp(164)  := LDI & "00" & '0' & x"00"; -- LDI 0
        tmp(165)  := STA & "00" & '1' & x"00"; -- STA 256 (LEDR0~LEDR7)
        tmp(166)  := RET & "00" & '0' & x"00"; -- RET
		  
        tmp(167)  := NOP & "00" & '0' & x"00"; -- NOP
        tmp(168)  := NOP & "00" & '0' & x"00"; -- NOP



--        -- Subrotina limite alcançado... NAO ESQUECER O RET 
--        -- Unidades
        tmp(169)  := LDA & "00" & '0' & x"00"; --LDA 0
        tmp(170)  := CEQ & "00" & '0' & x"0B"; --CEQ 11
        tmp(171)  := JEQ & "00" & '0' & x"AD"; --JEQ 173
        tmp(172)  := RET & "00" & '0' & x"00"; --RET
        --Dezenas
        tmp(173)  := LDA & "00" & '0' & x"01"; --LDA 1
        tmp(174)  := CEQ & "00" & '0' & x"0C"; --CEQ 12
        tmp(175)  := JEQ & "00" & '0' & x"B1"; --JEQ 177
        tmp(176)  := RET & "00" & '0' & x"00"; --RET
        --Centenas
        tmp(177)  := LDA & "00" & '0' & x"02"; --LDA 2
        tmp(178)  := CEQ & "00" & '0' & x"0D"; --CEQ 13
        tmp(179)  := JEQ & "00" & '0' & x"B5"; --JEQ 181
        tmp(180)  := RET & "00" & '0' & x"00"; --RET
        --Milhares
        tmp(181)  := LDA & "00" & '0' & x"03"; --LDA 3
        tmp(182)  := CEQ & "00" & '0' & x"0E"; --CEQ 14
        tmp(183)  := JEQ & "00" & '0' & x"B9"; --JEQ 185
        tmp(184)  := RET & "00" & '0' & x"00"; --RET
        --Dezenas de Milhares
        tmp(185)  := LDA & "00" & '0' & x"04"; --LDA 4
        tmp(186)  := CEQ & "00" & '0' & x"0F"; --CEQ 15
        tmp(187)  := JEQ & "00" & '0' & x"BD"; --JEQ 189
        tmp(188)  := RET & "00" & '0' & x"00"; --RET
        --Centenas de Milhares
        tmp(189)  := LDA & "00" & '0' & x"05"; --LDA 5
        tmp(190)  := CEQ & "00" & '0' & x"10"; --CEQ 16
        tmp(191)  := JEQ & "00" & '0' & x"C1"; --JEQ 193
        tmp(192)  := RET & "00" & '0' & x"00"; --RET

        tmp(193)  := LDI & "00" & '0' & x"01"; --LDI 1
        tmp(194)  := STA & "00" & '0' & x"09"; --STA 9
        tmp(195)  := STA & "00" & '1' & x"01"; --STA 257
        tmp(196)  := RET & "00" & '0' & x"00"; --RET
        
        tmp(197)  := NOP & "00" & '0' & x"00"; -- NOP
        tmp(198)  := NOP & "00" & '0' & x"00"; -- NOP
--
--
--
--        -- desviar para a sub-rotina de reiniciar contagem
        tmp(199)  := LDI & "00" & '0' & x"00"; -- LDI 0 
        tmp(200)  := STA & "00" & '0' & x"00"; -- STA 0 (contagem unidades)
        tmp(201)  := STA & "00" & '0' & x"01"; -- STA 1 (contagem dezenas)
        tmp(202)  := STA & "00" & '0' & x"02"; -- STA 2 (contagem centenas)
        tmp(203)  := STA & "00" & '0' & x"03"; -- STA 3 (contagem milhares)
        tmp(204)  := STA & "00" & '0' & x"04"; -- STA 4 (contagem dezenas de milhares)
        tmp(205)  := STA & "00" & '0' & x"05"; -- STA 5 (contagem centenas de milhares)
        tmp(206)  := STA & "00" & '0' & x"09"; -- STA 9 (flag inibir contagem)
        tmp(207)  := STA & "00" & '1' & x"01"; -- STA 257 (LED)
        tmp(208)  := STA & "00" & '1' & x"02"; -- STA 258 (LED)
        tmp(209)  := RET & "00" & '0' & x"00"; -- RET  





		  
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;
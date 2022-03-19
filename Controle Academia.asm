
;CodeVisionAVR C Compiler V3.46a 
;(C) Copyright 1998-2021 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 14,745600 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _keys=R4
	.DEF _keys_msb=R5
	.DEF _flag0=R7
	.DEF _rx_wr_index=R6
	.DEF _rx_rd_index=R9
	.DEF _rx_counter=R8
	.DEF _tx_wr_index=R11
	.DEF _tx_rd_index=R10
	.DEF _tx_counter=R13
	.DEF __lcd_x=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x3:
	.DB  0x14
_0x4:
	.DB  0x80
_0x22:
	.DB  0x0,0x0,0x0,0x0,0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x32,0x30,0x31
	.DB  0x37,0x36,0x39,0x30,0x32,0x34,0x0,0x41
	.DB  0x6C,0x75,0x6E,0x6F,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x45,0x78,0x70,0x65,0x72
	.DB  0x69,0x6D,0x65,0x6E,0x74,0x61,0x6C,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x50
	.DB  0x65,0x72,0x73,0x6F,0x6E,0x61,0x6C,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x44,0x69,0x67,0x69,0x74
	.DB  0x61,0x6C,0x0,0x0,0x0,0x53,0x65,0x6E
	.DB  0x68,0x61,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0xA,0x45,0x6E,0x74,0x72,0x61,0x72,0x20
	.DB  0x63,0x6F,0x6D,0x20,0x64,0x69,0x67,0x69
	.DB  0x74,0x61,0x6C,0x20,0x6F,0x75,0x20,0x73
	.DB  0x65,0x6E,0x68,0x61,0x3F,0xA,0xD,0x0
	.DB  0x5B,0x25,0x69,0x5D,0x20,0x3D,0x20,0x25
	.DB  0x73,0xA,0x0,0xA,0x43,0x6F,0x6C,0x6F
	.DB  0x71,0x75,0x65,0x20,0x73,0x75,0x61,0x20
	.DB  0x64,0x69,0x67,0x69,0x74,0x61,0x6C,0x20
	.DB  0x6E,0x6F,0x20,0x6C,0x65,0x69,0x74,0x6F
	.DB  0x72,0x21,0xA,0x0,0xA,0x44,0x69,0x67
	.DB  0x69,0x74,0x65,0x20,0x73,0x75,0x61,0x20
	.DB  0x73,0x65,0x6E,0x68,0x61,0x3A,0x0,0x43
	.DB  0x6F,0x6D,0x61,0x6E,0x64,0x6F,0x20,0x49
	.DB  0x6E,0x63,0x6F,0x72,0x72,0x65,0x74,0x6F
	.DB  0x21,0xA,0xD,0x0,0xA,0xD,0x42,0x65
	.DB  0x6D,0x20,0x76,0x69,0x6E,0x64,0x6F,0x20
	.DB  0x61,0x20,0x4D,0x50,0x52,0x20,0x41,0x63
	.DB  0x61,0x64,0x65,0x6D,0x69,0x61,0x21,0xA
	.DB  0xD,0x0,0x5B,0x31,0x5D,0x20,0x3D,0x20
	.DB  0x52,0x65,0x67,0x69,0x73,0x74,0x72,0x61
	.DB  0x72,0x20,0x45,0x6E,0x74,0x72,0x61,0x64
	.DB  0x61,0xA,0xD,0x0,0xA,0x45,0x6E,0x74
	.DB  0x72,0x61,0x64,0x61,0x3A,0x20,0x25,0x73
	.DB  0xA,0xD,0x0,0x41,0x43,0x45,0x53,0x53
	.DB  0x4F,0x20,0x50,0x45,0x52,0x4D,0x49,0x54
	.DB  0x49,0x44,0x4F,0xA,0xD,0x0,0xA,0x41
	.DB  0x43,0x45,0x53,0x53,0x4F,0x20,0x4E,0x45
	.DB  0x47,0x41,0x44,0x4F,0x20,0x4F,0x55,0x20
	.DB  0x4C,0x45,0x49,0x54,0x55,0x52,0x41,0x20
	.DB  0x49,0x4E,0x43,0x4F,0x52,0x52,0x45,0x54
	.DB  0x41,0xA,0x0,0xA,0x42,0x65,0x6D,0x20
	.DB  0x76,0x69,0x6E,0x64,0x6F,0x20,0x61,0x20
	.DB  0x4D,0x50,0x52,0x20,0x41,0x63,0x61,0x64
	.DB  0x65,0x6D,0x69,0x61,0x21,0xA,0x0,0xA
	.DB  0x5B,0x31,0x5D,0x20,0x3D,0x20,0x52,0x65
	.DB  0x67,0x69,0x73,0x74,0x72,0x61,0x72,0x20
	.DB  0x45,0x6E,0x74,0x72,0x61,0x64,0x61,0xA
	.DB  0xD,0x0,0x30,0x0,0x31,0x0,0x32,0x0
	.DB  0x33,0x0,0x34,0x0,0x35,0x0,0x36,0x0
	.DB  0x37,0x0,0x38,0x0,0x39,0x0,0xA,0xD
	.DB  0x41,0x43,0x45,0x53,0x53,0x4F,0x20,0x50
	.DB  0x45,0x52,0x4D,0x49,0x54,0x49,0x44,0x4F
	.DB  0xA,0xD,0x0,0xA,0xD,0x41,0x43,0x45
	.DB  0x53,0x53,0x4F,0x20,0x4E,0x45,0x47,0x41
	.DB  0x44,0x4F,0x20,0x4F,0x55,0x20,0x53,0x45
	.DB  0x4E,0x48,0x41,0x20,0x49,0x4E,0x43,0x4F
	.DB  0x52,0x52,0x45,0x54,0x41,0xA,0x0,0x56
	.DB  0x41,0x47,0x41,0x53,0x0,0xA,0x5B,0x31
	.DB  0x5D,0x20,0x3D,0x20,0x52,0x65,0x67,0x69
	.DB  0x73,0x74,0x72,0x61,0x72,0x20,0x45,0x6E
	.DB  0x74,0x72,0x61,0x64,0x61,0xA,0x0,0xA
	.DB  0x43,0x6F,0x6D,0x61,0x6E,0x64,0x6F,0x20
	.DB  0x69,0x6E,0x76,0x61,0x6C,0x69,0x64,0x6F
	.DB  0x21,0xA,0x0,0xA,0x53,0x61,0xED,0x64
	.DB  0x61,0x20,0x72,0x65,0x67,0x69,0x73,0x74
	.DB  0x72,0x61,0x64,0x61,0x21,0xA,0x56,0x6F
	.DB  0x6C,0x74,0x65,0x20,0x53,0x65,0x6D,0x70
	.DB  0x72,0x65,0x21,0xA,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  0x07
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _key_pressed_counter_S0000000000
	.DW  _0x3*2

	.DW  0x01
	.DW  _column_S0000000000
	.DW  _0x4*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;interrupt [10] void timer0_ovf_isr(void)
; 0000 0030 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0031 static byte key_pressed_counter=20;

	.DSEG

	.CSEG
; 0000 0032 static byte key_released_counter,column=FIRST_COLUMN;

	.DSEG

	.CSEG
; 0000 0033 static unsigned row_data,crt_key;
; 0000 0034 // Reinitialize Timer 0 value
; 0000 0035 TCNT0=0x8D; // para 2ms
	LDI  R30,LOW(141)
	OUT  0x32,R30
; 0000 0036 // Place your code here
; 0000 0037 row_data<<=4;
	RCALL SUBOPT_0x0
	RCALL __LSLW4
	RCALL SUBOPT_0x1
; 0000 0038 // get a group of 4 keys in in row_data
; 0000 0039 row_data|=~KEYIN&0xf;
	IN   R30,0x19
	LDI  R31,0
	COM  R30
	COM  R31
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	RCALL SUBOPT_0x2
	OR   R30,R26
	OR   R31,R27
	RCALL SUBOPT_0x1
; 0000 003A column>>=1;
	LDS  R30,_column_S0000000000
	LSR  R30
	STS  _column_S0000000000,R30
; 0000 003B if (column==(LAST_COLUMN>>1))
	LDS  R26,_column_S0000000000
	CPI  R26,LOW(0x8)
	BRNE _0x5
; 0000 003C {
; 0000 003D column=FIRST_COLUMN;
	LDI  R30,LOW(128)
	STS  _column_S0000000000,R30
; 0000 003E if (row_data==0) goto new_key;
	RCALL SUBOPT_0x0
	SBIW R30,0
	BREQ _0x7
; 0000 003F if (key_released_counter) --key_released_counter;
	LDS  R30,_key_released_counter_S0000000000
	CPI  R30,0
	BREQ _0x8
	SUBI R30,LOW(1)
	RJMP _0x8F
; 0000 0040 else
_0x8:
; 0000 0041 {
; 0000 0042 if (--key_pressed_counter==9) crt_key=row_data;
	LDS  R26,_key_pressed_counter_S0000000000
	SUBI R26,LOW(1)
	STS  _key_pressed_counter_S0000000000,R26
	CPI  R26,LOW(0x9)
	BRNE _0xA
	RCALL SUBOPT_0x0
	STS  _crt_key_S0000000000,R30
	STS  _crt_key_S0000000000+1,R31
; 0000 0043 else
	RJMP _0xB
_0xA:
; 0000 0044 {
; 0000 0045 if (row_data!=crt_key)
	LDS  R30,_crt_key_S0000000000
	LDS  R31,_crt_key_S0000000000+1
	RCALL SUBOPT_0x2
	CP   R30,R26
	CPC  R31,R27
	BREQ _0xC
; 0000 0046 {
; 0000 0047 new_key:
_0x7:
; 0000 0048 key_pressed_counter=10;
	LDI  R30,LOW(10)
	STS  _key_pressed_counter_S0000000000,R30
; 0000 0049 key_released_counter=0;
	LDI  R30,LOW(0)
	RJMP _0x8F
; 0000 004A goto end_key;
; 0000 004B };
_0xC:
; 0000 004C if (!key_pressed_counter)
	LDS  R30,_key_pressed_counter_S0000000000
	CPI  R30,0
	BRNE _0xE
; 0000 004D {
; 0000 004E keys=row_data;
	__GETWRMN 4,5,0,_row_data_S0000000000
; 0000 004F key_released_counter=20;
	LDI  R30,LOW(20)
_0x8F:
	STS  _key_released_counter_S0000000000,R30
; 0000 0050 };
_0xE:
; 0000 0051 };
_0xB:
; 0000 0052 };
; 0000 0053 end_key:;
; 0000 0054 row_data=0;
	LDI  R30,LOW(0)
	STS  _row_data_S0000000000,R30
	STS  _row_data_S0000000000+1,R30
; 0000 0055 };
_0x5:
; 0000 0056 // select next column, inputs will be with pull-up
; 0000 0057 KEYOUT=~column;
	LDS  R30,_column_S0000000000
	COM  R30
	OUT  0x1B,R30
; 0000 0058 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;unsigned inkey(void)
; 0000 005C {
_inkey:
; .FSTART _inkey
; 0000 005D unsigned k;
; 0000 005E if (k=keys) keys=0;
	ST   -Y,R17
	ST   -Y,R16
;	k -> R16,R17
	MOVW R30,R4
	MOVW R16,R30
	SBIW R30,0
	BREQ _0xF
	CLR  R4
	CLR  R5
; 0000 005F return k;
_0xF:
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0060 }
; .FEND
;void init_keypad(void)
; 0000 0064 {
_init_keypad:
; .FSTART _init_keypad
; 0000 0065 // PORT D initialization
; 0000 0066 // Bits 0..3 inputs
; 0000 0067 // Bits 4..7 outputs
; 0000 0068 DDRA=0xf0;
	LDI  R30,LOW(240)
	OUT  0x1A,R30
; 0000 0069 // Use pull-ups on bits 0..3 inputs
; 0000 006A // Output 1 on 4..7 outputs
; 0000 006B PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 006C // Timer/Counter 0 initialization
; 0000 006D // Clock source: System Clock
; 0000 006E // Clock value: 57.600 kHz
; 0000 006F // Mode: Normal top=FFh
; 0000 0070 // OC0 output: Disconnected
; 0000 0071 //TCCR0=0x03;
; 0000 0072 //INIT_TIMER0;
; 0000 0073 TCCR0=0x04;
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 0074 TCNT0=0x8D;
	LDI  R30,LOW(141)
	OUT  0x32,R30
; 0000 0075 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0076 
; 0000 0077 // External Interrupts are off
; 0000 0078 //MCUCR=0x00;
; 0000 0079 //EMCUCR=0x00;
; 0000 007A // Timer 0 overflow interrupt is on
; 0000 007B //TIMSK=0x02;
; 0000 007C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 007D TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 007E #asm("sei")
	SEI
; 0000 007F }
	RET
; .FEND
;interrupt [12] void usart_rx_isr(void)
; 0000 00B3 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	RCALL SUBOPT_0x3
; 0000 00B4 char status,data;
; 0000 00B5 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 00B6 data=UDR;
	IN   R16,12
; 0000 00B7 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x10
; 0000 00B8 {
; 0000 00B9 
; 0000 00BA if ( data == 0xd )
	CPI  R16,13
	BRNE _0x11
; 0000 00BB {
; 0000 00BC data = 0;
	LDI  R16,LOW(0)
; 0000 00BD rx_message = 1;
	SET
	BLD  R2,1
; 0000 00BE }
; 0000 00BF 
; 0000 00C0 rx_buffer[rx_wr_index++]=data;
_0x11:
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 00C1 #if RX_BUFFER_SIZE == 256
; 0000 00C2 // special case for receiver buffer size=256
; 0000 00C3 if (++rx_counter == 0)
; 0000 00C4 {
; 0000 00C5 #else
; 0000 00C6 if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(32)
	CP   R30,R6
	BRNE _0x12
	CLR  R6
; 0000 00C7 if (++rx_counter == RX_BUFFER_SIZE)
_0x12:
	INC  R8
	LDI  R30,LOW(32)
	CP   R30,R8
	BRNE _0x13
; 0000 00C8 {
; 0000 00C9 rx_counter=0;
	CLR  R8
; 0000 00CA #endif
; 0000 00CB rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 00CC }
; 0000 00CD }
_0x13:
; 0000 00CE }
_0x10:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x93
; .FEND
;char getchar(void)
; 0000 00D5 {
_getchar:
; .FSTART _getchar
; 0000 00D6 char data;
; 0000 00D7 while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x14:
	TST  R8
	BREQ _0x14
; 0000 00D8 data=rx_buffer[rx_rd_index++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 00D9 #if RX_BUFFER_SIZE != 256
; 0000 00DA if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(32)
	CP   R30,R9
	BRNE _0x17
	CLR  R9
; 0000 00DB #endif
; 0000 00DC #asm("cli")
_0x17:
	CLI
; 0000 00DD --rx_counter;
	DEC  R8
; 0000 00DE #asm("sei")
	SEI
; 0000 00DF return data;
	MOV  R30,R17
	JMP  _0x2080002
; 0000 00E0 }
; .FEND
;interrupt [14] void usart_tx_isr(void)
; 0000 00F0 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	RCALL SUBOPT_0x3
; 0000 00F1 if (tx_counter)
	TST  R13
	BREQ _0x18
; 0000 00F2 {
; 0000 00F3 --tx_counter;
	DEC  R13
; 0000 00F4 UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R10
	INC  R10
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 00F5 #if TX_BUFFER_SIZE != 256
; 0000 00F6 if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(32)
	CP   R30,R10
	BRNE _0x19
	CLR  R10
; 0000 00F7 #endif
; 0000 00F8 }
_0x19:
; 0000 00F9 }
_0x18:
_0x93:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;void putchar(char c)
; 0000 0100 {
_putchar:
; .FSTART _putchar
; 0000 0101 while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R17
	MOV  R17,R26
;	c -> R17
_0x1A:
	LDI  R30,LOW(32)
	CP   R30,R13
	BREQ _0x1A
; 0000 0102 #asm("cli")
	CLI
; 0000 0103 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R13
	BRNE _0x1E
	SBIC 0xB,5
	RJMP _0x1D
_0x1E:
; 0000 0104 {
; 0000 0105 tx_buffer[tx_wr_index++]=c;
	MOV  R30,R11
	INC  R11
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	ST   Z,R17
; 0000 0106 #if TX_BUFFER_SIZE != 256
; 0000 0107 if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(32)
	CP   R30,R11
	BRNE _0x20
	CLR  R11
; 0000 0108 #endif
; 0000 0109 ++tx_counter;
_0x20:
	INC  R13
; 0000 010A }
; 0000 010B else
	RJMP _0x21
_0x1D:
; 0000 010C UDR=c;
	OUT  0xC,R17
; 0000 010D #asm("sei")
_0x21:
	SEI
; 0000 010E }
	JMP  _0x2080002
; .FEND
;interrupt [2] void ext_int0_isr(void)
; 0000 0117 {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R30
; 0000 0118 // Place your code here
; 0000 0119 flag0=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 011A }
	LD   R30,Y+
	RETI
; .FEND
;int entrada(int np)
; 0000 011D {
_entrada:
; .FSTART _entrada
; 0000 011E unsigned k = 0;
; 0000 011F char message[20];
; 0000 0120 char chave[20];
; 0000 0121 char opcao[2][10] = {"Digital","Senha"};
; 0000 0122 char cadastro[3][20] = {"Aluno","Experimental","Personal"};
; 0000 0123 char senha[10] = "201769024";
; 0000 0124 char senha_botoes[9];
; 0000 0125 char comando[2];
; 0000 0126 int i, j, trava = 1, validado = 1, valida_senha = 1, contaux = 0, tam_chave=0;
; 0000 0127 
; 0000 0128 
; 0000 0129 printf("\nEntrar com digital ou senha?\n\r");
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,63
	SBIW R28,25
	LDI  R24,111
	__GETWRN 22,23,0
	LDI  R30,LOW(_0x22*2)
	LDI  R31,HIGH(_0x22*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR6
;	np -> Y+157
;	k -> R16,R17
;	message -> Y+137
;	chave -> Y+117
;	opcao -> Y+97
;	cadastro -> Y+37
;	senha -> Y+27
;	senha_botoes -> Y+18
;	comando -> Y+16
;	i -> R18,R19
;	j -> R20,R21
;	trava -> Y+14
;	validado -> Y+12
;	valida_senha -> Y+10
;	contaux -> Y+8
;	tam_chave -> Y+6
	__GETWRN 16,17,0
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x4
; 0000 012A for (i=0; i<2 ; i++)
	__GETWRN 18,19,0
_0x24:
	__CPWRN 18,19,2
	BRGE _0x25
; 0000 012B {
; 0000 012C printf("[%i] = %s\n", i+1, opcao[i]);
	__POINTW1FN _0x0,32
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	ADIW R30,1
	__CWD1
	RCALL __PUTPARD1
	__MULBNWRU 18,19,10
	MOVW R26,R28
	SUBI R26,LOW(-(103))
	SBCI R27,HIGH(-(103))
	ADD  R30,R26
	ADC  R31,R27
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,8
	RCALL _printf
	ADIW R28,10
; 0000 012D }
	__ADDWRN 18,19,1
	RJMP _0x24
_0x25:
; 0000 012E 
; 0000 012F while(trava)
_0x26:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,0
	BREQ _0x28
; 0000 0130 {
; 0000 0131 if(rx_message)
	SBRS R2,1
	RJMP _0x29
; 0000 0132 {
; 0000 0133 rx_message = 0;
	CLT
	BLD  R2,1
; 0000 0134 for (i=0, j=rx_counter;i<j;i++)
	RCALL SUBOPT_0x5
_0x2B:
	__CPWRR 18,19,20,21
	BRGE _0x2C
; 0000 0135 {
; 0000 0136 comando[i] = getchar();
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,16
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0137 };
	__ADDWRN 18,19,1
	RJMP _0x2B
_0x2C:
; 0000 0138 trava = 0;
	LDI  R30,LOW(0)
	STD  Y+14,R30
	STD  Y+14+1,R30
; 0000 0139 }
; 0000 013A }
_0x29:
	RJMP _0x26
_0x28:
; 0000 013B 
; 0000 013C switch(comando[0])
	LDD  R30,Y+16
	LDI  R31,0
; 0000 013D {
; 0000 013E case 49:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x30
; 0000 013F printf("\nColoque sua digital no leitor!\n");
	__POINTW1FN _0x0,43
	RJMP _0x90
; 0000 0140 break;
; 0000 0141 
; 0000 0142 case 50:
_0x30:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x32
; 0000 0143 printf("\nDigite sua senha:");
	__POINTW1FN _0x0,76
	RJMP _0x90
; 0000 0144 break;
; 0000 0145 
; 0000 0146 default:
_0x32:
; 0000 0147 printf("Comando Incorreto!\n\r");
	__POINTW1FN _0x0,95
	RCALL SUBOPT_0x4
; 0000 0148 printf("\n\rBem vindo a MPR Academia!\n\r");
	__POINTW1FN _0x0,116
	RCALL SUBOPT_0x4
; 0000 0149 printf("[1] = Registrar Entrada\n\r");
	__POINTW1FN _0x0,146
_0x90:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 014A break;
; 0000 014B };
; 0000 014C 
; 0000 014D if(comando[0] == 49)
	LDD  R26,Y+16
	CPI  R26,LOW(0x31)
	BREQ PC+2
	RJMP _0x33
; 0000 014E {
; 0000 014F trava = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 0150 
; 0000 0151 while(trava)
_0x34:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,0
	BRNE PC+2
	RJMP _0x36
; 0000 0152 {
; 0000 0153 if(rx_message)
	SBRS R2,1
	RJMP _0x37
; 0000 0154 {
; 0000 0155 rx_message = 0;
	CLT
	BLD  R2,1
; 0000 0156 tam_chave = rx_counter;
	MOV  R30,R8
	LDI  R31,0
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0157 
; 0000 0158 for (i=0, j=rx_counter; i<j ; i++)
	RCALL SUBOPT_0x5
_0x39:
	__CPWRR 18,19,20,21
	BRGE _0x3A
; 0000 0159 {
; 0000 015A message[i]= getchar();
	MOVW R30,R18
	MOVW R26,R28
	SUBI R26,LOW(-(137))
	SBCI R27,HIGH(-(137))
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 015B };
	__ADDWRN 18,19,1
	RJMP _0x39
_0x3A:
; 0000 015C 
; 0000 015D for (i=0;i<tam_chave;i++)      // LÊ O BUFFER ATÉ O TAMANHO DA CHAVE E SALVA ISSO COMO ENTRADA
	__GETWRN 18,19,0
_0x3C:
	RCALL SUBOPT_0x6
	BRGE _0x3D
; 0000 015E {
; 0000 015F chave[i] = message[i];
	MOVW R30,R18
	MOVW R26,R28
	SUBI R26,LOW(-(117))
	SBCI R27,HIGH(-(117))
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R26,R28
	SUBI R26,LOW(-(137))
	SBCI R27,HIGH(-(137))
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0160 };
	__ADDWRN 18,19,1
	RJMP _0x3C
_0x3D:
; 0000 0161 
; 0000 0162 
; 0000 0163 for (j=0; j<3; j++)
	__GETWRN 20,21,0
_0x3F:
	__CPWRN 20,21,3
	BRGE _0x40
; 0000 0164 {
; 0000 0165 validado = 1;
	RCALL SUBOPT_0x7
; 0000 0166 
; 0000 0167 for (i=0;i<tam_chave;i++)      // LÊ O BUFFER ATÉ O TAMANHO DA CHAVE E SALVA ISSO COMO ENTRADA
	__GETWRN 18,19,0
_0x42:
	RCALL SUBOPT_0x6
	BRGE _0x43
; 0000 0168 {
; 0000 0169 if (chave[i] != cadastro[j][i])   // VERIFICA SE A CHAVE É IGUAL AO CADASTRO PARA VALIDAR O ACESSO
	MOVW R26,R28
	SUBI R26,LOW(-(117))
	SBCI R27,HIGH(-(117))
	ADD  R26,R18
	ADC  R27,R19
	LD   R22,X
	__MULBNWRU 20,21,20
	MOVW R26,R28
	ADIW R26,37
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R18
	ADC  R31,R19
	LD   R30,Z
	CP   R30,R22
	BREQ _0x44
; 0000 016A {
; 0000 016B validado = 0;
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
; 0000 016C break;
	RJMP _0x43
; 0000 016D }
; 0000 016E };
_0x44:
	__ADDWRN 18,19,1
	RJMP _0x42
_0x43:
; 0000 016F 
; 0000 0170 if (validado == 1)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BREQ _0x40
; 0000 0171 {
; 0000 0172 break;
; 0000 0173 }
; 0000 0174 };
	__ADDWRN 20,21,1
	RJMP _0x3F
_0x40:
; 0000 0175 
; 0000 0176 if (validado)
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SBIW R30,0
	BREQ _0x46
; 0000 0177 {
; 0000 0178 PORTB.0=1;
	SBI  0x18,0
; 0000 0179 PORTB.1=0;
	CBI  0x18,1
; 0000 017A printf("\nEntrada: %s\n\r",chave);
	__POINTW1FN _0x0,172
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(119))
	SBCI R31,HIGH(-(119))
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
; 0000 017B printf("ACESSO PERMITIDO\n\r");
	__POINTW1FN _0x0,187
	RCALL SUBOPT_0x4
; 0000 017C validado = 0;
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
; 0000 017D np--;
	RCALL SUBOPT_0x8
; 0000 017E delay_ms(2000);
; 0000 017F PORTB.0=0;
; 0000 0180 printf("Bem vindo a MPR Academia!\n\r");
; 0000 0181 printf("[1] = Registrar Entrada\n\r");
	__POINTW1FN _0x0,146
	RCALL SUBOPT_0x4
; 0000 0182 trava = 0;
	LDI  R30,LOW(0)
	STD  Y+14,R30
	STD  Y+14+1,R30
; 0000 0183 }
; 0000 0184 else
	RJMP _0x4D
_0x46:
; 0000 0185 {
; 0000 0186 PORTB.0=0;
	CBI  0x18,0
; 0000 0187 PORTB.1=1;
	SBI  0x18,1
; 0000 0188 printf("\nACESSO NEGADO OU LEITURA INCORRETA\n");
	__POINTW1FN _0x0,206
	RCALL SUBOPT_0x4
; 0000 0189 validado = 1;
	RCALL SUBOPT_0x7
; 0000 018A trava = 0;
	LDI  R30,LOW(0)
	STD  Y+14,R30
	STD  Y+14+1,R30
; 0000 018B delay_ms(2000);
	RCALL SUBOPT_0x9
; 0000 018C PORTB.1=0;
; 0000 018D printf("\nBem vindo a MPR Academia!\n");
	__POINTW1FN _0x0,243
	RCALL SUBOPT_0x4
; 0000 018E printf("\n[1] = Registrar Entrada\n\r");
	__POINTW1FN _0x0,271
	RCALL SUBOPT_0x4
; 0000 018F };
_0x4D:
; 0000 0190 };
_0x37:
; 0000 0191 };
	RJMP _0x34
_0x36:
; 0000 0192 }
; 0000 0193 
; 0000 0194 if(comando[0] == 50)
_0x33:
	LDD  R26,Y+16
	CPI  R26,LOW(0x32)
	BREQ PC+2
	RJMP _0x54
; 0000 0195 {
; 0000 0196 do
_0x56:
; 0000 0197 {
; 0000 0198 if (k=inkey())
	RCALL _inkey
	MOVW R16,R30
	SBIW R30,0
	BRNE PC+2
	RJMP _0x58
; 0000 0199 {
; 0000 019A switch(k)
; 0000 019B {
; 0000 019C case 4096:
	CPI  R30,LOW(0x1000)
	LDI  R26,HIGH(0x1000)
	CPC  R31,R26
	BRNE _0x5C
; 0000 019D printf("0");
	__POINTW1FN _0x0,298
	RCALL SUBOPT_0x4
; 0000 019E senha_botoes[contaux] = '0';
	RCALL SUBOPT_0xA
	LDI  R30,LOW(48)
	RJMP _0x91
; 0000 019F contaux = contaux + 1;
; 0000 01A0 break;
; 0000 01A1 
; 0000 01A2 case 1:
_0x5C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5D
; 0000 01A3 printf("1");
	__POINTW1FN _0x0,300
	RCALL SUBOPT_0x4
; 0000 01A4 senha_botoes[contaux] = '1';
	RCALL SUBOPT_0xA
	LDI  R30,LOW(49)
	RJMP _0x91
; 0000 01A5 contaux = contaux + 1;
; 0000 01A6 break;
; 0000 01A7 
; 0000 01A8 case 2:
_0x5D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x5E
; 0000 01A9 printf("2");
	__POINTW1FN _0x0,302
	RCALL SUBOPT_0x4
; 0000 01AA senha_botoes[contaux] = '2';
	RCALL SUBOPT_0xA
	LDI  R30,LOW(50)
	RJMP _0x91
; 0000 01AB contaux = contaux + 1;
; 0000 01AC break;
; 0000 01AD 
; 0000 01AE case 4:
_0x5E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x5F
; 0000 01AF printf("3");
	__POINTW1FN _0x0,304
	RCALL SUBOPT_0x4
; 0000 01B0 senha_botoes[contaux] = '3';
	RCALL SUBOPT_0xA
	LDI  R30,LOW(51)
	RJMP _0x91
; 0000 01B1 contaux = contaux + 1;
; 0000 01B2 break;
; 0000 01B3 
; 0000 01B4 case 16:
_0x5F:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x60
; 0000 01B5 printf("4");
	__POINTW1FN _0x0,306
	RCALL SUBOPT_0x4
; 0000 01B6 senha_botoes[contaux] = '4';
	RCALL SUBOPT_0xA
	LDI  R30,LOW(52)
	RJMP _0x91
; 0000 01B7 contaux = contaux + 1;
; 0000 01B8 break;
; 0000 01B9 
; 0000 01BA case 32:
_0x60:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x61
; 0000 01BB printf("5");
	__POINTW1FN _0x0,308
	RCALL SUBOPT_0x4
; 0000 01BC senha_botoes[contaux] = '5';
	RCALL SUBOPT_0xA
	LDI  R30,LOW(53)
	RJMP _0x91
; 0000 01BD contaux = contaux + 1;
; 0000 01BE break;
; 0000 01BF 
; 0000 01C0 case 64:
_0x61:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x62
; 0000 01C1 printf("6");
	__POINTW1FN _0x0,310
	RCALL SUBOPT_0x4
; 0000 01C2 senha_botoes[contaux] = '6';
	RCALL SUBOPT_0xA
	LDI  R30,LOW(54)
	RJMP _0x91
; 0000 01C3 contaux = contaux + 1;
; 0000 01C4 break;
; 0000 01C5 
; 0000 01C6 case 256:
_0x62:
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	BRNE _0x63
; 0000 01C7 printf("7");
	__POINTW1FN _0x0,312
	RCALL SUBOPT_0x4
; 0000 01C8 senha_botoes[contaux] = '7';
	RCALL SUBOPT_0xA
	LDI  R30,LOW(55)
	RJMP _0x91
; 0000 01C9 contaux = contaux + 1;
; 0000 01CA break;
; 0000 01CB 
; 0000 01CC case 512:
_0x63:
	CPI  R30,LOW(0x200)
	LDI  R26,HIGH(0x200)
	CPC  R31,R26
	BRNE _0x64
; 0000 01CD printf("8");
	__POINTW1FN _0x0,314
	RCALL SUBOPT_0x4
; 0000 01CE senha_botoes[contaux] = '8';
	RCALL SUBOPT_0xA
	LDI  R30,LOW(56)
	RJMP _0x91
; 0000 01CF contaux = contaux + 1;
; 0000 01D0 break;
; 0000 01D1 
; 0000 01D2 case 1024:
_0x64:
	CPI  R30,LOW(0x400)
	LDI  R26,HIGH(0x400)
	CPC  R31,R26
	BRNE _0x5B
; 0000 01D3 printf("9");
	__POINTW1FN _0x0,316
	RCALL SUBOPT_0x4
; 0000 01D4 senha_botoes[contaux] = '9';
	RCALL SUBOPT_0xA
	LDI  R30,LOW(57)
_0x91:
	ST   X,R30
; 0000 01D5 contaux = contaux + 1;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01D6 break;
; 0000 01D7 }
_0x5B:
; 0000 01D8 }
; 0000 01D9 }while (contaux<9);
_0x58:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,9
	BRGE _0x57
	RJMP _0x56
_0x57:
; 0000 01DA 
; 0000 01DB if(contaux == 9)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,9
	BRNE _0x66
; 0000 01DC {
; 0000 01DD for (i=0;i<(sizeof(senha_botoes)/(sizeof(senha_botoes[0])));i++)
	__GETWRN 18,19,0
_0x68:
	__CPWRN 18,19,9
	BRGE _0x69
; 0000 01DE {
; 0000 01DF if (senha_botoes[i] != senha[i])                         // VERIFICA SE A ENTRADA É IGUAL A CHAVE PARA HABILITAR O ACESSO
	MOVW R26,R28
	ADIW R26,18
	ADD  R26,R18
	ADC  R27,R19
	LD   R0,X
	MOVW R26,R28
	ADIW R26,27
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	CP   R30,R0
	BREQ _0x6A
; 0000 01E0 {
; 0000 01E1 valida_senha = 0;
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
; 0000 01E2 }
; 0000 01E3 }
_0x6A:
	__ADDWRN 18,19,1
	RJMP _0x68
_0x69:
; 0000 01E4 }
; 0000 01E5 
; 0000 01E6 if (valida_senha)
_0x66:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,0
	BREQ _0x6B
; 0000 01E7 {
; 0000 01E8 PORTB.0=1;
	SBI  0x18,0
; 0000 01E9 PORTB.1=0;
	CBI  0x18,1
; 0000 01EA printf("\n\rACESSO PERMITIDO\n\r");
	__POINTW1FN _0x0,318
	RCALL SUBOPT_0x4
; 0000 01EB np--;
	RCALL SUBOPT_0x8
; 0000 01EC delay_ms(2000);
; 0000 01ED PORTB.0=0;
; 0000 01EE printf("Bem vindo a MPR Academia!\n\r");
; 0000 01EF printf("[1] = Registrar Entrada\n\r");
	__POINTW1FN _0x0,146
	RJMP _0x92
; 0000 01F0 
; 0000 01F1 }
; 0000 01F2 else
_0x6B:
; 0000 01F3 {
; 0000 01F4 PORTB.0=0;
	CBI  0x18,0
; 0000 01F5 PORTB.1=1;
	SBI  0x18,1
; 0000 01F6 printf("\n\rACESSO NEGADO OU SENHA INCORRETA\n");
	__POINTW1FN _0x0,339
	RCALL SUBOPT_0x4
; 0000 01F7 delay_ms(2000);
	RCALL SUBOPT_0x9
; 0000 01F8 PORTB.1=0;
; 0000 01F9 validado = 1;
	RCALL SUBOPT_0x7
; 0000 01FA valida_senha = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 01FB printf("\nBem vindo a MPR Academia!\n");
	__POINTW1FN _0x0,243
	RCALL SUBOPT_0x4
; 0000 01FC printf("\n[1] = Registrar Entrada\n\r");
	__POINTW1FN _0x0,271
_0x92:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 01FD }
; 0000 01FE }
; 0000 01FF 
; 0000 0200 contaux = 0;
_0x54:
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
; 0000 0201 return (np);
	__GETW1SX 157
	RCALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,63
	ADIW R28,33
	RET
; 0000 0202 }
; .FEND
;void main(void)
; 0000 0205 {
_main:
; .FSTART _main
; 0000 0206 // Declare your local variables here
; 0000 0207 
; 0000 0208 char texto[32];
; 0000 0209 char ent[2];
; 0000 020A char aux1, aux2, aux3;
; 0000 020B int i, j, nump = 15;
; 0000 020C 
; 0000 020D {// Input/Output Ports initialization
	SBIW R28,38
	LDI  R30,LOW(15)
	ST   Y,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
;	texto -> Y+6
;	ent -> Y+4
;	aux1 -> R17
;	aux2 -> R16
;	aux3 -> R19
;	i -> R20,R21
;	j -> Y+2
;	nump -> Y+0
; 0000 020E // Port A initialization
; 0000 020F // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0210 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	OUT  0x1A,R30
; 0000 0211 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0212 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0213 
; 0000 0214 // Port B initialization
; 0000 0215 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0216 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(3)
	OUT  0x17,R30
; 0000 0217 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0218 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (1<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(4)
	OUT  0x18,R30
; 0000 0219 
; 0000 021A // Port C initialization
; 0000 021B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 021C DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 021D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 021E PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 021F 
; 0000 0220 // Port D initialization
; 0000 0221 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=Out
; 0000 0222 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0223 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=0
; 0000 0224 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0225 
; 0000 0226 // Timer/Counter 0 initialization
; 0000 0227 // Clock source: System Clock
; 0000 0228 // Clock value: Timer 0 Stopped
; 0000 0229 // Mode: Normal top=0xFF
; 0000 022A // OC0 output: Disconnected
; 0000 022B TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 022C TCNT0=0x00;
	OUT  0x32,R30
; 0000 022D OCR0=0x00;
	OUT  0x3C,R30
; 0000 022E 
; 0000 022F // Timer/Counter 1 initialization
; 0000 0230 // Clock source: System Clock
; 0000 0231 // Clock value: Timer1 Stopped
; 0000 0232 // Mode: Normal top=0xFFFF
; 0000 0233 // OC1A output: Disconnected
; 0000 0234 // OC1B output: Disconnected
; 0000 0235 // Noise Canceler: Off
; 0000 0236 // Input Capture on Falling Edge
; 0000 0237 // Timer1 Overflow Interrupt: Off
; 0000 0238 // Input Capture Interrupt: Off
; 0000 0239 // Compare A Match Interrupt: Off
; 0000 023A // Compare B Match Interrupt: Off
; 0000 023B TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 023C TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 023D TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 023E TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 023F ICR1H=0x00;
	OUT  0x27,R30
; 0000 0240 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0241 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0242 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0243 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0244 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0245 
; 0000 0246 // Timer/Counter 2 initialization
; 0000 0247 // Clock source: System Clock
; 0000 0248 // Clock value: Timer2 Stopped
; 0000 0249 // Mode: Normal top=0xFF
; 0000 024A // OC2 output: Disconnected
; 0000 024B ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 024C TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 024D TCNT2=0x00;
	OUT  0x24,R30
; 0000 024E OCR2=0x00;
	OUT  0x23,R30
; 0000 024F 
; 0000 0250 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0251 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0252 
; 0000 0253 // External Interrupt(s) initialization
; 0000 0254 // INT0: On
; 0000 0255 // INT0 Mode: Any change
; 0000 0256 // INT1: Off
; 0000 0257 // INT1 Mode: Any change
; 0000 0258 // INT2: Off
; 0000 0259 GICR|=0x40;  // 0100 0000
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 025A MCUCR=0x02;  // 0000 1111
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 025B GIFR=0x40;   // 1100 0000
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 025C //GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
; 0000 025D //MCUCR=(0<<ISC11) | (1<<ISC10) | (0<<ISC01) | (1<<ISC00);
; 0000 025E //MCUCSR=(0<<ISC2);
; 0000 025F //GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);
; 0000 0260 
; 0000 0261 // USART initialization
; 0000 0262 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0263 // USART Receiver: On
; 0000 0264 // USART Transmitter: On
; 0000 0265 // USART Mode: Asynchronous
; 0000 0266 // USART Baud Rate: 19200
; 0000 0267 //UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
; 0000 0268 //UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
; 0000 0269 //UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
; 0000 026A 
; 0000 026B UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 026C UCSRB=0xD8;    // 11011000 - Habilitado recepção e transmissão com interrupçoes                                                   \\\\\\\
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 026D UCSRC=0x86;    // 10000110 - Habilitado ,Modo assíncrono, Paridade desabilitada, 1 stop bit, 9 bits ,borda de descida             \\\\\\\
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 026E UBRRH=0x00;    //                                                                                                                 \\\\\\\
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 026F UBRRL=0x2F;    // FREQUÊNCIA 19.200
	LDI  R30,LOW(47)
	OUT  0x9,R30
; 0000 0270 
; 0000 0271 // Analog Comparator initialization
; 0000 0272 // Analog Comparator: Off
; 0000 0273 // The Analog Comparator's positive input is
; 0000 0274 // connected to the AIN0 pin
; 0000 0275 // The Analog Comparator's negative input is
; 0000 0276 // connected to the AIN1 pin
; 0000 0277 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0278 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0279 
; 0000 027A // ADC initialization
; 0000 027B // ADC disabled
; 0000 027C ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 027D 
; 0000 027E // SPI initialization
; 0000 027F // SPI disabled
; 0000 0280 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0281 
; 0000 0282 // TWI initialization
; 0000 0283 // TWI disabled
; 0000 0284 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0285 
; 0000 0286 // Alphanumeric LCD initialization
; 0000 0287 // Connections are specified in the
; 0000 0288 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0289 // RS - PORTC Bit 0
; 0000 028A // RD - PORTC Bit 1
; 0000 028B // EN - PORTC Bit 2
; 0000 028C // D4 - PORTC Bit 4
; 0000 028D // D5 - PORTC Bit 5
; 0000 028E // D6 - PORTC Bit 6
; 0000 028F // D7 - PORTC Bit 7
; 0000 0290 // Characters/line: 8
; 0000 0291 }
; 0000 0292 
; 0000 0293 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0294 
; 0000 0295 // Globally enable interrupts
; 0000 0296 #asm("sei")
	SEI
; 0000 0297 init_keypad();
	RCALL _init_keypad
; 0000 0298 lcd_clear();
	RCALL _lcd_clear
; 0000 0299 lcd_gotoxy(5,0);
	RCALL SUBOPT_0xB
; 0000 029A sprintf(texto,"VAGAS");
; 0000 029B lcd_puts(texto);
; 0000 029C 
; 0000 029D lcd_gotoxy(6,1);
; 0000 029E lcd_putchar(48);
	LDI  R26,LOW(48)
	RCALL SUBOPT_0xC
; 0000 029F lcd_gotoxy(7,1);
; 0000 02A0 lcd_putchar(49);
	LDI  R26,LOW(49)
	RCALL SUBOPT_0xD
; 0000 02A1 lcd_gotoxy(8,1);
; 0000 02A2 lcd_putchar(53);
	LDI  R26,LOW(53)
	RCALL _lcd_putchar
; 0000 02A3 
; 0000 02A4 printf("Bem vindo a MPR Academia!\n");
	__POINTW1FN _0x0,244
	RCALL SUBOPT_0x4
; 0000 02A5 printf("\n[1] = Registrar Entrada\n");
	__POINTW1FN _0x0,381
	RCALL SUBOPT_0x4
; 0000 02A6 
; 0000 02A7 while (1)
_0x79:
; 0000 02A8 {
; 0000 02A9 // Place your code here
; 0000 02AA 
; 0000 02AB PORTB.0 = 0;
	CBI  0x18,0
; 0000 02AC PORTB.1 = 0;
	CBI  0x18,1
; 0000 02AD 
; 0000 02AE if(rx_message)
	SBRS R2,1
	RJMP _0x80
; 0000 02AF {
; 0000 02B0 rx_message=0;
	CLT
	BLD  R2,1
; 0000 02B1 
; 0000 02B2 for(i=0, j=rx_counter; i<j; i++)
	__GETWRN 20,21,0
	MOV  R30,R8
	LDI  R31,0
	STD  Y+2,R30
	STD  Y+2+1,R31
_0x82:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R20,R30
	CPC  R21,R31
	BRGE _0x83
; 0000 02B3 {
; 0000 02B4 ent[i] = getchar();
	MOVW R30,R20
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 02B5 };
	__ADDWRN 20,21,1
	RJMP _0x82
_0x83:
; 0000 02B6 
; 0000 02B7 
; 0000 02B8 if(ent[0] == 49)
	LDD  R26,Y+4
	CPI  R26,LOW(0x31)
	BRNE _0x84
; 0000 02B9 {
; 0000 02BA nump = entrada(nump);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _entrada
	ST   Y,R30
	STD  Y+1,R31
; 0000 02BB }
; 0000 02BC else
	RJMP _0x85
_0x84:
; 0000 02BD {
; 0000 02BE printf("\nComando invalido!\n");
	__POINTW1FN _0x0,407
	RCALL SUBOPT_0x4
; 0000 02BF delay_ms(1000);
	RCALL SUBOPT_0xE
; 0000 02C0 printf("\nBem vindo a MPR Academia!\n");
; 0000 02C1 printf("\n[1] = Registrar Entrada\n");
	__POINTW1FN _0x0,381
	RCALL SUBOPT_0x4
; 0000 02C2 }
_0x85:
; 0000 02C3 }
; 0000 02C4 
; 0000 02C5 if(flag0==1)
_0x80:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x86
; 0000 02C6 {
; 0000 02C7 flag0=0;
	CLR  R7
; 0000 02C8 printf("\nSaída registrada!\nVolte Sempre!\n");
	__POINTW1FN _0x0,427
	RCALL SUBOPT_0x4
; 0000 02C9 nump++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 02CA PORTB.1 = 1;
	SBI  0x18,1
; 0000 02CB delay_ms(1000);
	RCALL SUBOPT_0xE
; 0000 02CC 
; 0000 02CD printf("\nBem vindo a MPR Academia!\n");
; 0000 02CE printf("\n[1] = Registrar Entrada\n");
	__POINTW1FN _0x0,381
	RCALL SUBOPT_0x4
; 0000 02CF };
_0x86:
; 0000 02D0 
; 0000 02D1 if (nump<10)
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRGE _0x89
; 0000 02D2 {
; 0000 02D3 aux1 = (char) nump+48;
	LD   R30,Y
	SUBI R30,-LOW(48)
	MOV  R17,R30
; 0000 02D4 aux2 = '0';
	LDI  R16,LOW(48)
; 0000 02D5 aux3= '0';
	LDI  R19,LOW(48)
; 0000 02D6 }
; 0000 02D7 if (nump>=10 && nump<16)
_0x89:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRLT _0x8B
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,16
	BRLT _0x8C
_0x8B:
	RJMP _0x8A
_0x8C:
; 0000 02D8 {
; 0000 02D9 aux1 = (char)(nump-((nump/10)*10)+48);
	RCALL SUBOPT_0xF
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	LD   R26,Y
	RCALL __SWAPB12
	SUB  R30,R26
	SUBI R30,-LOW(48)
	MOV  R17,R30
; 0000 02DA aux2 = (char)((nump/10)+48);
	RCALL SUBOPT_0xF
	SUBI R30,-LOW(48)
	MOV  R16,R30
; 0000 02DB aux3 = '0';
	LDI  R19,LOW(48)
; 0000 02DC }
; 0000 02DD 
; 0000 02DE if(nump>=16)
_0x8A:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,16
	BRLT _0x8D
; 0000 02DF {
; 0000 02E0 nump = 15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   Y,R30
	STD  Y+1,R31
; 0000 02E1 }
; 0000 02E2 
; 0000 02E3 lcd_gotoxy(5,0);
_0x8D:
	RCALL SUBOPT_0xB
; 0000 02E4 sprintf(texto,"VAGAS");
; 0000 02E5 lcd_puts(texto);
; 0000 02E6 
; 0000 02E7 lcd_gotoxy(6,1);
; 0000 02E8 lcd_putchar(aux3);
	MOV  R26,R19
	RCALL SUBOPT_0xC
; 0000 02E9 lcd_gotoxy(7,1);
; 0000 02EA lcd_putchar(aux2);
	MOV  R26,R16
	RCALL SUBOPT_0xD
; 0000 02EB lcd_gotoxy(8,1);
; 0000 02EC lcd_putchar(aux1);
	MOV  R26,R17
	RCALL _lcd_putchar
; 0000 02ED }
	RJMP _0x79
; 0000 02EE }
_0x8E:
	RJMP _0x8E
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 25
	SBI  0x15,2
	__DELAY_USB 25
	CBI  0x15,2
	__DELAY_USB 25
	RJMP _0x2080002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 246
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	MOV  R12,R16
	STS  __lcd_y,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x10
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x10
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R12,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	CP   R12,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	CPI  R17,10
	BRNE _0x2000007
	RJMP _0x2080002
_0x2000007:
_0x2000004:
	INC  R12
	SBI  0x15,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2080002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL __SAVELOCR4
	MOVW R18,R26
_0x2000008:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	STS  __lcd_maxx,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x11
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 369
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080002:
	LD   R17,Y+
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_usart_G101:
; .FSTART _put_usart_G101
	RCALL __SAVELOCR4
	MOVW R16,R26
	LDD  R19,Y+4
	MOV  R26,R19
	RCALL _putchar
	MOVW R26,R16
	RCALL SUBOPT_0x12
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND
_put_buff_G101:
; .FSTART _put_buff_G101
	RCALL __SAVELOCR6
	MOVW R18,R26
	LDD  R21,Y+6
	ADIW R26,2
	__GETW1P
	SBIW R30,0
	BREQ _0x2020010
	MOVW R26,R18
	RCALL SUBOPT_0x13
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1RNS 18,4
_0x2020012:
	MOVW R26,R18
	ADIW R26,2
	RCALL SUBOPT_0x12
	SBIW R30,1
	ST   Z,R21
_0x2020013:
	MOVW R26,R18
	__GETW1P
	TST  R31
	BRMI _0x2020014
	RCALL SUBOPT_0x12
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	MOVW R26,R18
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	RCALL __LOADLOCR6
	ADIW R28,7
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	RCALL SUBOPT_0x14
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	RCALL SUBOPT_0x14
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	RCALL SUBOPT_0x15
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x16
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x17
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x17
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	RCALL SUBOPT_0x15
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	RCALL SUBOPT_0x15
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RCALL SUBOPT_0x13
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	RCALL SUBOPT_0x14
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	RCALL SUBOPT_0x14
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x16
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	RCALL SUBOPT_0x14
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x16
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR6
	MOVW R30,R28
	__ADDW1R15
	__GETWRZ 20,21,14
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x2020072:
	MOVW R26,R28
	ADIW R26,8
	RCALL SUBOPT_0x18
	__PUTWSR 20,21,8
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
	MOVW R26,R28
	ADIW R26,12
	RCALL SUBOPT_0x19
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,12
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080001:
	RCALL __LOADLOCR6
	ADIW R28,12
	POP  R15
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	RCALL SUBOPT_0x18
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL SUBOPT_0x19
	LDI  R30,LOW(_put_usart_G101)
	LDI  R31,HIGH(_put_usart_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G101
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_key_pressed_counter_S0000000000:
	.BYTE 0x1
_key_released_counter_S0000000000:
	.BYTE 0x1
_column_S0000000000:
	.BYTE 0x1
_row_data_S0000000000:
	.BYTE 0x2
_crt_key_S0000000000:
	.BYTE 0x2
_rx_buffer:
	.BYTE 0x20
_tx_buffer:
	.BYTE 0x20
__base_y_G100:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDS  R30,_row_data_S0000000000
	LDS  R31,_row_data_S0000000000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	STS  _row_data_S0000000000,R30
	STS  _row_data_S0000000000+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDS  R26,_row_data_S0000000000
	LDS  R27,_row_data_S0000000000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:118 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	__GETWRN 18,19,0
	MOV  R20,R8
	CLR  R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CP   R18,R30
	CPC  R19,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+12,R30
	STD  Y+12+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	MOVW R26,R28
	SUBI R26,LOW(-(157))
	SBCI R27,HIGH(-(157))
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
	CBI  0x18,0
	__POINTW1FN _0x0,118
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
	CBI  0x18,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0xA:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	MOVW R26,R28
	ADIW R26,18
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,375
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
	MOVW R26,R28
	ADIW R26,6
	RCALL _lcd_puts
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	RCALL _lcd_putchar
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	RCALL _lcd_putchar
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
	__POINTW1FN _0x0,243
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 369
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ADIW R26,4
	__GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x14:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x15:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	__ADDW2R15
	MOVW R16,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	__ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	PUSH R26
	PUSH R27
	MOVW R26,R22
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	POP  R27
	POP  R26
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETW1Z:
	PUSH R0
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	POP  R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xE66
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:

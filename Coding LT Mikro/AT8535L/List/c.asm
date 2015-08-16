
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8535L
;Program type             : Application
;Clock frequency          : 12.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 128 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega8535L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 607
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU __SRAM_END=0x025F
	.EQU __DSTACK_SIZE=0x0080
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
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
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
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
	.DEF _dd0=R5
	.DEF _dd1=R4
	.DEF _dd2=R7
	.DEF _dd3=R6
	.DEF _dat=R9
	.DEF _dut=R8
	.DEF _sayap=R11
	.DEF _sensor=R10
	.DEF _x=R13
	.DEF __lcd_x=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x5E,0x50,0x49,0x44,0x20,0x26,0x20,0x4F
	.DB  0x74,0x68,0x65,0x72,0x5E,0x0,0x31,0x2E
	.DB  0x53,0x65,0x74,0x74,0x20,0x50,0x49,0x44
	.DB  0x0,0x32,0x2E,0x53,0x65,0x74,0x74,0x20
	.DB  0x53,0x70,0x65,0x65,0x64,0x0,0x33,0x2E
	.DB  0x53,0x65,0x74,0x74,0x20,0x41,0x44,0x43
	.DB  0x0,0x34,0x2E,0x52,0x65,0x73,0x65,0x74
	.DB  0x20,0x45,0x45,0x50,0x52,0x4F,0x4D,0x0
	.DB  0x52,0x65,0x73,0x65,0x74,0x20,0x53,0x75
	.DB  0x63,0x63,0x65,0x73,0x73,0x85,0x0,0x6B
	.DB  0x70,0x3A,0x25,0x64,0x20,0x0,0x6B,0x69
	.DB  0x3A,0x25,0x64,0x20,0x0,0x6B,0x64,0x3A
	.DB  0x25,0x64,0x20,0x0,0x54,0x73,0x3A,0x25
	.DB  0x64,0x20,0x0,0x53,0x70,0x65,0x65,0x64
	.DB  0x3A,0x25,0x64,0x20,0x0,0x53,0x45,0x4E
	.DB  0x53,0x3A,0x0,0x41,0x44,0x43,0x5F,0x25
	.DB  0x64,0x3D,0x25,0x33,0x64,0x20,0x2C,0x20
	.DB  0x25,0x33,0x64,0x0,0x6B,0x70,0x20,0x6B
	.DB  0x69,0x20,0x6B,0x64,0x0,0x25,0x33,0x64
	.DB  0x20,0x25,0x33,0x64,0x20,0x25,0x35,0x64
	.DB  0x0,0x53,0x70,0x65,0x65,0x64,0x20,0x54
	.DB  0x73,0x0,0x25,0x33,0x64,0x20,0x25,0x64
	.DB  0x0,0x52,0x65,0x61,0x64,0x20,0x43,0x6F
	.DB  0x6D,0x70,0x6C,0x65,0x74,0x65,0x0,0x54
	.DB  0x45,0x4B,0x41,0x4E,0x20,0x4F,0x4B,0x21
	.DB  0x0,0x4C,0x25,0x33,0x64,0x20,0x52,0x25
	.DB  0x33,0x64,0x20,0x70,0x25,0x33,0x64,0x0
	.DB  0x53,0x63,0x61,0x6E,0x20,0x47,0x61,0x72
	.DB  0x69,0x73,0x0,0x48,0x69,0x74,0x61,0x6D
	.DB  0x0,0x50,0x75,0x74,0x69,0x68,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xE0

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 29-Aug-2015
;Author  : flo
;Company : syndrome
;Comments:
;
;
;Chip type               : ATmega8535L
;Program type            : Application
;AVR Core Clock frequency: 12.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 128
;*****************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;#include <stdio.h>
;
;#define down PINB.3
;#define up PINB.2
;#define cancel PINB.1
;#define ok PINB.0
;#define Lampu PORTD.7
;#define Lpwm OCR1B
;#define Rpwm OCR1A
;#define Low 50
;#define High 150
;#define Mid 100
;
;eeprom unsigned char kp=0;
;eeprom unsigned char ki=0;
;eeprom unsigned char kd=0;
;eeprom unsigned char ts=0;
;eeprom unsigned char max_speed=0;
;eeprom unsigned char B[8];
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;char data[33];
;
;#define ADC_VREF_TYPE 0x60
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0038 {

	.CSEG
_read_adc:
; 0000 0039 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 003A // Delay needed for the stabilization of the ADC input voltage
; 0000 003B delay_us(10);
	__DELAY_USB 40
; 0000 003C // Start the AD conversion
; 0000 003D ADCSRA|=0x40;
	SBI  0x6,6
; 0000 003E // Wait for the AD conversion to complete
; 0000 003F while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0040 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0041 return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0042 }
;
;// Declare your global variables here
;float tF, pid;
;unsigned char a[8], c[8], S[8], SS[8];
;unsigned char dd0, dd1, dd2, dd3;
;unsigned char dat, dut, sayap, sensor, x;
;int P, I, D, kpF, kiF, kdF, posisi, error, last_error, max_speedF, min, m1, m2, gas,
;hasil;
;
;/********************GERAKAN RODA************************/
;void motor(unsigned char d0, unsigned char d1, unsigned char d2, unsigned char d3,
; 0000 004E unsigned char L, unsigned char R)
; 0000 004F {
_motor:
; 0000 0050 PORTD.0=d0; //m_kiri_maju
	ST   -Y,R26
;	d0 -> Y+5
;	d1 -> Y+4
;	d2 -> Y+3
;	d3 -> Y+2
;	L -> Y+1
;	R -> Y+0
	LDD  R30,Y+5
	CPI  R30,0
	BRNE _0x6
	CBI  0x12,0
	RJMP _0x7
_0x6:
	SBI  0x12,0
_0x7:
; 0000 0051 PORTD.1=d1; //m_kiri_mundur
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x8
	CBI  0x12,1
	RJMP _0x9
_0x8:
	SBI  0x12,1
_0x9:
; 0000 0052 PORTD.2=d2; //m_kanan_mundur
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0xA
	CBI  0x12,2
	RJMP _0xB
_0xA:
	SBI  0x12,2
_0xB:
; 0000 0053 PORTD.3=d3; //m_kanan_maju
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0xC
	CBI  0x12,3
	RJMP _0xD
_0xC:
	SBI  0x12,3
_0xD:
; 0000 0054 Lpwm=L; //pwm m_kiri
	LDD  R30,Y+1
	RCALL SUBOPT_0x0
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0055 Rpwm=R; //pwm m_kanan
	LD   R30,Y
	RCALL SUBOPT_0x0
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0056 }
	ADIW R28,6
	RET
;
;void off()
; 0000 0059 {
_off:
; 0000 005A PORTD.0=1;
	SBI  0x12,0
; 0000 005B PORTD.1=1;
	SBI  0x12,1
; 0000 005C PORTD.2=1;
	SBI  0x12,2
; 0000 005D PORTD.3=1;
	SBI  0x12,3
; 0000 005E Lpwm=Rpwm=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 005F }
	RET
;
;//*******************************ON_AIR SCAN*********************************************
;void scan()
; 0000 0063 {
_scan:
; 0000 0064 a[0]=read_adc(0); a[1]=read_adc(1); a[2]=read_adc(2); a[3]=read_adc(3);
	LDI  R26,LOW(0)
	RCALL _read_adc
	STS  _a,R30
	LDI  R26,LOW(1)
	RCALL _read_adc
	__PUTB1MN _a,1
	LDI  R26,LOW(2)
	RCALL _read_adc
	__PUTB1MN _a,2
	LDI  R26,LOW(3)
	RCALL _read_adc
	__PUTB1MN _a,3
; 0000 0065 a[4]=read_adc(4); a[5]=read_adc(5); a[6]=read_adc(6); a[7]=read_adc(7);
	LDI  R26,LOW(4)
	RCALL _read_adc
	__PUTB1MN _a,4
	LDI  R26,LOW(5)
	RCALL _read_adc
	__PUTB1MN _a,5
	LDI  R26,LOW(6)
	RCALL _read_adc
	__PUTB1MN _a,6
	LDI  R26,LOW(7)
	RCALL _read_adc
	__PUTB1MN _a,7
; 0000 0066 c[0]=B[0]; c[1]=B[1]; c[2]=B[2]; c[3]=B[3]; c[4]=B[4]; c[5]=B[5]; c[6]=B[6];
	LDI  R26,LOW(_B)
	LDI  R27,HIGH(_B)
	RCALL __EEPROMRDB
	STS  _c,R30
	__POINTW2MN _B,1
	RCALL __EEPROMRDB
	__PUTB1MN _c,1
	__POINTW2MN _B,2
	RCALL __EEPROMRDB
	__PUTB1MN _c,2
	__POINTW2MN _B,3
	RCALL __EEPROMRDB
	__PUTB1MN _c,3
	__POINTW2MN _B,4
	RCALL __EEPROMRDB
	__PUTB1MN _c,4
	__POINTW2MN _B,5
	RCALL __EEPROMRDB
	__PUTB1MN _c,5
	__POINTW2MN _B,6
	RCALL __EEPROMRDB
	__PUTB1MN _c,6
; 0000 0067 c[7]=B[7];
	__POINTW2MN _B,7
	RCALL __EEPROMRDB
	__PUTB1MN _c,7
; 0000 0068 
; 0000 0069 if (a[0]>c[0]) {SS[0]=Low;} if (a[0]<c[0]) {SS[0]=High;}
	RCALL SUBOPT_0x1
	CP   R30,R26
	BRSH _0x16
	LDI  R30,LOW(50)
	STS  _SS,R30
_0x16:
	RCALL SUBOPT_0x1
	CP   R26,R30
	BRSH _0x17
	LDI  R30,LOW(150)
	STS  _SS,R30
; 0000 006A if (a[1]>c[1]) {SS[1]=Low;} if (a[1]<c[1]) {SS[1]=High;}
_0x17:
	RCALL SUBOPT_0x2
	CP   R30,R26
	BRSH _0x18
	LDI  R30,LOW(50)
	__PUTB1MN _SS,1
_0x18:
	RCALL SUBOPT_0x2
	CP   R26,R30
	BRSH _0x19
	LDI  R30,LOW(150)
	__PUTB1MN _SS,1
; 0000 006B if (a[2]>c[2]) {SS[2]=Low;} if (a[2]<c[2]) {SS[2]=High;}
_0x19:
	RCALL SUBOPT_0x3
	CP   R30,R26
	BRSH _0x1A
	LDI  R30,LOW(50)
	__PUTB1MN _SS,2
_0x1A:
	RCALL SUBOPT_0x3
	CP   R26,R30
	BRSH _0x1B
	LDI  R30,LOW(150)
	__PUTB1MN _SS,2
; 0000 006C if (a[3]>c[3]) {SS[3]=Low;} if (a[3]<c[3]) {SS[3]=High;}
_0x1B:
	RCALL SUBOPT_0x4
	CP   R30,R26
	BRSH _0x1C
	LDI  R30,LOW(50)
	__PUTB1MN _SS,3
_0x1C:
	RCALL SUBOPT_0x4
	CP   R26,R30
	BRSH _0x1D
	LDI  R30,LOW(150)
	__PUTB1MN _SS,3
; 0000 006D if (a[4]>c[4]) {SS[4]=Low;} if (a[4]<c[4]) {SS[4]=High;}
_0x1D:
	RCALL SUBOPT_0x5
	CP   R30,R26
	BRSH _0x1E
	LDI  R30,LOW(50)
	__PUTB1MN _SS,4
_0x1E:
	RCALL SUBOPT_0x5
	CP   R26,R30
	BRSH _0x1F
	LDI  R30,LOW(150)
	__PUTB1MN _SS,4
; 0000 006E if (a[5]>c[5]) {SS[5]=Low;} if (a[5]<c[5]) {SS[5]=High;}
_0x1F:
	RCALL SUBOPT_0x6
	CP   R30,R26
	BRSH _0x20
	LDI  R30,LOW(50)
	__PUTB1MN _SS,5
_0x20:
	RCALL SUBOPT_0x6
	CP   R26,R30
	BRSH _0x21
	LDI  R30,LOW(150)
	__PUTB1MN _SS,5
; 0000 006F if (a[6]>c[6]) {SS[6]=Low;} if (a[6]<c[6]) {SS[6]=High;}
_0x21:
	RCALL SUBOPT_0x7
	CP   R30,R26
	BRSH _0x22
	LDI  R30,LOW(50)
	__PUTB1MN _SS,6
_0x22:
	RCALL SUBOPT_0x7
	CP   R26,R30
	BRSH _0x23
	LDI  R30,LOW(150)
	__PUTB1MN _SS,6
; 0000 0070 if (a[7]>c[7]) {SS[7]=Low;} if (a[7]<c[7]) {SS[7]=High;}
_0x23:
	RCALL SUBOPT_0x8
	CP   R30,R26
	BRSH _0x24
	LDI  R30,LOW(50)
	__PUTB1MN _SS,7
_0x24:
	RCALL SUBOPT_0x8
	CP   R26,R30
	BRSH _0x25
	LDI  R30,LOW(150)
	__PUTB1MN _SS,7
; 0000 0071 
; 0000 0072 lcd_gotoxy(6,0);
_0x25:
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x9
; 0000 0073 if (PINB.4==1) {lcd_putchar('1');} else {lcd_putchar('0');}
	SBIS 0x16,4
	RJMP _0x26
	LDI  R26,LOW(49)
	RJMP _0x112
_0x26:
	LDI  R26,LOW(48)
_0x112:
	RCALL _lcd_putchar
; 0000 0074 if (SS[0]>Mid) {S[0]=1; lcd_putchar('1');} if (SS[0]<Mid) {S[0]=0; lcd_putchar('0');}
	LDS  R26,_SS
	CPI  R26,LOW(0x65)
	BRLO _0x28
	LDI  R30,LOW(1)
	STS  _S,R30
	RCALL SUBOPT_0xA
_0x28:
	LDS  R26,_SS
	CPI  R26,LOW(0x64)
	BRSH _0x29
	LDI  R30,LOW(0)
	STS  _S,R30
	RCALL SUBOPT_0xB
; 0000 0075 if (SS[1]>Mid) {S[1]=1; lcd_putchar('1');} if (SS[1]<Mid) {S[1]=0; lcd_putchar('0');}
_0x29:
	__GETB2MN _SS,1
	CPI  R26,LOW(0x65)
	BRLO _0x2A
	LDI  R30,LOW(1)
	__PUTB1MN _S,1
	RCALL SUBOPT_0xA
_0x2A:
	__GETB2MN _SS,1
	CPI  R26,LOW(0x64)
	BRSH _0x2B
	LDI  R30,LOW(0)
	__PUTB1MN _S,1
	RCALL SUBOPT_0xB
; 0000 0076 if (SS[2]>Mid) {S[2]=1; lcd_putchar('1');} if (SS[2]<Mid) {S[2]=0; lcd_putchar('0');}
_0x2B:
	__GETB2MN _SS,2
	CPI  R26,LOW(0x65)
	BRLO _0x2C
	LDI  R30,LOW(1)
	__PUTB1MN _S,2
	RCALL SUBOPT_0xA
_0x2C:
	__GETB2MN _SS,2
	CPI  R26,LOW(0x64)
	BRSH _0x2D
	LDI  R30,LOW(0)
	__PUTB1MN _S,2
	RCALL SUBOPT_0xB
; 0000 0077 if (SS[3]>Mid) {S[3]=1; lcd_putchar('1');} if (SS[3]<Mid) {S[3]=0; lcd_putchar('0');}
_0x2D:
	__GETB2MN _SS,3
	CPI  R26,LOW(0x65)
	BRLO _0x2E
	LDI  R30,LOW(1)
	__PUTB1MN _S,3
	RCALL SUBOPT_0xA
_0x2E:
	__GETB2MN _SS,3
	CPI  R26,LOW(0x64)
	BRSH _0x2F
	LDI  R30,LOW(0)
	__PUTB1MN _S,3
	RCALL SUBOPT_0xB
; 0000 0078 if (SS[4]>Mid) {S[4]=1; lcd_putchar('1');} if (SS[4]<Mid) {S[4]=0; lcd_putchar('0');}
_0x2F:
	__GETB2MN _SS,4
	CPI  R26,LOW(0x65)
	BRLO _0x30
	LDI  R30,LOW(1)
	__PUTB1MN _S,4
	RCALL SUBOPT_0xA
_0x30:
	__GETB2MN _SS,4
	CPI  R26,LOW(0x64)
	BRSH _0x31
	LDI  R30,LOW(0)
	__PUTB1MN _S,4
	RCALL SUBOPT_0xB
; 0000 0079 if (SS[5]>Mid) {S[5]=1; lcd_putchar('1');} if (SS[5]<Mid) {S[5]=0; lcd_putchar('0');}
_0x31:
	__GETB2MN _SS,5
	CPI  R26,LOW(0x65)
	BRLO _0x32
	LDI  R30,LOW(1)
	__PUTB1MN _S,5
	RCALL SUBOPT_0xA
_0x32:
	__GETB2MN _SS,5
	CPI  R26,LOW(0x64)
	BRSH _0x33
	LDI  R30,LOW(0)
	__PUTB1MN _S,5
	RCALL SUBOPT_0xB
; 0000 007A if (SS[6]>Mid) {S[6]=1; lcd_putchar('1');} if (SS[6]<Mid) {S[6]=0; lcd_putchar('0');}
_0x33:
	__GETB2MN _SS,6
	CPI  R26,LOW(0x65)
	BRLO _0x34
	LDI  R30,LOW(1)
	__PUTB1MN _S,6
	RCALL SUBOPT_0xA
_0x34:
	__GETB2MN _SS,6
	CPI  R26,LOW(0x64)
	BRSH _0x35
	LDI  R30,LOW(0)
	__PUTB1MN _S,6
	RCALL SUBOPT_0xB
; 0000 007B if (SS[7]>Mid) {S[7]=1; lcd_putchar('1');} if (SS[7]<Mid) {S[7]=0; lcd_putchar('0');}
_0x35:
	__GETB2MN _SS,7
	CPI  R26,LOW(0x65)
	BRLO _0x36
	LDI  R30,LOW(1)
	__PUTB1MN _S,7
	RCALL SUBOPT_0xA
_0x36:
	__GETB2MN _SS,7
	CPI  R26,LOW(0x64)
	BRSH _0x37
	LDI  R30,LOW(0)
	__PUTB1MN _S,7
	RCALL SUBOPT_0xB
; 0000 007C if (PINB.5==1) {lcd_putchar('1');} else {lcd_putchar('0');}
_0x37:
	SBIS 0x16,5
	RJMP _0x38
	LDI  R26,LOW(49)
	RJMP _0x113
_0x38:
	LDI  R26,LOW(48)
_0x113:
	RCALL _lcd_putchar
; 0000 007D 
; 0000 007E dat=(S[7]*128)+(S[6]*64)+(S[5]*32)+(S[4]*16)+(S[3]*8)+(S[2]*4)+(S[1]*2)+(S[0]*
; 0000 007F 1);
	__GETB1MN _S,7
	LDI  R26,LOW(128)
	MULS R30,R26
	MOV  R22,R0
	__GETB1MN _S,6
	LDI  R26,LOW(64)
	MULS R30,R26
	MOVW R30,R0
	ADD  R22,R30
	__GETB1MN _S,5
	LDI  R26,LOW(32)
	MULS R30,R26
	MOVW R30,R0
	ADD  R22,R30
	__GETB1MN _S,4
	LDI  R26,LOW(16)
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R22
	ADD  R26,R30
	__GETB1MN _S,3
	LSL  R30
	LSL  R30
	LSL  R30
	ADD  R26,R30
	__GETB1MN _S,2
	LSL  R30
	LSL  R30
	ADD  R26,R30
	__GETB1MN _S,1
	LSL  R30
	ADD  R30,R26
	LDS  R26,_S
	ADD  R30,R26
	MOV  R9,R30
; 0000 0080 sensor=dat;
	MOV  R10,R9
; 0000 0081 dut=(PINB.4*2)+(PINB.5*1);
	LDI  R26,0
	SBIC 0x16,4
	LDI  R26,1
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOV  R22,R0
	LDI  R26,0
	SBIC 0x16,5
	LDI  R26,1
	LDI  R30,LOW(1)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R30,R22
	MOV  R8,R30
; 0000 0082 sayap=dut;
	MOV  R11,R8
; 0000 0083 }
	RET
;
;/********************DISPLAY SETTING************************/
;void display()
; 0000 0087 {
_display:
; 0000 0088 warning1:
_0x3A:
; 0000 0089 delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("^PID & Other^");
	RCALL SUBOPT_0xC
	__POINTW2FN _0x0,0
	RCALL _lcd_putsf
; 0000 008A if (ok==0) { goto warning2; }
	SBIS 0x16,0
	RJMP _0x3C
; 0000 008B if (cancel==0) { goto start; }
	SBIS 0x16,1
	RJMP _0x3E
; 0000 008C goto warning1;
	RJMP _0x3A
; 0000 008D 
; 0000 008E warning2:
_0x3C:
; 0000 008F delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("1.Sett PID");
	RCALL SUBOPT_0xC
	__POINTW2FN _0x0,14
	RCALL _lcd_putsf
; 0000 0090 if (up==0) { goto warning5; }
	SBIS 0x16,2
	RJMP _0x40
; 0000 0091 if (down==0) { goto warning3; }
	SBIS 0x16,3
	RJMP _0x42
; 0000 0092 if (ok==0) { goto set_kp; }
	SBIS 0x16,0
	RJMP _0x44
; 0000 0093 if (cancel==0) { goto warning1; }
	SBIS 0x16,1
	RJMP _0x3A
; 0000 0094 goto warning2;
	RJMP _0x3C
; 0000 0095 
; 0000 0096 warning3:
_0x42:
; 0000 0097 delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("2.Sett Speed");
	RCALL SUBOPT_0xC
	__POINTW2FN _0x0,25
	RCALL _lcd_putsf
; 0000 0098 if (up==0) { goto warning2; }
	SBIS 0x16,2
	RJMP _0x3C
; 0000 0099 if (down==0) { goto warning4; }
	SBIS 0x16,3
	RJMP _0x48
; 0000 009A if (ok==0) { goto set_MAXspeed; }
	SBIS 0x16,0
	RJMP _0x4A
; 0000 009B if (cancel==0) { goto warning1; }
	SBIS 0x16,1
	RJMP _0x3A
; 0000 009C goto warning3;
	RJMP _0x42
; 0000 009D 
; 0000 009E warning4:
_0x48:
; 0000 009F delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("3.Sett ADC");
	RCALL SUBOPT_0xC
	__POINTW2FN _0x0,38
	RCALL _lcd_putsf
; 0000 00A0 if (up==0) { goto warning3; }
	SBIS 0x16,2
	RJMP _0x42
; 0000 00A1 if (down==0) { goto warning5; }
	SBIS 0x16,3
	RJMP _0x40
; 0000 00A2 if (ok==0) { delay_ms(100); lcd_clear(); goto disp; }
	SBIC 0x16,0
	RJMP _0x4E
	RCALL SUBOPT_0xD
	RJMP _0x4F
; 0000 00A3 if (cancel==0) { goto warning1; }
_0x4E:
	SBIS 0x16,1
	RJMP _0x3A
; 0000 00A4 goto warning4;
	RJMP _0x48
; 0000 00A5 
; 0000 00A6 warning5:
_0x40:
; 0000 00A7 delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("4.Reset EEPROM");
	RCALL SUBOPT_0xC
	__POINTW2FN _0x0,49
	RCALL _lcd_putsf
; 0000 00A8 if (up==0) { goto warning4; }
	SBIS 0x16,2
	RJMP _0x48
; 0000 00A9 if (down==0) { goto warning2; }
	SBIS 0x16,3
	RJMP _0x3C
; 0000 00AA if (ok==0) {
	SBIC 0x16,0
	RJMP _0x53
; 0000 00AB kp=ki=kd=max_speed=ts=B[0]=B[1]=B[2]=B[3]=B[4]=B[5]=B[6]=B[7]=0;
	__POINTW1MN _B,1
	PUSH R31
	PUSH R30
	__POINTW1MN _B,2
	PUSH R31
	PUSH R30
	__POINTW1MN _B,3
	PUSH R31
	PUSH R30
	__POINTWRMN 22,23,_B,4
	__POINTW1MN _B,5
	MOVW R0,R30
	__POINTW2MN _B,7
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	__POINTW2MN _B,6
	RCALL __EEPROMWRB
	MOVW R26,R0
	RCALL __EEPROMWRB
	MOVW R26,R22
	RCALL __EEPROMWRB
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
	LDI  R26,LOW(_B)
	LDI  R27,HIGH(_B)
	RCALL __EEPROMWRB
	RCALL SUBOPT_0xE
	RCALL __EEPROMWRB
	RCALL SUBOPT_0xF
	RCALL __EEPROMWRB
	RCALL SUBOPT_0x10
	RCALL __EEPROMWRB
	RCALL SUBOPT_0x11
	RCALL __EEPROMWRB
	RCALL SUBOPT_0x12
	RCALL __EEPROMWRB
; 0000 00AC lcd_gotoxy(0,0); lcd_putsf("Reset Success…"); delay_ms(500); lcd_clear();
	RCALL SUBOPT_0x13
	__POINTW2FN _0x0,64
	RCALL SUBOPT_0x14
; 0000 00AD }
; 0000 00AE if (cancel==0) { goto warning1; }
_0x53:
	SBIS 0x16,1
	RJMP _0x3A
; 0000 00AF goto warning5;
	RJMP _0x40
; 0000 00B0 
; 0000 00B1 //*******************************SETT PID*********************************************
; 0000 00B2 set_kp:
_0x44:
; 0000 00B3 delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); sprintf(data,"kp:%d ",kp);
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x15
	__POINTW1FN _0x0,79
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
; 0000 00B4 lcd_puts(data);
; 0000 00B5 if (up==0) { delay_ms(1); if (kp<255) {kp++;} }
	SBIC 0x16,2
	RJMP _0x55
	RCALL SUBOPT_0x19
	CPI  R30,LOW(0xFF)
	BRSH _0x56
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1A
_0x56:
; 0000 00B6 if (down==0) { delay_ms(1); if (kp>0) {kp--;} }
_0x55:
	SBIC 0x16,3
	RJMP _0x57
	RCALL SUBOPT_0x19
	CPI  R30,LOW(0x1)
	BRLO _0x58
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1B
_0x58:
; 0000 00B7 if (ok==0) { goto set_ki; }
_0x57:
	SBIS 0x16,0
	RJMP _0x5A
; 0000 00B8 if (cancel==0) { goto warning2; }
	SBIS 0x16,1
	RJMP _0x3C
; 0000 00B9 goto set_kp;
	RJMP _0x44
; 0000 00BA 
; 0000 00BB set_ki:
_0x5A:
; 0000 00BC delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); sprintf(data,"ki:%d ",ki); lcd_puts(data);
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x15
	__POINTW1FN _0x0,86
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x18
; 0000 00BD if (up==0) { delay_ms(1); if (ki<255) {ki++;} }
	SBIC 0x16,2
	RJMP _0x5C
	RCALL SUBOPT_0x1D
	CPI  R30,LOW(0xFF)
	BRSH _0x5D
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1A
_0x5D:
; 0000 00BE if (down==0) { delay_ms(1); if (ki>0) {ki--;} }
_0x5C:
	SBIC 0x16,3
	RJMP _0x5E
	RCALL SUBOPT_0x1D
	CPI  R30,LOW(0x1)
	BRLO _0x5F
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1B
_0x5F:
; 0000 00BF if (ok==0) { goto set_kd; }
_0x5E:
	SBIS 0x16,0
	RJMP _0x61
; 0000 00C0 if (cancel==0) { goto set_kp; }
	SBIS 0x16,1
	RJMP _0x44
; 0000 00C1 goto set_ki;
	RJMP _0x5A
; 0000 00C2 
; 0000 00C3 set_kd:
_0x61:
; 0000 00C4 delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); sprintf(data,"kd:%d ",kd);
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x15
	__POINTW1FN _0x0,93
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x18
; 0000 00C5 lcd_puts(data);
; 0000 00C6 if (up==0) { delay_ms(1); if (kd<255) {kd++;} }
	SBIC 0x16,2
	RJMP _0x63
	RCALL SUBOPT_0x1F
	CPI  R30,LOW(0xFF)
	BRSH _0x64
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1A
_0x64:
; 0000 00C7 if (down==0) { delay_ms(1); if (kd>0) {kd--;} }
_0x63:
	SBIC 0x16,3
	RJMP _0x65
	RCALL SUBOPT_0x1F
	CPI  R30,LOW(0x1)
	BRLO _0x66
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1B
_0x66:
; 0000 00C8 if (ok==0) { goto set_ts; }
_0x65:
	SBIS 0x16,0
	RJMP _0x68
; 0000 00C9 if (cancel==0) { goto set_ki; }
	SBIS 0x16,1
	RJMP _0x5A
; 0000 00CA goto set_kd;
	RJMP _0x61
; 0000 00CB 
; 0000 00CC set_ts:
_0x68:
; 0000 00CD delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); sprintf(data,"Ts:%d ",ts);
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x15
	__POINTW1FN _0x0,100
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x18
; 0000 00CE lcd_puts(data);
; 0000 00CF if (up==0) { delay_ms(1); if (ts<50) {ts++;} }
	SBIC 0x16,2
	RJMP _0x6A
	RCALL SUBOPT_0x21
	CPI  R30,LOW(0x32)
	BRSH _0x6B
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x1A
_0x6B:
; 0000 00D0 if (down==0) { delay_ms(1); if (ts>0) {ts--;} }
_0x6A:
	SBIC 0x16,3
	RJMP _0x6C
	RCALL SUBOPT_0x21
	CPI  R30,LOW(0x1)
	BRLO _0x6D
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x1B
_0x6D:
; 0000 00D1 if (ok==0) { goto set_kp; }
_0x6C:
	SBIS 0x16,0
	RJMP _0x44
; 0000 00D2 if (cancel==0) { goto set_kd; }
	SBIS 0x16,1
	RJMP _0x61
; 0000 00D3 goto set_ts;
	RJMP _0x68
; 0000 00D4 
; 0000 00D5 //*******************************SETT SPEDD*********************************************
; 0000 00D6 set_MAXspeed:
_0x4A:
; 0000 00D7 delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); sprintf(data,"Speed:%d ",max_speed);
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x15
	__POINTW1FN _0x0,107
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x18
; 0000 00D8 lcd_puts(data);
; 0000 00D9 if (up==0) { delay_ms(1); if (max_speed<255) {max_speed+=5;} }
	SBIC 0x16,2
	RJMP _0x70
	RCALL SUBOPT_0x23
	CPI  R30,LOW(0xFF)
	BRSH _0x71
	RCALL SUBOPT_0x22
	SUBI R30,-LOW(5)
	RCALL SUBOPT_0xF
	RCALL __EEPROMWRB
_0x71:
; 0000 00DA if (down==0) { delay_ms(1); if (max_speed>0) {max_speed-=5;} }
_0x70:
	SBIC 0x16,3
	RJMP _0x72
	RCALL SUBOPT_0x23
	CPI  R30,LOW(0x1)
	BRLO _0x73
	RCALL SUBOPT_0x22
	SUBI R30,LOW(5)
	RCALL SUBOPT_0xF
	RCALL __EEPROMWRB
_0x73:
; 0000 00DB if (cancel==0) { goto warning3; }
_0x72:
	SBIS 0x16,1
	RJMP _0x42
; 0000 00DC goto set_MAXspeed;
	RJMP _0x4A
; 0000 00DD 
; 0000 00DE //*******************************SETT ADC*********************************************
; 0000 00DF disp: //01234567
_0x4F:
; 0000 00E0 lcd_gotoxy(0,0); lcd_putsf("SENS:");
	RCALL SUBOPT_0x13
	__POINTW2FN _0x0,117
	RCALL _lcd_putsf
; 0000 00E1 scan();
	RCALL _scan
; 0000 00E2 if (ok==0) {x=0; goto settadc;}
	SBIC 0x16,0
	RJMP _0x75
	CLR  R13
	RJMP _0x76
; 0000 00E3 if (cancel==0) {goto warning4;}
_0x75:
	SBIS 0x16,1
	RJMP _0x48
; 0000 00E4 goto disp;
	RJMP _0x4F
; 0000 00E5 
; 0000 00E6 settadc: //01234567
_0x76:
; 0000 00E7 delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); sprintf(data,"ADC_%d=%3d , %3d", x,
	RCALL SUBOPT_0xC
; 0000 00E8 read_adc(x), B[x] ); lcd_puts(data);
	RCALL SUBOPT_0x15
	__POINTW1FN _0x0,123
	RCALL SUBOPT_0x16
	MOV  R30,R13
	RCALL SUBOPT_0x24
	RCALL _read_adc
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	SUBI R26,LOW(-_B)
	SBCI R27,HIGH(-_B)
	RCALL __EEPROMRDB
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL SUBOPT_0x26
; 0000 00E9 read_adc(x);
	MOV  R26,R13
	RCALL _read_adc
; 0000 00EA if (ok==0) {delay_ms(150); B[x]=read_adc(x);}
	SBIC 0x16,0
	RJMP _0x78
	RCALL SUBOPT_0x27
	MOV  R30,R13
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_B)
	SBCI R31,HIGH(-_B)
	PUSH R31
	PUSH R30
	MOV  R26,R13
	RCALL _read_adc
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
; 0000 00EB if (cancel==0) {delay_ms(150); lcd_clear(); goto disp;}
_0x78:
	SBIC 0x16,1
	RJMP _0x79
	RCALL SUBOPT_0x27
	RCALL _lcd_clear
	RJMP _0x4F
; 0000 00EC 
; 0000 00ED if (up==0) {delay_ms(150); if (x<7) {x++;}
_0x79:
	SBIC 0x16,2
	RJMP _0x7A
	RCALL SUBOPT_0x27
	LDI  R30,LOW(7)
	CP   R13,R30
	BRSH _0x7B
	INC  R13
; 0000 00EE }
_0x7B:
; 0000 00EF 
; 0000 00F0 if (down==0) {delay_ms(150); if (x>0) {x--;}
_0x7A:
	SBIC 0x16,3
	RJMP _0x7C
	RCALL SUBOPT_0x27
	LDI  R30,LOW(0)
	CP   R30,R13
	BRSH _0x7D
	DEC  R13
; 0000 00F1 }
_0x7D:
; 0000 00F2 goto settadc;
_0x7C:
	RJMP _0x76
; 0000 00F3 
; 0000 00F4 //*******************************START****************************
; 0000 00F5 start:
_0x3E:
; 0000 00F6 delay_ms(100); lcd_clear(); x=0;
	RCALL SUBOPT_0xD
	CLR  R13
; 0000 00F7 
; 0000 00F8 }
	RET
;
;//*******************************WRITE ALL*********************************************
;void write_all()
; 0000 00FC {lcd_gotoxy(0,0);
_write_all:
	RCALL SUBOPT_0x13
; 0000 00FD kpF=kp*5; lcd_putchar('R'); delay_ms(10);
	RCALL SUBOPT_0x17
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	STS  _kpF,R30
	STS  _kpF+1,R31
	LDI  R26,LOW(82)
	RCALL _lcd_putchar
	LDI  R26,LOW(10)
	RCALL SUBOPT_0x28
; 0000 00FE kiF=ki;   lcd_putchar('E'); delay_ms(20);
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x0
	STS  _kiF,R30
	STS  _kiF+1,R31
	LDI  R26,LOW(69)
	RCALL _lcd_putchar
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x28
; 0000 00FF kdF=kd; lcd_putchar('A'); delay_ms(30);
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x0
	STS  _kdF,R30
	STS  _kdF+1,R31
	LDI  R26,LOW(65)
	RCALL _lcd_putchar
	LDI  R26,LOW(30)
	RCALL SUBOPT_0x28
; 0000 0100 tF = (float) ts / (float) 10; lcd_putchar('D'); delay_ms(40);
	RCALL SUBOPT_0x20
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL SUBOPT_0x29
	__GETD1N 0x41200000
	RCALL __DIVF21
	STS  _tF,R30
	STS  _tF+1,R31
	STS  _tF+2,R22
	STS  _tF+3,R23
	LDI  R26,LOW(68)
	RCALL _lcd_putchar
	LDI  R26,LOW(40)
	RCALL SUBOPT_0x28
; 0000 0101 max_speedF=max_speed; lcd_putchar('_'); delay_ms(50);
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x0
	STS  _max_speedF,R30
	STS  _max_speedF+1,R31
	LDI  R26,LOW(95)
	RCALL _lcd_putchar
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x28
; 0000 0102 min=0-max_speed; lcd_putchar('E'); delay_ms(60);
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x0
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	SUB  R26,R30
	SBC  R27,R31
	STS  _min,R26
	STS  _min+1,R27
	LDI  R26,LOW(69)
	RCALL _lcd_putchar
	LDI  R26,LOW(60)
	RCALL SUBOPT_0x28
; 0000 0103 lcd_putchar('E'); delay_ms(70);
	LDI  R26,LOW(69)
	RCALL _lcd_putchar
	LDI  R26,LOW(70)
	RCALL SUBOPT_0x28
; 0000 0104 lcd_putchar('P'); delay_ms(80);
	LDI  R26,LOW(80)
	RCALL _lcd_putchar
	LDI  R26,LOW(80)
	RCALL SUBOPT_0x28
; 0000 0105 lcd_putchar('R'); delay_ms(90);
	LDI  R26,LOW(82)
	RCALL _lcd_putchar
	LDI  R26,LOW(90)
	RCALL SUBOPT_0x28
; 0000 0106 lcd_putchar('O'); delay_ms(100);
	LDI  R26,LOW(79)
	RCALL _lcd_putchar
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x28
; 0000 0107 lcd_putchar('M'); delay_ms(200); lcd_clear();
	LDI  R26,LOW(77)
	RCALL _lcd_putchar
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x28
	RCALL _lcd_clear
; 0000 0108 lcd_gotoxy(0,0); lcd_putsf("kp ki kd");
	RCALL SUBOPT_0x13
	__POINTW2FN _0x0,140
	RCALL SUBOPT_0x2A
; 0000 0109 lcd_gotoxy(0,1); sprintf(data,"%3d %3d %5d", kpF, kiF, kdF); lcd_puts(data);
	__POINTW1FN _0x0,149
	RCALL SUBOPT_0x16
	LDS  R30,_kpF
	LDS  R31,_kpF+1
	RCALL SUBOPT_0x2B
	LDS  R30,_kiF
	LDS  R31,_kiF+1
	RCALL SUBOPT_0x2B
	LDS  R30,_kdF
	LDS  R31,_kdF+1
	RCALL SUBOPT_0x2C
; 0000 010A delay_ms(500); lcd_clear();
	RCALL SUBOPT_0x2D
; 0000 010B lcd_gotoxy(0,0); lcd_putsf("Speed Ts");
	__POINTW2FN _0x0,161
	RCALL SUBOPT_0x2A
; 0000 010C lcd_gotoxy(0,1); sprintf(data,"%3d %d", max_speedF, (int)tF); lcd_puts(data);
	__POINTW1FN _0x0,170
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x2F
	RCALL __CFD1
	RCALL SUBOPT_0x2B
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
	RCALL SUBOPT_0x30
; 0000 010D delay_ms(500); lcd_clear();
	RCALL SUBOPT_0x2D
; 0000 010E lcd_gotoxy(0,0); lcd_putsf("Read Complete"); delay_ms(500); lcd_clear();
	__POINTW2FN _0x0,177
	RCALL SUBOPT_0x14
; 0000 010F }
	RET
;
;//*******************************ON_AIR****************************
;void program()
; 0000 0113 {
_program:
; 0000 0114 pilih:
_0x7E:
; 0000 0115 lcd_gotoxy(0,1); lcd_putsf("TEKAN OK!");
	RCALL SUBOPT_0x31
	__POINTW2FN _0x0,191
	RCALL _lcd_putsf
; 0000 0116 if (ok==0 && x==150) {lcd_clear(); goto hitam;}
	RCALL SUBOPT_0x32
	BRNE _0x80
	LDI  R30,LOW(150)
	CP   R30,R13
	BREQ _0x81
_0x80:
	RJMP _0x7F
_0x81:
	RCALL _lcd_clear
	RJMP _0x82
; 0000 0117 if (ok==0 && x==200) {lcd_clear(); goto putih;}
_0x7F:
	RCALL SUBOPT_0x32
	BRNE _0x84
	LDI  R30,LOW(200)
	CP   R30,R13
	BREQ _0x85
_0x84:
	RJMP _0x83
_0x85:
	RCALL _lcd_clear
	RJMP _0x86
; 0000 0118 goto pilih;
_0x83:
	RJMP _0x7E
; 0000 0119 
; 0000 011A hitam:
_0x82:
; 0000 011B Lampu=0;
	CBI  0x12,7
; 0000 011C lcd_gotoxy(0,0); sprintf(data,"%5d", hasil); lcd_puts(data);
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x34
; 0000 011D lcd_gotoxy(0,1); sprintf(data,"L%3d R%3d p%3d", m1, m2, posisi); lcd_puts(data);
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x2C
; 0000 011E scan();
	RCALL _scan
; 0000 011F if (sensor==0b11111110) {posisi=7;} // +error ujung kiri
	LDI  R30,LOW(254)
	CP   R30,R10
	BRNE _0x89
	RCALL SUBOPT_0x38
; 0000 0120 if (sensor==0b11111101) {posisi=5;}
_0x89:
	LDI  R30,LOW(253)
	CP   R30,R10
	BRNE _0x8A
	RCALL SUBOPT_0x39
; 0000 0121 if (sensor==0b11111011) {posisi=3;}
_0x8A:
	LDI  R30,LOW(251)
	CP   R30,R10
	BRNE _0x8B
	RCALL SUBOPT_0x3A
; 0000 0122 if (sensor==0b11110111) {posisi=1;}
_0x8B:
	LDI  R30,LOW(247)
	CP   R30,R10
	BRNE _0x8C
	RCALL SUBOPT_0x3B
; 0000 0123 if (sensor==0b11101111) {posisi=-1;}
_0x8C:
	LDI  R30,LOW(239)
	CP   R30,R10
	BRNE _0x8D
	RCALL SUBOPT_0x3C
; 0000 0124 if (sensor==0b11011111) {posisi=-3;}
_0x8D:
	LDI  R30,LOW(223)
	CP   R30,R10
	BRNE _0x8E
	RCALL SUBOPT_0x3D
; 0000 0125 if (sensor==0b10111111) {posisi=-5;}
_0x8E:
	LDI  R30,LOW(191)
	CP   R30,R10
	BRNE _0x8F
	RCALL SUBOPT_0x3E
; 0000 0126 if (sensor==0b01111111) {posisi=-7;} // -error ujung kanan
_0x8F:
	LDI  R30,LOW(127)
	CP   R30,R10
	BRNE _0x90
	RCALL SUBOPT_0x3F
; 0000 0127 
; 0000 0128 if (sensor==0b11111100) {posisi=6;}
_0x90:
	LDI  R30,LOW(252)
	CP   R30,R10
	BRNE _0x91
	RCALL SUBOPT_0x40
; 0000 0129 if (sensor==0b11111001) {posisi=4;}
_0x91:
	LDI  R30,LOW(249)
	CP   R30,R10
	BRNE _0x92
	RCALL SUBOPT_0x41
; 0000 012A if (sensor==0b11110011) {posisi=2;}
_0x92:
	LDI  R30,LOW(243)
	CP   R30,R10
	BRNE _0x93
	RCALL SUBOPT_0x42
; 0000 012B if (sensor==0b11100111) {posisi=0;} //tengah
_0x93:
	LDI  R30,LOW(231)
	CP   R30,R10
	BRNE _0x94
	RCALL SUBOPT_0x43
; 0000 012C if (sensor==0b11001111) {posisi=-2;}
_0x94:
	LDI  R30,LOW(207)
	CP   R30,R10
	BRNE _0x95
	RCALL SUBOPT_0x44
; 0000 012D if (sensor==0b10011111) {posisi=-4;}
_0x95:
	LDI  R30,LOW(159)
	CP   R30,R10
	BRNE _0x96
	RCALL SUBOPT_0x45
; 0000 012E if (sensor==0b00111111) {posisi=-6;}
_0x96:
	LDI  R30,LOW(63)
	CP   R30,R10
	BRNE _0x97
	RCALL SUBOPT_0x46
; 0000 012F 
; 0000 0130 if (sensor==0b11111000) {posisi=5;}
_0x97:
	LDI  R30,LOW(248)
	CP   R30,R10
	BRNE _0x98
	RCALL SUBOPT_0x39
; 0000 0131 if (sensor==0b11110001) {posisi=3;}
_0x98:
	LDI  R30,LOW(241)
	CP   R30,R10
	BRNE _0x99
	RCALL SUBOPT_0x3A
; 0000 0132 if (sensor==0b11100011) {posisi=1;}
_0x99:
	LDI  R30,LOW(227)
	CP   R30,R10
	BRNE _0x9A
	RCALL SUBOPT_0x3B
; 0000 0133 if (sensor==0b11000111) {posisi=-1;}
_0x9A:
	LDI  R30,LOW(199)
	CP   R30,R10
	BRNE _0x9B
	RCALL SUBOPT_0x3C
; 0000 0134 if (sensor==0b10001111) {posisi=-3;}
_0x9B:
	LDI  R30,LOW(143)
	CP   R30,R10
	BRNE _0x9C
	RCALL SUBOPT_0x3D
; 0000 0135 if (sensor==0b00011111) {posisi=-5;}
_0x9C:
	LDI  R30,LOW(31)
	CP   R30,R10
	BRNE _0x9D
	RCALL SUBOPT_0x3E
; 0000 0136 
; 0000 0137 if (sensor==0b11110000) {posisi=6;}
_0x9D:
	LDI  R30,LOW(240)
	CP   R30,R10
	BRNE _0x9E
	RCALL SUBOPT_0x40
; 0000 0138 if (sensor==0b11100001) {posisi=5;}
_0x9E:
	LDI  R30,LOW(225)
	CP   R30,R10
	BRNE _0x9F
	RCALL SUBOPT_0x39
; 0000 0139 if (sensor==0b11000011) {posisi=0;}
_0x9F:
	LDI  R30,LOW(195)
	CP   R30,R10
	BRNE _0xA0
	RCALL SUBOPT_0x43
; 0000 013A if (sensor==0b10000111) {posisi=-5;}
_0xA0:
	LDI  R30,LOW(135)
	CP   R30,R10
	BRNE _0xA1
	RCALL SUBOPT_0x3E
; 0000 013B if (sensor==0b00001111) {posisi=-6;}
_0xA1:
	LDI  R30,LOW(15)
	CP   R30,R10
	BRNE _0xA2
	RCALL SUBOPT_0x46
; 0000 013C 
; 0000 013D if (sensor==0b11100000) {posisi=7;}
_0xA2:
	LDI  R30,LOW(224)
	CP   R30,R10
	BRNE _0xA3
	RCALL SUBOPT_0x38
; 0000 013E if (sensor==0b11000001) {posisi=6;}
_0xA3:
	LDI  R30,LOW(193)
	CP   R30,R10
	BRNE _0xA4
	RCALL SUBOPT_0x40
; 0000 013F if (sensor==0b10000011) {posisi=-6;}
_0xA4:
	LDI  R30,LOW(131)
	CP   R30,R10
	BRNE _0xA5
	RCALL SUBOPT_0x46
; 0000 0140 if (sensor==0b00000111) {posisi=-7;}
_0xA5:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0xA6
	RCALL SUBOPT_0x3F
; 0000 0141 
; 0000 0142 if (sensor==0b10000001) {posisi=0;}
_0xA6:
	LDI  R30,LOW(129)
	CP   R30,R10
	BRNE _0xA7
	RCALL SUBOPT_0x43
; 0000 0143 if (sensor==0b00000000) {posisi=0;}
_0xA7:
	TST  R10
	BRNE _0xA8
	RCALL SUBOPT_0x43
; 0000 0144 if (sensor==0b10000000) {posisi=0;}
_0xA8:
	LDI  R30,LOW(128)
	CP   R30,R10
	BRNE _0xA9
	RCALL SUBOPT_0x43
; 0000 0145 if (sensor==0b00000001) {posisi=0;}
_0xA9:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xAA
	RCALL SUBOPT_0x43
; 0000 0146 
; 0000 0147 if ( sensor==0b11111111 && sayap==0b01 ) {posisi=9;} //sayap kiri
_0xAA:
	RCALL SUBOPT_0x47
	BRNE _0xAC
	LDI  R30,LOW(1)
	CP   R30,R11
	BREQ _0xAD
_0xAC:
	RJMP _0xAB
_0xAD:
	RCALL SUBOPT_0x48
; 0000 0148 if ( sensor==0b11111111 && sayap==0b10 ) {posisi=-9;} //sayap kanan
_0xAB:
	RCALL SUBOPT_0x47
	BRNE _0xAF
	LDI  R30,LOW(2)
	CP   R30,R11
	BREQ _0xB0
_0xAF:
	RJMP _0xAE
_0xB0:
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
; 0000 0149 
; 0000 014A if ( sensor==0b11111111 && sayap==0b11 ) //loss
_0xAE:
	RCALL SUBOPT_0x47
	BRNE _0xB2
	LDI  R30,LOW(3)
	CP   R30,R11
	BREQ _0xB3
_0xB2:
	RJMP _0xB1
_0xB3:
; 0000 014B {
; 0000 014C if ( posisi >0 && posisi < 9) { posisi = 8; }
	RCALL SUBOPT_0x4B
	RCALL __CPW02
	BRGE _0xB5
	RCALL SUBOPT_0x4C
	BRLT _0xB6
_0xB5:
	RJMP _0xB4
_0xB6:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x4A
; 0000 014D if ( posisi <0 && posisi > -9) { posisi = -8 ; }
_0xB4:
	LDS  R26,_posisi+1
	TST  R26
	BRPL _0xB8
	RCALL SUBOPT_0x4D
	BRLT _0xB9
_0xB8:
	RJMP _0xB7
_0xB9:
	LDI  R30,LOW(65528)
	LDI  R31,HIGH(65528)
	RCALL SUBOPT_0x4A
; 0000 014E 
; 0000 014F if ( posisi > 8 ) { posisi = 10; }
_0xB7:
	RCALL SUBOPT_0x4C
	BRLT _0xBA
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x4A
; 0000 0150 if ( posisi < -8 ) {posisi = -10; }
_0xBA:
	RCALL SUBOPT_0x4E
	BRGE _0xBB
	LDI  R30,LOW(65526)
	LDI  R31,HIGH(65526)
	RCALL SUBOPT_0x4A
; 0000 0151 }
_0xBB:
; 0000 0152 
; 0000 0153 error = (kpF * posisi);         //nilai error
_0xB1:
	RCALL SUBOPT_0x4F
; 0000 0154 P = error;                            //nilai P
; 0000 0155 I = kiF * (error + last_error);    //nilai I
; 0000 0156 D = kdF * (error - last_error);  //nilai D
; 0000 0157 last_error = error;                      //nilai last error
; 0000 0158 pid = (float)P + ( (float)I / (float)10000 ) + (float)D;
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x50
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x51
; 0000 0159 hasil = (int)pid;
; 0000 015A 
; 0000 015B //motor kiri
; 0000 015C m1 = max_speedF - hasil;
; 0000 015D if ( m1 > max_speedF ) {m1 = max_speedF;}
	BRGE _0xBC
	RCALL SUBOPT_0x52
; 0000 015E if ( m1 < min ) {m1 = min;}
_0xBC:
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x55
	BRGE _0xBD
	RCALL SUBOPT_0x56
; 0000 015F if ( m1 > 0 ) {dd0=1; dd1=0;} // kiri maju
_0xBD:
	RCALL SUBOPT_0x54
	RCALL __CPW02
	BRGE _0xBE
	LDI  R30,LOW(1)
	MOV  R5,R30
	CLR  R4
; 0000 0160 if ( m1 < 0 ) {dd0=0; dd1=1; gas=0-m1; m1=gas;} // kiri mundur
_0xBE:
	LDS  R26,_m1+1
	TST  R26
	BRPL _0xBF
	RCALL SUBOPT_0x57
; 0000 0161 if ( error == 0 ) {m1 = max_speedF; }
_0xBF:
	RCALL SUBOPT_0x58
	BRNE _0xC0
	RCALL SUBOPT_0x52
; 0000 0162 
; 0000 0163 //motor kanan
; 0000 0164 m2 = max_speedF + hasil;
_0xC0:
	RCALL SUBOPT_0x59
; 0000 0165 if ( m2 > max_speedF ) {m2 = max_speedF;}
	BRGE _0xC1
	RCALL SUBOPT_0x5A
; 0000 0166 if ( m2 < min ) {m2 = min;}
_0xC1:
	RCALL SUBOPT_0x5B
	BRGE _0xC2
	RCALL SUBOPT_0x5C
; 0000 0167 if ( m2 > 0 ) {dd2=0; dd3=1;} // kanan maju
_0xC2:
	RCALL SUBOPT_0x5D
	RCALL __CPW02
	BRGE _0xC3
	CLR  R7
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0168 if ( m2 < 0 ) {dd2=1; dd3=0; gas=0-m2; m2=gas;} // kanan mundur
_0xC3:
	LDS  R26,_m2+1
	TST  R26
	BRPL _0xC4
	RCALL SUBOPT_0x5E
; 0000 0169 if ( error == 0 ) {m2 = max_speedF; }
_0xC4:
	RCALL SUBOPT_0x58
	BRNE _0xC5
	RCALL SUBOPT_0x5A
; 0000 016A 
; 0000 016B motor(dd0, dd1, dd2, dd3, m1, m2); // aksi motor
_0xC5:
	RCALL SUBOPT_0x5F
; 0000 016C delay_ms(tF); // time sampling
; 0000 016D goto hitam;
	RJMP _0x82
; 0000 016E 
; 0000 016F putih:
_0x86:
; 0000 0170 Lampu=1;
	SBI  0x12,7
; 0000 0171 lcd_gotoxy(0,0); sprintf(data,"%5d", hasil); lcd_puts(data);
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x34
; 0000 0172 lcd_gotoxy(0,1); sprintf(data,"L%3d R%3d p%3d", m1, m2, posisi); lcd_puts(data);
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x2C
; 0000 0173 scan();
	RCALL _scan
; 0000 0174 if (sensor==0b00000001) {posisi=7;} // +error ujung kiri
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xC8
	RCALL SUBOPT_0x38
; 0000 0175 if (sensor==0b00000010) {posisi=5;}
_0xC8:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xC9
	RCALL SUBOPT_0x39
; 0000 0176 if (sensor==0b00000100) {posisi=3;}
_0xC9:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xCA
	RCALL SUBOPT_0x3A
; 0000 0177 if (sensor==0b00001000) {posisi=1;}
_0xCA:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0xCB
	RCALL SUBOPT_0x3B
; 0000 0178 if (sensor==0b00010000) {posisi=-1;}
_0xCB:
	LDI  R30,LOW(16)
	CP   R30,R10
	BRNE _0xCC
	RCALL SUBOPT_0x3C
; 0000 0179 if (sensor==0b00100000) {posisi=-3;}
_0xCC:
	LDI  R30,LOW(32)
	CP   R30,R10
	BRNE _0xCD
	RCALL SUBOPT_0x3D
; 0000 017A if (sensor==0b01000000) {posisi=-5;}
_0xCD:
	LDI  R30,LOW(64)
	CP   R30,R10
	BRNE _0xCE
	RCALL SUBOPT_0x3E
; 0000 017B if (sensor==0b10000000) {posisi=-7;} // -error ujung kanan
_0xCE:
	LDI  R30,LOW(128)
	CP   R30,R10
	BRNE _0xCF
	RCALL SUBOPT_0x3F
; 0000 017C 
; 0000 017D if (sensor==0b00000011) {posisi=6;}
_0xCF:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xD0
	RCALL SUBOPT_0x40
; 0000 017E if (sensor==0b00000110) {posisi=4;}
_0xD0:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0xD1
	RCALL SUBOPT_0x41
; 0000 017F if (sensor==0b00001100) {posisi=2;}
_0xD1:
	LDI  R30,LOW(12)
	CP   R30,R10
	BRNE _0xD2
	RCALL SUBOPT_0x42
; 0000 0180 if (sensor==0b00011000) {posisi=0;} //tengah
_0xD2:
	LDI  R30,LOW(24)
	CP   R30,R10
	BRNE _0xD3
	RCALL SUBOPT_0x43
; 0000 0181 if (sensor==0b00110000) {posisi=-2;}
_0xD3:
	LDI  R30,LOW(48)
	CP   R30,R10
	BRNE _0xD4
	RCALL SUBOPT_0x44
; 0000 0182 if (sensor==0b01100000) {posisi=-4;}
_0xD4:
	LDI  R30,LOW(96)
	CP   R30,R10
	BRNE _0xD5
	RCALL SUBOPT_0x45
; 0000 0183 if (sensor==0b11000000) {posisi=-6;}
_0xD5:
	LDI  R30,LOW(192)
	CP   R30,R10
	BRNE _0xD6
	RCALL SUBOPT_0x46
; 0000 0184 
; 0000 0185 if (sensor==0b00000111) {posisi=5;}
_0xD6:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0xD7
	RCALL SUBOPT_0x39
; 0000 0186 if (sensor==0b00001110) {posisi=3;}
_0xD7:
	LDI  R30,LOW(14)
	CP   R30,R10
	BRNE _0xD8
	RCALL SUBOPT_0x3A
; 0000 0187 if (sensor==0b00011100) {posisi=1;}
_0xD8:
	LDI  R30,LOW(28)
	CP   R30,R10
	BRNE _0xD9
	RCALL SUBOPT_0x3B
; 0000 0188 if (sensor==0b00111000) {posisi=-1;}
_0xD9:
	LDI  R30,LOW(56)
	CP   R30,R10
	BRNE _0xDA
	RCALL SUBOPT_0x3C
; 0000 0189 if (sensor==0b01110000) {posisi=-3;}
_0xDA:
	LDI  R30,LOW(112)
	CP   R30,R10
	BRNE _0xDB
	RCALL SUBOPT_0x3D
; 0000 018A if (sensor==0b11100000) {posisi=-5;}
_0xDB:
	LDI  R30,LOW(224)
	CP   R30,R10
	BRNE _0xDC
	RCALL SUBOPT_0x3E
; 0000 018B 
; 0000 018C if (sensor==0b00001111) {posisi=6;}
_0xDC:
	LDI  R30,LOW(15)
	CP   R30,R10
	BRNE _0xDD
	RCALL SUBOPT_0x40
; 0000 018D if (sensor==0b00011110) {posisi=5;}
_0xDD:
	LDI  R30,LOW(30)
	CP   R30,R10
	BRNE _0xDE
	RCALL SUBOPT_0x39
; 0000 018E if (sensor==0b00111100) {posisi=0;}
_0xDE:
	LDI  R30,LOW(60)
	CP   R30,R10
	BRNE _0xDF
	RCALL SUBOPT_0x43
; 0000 018F if (sensor==0b01111000) {posisi=-5;}
_0xDF:
	LDI  R30,LOW(120)
	CP   R30,R10
	BRNE _0xE0
	RCALL SUBOPT_0x3E
; 0000 0190 if (sensor==0b11110000) {posisi=-6;}
_0xE0:
	LDI  R30,LOW(240)
	CP   R30,R10
	BRNE _0xE1
	RCALL SUBOPT_0x46
; 0000 0191 
; 0000 0192 if (sensor==0b00011111) {posisi=7;}
_0xE1:
	LDI  R30,LOW(31)
	CP   R30,R10
	BRNE _0xE2
	RCALL SUBOPT_0x38
; 0000 0193 if (sensor==0b00111110) {posisi=6;}
_0xE2:
	LDI  R30,LOW(62)
	CP   R30,R10
	BRNE _0xE3
	RCALL SUBOPT_0x40
; 0000 0194 if (sensor==0b01111100) {posisi=-6;}
_0xE3:
	LDI  R30,LOW(124)
	CP   R30,R10
	BRNE _0xE4
	RCALL SUBOPT_0x46
; 0000 0195 if (sensor==0b11111000) {posisi=-7;}
_0xE4:
	LDI  R30,LOW(248)
	CP   R30,R10
	BRNE _0xE5
	RCALL SUBOPT_0x3F
; 0000 0196 
; 0000 0197 if (sensor==0b01111110) {posisi=0;}
_0xE5:
	LDI  R30,LOW(126)
	CP   R30,R10
	BRNE _0xE6
	RCALL SUBOPT_0x43
; 0000 0198 if (sensor==0b11111111) {posisi=0;}
_0xE6:
	RCALL SUBOPT_0x47
	BRNE _0xE7
	RCALL SUBOPT_0x43
; 0000 0199 if (sensor==0b01111111) {posisi=0;}
_0xE7:
	LDI  R30,LOW(127)
	CP   R30,R10
	BRNE _0xE8
	RCALL SUBOPT_0x43
; 0000 019A if (sensor==0b11111110) {posisi=0;}
_0xE8:
	LDI  R30,LOW(254)
	CP   R30,R10
	BRNE _0xE9
	RCALL SUBOPT_0x43
; 0000 019B 
; 0000 019C if ( sensor==0b00000000 && sayap==0b10 ) {posisi=9;} //sayap kiri
_0xE9:
	RCALL SUBOPT_0x60
	BRNE _0xEB
	LDI  R30,LOW(2)
	CP   R30,R11
	BREQ _0xEC
_0xEB:
	RJMP _0xEA
_0xEC:
	RCALL SUBOPT_0x48
; 0000 019D if ( sensor==0b00000000 && sayap==0b01 ) {posisi=-9;} //sayap kanan
_0xEA:
	RCALL SUBOPT_0x60
	BRNE _0xEE
	LDI  R30,LOW(1)
	CP   R30,R11
	BREQ _0xEF
_0xEE:
	RJMP _0xED
_0xEF:
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
; 0000 019E 
; 0000 019F if ( sensor==0b00000000 && sayap==0b00 ) //loss
_0xED:
	RCALL SUBOPT_0x60
	BRNE _0xF1
	LDI  R30,LOW(0)
	CP   R30,R11
	BREQ _0xF2
_0xF1:
	RJMP _0xF0
_0xF2:
; 0000 01A0 {
; 0000 01A1 if ( posisi >0 && posisi < 9) { posisi = 8; }
	RCALL SUBOPT_0x4B
	RCALL __CPW02
	BRGE _0xF4
	RCALL SUBOPT_0x4C
	BRLT _0xF5
_0xF4:
	RJMP _0xF3
_0xF5:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x4A
; 0000 01A2 if ( posisi <0 && posisi > -9) { posisi = -8 ; }
_0xF3:
	LDS  R26,_posisi+1
	TST  R26
	BRPL _0xF7
	RCALL SUBOPT_0x4D
	BRLT _0xF8
_0xF7:
	RJMP _0xF6
_0xF8:
	LDI  R30,LOW(65528)
	LDI  R31,HIGH(65528)
	RCALL SUBOPT_0x4A
; 0000 01A3 
; 0000 01A4 if ( posisi > 8 ) { posisi = 10; }
_0xF6:
	RCALL SUBOPT_0x4C
	BRLT _0xF9
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x4A
; 0000 01A5 if ( posisi < -8 ) {posisi = -10; }
_0xF9:
	RCALL SUBOPT_0x4E
	BRGE _0xFA
	LDI  R30,LOW(65526)
	LDI  R31,HIGH(65526)
	RCALL SUBOPT_0x4A
; 0000 01A6 }
_0xFA:
; 0000 01A7 
; 0000 01A8 error = (kpF * posisi);         //nilai error
_0xF0:
	RCALL SUBOPT_0x4F
; 0000 01A9 P = error;                            //nilai P
; 0000 01AA I = kiF * (error + last_error);    //nilai I
; 0000 01AB D = kdF * (error - last_error);  //nilai D
; 0000 01AC last_error = error;                      //nilai last error
; 0000 01AD pid = (float)P + ( (float)I / (float)10000 ) + (float)D;
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x50
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x51
; 0000 01AE hasil = (int)pid;
; 0000 01AF 
; 0000 01B0 //motor kiri
; 0000 01B1 m1 = max_speedF - hasil;
; 0000 01B2 if ( m1 > max_speedF ) {m1 = max_speedF;}
	BRGE _0xFB
	RCALL SUBOPT_0x52
; 0000 01B3 if ( m1 < min ) {m1 = min;}
_0xFB:
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x55
	BRGE _0xFC
	RCALL SUBOPT_0x56
; 0000 01B4 if ( m1 > 0 ) {dd0=1; dd1=0;} // kiri maju
_0xFC:
	RCALL SUBOPT_0x54
	RCALL __CPW02
	BRGE _0xFD
	LDI  R30,LOW(1)
	MOV  R5,R30
	CLR  R4
; 0000 01B5 if ( m1 < 0 ) {dd0=0; dd1=1; gas=0-m1; m1=gas;} // kiri mundur
_0xFD:
	LDS  R26,_m1+1
	TST  R26
	BRPL _0xFE
	RCALL SUBOPT_0x57
; 0000 01B6 if ( error == 0 ) {m1 = max_speedF; }
_0xFE:
	RCALL SUBOPT_0x58
	BRNE _0xFF
	RCALL SUBOPT_0x52
; 0000 01B7 
; 0000 01B8 //motor kanan
; 0000 01B9 m2 = max_speedF + hasil;
_0xFF:
	RCALL SUBOPT_0x59
; 0000 01BA if ( m2 > max_speedF ) {m2 = max_speedF;}
	BRGE _0x100
	RCALL SUBOPT_0x5A
; 0000 01BB if ( m2 < min ) {m2 = min;}
_0x100:
	RCALL SUBOPT_0x5B
	BRGE _0x101
	RCALL SUBOPT_0x5C
; 0000 01BC if ( m2 > 0 ) {dd2=0; dd3=1;} // kanan maju
_0x101:
	RCALL SUBOPT_0x5D
	RCALL __CPW02
	BRGE _0x102
	CLR  R7
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 01BD if ( m2 < 0 ) {dd2=1; dd3=0; gas=0-m2; m2=gas;} // kanan mundur
_0x102:
	LDS  R26,_m2+1
	TST  R26
	BRPL _0x103
	RCALL SUBOPT_0x5E
; 0000 01BE if ( error == 0 ) {m2 = max_speedF; }
_0x103:
	RCALL SUBOPT_0x58
	BRNE _0x104
	RCALL SUBOPT_0x5A
; 0000 01BF 
; 0000 01C0 motor(dd0, dd1, dd2, dd3, m1, m2); // aksi motor
_0x104:
	RCALL SUBOPT_0x5F
; 0000 01C1 delay_ms(tF); //time sampling
; 0000 01C2 
; 0000 01C3 goto putih;
	RJMP _0x86
; 0000 01C4 
; 0000 01C5 }
;
;//*******************************CEK WARNA TRACK*********************************************
;void baca_track()
; 0000 01C9 {
_baca_track:
; 0000 01CA lcd_gotoxy(0,1); lcd_putsf("Scan Garis");
	RCALL SUBOPT_0x31
	__POINTW2FN _0x0,216
	RCALL _lcd_putsf
; 0000 01CB scan();
	RCALL _scan
; 0000 01CC if (x<100)
	LDI  R30,LOW(100)
	CP   R13,R30
	BRSH _0x105
; 0000 01CD {x++; motor(1, 0, 1, 0, 100, 100);}
	INC  R13
	RCALL SUBOPT_0x61
	RCALL SUBOPT_0x61
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R26,LOW(100)
	RCALL _motor
; 0000 01CE 
; 0000 01CF if ( sensor==0b11111111 && x==100)
_0x105:
	RCALL SUBOPT_0x47
	BRNE _0x107
	LDI  R30,LOW(100)
	CP   R30,R13
	BREQ _0x108
_0x107:
	RJMP _0x106
_0x108:
; 0000 01D0 {lcd_clear(); off(); x=150; lcd_gotoxy(0,0); lcd_putsf("Hitam"); program(); }
	RCALL _lcd_clear
	RCALL _off
	LDI  R30,LOW(150)
	MOV  R13,R30
	RCALL SUBOPT_0x13
	__POINTW2FN _0x0,227
	RCALL _lcd_putsf
	RCALL _program
; 0000 01D1 if ( sensor==0b00000000 && x==100)
_0x106:
	RCALL SUBOPT_0x60
	BRNE _0x10A
	LDI  R30,LOW(100)
	CP   R30,R13
	BREQ _0x10B
_0x10A:
	RJMP _0x109
_0x10B:
; 0000 01D2 {lcd_clear(); off(); x=200; lcd_gotoxy(0,0); lcd_putsf("Putih"); program(); }
	RCALL _lcd_clear
	RCALL _off
	LDI  R30,LOW(200)
	MOV  R13,R30
	RCALL SUBOPT_0x13
	__POINTW2FN _0x0,233
	RCALL _lcd_putsf
	RCALL _program
; 0000 01D3 delay_ms(20);
_0x109:
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x28
; 0000 01D4 }
	RET
;
;void main(void)
; 0000 01D7 {
_main:
; 0000 01D8 // Declare your local variables here
; 0000 01D9 
; 0000 01DA // Input/Output Ports initialization
; 0000 01DB // Port A initialization
; 0000 01DC // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01DD // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01DE PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 01DF DDRA=0x00;
	OUT  0x1A,R30
; 0000 01E0 
; 0000 01E1 // Port B initialization
; 0000 01E2 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01E3 // State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P
; 0000 01E4 PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 01E5 DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 01E6 
; 0000 01E7 // Port C initialization
; 0000 01E8 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In
; 0000 01E9 // State7=T State6=T State5=T State4=T State3=0 State2=T State1=T State0=T
; 0000 01EA PORTC=0x00;
	OUT  0x15,R30
; 0000 01EB DDRC=0x00;
	OUT  0x14,R30
; 0000 01EC 
; 0000 01ED // Port D initialization
; 0000 01EE // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out
; 0000 01EF //Func0=Out
; 0000 01F0 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 01F1 PORTD=0x00;
	OUT  0x12,R30
; 0000 01F2 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 01F3 
; 0000 01F4 // Timer/Counter 0 initialization
; 0000 01F5 // Clock source: System Clock
; 0000 01F6 // Clock value: Timer 0 Stopped
; 0000 01F7 // Mode: Normal top=0xFF
; 0000 01F8 // OC0 output: Disconnected
; 0000 01F9 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 01FA TCNT0=0x00;
	OUT  0x32,R30
; 0000 01FB OCR0=0x00;
	OUT  0x3C,R30
; 0000 01FC 
; 0000 01FD // Timer/Counter 1 initialization
; 0000 01FE // Clock source: System Clock
; 0000 01FF // Clock value: 187.500 kHz
; 0000 0200 // Mode: Fast PWM top=0x00FF
; 0000 0201 // OC1A output: Non-Inv.
; 0000 0202 // OC1B output: Non-Inv.
; 0000 0203 // Noise Canceler: Off
; 0000 0204 // Input Capture on Falling Edge
; 0000 0205 // Timer1 Overflow Interrupt: Off
; 0000 0206 // Input Capture Interrupt: Off
; 0000 0207 // Compare A Match Interrupt: Off
; 0000 0208 // Compare B Match Interrupt: Off
; 0000 0209 TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 020A TCCR1B=0x0B;
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 020B TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 020C TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 020D ICR1H=0x00;
	OUT  0x27,R30
; 0000 020E ICR1L=0x00;
	OUT  0x26,R30
; 0000 020F OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0210 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0211 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0212 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0213 
; 0000 0214 // Timer/Counter 2 initialization
; 0000 0215 // Clock source: System Clock
; 0000 0216 // Clock value: Timer2 Stopped
; 0000 0217 // Mode: Normal top=0xFF
; 0000 0218 // OC2 output: Disconnected
; 0000 0219 ASSR=0x00;
	OUT  0x22,R30
; 0000 021A TCCR2=0x00;
	OUT  0x25,R30
; 0000 021B TCNT2=0x00;
	OUT  0x24,R30
; 0000 021C OCR2=0x00;
	OUT  0x23,R30
; 0000 021D 
; 0000 021E // External Interrupt(s) initialization
; 0000 021F // INT0: Off
; 0000 0220 // INT1: Off
; 0000 0221 // INT2: Off
; 0000 0222 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0223 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0224 
; 0000 0225 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0226 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0227 
; 0000 0228 // USART initialization
; 0000 0229 // USART disabled
; 0000 022A UCSRB=0x00;
	OUT  0xA,R30
; 0000 022B 
; 0000 022C // Analog Comparator initialization
; 0000 022D // Analog Comparator: Off
; 0000 022E // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 022F ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0230 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0231 
; 0000 0232 // ADC initialization
; 0000 0233 // ADC Clock frequency: 93.750 kHz
; 0000 0234 // ADC Voltage Reference: AVCC pin
; 0000 0235 // ADC High Speed Mode: Off
; 0000 0236 // ADC Auto Trigger Source: ADC Stopped
; 0000 0237 // Only the 8 most significant bits of
; 0000 0238 // the AD conversion result are used
; 0000 0239 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 023A ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 023B SFIOR&=0xEF;
	IN   R30,0x30
	ANDI R30,0xEF
	OUT  0x30,R30
; 0000 023C 
; 0000 023D // SPI initialization
; 0000 023E // SPI disabled
; 0000 023F SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 0240 
; 0000 0241 // TWI initialization
; 0000 0242 // TWI disabled
; 0000 0243 TWCR=0x00;
	OUT  0x36,R30
; 0000 0244 
; 0000 0245 // Alphanumeric LCD initialization
; 0000 0246 // Connections specified in the
; 0000 0247 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0248 // RS - PORTC Bit 0
; 0000 0249 // RD - PORTC Bit 1
; 0000 024A // EN - PORTC Bit 2
; 0000 024B // D4 - PORTC Bit 4
; 0000 024C // D5 - PORTC Bit 5
; 0000 024D // D6 - PORTC Bit 6
; 0000 024E // D7 - PORTC Bit 7
; 0000 024F // Characters/line: 16
; 0000 0250 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0251 Lampu=1; //lampu lcd
	SBI  0x12,7
; 0000 0252 display(); //call display(); untuk setup menu
	RCALL _display
; 0000 0253 write_all(); //call write_all(); untuk semua data di eeprom
	RCALL _write_all
; 0000 0254 while (1)
_0x10E:
; 0000 0255       {
; 0000 0256       // Place your code here
; 0000 0257       baca_track();
	RCALL _baca_track
; 0000 0258       }
	RJMP _0x10E
; 0000 0259 }
_0x111:
	RJMP _0x111
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
_put_buff_G100:
	RCALL SUBOPT_0x62
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x63
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	RCALL SUBOPT_0x63
	RCALL SUBOPT_0x64
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	RCALL SUBOPT_0x63
	ADIW R26,2
	RCALL SUBOPT_0x65
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0x63
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x63
	RCALL SUBOPT_0x65
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x63
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
__print_G100:
	RCALL SUBOPT_0x62
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
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
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x66
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x66
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x67
	RCALL SUBOPT_0x68
	RCALL SUBOPT_0x67
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x69
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x6A
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x6C
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x6A
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x6C
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x6D
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x6D
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x6A
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x6E
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x6E
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x6A
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x6E
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x66
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x6D
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x66
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x6D
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x55
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x6E
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x69
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x66
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x69
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x6F
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080003
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x6F
	RCALL SUBOPT_0x6D
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x16
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0x16
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080003:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
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
__lcd_write_nibble_G101:
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 8
	SBI  0x15,2
	__DELAY_USB 20
	CBI  0x15,2
	__DELAY_USB 20
	RJMP _0x2080001
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 200
	RJMP _0x2080001
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R12,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x28
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x28
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R12,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020005
	LDS  R30,__lcd_maxx
	CP   R12,R30
	BRLO _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020007
	RJMP _0x2080001
_0x2020007:
_0x2020004:
	INC  R12
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2080001
_lcd_puts:
	RCALL SUBOPT_0x62
	ST   -Y,R17
_0x2020008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	RJMP _0x2080002
_lcd_putsf:
	RCALL SUBOPT_0x62
	ST   -Y,R17
_0x202000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x202000B
_0x202000D:
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x70
	RCALL SUBOPT_0x70
	RCALL SUBOPT_0x70
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 300
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG
_strlen:
	RCALL SUBOPT_0x62
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
_strlenf:
	RCALL SUBOPT_0x62
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

	.ESEG
_kp:
	.DB  0x0
_ki:
	.DB  0x0
_kd:
	.DB  0x0
_ts:
	.DB  0x0
_max_speed:
	.DB  0x0
_B:
	.BYTE 0x8

	.DSEG
_data:
	.BYTE 0x21
_tF:
	.BYTE 0x4
_pid:
	.BYTE 0x4
_a:
	.BYTE 0x8
_c:
	.BYTE 0x8
_S:
	.BYTE 0x8
_SS:
	.BYTE 0x8
_P:
	.BYTE 0x2
_I:
	.BYTE 0x2
_D:
	.BYTE 0x2
_kpF:
	.BYTE 0x2
_kiF:
	.BYTE 0x2
_kdF:
	.BYTE 0x2
_posisi:
	.BYTE 0x2
_error:
	.BYTE 0x2
_last_error:
	.BYTE 0x2
_max_speedF:
	.BYTE 0x2
_min:
	.BYTE 0x2
_m1:
	.BYTE 0x2
_m2:
	.BYTE 0x2
_gas:
	.BYTE 0x2
_hasil:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x0:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDS  R30,_c
	LDS  R26,_a
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	__GETB2MN _a,1
	__GETB1MN _c,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	__GETB2MN _a,2
	__GETB1MN _c,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	__GETB2MN _a,3
	__GETB1MN _c,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	__GETB2MN _a,4
	__GETB1MN _c,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	__GETB2MN _a,5
	__GETB1MN _c,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__GETB2MN _a,6
	__GETB1MN _c,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETB2MN _a,7
	__GETB1MN _c,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(49)
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(48)
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:68 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
	RCALL _lcd_clear
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
	RJMP _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(_ts)
	LDI  R27,HIGH(_ts)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(_max_speed)
	LDI  R27,HIGH(_max_speed)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_kd)
	LDI  R27,HIGH(_kd)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_ki)
	LDI  R27,HIGH(_ki)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(_kp)
	LDI  R27,HIGH(_kp)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	RCALL _lcd_putsf
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
	RJMP _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(_data)
	LDI  R31,HIGH(_data)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	RCALL SUBOPT_0x12
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x18:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_data)
	LDI  R27,HIGH(_data)
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _delay_ms
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A:
	SUBI R30,-LOW(1)
	RCALL __EEPROMWRB
	SUBI R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1B:
	SUBI R30,LOW(1)
	RCALL __EEPROMWRB
	SUBI R30,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	RCALL SUBOPT_0x11
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _delay_ms
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0x10
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _delay_ms
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0xE
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _delay_ms
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	RCALL SUBOPT_0xF
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _delay_ms
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	MOV  R26,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x25:
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x26:
	RCALL __PUTPARD1
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
	LDI  R26,LOW(_data)
	LDI  R27,HIGH(_data)
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	LDI  R26,LOW(150)
	RCALL SUBOPT_0x25
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x25
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	RCALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x2B:
	RCALL __CWD1
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2C:
	RCALL __CWD1
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
	RCALL _lcd_clear
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0x2E:
	LDS  R30,_max_speedF
	LDS  R31,_max_speedF+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2F:
	LDS  R30,_tF
	LDS  R31,_tF+1
	LDS  R22,_tF+2
	LDS  R23,_tF+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x30:
	LDI  R26,LOW(_data)
	LDI  R27,HIGH(_data)
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	LDI  R26,0
	SBIC 0x16,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	__POINTW1FN _0x0,157
	RCALL SUBOPT_0x16
	LDS  R30,_hasil
	LDS  R31,_hasil+1
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	__POINTW1FN _0x0,201
	RCALL SUBOPT_0x16
	LDS  R30,_m1
	LDS  R31,_m1+1
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x36:
	LDS  R30,_m2
	LDS  R31,_m2+1
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x37:
	LDS  R30,_posisi
	LDS  R31,_posisi+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x39:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3A:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3C:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3D:
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3F:
	LDI  R30,LOW(65529)
	LDI  R31,HIGH(65529)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x40:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x43:
	LDI  R30,LOW(0)
	STS  _posisi,R30
	STS  _posisi+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	LDI  R30,LOW(65532)
	LDI  R31,HIGH(65532)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x46:
	LDI  R30,LOW(65530)
	LDI  R31,HIGH(65530)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(255)
	CP   R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	LDI  R30,LOW(65527)
	LDI  R31,HIGH(65527)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x4A:
	STS  _posisi,R30
	STS  _posisi+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x4B:
	LDS  R26,_posisi
	LDS  R27,_posisi+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	RCALL SUBOPT_0x4B
	SBIW R26,9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x49
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	RCALL SUBOPT_0x4B
	CPI  R26,LOW(0xFFF8)
	LDI  R30,HIGH(0xFFF8)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:68 WORDS
SUBOPT_0x4F:
	RCALL SUBOPT_0x37
	LDS  R26,_kpF
	LDS  R27,_kpF+1
	RCALL __MULW12
	STS  _error,R30
	STS  _error+1,R31
	STS  _P,R30
	STS  _P+1,R31
	LDS  R30,_last_error
	LDS  R31,_last_error+1
	LDS  R26,_error
	LDS  R27,_error+1
	ADD  R30,R26
	ADC  R31,R27
	LDS  R26,_kiF
	LDS  R27,_kiF+1
	RCALL __MULW12
	STS  _I,R30
	STS  _I+1,R31
	LDS  R26,_last_error
	LDS  R27,_last_error+1
	LDS  R30,_error
	LDS  R31,_error+1
	SUB  R30,R26
	SBC  R31,R27
	LDS  R26,_kdF
	LDS  R27,_kdF+1
	RCALL __MULW12
	STS  _D,R30
	STS  _D+1,R31
	LDS  R30,_error
	LDS  R31,_error+1
	STS  _last_error,R30
	STS  _last_error+1,R31
	LDS  R30,_P
	LDS  R31,_P+1
	RCALL __CWD1
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x50:
	LDS  R30,_I
	LDS  R31,_I+1
	RCALL __CWD1
	RCALL __CDF1
	RCALL SUBOPT_0x29
	__GETD1N 0x461C4000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x51:
	RCALL __ADDF12
	RCALL SUBOPT_0x29
	LDS  R30,_D
	LDS  R31,_D+1
	RCALL __CWD1
	RCALL __CDF1
	RCALL __ADDF12
	STS  _pid,R30
	STS  _pid+1,R31
	STS  _pid+2,R22
	STS  _pid+3,R23
	RCALL __CFD1
	STS  _hasil,R30
	STS  _hasil+1,R31
	LDS  R26,_hasil
	LDS  R27,_hasil+1
	RCALL SUBOPT_0x2E
	SUB  R30,R26
	SBC  R31,R27
	STS  _m1,R30
	STS  _m1+1,R31
	RCALL SUBOPT_0x2E
	LDS  R26,_m1
	LDS  R27,_m1+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x52:
	RCALL SUBOPT_0x2E
	STS  _m1,R30
	STS  _m1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x53:
	LDS  R30,_min
	LDS  R31,_min+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x54:
	LDS  R26,_m1
	LDS  R27,_m1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x55:
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x56:
	RCALL SUBOPT_0x53
	STS  _m1,R30
	STS  _m1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x57:
	CLR  R5
	LDI  R30,LOW(1)
	MOV  R4,R30
	RCALL SUBOPT_0x54
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	SUB  R30,R26
	SBC  R31,R27
	STS  _gas,R30
	STS  _gas+1,R31
	STS  _m1,R30
	STS  _m1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x58:
	LDS  R30,_error
	LDS  R31,_error+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x59:
	LDS  R30,_hasil
	LDS  R31,_hasil+1
	LDS  R26,_max_speedF
	LDS  R27,_max_speedF+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _m2,R30
	STS  _m2+1,R31
	RCALL SUBOPT_0x2E
	LDS  R26,_m2
	LDS  R27,_m2+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5A:
	RCALL SUBOPT_0x2E
	STS  _m2,R30
	STS  _m2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	RCALL SUBOPT_0x53
	LDS  R26,_m2
	LDS  R27,_m2+1
	RJMP SUBOPT_0x55

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5C:
	RCALL SUBOPT_0x53
	STS  _m2,R30
	STS  _m2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5D:
	LDS  R26,_m2
	LDS  R27,_m2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x5E:
	LDI  R30,LOW(1)
	MOV  R7,R30
	CLR  R6
	RCALL SUBOPT_0x5D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	SUB  R30,R26
	SBC  R31,R27
	STS  _gas,R30
	STS  _gas+1,R31
	STS  _m2,R30
	STS  _m2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5F:
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R7
	ST   -Y,R6
	LDS  R30,_m1
	ST   -Y,R30
	LDS  R26,_m2
	RCALL _motor
	RCALL SUBOPT_0x2F
	RCALL __CFD1U
	MOVW R26,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	LDI  R30,LOW(0)
	CP   R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x62:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x63:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x64:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x65:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x66:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x67:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x68:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x69:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6A:
	RCALL SUBOPT_0x67
	RJMP SUBOPT_0x68

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6B:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x64

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6C:
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6D:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6E:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6F:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x70:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 300
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xBB8
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

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

;END OF CODE MARKER
__END_OF_CODE:

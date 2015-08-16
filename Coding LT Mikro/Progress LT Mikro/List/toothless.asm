
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _key=R5
	.DEF _key2=R4
	.DEF _sensor=R7
	.DEF _in_arah_kiri=R6
	.DEF _in_kec_kiri=R9
	.DEF _in_arah_kanan=R8
	.DEF _in_kec_kanan=R11
	.DEF _delay_belok=R10
	.DEF _last=R13
	.DEF __lcd_x=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x3C,0x3C,0x3C,0x3C,0x3C,0x3C,0x3C,0x3C
_0x4:
	.DB  0x3C,0x3C,0x3C,0x3C,0x3C,0x3C,0x3C,0x3C
_0x0:
	.DB  0x25,0x64,0x0,0x69,0x3A,0x0,0x2B,0x0
	.DB  0x45,0x52,0x52,0x4F,0x52,0x20,0x4D,0x41
	.DB  0x58,0x20,0x3D,0x20,0x32,0x35,0x35,0x0
	.DB  0x41,0x6C,0x68,0x61,0x6D,0x64,0x75,0x6C
	.DB  0x69,0x6C,0x6C,0x61,0x68,0x0,0x49,0x6E
	.DB  0x70,0x75,0x74,0x20,0x3A,0x0,0x53,0x65
	.DB  0x6C,0x65,0x73,0x61,0x69,0x20,0x3A,0x0
	.DB  0x20,0x20,0x20,0x20,0x42,0x69,0x73,0x6D
	.DB  0x69,0x6C,0x6C,0x61,0x68,0x20,0x20,0x20
	.DB  0x0,0x5E,0x5F,0x5E,0x20,0x4B,0x61,0x6C
	.DB  0x69,0x62,0x72,0x61,0x73,0x69,0x5E,0x5F
	.DB  0x5E,0x0,0x20,0x41,0x6C,0x68,0x61,0x6D
	.DB  0x64,0x75,0x6C,0x69,0x6C,0x6C,0x61,0x68
	.DB  0x20,0x20,0x0,0x53,0x65,0x6D,0x6F,0x67
	.DB  0x61,0x20,0x53,0x75,0x6B,0x73,0x65,0x73
	.DB  0x20,0x3A,0x29,0x0,0x20,0x3E,0x3E,0x3E
	.DB  0x20,0x53,0x65,0x6E,0x73,0x6F,0x72,0x20
	.DB  0x3C,0x3C,0x3C,0x20,0x0,0x20,0x20,0x53
	.DB  0x65,0x6E,0x73,0x6F,0x72,0x20,0x20,0x42
	.DB  0x61,0x63,0x61,0x20,0x20,0x0,0x31,0x3A
	.DB  0x47,0x65,0x6C,0x61,0x70,0x20,0x32,0x3A
	.DB  0x54,0x65,0x72,0x61,0x6E,0x67,0x0,0x25
	.DB  0x64,0x20,0x25,0x64,0x20,0x25,0x64,0x20
	.DB  0x25,0x64,0x0,0x20,0x20,0x4D,0x61,0x73
	.DB  0x75,0x6B,0x61,0x6E,0x20,0x4D,0x6F,0x64
	.DB  0x65,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x53,0x74,0x61,0x72,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x41,0x6C,0x68,0x61
	.DB  0x6D,0x64,0x75,0x6C,0x69,0x6C,0x6C,0x61
	.DB  0x68,0x20,0x0,0x20,0x4D,0x61,0x73,0x75
	.DB  0x6B,0x61,0x6E,0x20,0x43,0x68,0x65,0x63
	.DB  0x6B,0x50,0x20,0x0,0x20,0x20,0x20,0x4D
	.DB  0x4F,0x54,0x4F,0x52,0x20,0x4B,0x49,0x52
	.DB  0x49,0x20,0x20,0x20,0x0,0x31,0x3A,0x4D
	.DB  0x61,0x6A,0x75,0x20,0x20,0x32,0x3A,0x4D
	.DB  0x75,0x6E,0x64,0x75,0x72,0x0,0x53,0x70
	.DB  0x65,0x65,0x64,0x20,0x3A,0x20,0x0,0x20
	.DB  0x20,0x4D,0x4F,0x54,0x4F,0x52,0x20,0x20
	.DB  0x4B,0x41,0x4E,0x41,0x4E,0x20,0x20,0x0
	.DB  0x44,0x65,0x6C,0x61,0x79,0x20,0x3A,0x20
	.DB  0x0,0x4B,0x50,0x20,0x3A,0x20,0x0,0x4B
	.DB  0x44,0x20,0x3A,0x20,0x0,0x20,0x20,0x20
	.DB  0x42,0x69,0x73,0x6D,0x69,0x6C,0x6C,0x61
	.DB  0x68,0x20,0x20,0x20,0x20,0x0,0x4D,0x6F
	.DB  0x64,0x65,0x20,0x53,0x74,0x61,0x72,0x74
	.DB  0x20,0x3A,0x20,0x31,0x2F,0x34,0x0,0x4D
	.DB  0x6F,0x64,0x65,0x20,0x53,0x74,0x61,0x72
	.DB  0x74,0x20,0x3A,0x20,0x32,0x2F,0x33,0x0
	.DB  0x41,0x53,0x53,0x41,0x4C,0x41,0x4D,0x55
	.DB  0x41,0x4C,0x41,0x49,0x4B,0x55,0x4D,0x20
	.DB  0x0,0x20,0x42,0x49,0x53,0x4D,0x49,0x4C
	.DB  0x4C,0x41,0x48,0x20,0x3A,0x29,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x54,0x4F,0x4F
	.DB  0x54,0x48,0x4C,0x45,0x53,0x53,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x4C,0x69,0x6E,0x65
	.DB  0x20,0x46,0x6F,0x6C,0x6C,0x6F,0x77,0x65
	.DB  0x72,0x20,0x0,0x20,0x20,0x50,0x69,0x6C
	.DB  0x69,0x68,0x20,0x20,0x20,0x4D,0x65,0x6E
	.DB  0x75,0x20,0x20,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  _data_gelap
	.DW  _0x3*2

	.DW  0x08
	.DW  _data_terang
	.DW  _0x4*2

	.DW  0x11
	.DW  _0x2EF
	.DW  _0x0*2+235

	.DW  0x11
	.DW  _0x2EF+17
	.DW  _0x0*2+235

	.DW  0x11
	.DW  _0x2EF+34
	.DW  _0x0*2+252

	.DW  0x11
	.DW  _0x2EF+51
	.DW  _0x0*2+269

	.DW  0x09
	.DW  _0x2EF+68
	.DW  _0x0*2+286

	.DW  0x11
	.DW  _0x2EF+77
	.DW  _0x0*2+295

	.DW  0x11
	.DW  _0x2EF+94
	.DW  _0x0*2+269

	.DW  0x09
	.DW  _0x2EF+111
	.DW  _0x0*2+286

	.DW  0x09
	.DW  _0x2EF+120
	.DW  _0x0*2+312

	.DW  0x09
	.DW  _0x2EF+129
	.DW  _0x0*2+286

	.DW  0x06
	.DW  _0x2EF+138
	.DW  _0x0*2+321

	.DW  0x06
	.DW  _0x2EF+144
	.DW  _0x0*2+327

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 19/09/2014
;Author  : Naufal Suryanto
;Company : Computer Engineering PENS 2013
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
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
;#include <delay.h>
;#include <stdio.h>
;#include <stdbool.h>
;
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 0021 #endasm
;#include <lcd.h>
;
;//>KEYPAD<//
;#define row0 PORTC.1
;#define row1 PORTC.6
;#define row2 PORTC.5
;#define row3 PORTC.3
;#define col0 PINC.2
;#define col1 PINC.0
;#define col2 PINC.4
;#define kosong 123
;//>KEYPAD<//
;
;//>MOTOR<//
;#define en_ki PORTD.6
;#define en_ka PORTD.7
;#define IN_1A PORTD.5
;#define pwm_ki OCR1A
;#define IN_2A PORTD.0
;#define IN_1B PORTD.4
;#define pwm_ka OCR1B
;#define IN_2B PORTD.1
;#define maju 0
;#define mundur 1
;//>MOTOR<//
;
;//>BUZZER<//
;#define buz PORTC.7
;#define buz_on buz=0
;#define buz_off buz=1
;#define bip {buz_on; delay_ms(100); buz_off;}
;//>BUZZER<//
;
;//>SENSOR SAYAP<//
;#define syp_ki PIND.2
;#define syp_ka PIND.3
;//>SENSOR SAYAP<//
;
;//>PERTIGAAN<//
;#define kiri 0
;#define kanan 1
;
;//>MODE MOTOR<//
;#define slow 0
;#define normal 1
;#define fast 2
;#define veryfast 3
;#define veryfast2 4
;
;//>MODE MOTOR<//
;
;#define ADC_VREF_TYPE 0x20
;
;//>Deklarasi Variable Global<//
;char key,key2;
;char buf[3],buf2[5],buf3[16];
;
;unsigned char data_sensor[8];
;unsigned char data_gelap[8]={60,60,60,60,60,60,60,60};

	.DSEG
;unsigned char data_terang[8]={60,60,60,60,60,60,60,60};
;unsigned char sensor;
;eeprom unsigned data_ref[8]={120,120,120,120,120,120,120,120};
;eeprom unsigned char gt=0;
;eeprom unsigned char inkec,inkp,inkd;
;eeprom unsigned char pilihstart;
;unsigned char in_arah_kiri,in_kec_kiri,in_arah_kanan,in_kec_kanan,delay_belok;
;
;//bit s1,s2,s3,s4,s5,s6,s7,s8,last;
;bool s[8],last;
;int last_error;
;//>Deklarasi Variable Global<//
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 006D {

	.CSEG
_read_adc:
; 0000 006E ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 006F // Delay needed for the stabilization of the ADC input voltage
; 0000 0070 delay_us(10);
	__DELAY_USB 53
; 0000 0071 // Start the AD conversion
; 0000 0072 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0073 // Wait for the AD conversion to complete
; 0000 0074 while ((ADCSRA & 0x10)==0);
_0x5:
	SBIS 0x6,4
	RJMP _0x5
; 0000 0075 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0076 return ADCH;
	IN   R30,0x5
	RJMP _0x2080008
; 0000 0077 }
;//>>>>>>>>>>>>>>>>>>> KEYPAD <<<<<<<<<<<<<<<<<<<\\
;unsigned char keypad()
; 0000 007A {
_keypad:
; 0000 007B     delay_ms(1);
	CALL SUBOPT_0x0
; 0000 007C      row0=0; row1=1; row2=1; row3=1;
	CBI  0x15,1
	SBI  0x15,6
	SBI  0x15,5
	SBI  0x15,3
; 0000 007D      if(!col0) return(1);
	SBIC 0x13,2
	RJMP _0x10
	LDI  R30,LOW(1)
	RET
; 0000 007E      if(!col1) return(2);
_0x10:
	SBIC 0x13,0
	RJMP _0x11
	LDI  R30,LOW(2)
	RET
; 0000 007F      if(!col2) return(3);
_0x11:
	SBIC 0x13,4
	RJMP _0x12
	LDI  R30,LOW(3)
	RET
; 0000 0080 
; 0000 0081      delay_ms(1);
_0x12:
	CALL SUBOPT_0x0
; 0000 0082      row0=1; row1=0; row2=1; row3=1;
	SBI  0x15,1
	CBI  0x15,6
	SBI  0x15,5
	SBI  0x15,3
; 0000 0083      if(!col0) return(4);
	SBIC 0x13,2
	RJMP _0x1B
	LDI  R30,LOW(4)
	RET
; 0000 0084      if(!col1) return(5);
_0x1B:
	SBIC 0x13,0
	RJMP _0x1C
	LDI  R30,LOW(5)
	RET
; 0000 0085 	 if(!col2) return(6);
_0x1C:
	SBIC 0x13,4
	RJMP _0x1D
	LDI  R30,LOW(6)
	RET
; 0000 0086      row1=1;
_0x1D:
	SBI  0x15,6
; 0000 0087 
; 0000 0088      delay_ms(1);
	CALL SUBOPT_0x0
; 0000 0089      row0=1; row1=1; row2=0; row3=1;
	SBI  0x15,1
	SBI  0x15,6
	CBI  0x15,5
	SBI  0x15,3
; 0000 008A      if(!col0) return(7);
	SBIC 0x13,2
	RJMP _0x28
	LDI  R30,LOW(7)
	RET
; 0000 008B      if(!col1) return(8);
_0x28:
	SBIC 0x13,0
	RJMP _0x29
	LDI  R30,LOW(8)
	RET
; 0000 008C 	 if(!col2) return(9);
_0x29:
	SBIC 0x13,4
	RJMP _0x2A
	LDI  R30,LOW(9)
	RET
; 0000 008D 
; 0000 008E      delay_ms(1);
_0x2A:
	CALL SUBOPT_0x0
; 0000 008F 	 row0=1; row1=1; row2=1; row3=0;
	SBI  0x15,1
	SBI  0x15,6
	SBI  0x15,5
	CBI  0x15,3
; 0000 0090      if(!col0) return(11); //*
	SBIC 0x13,2
	RJMP _0x33
	LDI  R30,LOW(11)
	RET
; 0000 0091      if(!col1) return(0);
_0x33:
	SBIC 0x13,0
	RJMP _0x34
	LDI  R30,LOW(0)
	RET
; 0000 0092      if(!col2) return(12); //#
_0x34:
	SBIC 0x13,4
	RJMP _0x35
	LDI  R30,LOW(12)
	RET
; 0000 0093      else return(kosong);
_0x35:
	LDI  R30,LOW(123)
	RET
; 0000 0094 }
	RET
;
;unsigned char inkeypad()
; 0000 0097 {
_inkeypad:
; 0000 0098     unsigned char k=kosong,hit;
; 0000 0099     k=kosong;
	ST   -Y,R17
	ST   -Y,R16
;	k -> R17
;	hit -> R16
	LDI  R17,123
	LDI  R17,LOW(123)
; 0000 009A     while(k==kosong)
_0x37:
	CPI  R17,123
	BRNE _0x39
; 0000 009B     {
; 0000 009C         k=keypad();
	RCALL _keypad
	MOV  R17,R30
; 0000 009D         if(k!=kosong) hit=k;
	CPI  R17,123
	BREQ _0x3A
	MOV  R16,R17
; 0000 009E         if(k==hit) {while(k==hit) {k=keypad(); delay_ms(1);} return hit;}
_0x3A:
	CP   R16,R17
	BRNE _0x3B
_0x3C:
	CP   R16,R17
	BRNE _0x3E
	RCALL _keypad
	MOV  R17,R30
	CALL SUBOPT_0x0
	RJMP _0x3C
_0x3E:
	MOV  R30,R16
	RJMP _0x2080007
; 0000 009F //        if(k==1) { while(k==1){k=keypad(); delay_ms(1);} return(1);}
; 0000 00A0 //        if(k==2) { while(k==2){k=keypad(); delay_ms(1);} return(2);}
; 0000 00A1 
; 0000 00A2     }
_0x3B:
	RJMP _0x37
_0x39:
; 0000 00A3     delay_ms(100);
	CALL SUBOPT_0x1
	CALL _delay_ms
; 0000 00A4     return k;
	MOV  R30,R17
	RJMP _0x2080007
; 0000 00A5 
; 0000 00A6 }
;
;unsigned char inputnilai(unsigned char pointer)
; 0000 00A9 {
_inputnilai:
; 0000 00AA     unsigned char stack[3];
; 0000 00AB     unsigned char hasil=0,pengali=1;
; 0000 00AC     int i=0;
; 0000 00AD     char k=0;
; 0000 00AE     pengali=1;
	SBIW R28,3
	CALL __SAVELOCR6
;	pointer -> Y+9
;	stack -> Y+6
;	hasil -> R17
;	pengali -> R16
;	i -> R18,R19
;	k -> R21
	LDI  R17,0
	LDI  R16,1
	__GETWRN 18,19,0
	LDI  R21,0
	LDI  R16,LOW(1)
; 0000 00AF     delay_ms(500);
	CALL SUBOPT_0x2
; 0000 00B0     while (i<3 && k!=12)
_0x3F:
	__CPWRN 18,19,3
	BRGE _0x42
	CPI  R21,12
	BRNE _0x43
_0x42:
	RJMP _0x41
_0x43:
; 0000 00B1     {
; 0000 00B2         lcd_gotoxy(pointer,0);
	LDD  R30,Y+9
	CALL SUBOPT_0x3
; 0000 00B3         k=inkeypad();
	RCALL _inkeypad
	MOV  R21,R30
; 0000 00B4         if(k==12) break;
	CPI  R21,12
	BREQ _0x41
; 0000 00B5         else stack[i]=k;
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R21
; 0000 00B6         sprintf(buf2,"%d",k);
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R21
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
; 0000 00B7         lcd_puts(buf2);
	CALL _lcd_puts
; 0000 00B8         i++; pointer++;
	__ADDWRN 18,19,1
	LDD  R30,Y+9
	SUBI R30,-LOW(1)
	STD  Y+9,R30
; 0000 00B9     }
	RJMP _0x3F
_0x41:
; 0000 00BA     lcd_putsf("i:");
	__POINTW1FN _0x0,3
	CALL SUBOPT_0x7
; 0000 00BB     sprintf(buf2,"%d",i);
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	CALL __CWD1
	CALL __PUTPARD1
	CALL SUBOPT_0x6
; 0000 00BC         lcd_puts(buf2);
	CALL _lcd_puts
; 0000 00BD     lcd_putsf("+");
	__POINTW1FN _0x0,6
	CALL SUBOPT_0x7
; 0000 00BE     i--;
	__SUBWRN 18,19,1
; 0000 00BF     while(i>-1)
_0x46:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R18
	CPC  R31,R19
	BRGE _0x48
; 0000 00C0     {
; 0000 00C1         hasil+=(stack[i]*pengali);
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R18
	ADC  R27,R19
	LD   R26,X
	MULS R16,R26
	MOVW R30,R0
	ADD  R17,R30
; 0000 00C2         pengali*=10;
	LDI  R26,LOW(10)
	MULS R16,R26
	MOV  R16,R0
; 0000 00C3         i--;
	__SUBWRN 18,19,1
; 0000 00C4         //lcd_putsf("*");
; 0000 00C5     }
	RJMP _0x46
_0x48:
; 0000 00C6     lcd_clear(); lcd_gotoxy(0,0);
	CALL _lcd_clear
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 00C7     if (hasil>255) {
	LDI  R30,LOW(255)
	CP   R30,R17
	BRSH _0x49
; 0000 00C8     lcd_putsf("ERROR MAX = 255"); hasil=inputnilai(pointer);
	__POINTW1FN _0x0,8
	CALL SUBOPT_0x7
	LDD  R30,Y+9
	ST   -Y,R30
	RCALL _inputnilai
	MOV  R17,R30
; 0000 00C9     }
; 0000 00CA     else lcd_putsf("Alhamdulillah");
	RJMP _0x4A
_0x49:
	__POINTW1FN _0x0,24
	CALL SUBOPT_0x7
; 0000 00CB     delay_ms(500);
_0x4A:
	CALL SUBOPT_0x2
; 0000 00CC     lcd_clear();
	CALL _lcd_clear
; 0000 00CD     return hasil;
	MOV  R30,R17
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; 0000 00CE }
;
;void coba()
; 0000 00D1 {
; 0000 00D2     unsigned char inp;
; 0000 00D3     lcd_clear();
;	inp -> R17
; 0000 00D4     lcd_gotoxy(0,0);
; 0000 00D5     lcd_putsf("Input :");
; 0000 00D6     inp=inputnilai(9);
; 0000 00D7     lcd_putsf("Selesai :");
; 0000 00D8     sprintf(buf,"%d",inp);
; 0000 00D9     lcd_puts(buf);
; 0000 00DA }
;//>>>>>>>>>>>>>>>>>>> KEYPAD <<<<<<<<<<<<<<<<<<<\\
;
;//>>>>>>>>>>>>>>>>>>> MOTOR <<<<<<<<<<<<<<<<<<<\\
;//     a=pwm; b=0-->maju; b=1-->mundur;
;void motor_ki(unsigned char b,unsigned char a)
; 0000 00E0 {
_motor_ki:
; 0000 00E1     en_ki=1;
;	b -> Y+1
;	a -> Y+0
	SBI  0x12,6
; 0000 00E2     if(b==0) pwm_ki=a;
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x4D
	CALL SUBOPT_0x8
	RJMP _0x31E
; 0000 00E3     else
_0x4D:
; 0000 00E4     pwm_ki=255-a;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
_0x31E:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00E5     IN_2A=b;
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x4F
	CBI  0x12,0
	RJMP _0x50
_0x4F:
	SBI  0x12,0
_0x50:
; 0000 00E6 }
	RJMP _0x2080009
;
;void motor_ka(unsigned char arah,unsigned char a)
; 0000 00E9 {
_motor_ka:
; 0000 00EA     en_ka=1;
;	arah -> Y+1
;	a -> Y+0
	SBI  0x12,7
; 0000 00EB     if(arah==0) pwm_ka=a;
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x53
	CALL SUBOPT_0x8
	RJMP _0x31F
; 0000 00EC     else pwm_ka=255-a;
_0x53:
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
_0x31F:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00ED     IN_2B=arah;
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x55
	CBI  0x12,1
	RJMP _0x56
_0x55:
	SBI  0x12,1
_0x56:
; 0000 00EE }
	RJMP _0x2080009
;
;void jalan_mundur(unsigned char ki,unsigned char ka,unsigned int delayms)
; 0000 00F1 {
_jalan_mundur:
; 0000 00F2     motor_ki(mundur,ki);
;	ki -> Y+3
;	ka -> Y+2
;	delayms -> Y+0
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	RCALL _motor_ki
; 0000 00F3     motor_ka(mundur,ka);
	LDI  R30,LOW(1)
	CALL SUBOPT_0xA
; 0000 00F4     delay_ms(delayms);
; 0000 00F5 }
	RJMP _0x2080006
;
;void cekmotor()
; 0000 00F8 {
; 0000 00F9     key=inkeypad();
; 0000 00FA     if(key==1) motor_ki(0,1);
; 0000 00FB     if(key==2) motor_ki(1,0);
; 0000 00FC     if(key==3) en_ki=0;
; 0000 00FD     if(key==4) motor_ka(0,1);
; 0000 00FE     if(key==5) motor_ka(1,0);
; 0000 00FF     if(key==6) en_ka=0;
; 0000 0100 }
;
;void stop(unsigned int delayms)
; 0000 0103 {
_stop:
; 0000 0104     jalan_mundur(0,0,delayms);
;	delayms -> Y+0
	CALL SUBOPT_0xB
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0xC
; 0000 0105 }
_0x2080009:
	ADIW R28,2
	RET
;
;void jalan(unsigned char arah_ki,unsigned char kecp_ki,unsigned char arah_ka,unsigned char kecp_ka,unsigned int delayms)
; 0000 0108 {
_jalan:
; 0000 0109     motor_ki(arah_ki,kecp_ki);
;	arah_ki -> Y+5
;	kecp_ki -> Y+4
;	arah_ka -> Y+3
;	kecp_ka -> Y+2
;	delayms -> Y+0
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	RCALL _motor_ki
; 0000 010A     motor_ka(arah_ka,kecp_ka);
	LDD  R30,Y+3
	CALL SUBOPT_0xA
; 0000 010B     delay_ms(delayms);
; 0000 010C     stop(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0xD
; 0000 010D }
	ADIW R28,6
	RET
;
;void rem(unsigned char mode)
; 0000 0110 {
_rem:
; 0000 0111 	buz_on;
;	mode -> Y+0
	CBI  0x15,7
; 0000 0112 	if(mode==3)             {stop(5);  jalan_mundur(150,150,225); stop(1);}
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x63
	CALL SUBOPT_0xE
	LDI  R30,LOW(150)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(225)
	LDI  R31,HIGH(225)
	CALL SUBOPT_0xC
	CALL SUBOPT_0xF
; 0000 0113     else if(mode==2)        {stop(5);  jalan_mundur(100,100,200); stop(1);}
	RJMP _0x64
_0x63:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x65
	CALL SUBOPT_0xE
	LDI  R30,LOW(100)
	CALL SUBOPT_0x10
	CALL SUBOPT_0xC
	CALL SUBOPT_0xF
; 0000 0114     else if(mode==1)        {stop(5);  stop(1);}
	RJMP _0x66
_0x65:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x67
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
; 0000 0115     else if(mode==0)        {delay_ms(1);}
	RJMP _0x68
_0x67:
	LD   R30,Y
	CPI  R30,0
	BRNE _0x69
	CALL SUBOPT_0x0
; 0000 0116 	buz_off;
_0x69:
_0x68:
_0x66:
_0x64:
	SBI  0x15,7
; 0000 0117 }
	RJMP _0x2080008
;//>>>>>>>>>>>>>>>>>>> MOTOR <<<<<<<<<<<<<<<<<<<\\
;
;//>>>>>>>>>>>>>>>>>>> SENSOR <<<<<<<<<<<<<<<<<<<\\
;void baca_sensor()
; 0000 011C {
_baca_sensor:
; 0000 011D     unsigned char i,j=7;
; 0000 011E     for(i=0;i<8;i++) {data_sensor[j]=read_adc(i); j--;}
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	j -> R16
	LDI  R16,7
	LDI  R17,LOW(0)
_0x6D:
	CPI  R17,8
	BRSH _0x6E
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_data_sensor)
	SBCI R31,HIGH(-_data_sensor)
	PUSH R31
	PUSH R30
	ST   -Y,R17
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R16,1
	SUBI R17,-1
	RJMP _0x6D
_0x6E:
; 0000 011F 
; 0000 0120 }
	RJMP _0x2080007
;
;void baca()  //gelap=1 terang=0
; 0000 0123 {
_baca:
; 0000 0124     unsigned char i;
; 0000 0125     baca_sensor();
	ST   -Y,R17
;	i -> R17
	RCALL _baca_sensor
; 0000 0126     if (gt==1)
	CALL SUBOPT_0x12
	BRNE _0x6F
; 0000 0127         for(i=0;i<8;i++) {if(data_sensor[i]<=data_ref[i]) {s[i]=1;}  else {s[i]=0;}}
	LDI  R17,LOW(0)
_0x71:
	CPI  R17,8
	BRSH _0x72
	CALL SUBOPT_0x13
	BRLO _0x73
	CALL SUBOPT_0x14
	LDI  R30,LOW(1)
	RJMP _0x320
_0x73:
	CALL SUBOPT_0x14
	LDI  R30,LOW(0)
_0x320:
	ST   X,R30
	SUBI R17,-1
	RJMP _0x71
_0x72:
; 0000 0128     else
	RJMP _0x75
_0x6F:
; 0000 0129         for(i=0;i<8;i++){if(data_sensor[i]<=data_ref[i]) {s[i]=0;}  else {s[i]=1;}}
	LDI  R17,LOW(0)
_0x77:
	CPI  R17,8
	BRSH _0x78
	CALL SUBOPT_0x13
	BRLO _0x79
	CALL SUBOPT_0x14
	LDI  R30,LOW(0)
	RJMP _0x321
_0x79:
	CALL SUBOPT_0x14
	LDI  R30,LOW(1)
_0x321:
	ST   X,R30
	SUBI R17,-1
	RJMP _0x77
_0x78:
_0x75:
; 0000 012A     if (s[0]==1) last=0; else if (s[7]==1) last=1;
	LDS  R26,_s
	CPI  R26,LOW(0x1)
	BRNE _0x7B
	CLR  R13
	RJMP _0x7C
_0x7B:
	__GETB2MN _s,7
	CPI  R26,LOW(0x1)
	BRNE _0x7D
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 012B     sensor=(s[0]+s[1]*2+s[2]*4+s[3]*8+s[4]*16+s[5]*32+s[6]*64+s[7]*128);
_0x7D:
_0x7C:
	__GETB1MN _s,1
	LSL  R30
	LDS  R26,_s
	ADD  R26,R30
	__GETB1MN _s,2
	LSL  R30
	LSL  R30
	ADD  R26,R30
	__GETB1MN _s,3
	LSL  R30
	LSL  R30
	LSL  R30
	ADD  R30,R26
	MOV  R22,R30
	__GETB1MN _s,4
	LDI  R26,LOW(16)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R22,R30
	__GETB1MN _s,5
	LDI  R26,LOW(32)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R22,R30
	__GETB1MN _s,6
	LDI  R26,LOW(64)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R22,R30
	__GETB1MN _s,7
	LDI  R26,LOW(128)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R30,R22
	MOV  R7,R30
; 0000 012C }
	LD   R17,Y+
	RET
;
;void kalibrasi()
; 0000 012F {
_kalibrasi:
; 0000 0130     unsigned char a,b,c;
; 0000 0131     lcd_clear();
	CALL __SAVELOCR4
;	a -> R17
;	b -> R16
;	c -> R19
	CALL _lcd_clear
; 0000 0132     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 0133             // 1234567890123456
; 0000 0134     lcd_putsf("    Bismillah   ");
	__POINTW1FN _0x0,56
	CALL SUBOPT_0x7
; 0000 0135     lcd_putsf("^_^ Kalibrasi^_^");
	__POINTW1FN _0x0,73
	CALL SUBOPT_0x7
; 0000 0136     for(a=0;a<10;a++)    data_ref[a]=120;
	LDI  R17,LOW(0)
_0x7F:
	CPI  R17,10
	BRSH _0x80
	MOV  R30,R17
	CALL SUBOPT_0x15
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL __EEPROMWRW
	SUBI R17,-1
	RJMP _0x7F
_0x80:
; 0000 0137 PORTC.7=0;
	CBI  0x15,7
; 0000 0138     while(key==7 || key ==3)
_0x83:
	LDI  R30,LOW(7)
	CP   R30,R5
	BREQ _0x86
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ _0x86
	RJMP _0x85
_0x86:
; 0000 0139     {
; 0000 013A         key=keypad();
	RCALL _keypad
	MOV  R5,R30
; 0000 013B         baca_sensor();
	RCALL _baca_sensor
; 0000 013C         b=0;
	LDI  R16,LOW(0)
; 0000 013D         for(b=0;b<8;b++)
	LDI  R16,LOW(0)
_0x89:
	CPI  R16,8
	BRSH _0x8A
; 0000 013E         {
; 0000 013F             if(data_sensor[b]<=data_terang[b])  data_terang[b]=data_sensor[b];
	CALL SUBOPT_0x11
	MOVW R0,R30
	SUBI R30,LOW(-_data_sensor)
	SBCI R31,HIGH(-_data_sensor)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_data_terang)
	SBCI R31,HIGH(-_data_terang)
	LD   R30,Z
	CP   R30,R26
	BRLO _0x8B
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_data_terang)
	SBCI R27,HIGH(-_data_terang)
	RJMP _0x322
; 0000 0140             else if(data_sensor[b]>data_gelap[b])   data_gelap[b]=data_sensor[b];
_0x8B:
	CALL SUBOPT_0x11
	MOVW R0,R30
	SUBI R30,LOW(-_data_sensor)
	SBCI R31,HIGH(-_data_sensor)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_data_gelap)
	SBCI R31,HIGH(-_data_gelap)
	LD   R30,Z
	CP   R30,R26
	BRSH _0x8D
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_data_gelap)
	SBCI R27,HIGH(-_data_gelap)
_0x322:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_data_sensor)
	SBCI R31,HIGH(-_data_sensor)
	LD   R30,Z
	ST   X,R30
; 0000 0141         }
_0x8D:
	SUBI R16,-1
	RJMP _0x89
_0x8A:
; 0000 0142         c=0;
	LDI  R19,LOW(0)
; 0000 0143         for(c=0;c<8;c++)
	LDI  R19,LOW(0)
_0x8F:
	CPI  R19,8
	BRSH _0x90
; 0000 0144         {
; 0000 0145             data_ref[c]=data_terang[c]+((data_gelap[c]-data_terang[c])/2);
	MOV  R30,R19
	CALL SUBOPT_0x15
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x16
	SUBI R30,LOW(-_data_terang)
	SBCI R31,HIGH(-_data_terang)
	LD   R22,Z
	CLR  R23
	CALL SUBOPT_0x16
	SUBI R30,LOW(-_data_gelap)
	SBCI R31,HIGH(-_data_gelap)
	LD   R26,Z
	LDI  R27,0
	CALL SUBOPT_0x16
	SUBI R30,LOW(-_data_terang)
	SBCI R31,HIGH(-_data_terang)
	LD   R30,Z
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	ADD  R30,R22
	ADC  R31,R23
	POP  R26
	POP  R27
	CALL __EEPROMWRW
; 0000 0146         }
	SUBI R19,-1
	RJMP _0x8F
_0x90:
; 0000 0147 
; 0000 0148     }
	RJMP _0x83
_0x85:
; 0000 0149     buz_off;
	SBI  0x15,7
; 0000 014A     lcd_clear();
	CALL _lcd_clear
; 0000 014B     lcd_putsf(" Alhamdulillah  ");
	__POINTW1FN _0x0,90
	CALL SUBOPT_0x7
; 0000 014C     lcd_putsf("Semoga Sukses :)");
	__POINTW1FN _0x0,107
	CALL SUBOPT_0x7
; 0000 014D     delay_ms(1000);
	CALL SUBOPT_0x17
; 0000 014E     lcd_clear();
	CALL _lcd_clear
; 0000 014F 
; 0000 0150 }
	CALL __LOADLOCR4
	RJMP _0x2080006
;
;
;void tampil_bit(unsigned char xx){
; 0000 0153 void tampil_bit(unsigned char xx){
_tampil_bit:
; 0000 0154      if(xx==0) lcd_putchar('0');
;	xx -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x93
	LDI  R30,LOW(48)
	RJMP _0x323
; 0000 0155      else      lcd_putchar('1');
_0x93:
	LDI  R30,LOW(49)
_0x323:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0156 }
_0x2080008:
	ADIW R28,1
	RET
;
;void cetak_sensor()
; 0000 0159 {
_cetak_sensor:
; 0000 015A     unsigned char i,j=7;
; 0000 015B     lcd_gotoxy(0,0);
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	j -> R16
	LDI  R16,7
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 015C              //1234567890123456
; 0000 015D     lcd_putsf(" >>> Sensor <<< ");
	__POINTW1FN _0x0,124
	CALL SUBOPT_0x7
; 0000 015E     delay_ms(1);
	CALL SUBOPT_0x0
; 0000 015F     baca();
	RCALL _baca
; 0000 0160     lcd_gotoxy(4,1);
	CALL SUBOPT_0x18
	CALL _lcd_gotoxy
; 0000 0161     for(i=0;i<8;i++) {tampil_bit(s[j]); j--;}
	LDI  R17,LOW(0)
_0x96:
	CPI  R17,8
	BRSH _0x97
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_s)
	SBCI R31,HIGH(-_s)
	LD   R30,Z
	ST   -Y,R30
	RCALL _tampil_bit
	SUBI R16,1
	SUBI R17,-1
	RJMP _0x96
_0x97:
; 0000 0162     lcd_gotoxy(2,1);
	CALL SUBOPT_0x19
	CALL _lcd_gotoxy
; 0000 0163     if(gt==1) tampil_bit(!syp_ki);
	CALL SUBOPT_0x12
	BRNE _0x98
	LDI  R30,0
	SBIS 0x10,2
	LDI  R30,1
	RJMP _0x324
; 0000 0164     else tampil_bit(syp_ki);
_0x98:
	LDI  R30,0
	SBIC 0x10,2
	LDI  R30,1
_0x324:
	ST   -Y,R30
	RCALL _tampil_bit
; 0000 0165     lcd_gotoxy(13,1);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x1A
; 0000 0166     if(gt==1) tampil_bit(!syp_ka);
	CALL SUBOPT_0x12
	BRNE _0x9A
	LDI  R30,0
	SBIS 0x10,3
	LDI  R30,1
	RJMP _0x325
; 0000 0167     else tampil_bit(syp_ka);
_0x9A:
	LDI  R30,0
	SBIC 0x10,3
	LDI  R30,1
_0x325:
	ST   -Y,R30
	RCALL _tampil_bit
; 0000 0168     delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x1B
; 0000 0169 }
_0x2080007:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void set_baca()
; 0000 016C {
_set_baca:
; 0000 016D     while(key!=12)
_0x9C:
	LDI  R30,LOW(12)
	CP   R30,R5
	BREQ _0x9E
; 0000 016E     {
; 0000 016F         lcd_putsf("  Sensor  Baca  ");
	__POINTW1FN _0x0,141
	CALL SUBOPT_0x7
; 0000 0170         lcd_putsf("1:Gelap 2:Terang");
	__POINTW1FN _0x0,158
	CALL SUBOPT_0x7
; 0000 0171         key=inkeypad();
	RCALL _inkeypad
	MOV  R5,R30
; 0000 0172         if(key==1) {gt=0; lcd_clear(); delay_ms(200); break;}
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x9F
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	RJMP _0x9E
; 0000 0173         else if(key==2) {gt=1; lcd_clear(); delay_ms(200); break;}
_0x9F:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0xA1
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1D
	RJMP _0x9E
; 0000 0174     }
_0xA1:
	RJMP _0x9C
_0x9E:
; 0000 0175 }
	RET
;
;void cek_adc()
; 0000 0178 {
_cek_adc:
; 0000 0179     while(key!=12)
_0xA2:
	LDI  R30,LOW(12)
	CP   R30,R5
	BREQ _0xA4
; 0000 017A     {
; 0000 017B     key=keypad();
	RCALL _keypad
	MOV  R5,R30
; 0000 017C     lcd_clear();
	CALL _lcd_clear
; 0000 017D     //lcd_gotoxy(0,0);
; 0000 017E     //lcd_putsf("Sensor =");
; 0000 017F     //lcd_gotoxy(6,0);
; 0000 0180     sprintf(buf3,"%d %d %d %d",read_adc(7),read_adc(6),read_adc(5),read_adc(4));
	CALL SUBOPT_0x1F
	__POINTW1FN _0x0,175
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(7)
	CALL SUBOPT_0x20
	LDI  R30,LOW(6)
	CALL SUBOPT_0x20
	LDI  R30,LOW(5)
	CALL SUBOPT_0x20
	LDI  R30,LOW(4)
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
; 0000 0181     lcd_puts(buf3);
	CALL _lcd_puts
; 0000 0182     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
; 0000 0183     sprintf(buf3,"%d %d %d %d",read_adc(3),read_adc(2),read_adc(1),read_adc(0));
	CALL SUBOPT_0x1F
	__POINTW1FN _0x0,175
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	CALL SUBOPT_0x20
	LDI  R30,LOW(2)
	CALL SUBOPT_0x20
	LDI  R30,LOW(1)
	CALL SUBOPT_0x20
	LDI  R30,LOW(0)
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
; 0000 0184     lcd_puts(buf3);
	CALL _lcd_puts
; 0000 0185     delay_ms(300);
	CALL SUBOPT_0x22
; 0000 0186     }
	RJMP _0xA2
_0xA4:
; 0000 0187     lcd_clear();
	CALL _lcd_clear
; 0000 0188 }
	RET
;
;//void baca() //gelap=1 terang=0
;//{
;//    baca_sensor();
;//    if(gt==1)
;//
;//    {
;//    if(data_sensor[0]<=data_ref[0]) {s1=1; last=0;}  else {s1=0;}
;//    if(data_sensor[1]<=data_ref[1]) {s2=1;}  else {s2=0;}
;//    if(data_sensor[2]<=data_ref[2]) {s3=1;}  else {s3=0;}
;//    if(data_sensor[3]<=data_ref[3]) {s4=1;}  else {s4=0;}
;//    if(data_sensor[4]<=data_ref[4]) {s5=1;}  else {s5=0;}
;//    if(data_sensor[5]<=data_ref[5]) {s6=1;}  else {s6=0;}
;//    if(data_sensor[6]<=data_ref[6]) {s7=1;}  else {s7=0;}
;//    if(data_sensor[7]<=data_ref[7]) {s8=1; last=1;}  else {s8=0;}
;//    }
;//    else
;//    {
;//    if(data_sensor[0]<=data_ref[0]) {s1=0;}  else {s1=1; last=0;}
;//    if(data_sensor[1]<=data_ref[1]) {s2=0;}  else {s2=1;}
;//    if(data_sensor[2]<=data_ref[2]) {s3=0;}  else {s3=1;}
;//    if(data_sensor[3]<=data_ref[3]) {s4=0;}  else {s4=1;}
;//    if(data_sensor[4]<=data_ref[4]) {s5=0;}  else {s5=1;}
;//    if(data_sensor[5]<=data_ref[5]) {s6=0;}  else {s6=1;}
;//    if(data_sensor[6]<=data_ref[6]) {s7=0;}  else {s7=1;}
;//    if(data_sensor[7]<=data_ref[7]) {s8=0;}  else {s8=1; last=1;}
;//    }
;//    sensor=(s1+s2*2+s3*4+s4*8+s5*16+s6*32+s7*64+s8*128);
;//    //for(i=0;i<9;i++) if(data_sensor[i]<=data_ref[i]) {sensor[i]=1;}  else {sensor[i]=0;}
;//}
;
;//void cetak_sensor()
;//{
;//    lcd_gotoxy(0,0);
;//             //1234567890123456
;//    lcd_putsf(" >>> Sensor <<< ");
;//    delay_ms(1);
;//    baca();
;//    lcd_gotoxy(4,1);
;//    tampil_bit(s1);
;//    tampil_bit(s2);
;//    tampil_bit(s3);
;//    tampil_bit(s4);
;//    tampil_bit(s5);
;//    tampil_bit(s6);
;//    tampil_bit(s7);
;//    tampil_bit(s8);
;//    lcd_gotoxy(2,1);
;//    if(gt==1) tampil_bit(!syp_ki);
;//    else tampil_bit(syp_ki);
;//    lcd_gotoxy(13,1);
;//    if(gt==1) tampil_bit(!syp_ka);
;//    else tampil_bit(syp_ka);
;//    delay_ms(10);
;//    //for(i=0;i<9;i++) if(sensor[i]==0) lcd_putchar('0'); else  lcd_putchar('1');
;//}
;//>>>>>>>>>>>>>>>>>>> SENSOR <<<<<<<<<<<<<<<<<<<\\
;
;//>>>>>>>>>>>>>>>>>>> PD CONTROLER <<<<<<<<<<<<<<<<<<<\\
;void pid()
; 0000 01C5 {
; 0000 01C6     int error,kec_ki,kec_ka,rate;
; 0000 01C7     long int sterr;
; 0000 01C8     unsigned char kec=120;
; 0000 01C9     unsigned char kp=15,kd=10,kec_min=50,kec_max=255;
; 0000 01CA     cetak_sensor();
;	error -> R16,R17
;	kec_ki -> R18,R19
;	kec_ka -> R20,R21
;	rate -> Y+15
;	sterr -> Y+11
;	kec -> Y+10
;	kp -> Y+9
;	kd -> Y+8
;	kec_min -> Y+7
;	kec_max -> Y+6
; 0000 01CB     kec=120;
; 0000 01CC //    if(sensor==0b00011000 || sensor==0b00010000 || sensor==0b00001000) kec++;
; 0000 01CD //    if(kec>=kec_max)kec=kec_max;
; 0000 01CE //    else if(kec<kec_min) kec=kec_min;
; 0000 01CF     switch(sensor)
; 0000 01D0     {
; 0000 01D1         case 0b00000001 : error=-8;  break;
; 0000 01D2         case 0b00000011 : error=-6;  break;
; 0000 01D3         case 0b00000010 : error=-5;  break;
; 0000 01D4         case 0b00000110 : error=-4;  break;
; 0000 01D5         case 0b00000100 : error=-3;  break;
; 0000 01D6         case 0b00001100 : error=-2;  break;
; 0000 01D7         case 0b00001000 : error=-1;  break;
; 0000 01D8         case 0b00011000 : error=0;   break;
; 0000 01D9         case 0b00010000 : error=1;   break;
; 0000 01DA         case 0b00110000 : error=2;   break;
; 0000 01DB         case 0b00100000 : error=3;   break;
; 0000 01DC         case 0b01100000 : error=4;   break;
; 0000 01DD         case 0b01000000 : error=5;   break;
; 0000 01DE         case 0b11000000 : error=6;   break;
; 0000 01DF         case 0b10000000 : error=8;   break;
; 0000 01E0         case 0b11110000 : error=10;  break;
; 0000 01E1         case 0b00001111 : error=-10; break;
; 0000 01E2         case 0x00 : if (last==0) error=-10; else if(last==1) error=10; break;
; 0000 01E3         default : error=0; break;
; 0000 01E4     }
; 0000 01E5     rate = error - last_error;
; 0000 01E6     last_error = error;
; 0000 01E7     sterr= (kp*error) + (kd*rate);
; 0000 01E8 
; 0000 01E9     kec_ki= kec - sterr;
; 0000 01EA     kec_ka= kec + sterr;
; 0000 01EB 
; 0000 01EC     if(kec_ki>kec) motor_ki(maju,kec);
; 0000 01ED     else if(kec_ki<0) motor_ki(mundur,-kec_ki);
; 0000 01EE     else motor_ki(maju,kec_ki);
; 0000 01EF 
; 0000 01F0     if(kec_ka>kec) motor_ka(maju,kec);
; 0000 01F1     else if(kec_ka<0) motor_ka(mundur,-kec_ki);
; 0000 01F2     else motor_ka(maju,kec_ka);
; 0000 01F3 
; 0000 01F4     delay_us(1);
; 0000 01F5 
; 0000 01F6 }
;
;void pid2(unsigned char kec,unsigned char kp, unsigned char kd)
; 0000 01F9 {
_pid2:
; 0000 01FA     int error,kec_ki,kec_ka,rate;
; 0000 01FB     long int sterr;
; 0000 01FC     //unsigned char kec=200;
; 0000 01FD     //unsigned char kp=30,kd=20;
; 0000 01FE     baca();
	SBIW R28,6
	CALL __SAVELOCR6
;	kec -> Y+14
;	kp -> Y+13
;	kd -> Y+12
;	error -> R16,R17
;	kec_ki -> R18,R19
;	kec_ka -> R20,R21
;	rate -> Y+10
;	sterr -> Y+6
	RCALL _baca
; 0000 01FF //    if(sensor==0b00011000 || sensor==0b00010000 || sensor==0b00001000) kec++;
; 0000 0200 //    if(kec>=kec_max)kec=kec_max;
; 0000 0201 //    else if(kec<kec_min) kec=kec_min;
; 0000 0202     switch(sensor)
	CALL SUBOPT_0x23
; 0000 0203     {
; 0000 0204         case 0b00000001 : error=-8;  break;
	BRNE _0xC9
	__GETWRN 16,17,-8
	RJMP _0xC8
; 0000 0205         case 0b00000011 : error=-6;  break;
_0xC9:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xCA
	__GETWRN 16,17,-6
	RJMP _0xC8
; 0000 0206         case 0b00000010 : error=-5;  break;
_0xCA:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xCB
	__GETWRN 16,17,-5
	RJMP _0xC8
; 0000 0207         case 0b00000110 : error=-4;  break;
_0xCB:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xCC
	__GETWRN 16,17,-4
	RJMP _0xC8
; 0000 0208         case 0b00000100 : error=-3;  break;
_0xCC:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xCD
	__GETWRN 16,17,-3
	RJMP _0xC8
; 0000 0209         case 0b00001100 : error=-2;  break;
_0xCD:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xCE
	__GETWRN 16,17,-2
	RJMP _0xC8
; 0000 020A         case 0b00001000 : error=-1;   break;
_0xCE:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xCF
	__GETWRN 16,17,-1
	RJMP _0xC8
; 0000 020B         case 0b00011000 : error=0;   break;
_0xCF:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0xD0
	RJMP _0x329
; 0000 020C         case 0b00010000 : error=1;   break;
_0xD0:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xD1
	__GETWRN 16,17,1
	RJMP _0xC8
; 0000 020D         case 0b00110000 : error=2;   break;
_0xD1:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0xD2
	__GETWRN 16,17,2
	RJMP _0xC8
; 0000 020E         case 0b00100000 : error=3;   break;
_0xD2:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xD3
	__GETWRN 16,17,3
	RJMP _0xC8
; 0000 020F         case 0b01100000 : error=4;   break;
_0xD3:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0xD4
	__GETWRN 16,17,4
	RJMP _0xC8
; 0000 0210         case 0b01000000 : error=5;   break;
_0xD4:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0xD5
	__GETWRN 16,17,5
	RJMP _0xC8
; 0000 0211         case 0b11000000 : error=6;   break;
_0xD5:
	CPI  R30,LOW(0xC0)
	LDI  R26,HIGH(0xC0)
	CPC  R31,R26
	BRNE _0xD6
	__GETWRN 16,17,6
	RJMP _0xC8
; 0000 0212         case 0b10000000 : error=8;   break;
_0xD6:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0xD7
	__GETWRN 16,17,8
	RJMP _0xC8
; 0000 0213         case 0b11110000 : error=10;  break;
_0xD7:
	CPI  R30,LOW(0xF0)
	LDI  R26,HIGH(0xF0)
	CPC  R31,R26
	BRNE _0xD8
	__GETWRN 16,17,10
	RJMP _0xC8
; 0000 0214         case 0b00001111 : error=-10; break;
_0xD8:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xD9
	__GETWRN 16,17,-10
	RJMP _0xC8
; 0000 0215         case 0x00 : if (last==0) error=-10; else if(last==1) error=10; break;
_0xD9:
	SBIW R30,0
	BRNE _0xDE
	TST  R13
	BRNE _0xDB
	__GETWRN 16,17,-10
	RJMP _0xDC
_0xDB:
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xDD
	__GETWRN 16,17,10
_0xDD:
_0xDC:
	RJMP _0xC8
; 0000 0216         default : error=0; break;
_0xDE:
_0x329:
	__GETWRN 16,17,0
; 0000 0217     }
_0xC8:
; 0000 0218     rate = error - last_error;
	CALL SUBOPT_0x24
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0219     last_error = error;
	__PUTWMRN _last_error,0,16,17
; 0000 021A     sterr= (kp*error) + (kd*rate);
	LDD  R26,Y+13
	CALL SUBOPT_0x25
	LDD  R30,Y+12
	LDI  R31,0
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x26
	__PUTD1S 6
; 0000 021B 
; 0000 021C     kec_ki= kec - sterr;
	LDD  R26,Y+14
	CLR  R27
	CALL SUBOPT_0x27
; 0000 021D     kec_ka= kec + sterr;
	LDD  R30,Y+14
	LDI  R31,0
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
; 0000 021E 
; 0000 021F     if(kec_ki>kec) motor_ki(maju,kec);
	LDD  R30,Y+14
	CALL SUBOPT_0x28
	BRGE _0xDF
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+15
	ST   -Y,R30
	RJMP _0x32A
; 0000 0220     else if(kec_ki<0) motor_ki(mundur,-kec_ki);
_0xDF:
	TST  R19
	BRPL _0xE1
	CALL SUBOPT_0x29
	RJMP _0x32A
; 0000 0221     else motor_ki(maju,kec_ki);
_0xE1:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R18
_0x32A:
	RCALL _motor_ki
; 0000 0222 
; 0000 0223     if(kec_ka>kec) motor_ka(maju,kec);
	LDD  R30,Y+14
	CALL SUBOPT_0x2A
	BRGE _0xE3
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+15
	ST   -Y,R30
	RJMP _0x32B
; 0000 0224     else if(kec_ka<0) motor_ka(mundur,-kec_ka);
_0xE3:
	TST  R21
	BRPL _0xE5
	LDI  R30,LOW(1)
	ST   -Y,R30
	MOV  R30,R20
	NEG  R30
	ST   -Y,R30
	RJMP _0x32B
; 0000 0225     else motor_ka(maju,kec_ka);
_0xE5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R20
_0x32B:
	RCALL _motor_ka
; 0000 0226 
; 0000 0227     //delay_us(10);
; 0000 0228 
; 0000 0229 }
	CALL __LOADLOCR6
	ADIW R28,15
	RET
;
;void pid_putus2()
; 0000 022C {
_pid_putus2:
; 0000 022D     int error,kec_ki,kec_ka,rate;
; 0000 022E     long int sterr;
; 0000 022F     unsigned char kec=150;
; 0000 0230     unsigned char kp=23,kd=15,kec_min=50,kec_max=255;
; 0000 0231     cetak_sensor();
	SBIW R28,11
	LDI  R30,LOW(255)
	ST   Y,R30
	LDI  R30,LOW(50)
	STD  Y+1,R30
	LDI  R30,LOW(15)
	STD  Y+2,R30
	LDI  R30,LOW(23)
	STD  Y+3,R30
	LDI  R30,LOW(150)
	STD  Y+4,R30
	CALL __SAVELOCR6
;	error -> R16,R17
;	kec_ki -> R18,R19
;	kec_ka -> R20,R21
;	rate -> Y+15
;	sterr -> Y+11
;	kec -> Y+10
;	kp -> Y+9
;	kd -> Y+8
;	kec_min -> Y+7
;	kec_max -> Y+6
	RCALL _cetak_sensor
; 0000 0232     kec=150;
	LDI  R30,LOW(150)
	STD  Y+10,R30
; 0000 0233 //    if(sensor==0b00011000 || sensor==0b00010000 || sensor==0b00001000) kec++;
; 0000 0234 //    if(kec>=kec_max)kec=kec_max;
; 0000 0235 //    else if(kec<kec_min) kec=kec_min;
; 0000 0236     switch(sensor)
	CALL SUBOPT_0x23
; 0000 0237     {
; 0000 0238         case 0b00000001 : error=-8;  break;
	BRNE _0xEA
	__GETWRN 16,17,-8
	RJMP _0xE9
; 0000 0239         case 0b00000011 : error=-6;  break;
_0xEA:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xEB
	__GETWRN 16,17,-6
	RJMP _0xE9
; 0000 023A         case 0b00000010 : error=-5;  break;
_0xEB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xEC
	__GETWRN 16,17,-5
	RJMP _0xE9
; 0000 023B         case 0b00000110 : error=-4;  break;
_0xEC:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xED
	__GETWRN 16,17,-4
	RJMP _0xE9
; 0000 023C         case 0b00000100 : error=-3;  break;
_0xED:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xEE
	__GETWRN 16,17,-3
	RJMP _0xE9
; 0000 023D         case 0b00001100 : error=-2;  break;
_0xEE:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xEF
	__GETWRN 16,17,-2
	RJMP _0xE9
; 0000 023E         case 0b00001000 : error=-1;  break;
_0xEF:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xF0
	__GETWRN 16,17,-1
	RJMP _0xE9
; 0000 023F         case 0b00011000 : error=0;   break;
_0xF0:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0xF1
	RJMP _0x32C
; 0000 0240         case 0b00010000 : error=1;   break;
_0xF1:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xF2
	__GETWRN 16,17,1
	RJMP _0xE9
; 0000 0241         case 0b00110000 : error=2;   break;
_0xF2:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0xF3
	__GETWRN 16,17,2
	RJMP _0xE9
; 0000 0242         case 0b00100000 : error=3;   break;
_0xF3:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xF4
	__GETWRN 16,17,3
	RJMP _0xE9
; 0000 0243         case 0b01100000 : error=4;   break;
_0xF4:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0xF5
	__GETWRN 16,17,4
	RJMP _0xE9
; 0000 0244         case 0b01000000 : error=5;   break;
_0xF5:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0xF6
	__GETWRN 16,17,5
	RJMP _0xE9
; 0000 0245         case 0b11000000 : error=6;   break;
_0xF6:
	CPI  R30,LOW(0xC0)
	LDI  R26,HIGH(0xC0)
	CPC  R31,R26
	BRNE _0xF7
	__GETWRN 16,17,6
	RJMP _0xE9
; 0000 0246         case 0b10000000 : error=8;   break;
_0xF7:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0xF8
	__GETWRN 16,17,8
	RJMP _0xE9
; 0000 0247         case 0b11110000 : error=10;  break;
_0xF8:
	CPI  R30,LOW(0xF0)
	LDI  R26,HIGH(0xF0)
	CPC  R31,R26
	BRNE _0xF9
	__GETWRN 16,17,10
	RJMP _0xE9
; 0000 0248         case 0b00001111 : error=-10; break;
_0xF9:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xFB
	__GETWRN 16,17,-10
	RJMP _0xE9
; 0000 0249 //        case 0x00 : if (last==0) error=-10; else if(last==1) error=10; break;
; 0000 024A         default : error=0; break;
_0xFB:
_0x32C:
	__GETWRN 16,17,0
; 0000 024B     }
_0xE9:
; 0000 024C     rate = error - last_error;
	CALL SUBOPT_0x24
	STD  Y+15,R30
	STD  Y+15+1,R31
; 0000 024D     last_error = error;
	__PUTWMRN _last_error,0,16,17
; 0000 024E     sterr= (kp*error) + (kd*rate);
	LDD  R26,Y+9
	CALL SUBOPT_0x25
	LDD  R30,Y+8
	LDI  R31,0
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x26
	__PUTD1S 11
; 0000 024F 
; 0000 0250     kec_ki= kec - sterr;
	LDD  R26,Y+10
	CLR  R27
	CALL SUBOPT_0x27
; 0000 0251     kec_ka= kec + sterr;
	LDD  R30,Y+10
	LDI  R31,0
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
; 0000 0252 
; 0000 0253     if(kec_ki>kec) motor_ki(maju,kec);
	LDD  R30,Y+10
	CALL SUBOPT_0x28
	BRGE _0xFC
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+11
	ST   -Y,R30
	RJMP _0x32D
; 0000 0254     else if(kec_ki<0) motor_ki(mundur,-kec_ki);
_0xFC:
	TST  R19
	BRPL _0xFE
	CALL SUBOPT_0x29
	RJMP _0x32D
; 0000 0255     else motor_ki(maju,kec_ki);
_0xFE:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R18
_0x32D:
	RCALL _motor_ki
; 0000 0256 
; 0000 0257     if(kec_ka>kec) motor_ka(maju,kec);
	LDD  R30,Y+10
	CALL SUBOPT_0x2A
	BRGE _0x100
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+11
	ST   -Y,R30
	RJMP _0x32E
; 0000 0258     else if(kec_ka<0) motor_ka(mundur,-kec_ki);
_0x100:
	TST  R21
	BRPL _0x102
	CALL SUBOPT_0x29
	RJMP _0x32E
; 0000 0259     else motor_ka(maju,kec_ka);
_0x102:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R20
_0x32E:
	RCALL _motor_ka
; 0000 025A 
; 0000 025B     delay_us(10);
	__DELAY_USB 53
; 0000 025C 
; 0000 025D }
	CALL __LOADLOCR6
	ADIW R28,17
	RET
;
;
;void pid_sampai(unsigned char sens,unsigned char sens2,unsigned char mode_speed,unsigned char mode_rem)
; 0000 0261 {
; 0000 0262 	if(mode_speed==1) while(sensor!=sens && sensor!=sens2) {pid2(150,23,15);}
;	sens -> Y+3
;	sens2 -> Y+2
;	mode_speed -> Y+1
;	mode_rem -> Y+0
; 0000 0263     else if(mode_speed==2) while(sensor!=sens && sensor!=sens2) {pid2(200,32,25);}
; 0000 0264 	else if(mode_speed==slow) while(sensor!=sens && sensor!=sens2) {pid2(120,15,10);}
; 0000 0265     rem(mode_rem);
; 0000 0266 }
;
;void pid_p3an(unsigned char arah,unsigned char counter,unsigned char mode_speed,unsigned char mode_rem)
; 0000 0269 {
; 0000 026A 	unsigned char count=0;
; 0000 026B 	if(arah==kanan)
;	arah -> Y+4
;	counter -> Y+3
;	mode_speed -> Y+2
;	mode_rem -> Y+1
;	count -> R17
; 0000 026C 	while(count<=counter)
; 0000 026D 	{
; 0000 026E 		if(mode_speed==fast) while(sensor!=0b00001100 && sensor!=0b00001110) {pid2(200,35,28);}
; 0000 026F 		count++;
; 0000 0270         while(sensor==0b00001100 || sensor==0b00001110) delay_ms(1);
; 0000 0271 }
; 0000 0272 	else if(arah==kiri)
; 0000 0273 	while(count<=counter)
; 0000 0274 	{
; 0000 0275 		if(mode_speed==fast) while(sensor!=0b01110000 && sensor!=0b00111000) {pid2(200,35,28);}
; 0000 0276 		count++;
; 0000 0277         while(sensor==0b01110000 || sensor==0b11110000) delay_ms(1);
; 0000 0278 }
; 0000 0279 	rem(mode_rem);
; 0000 027A }
;
;void pid_p4an(unsigned char counter,unsigned char mode_speed,unsigned char mode_rem)
; 0000 027D {
; 0000 027E     unsigned char count=0;
; 0000 027F 	while(count<=counter)
;	counter -> Y+3
;	mode_speed -> Y+2
;	mode_rem -> Y+1
;	count -> R17
; 0000 0280 	{
; 0000 0281 		if(mode_speed==fast) while(sensor!=0b00111100 && sensor!=0b01111110) {pid2(200,35,28);}
; 0000 0282         else if(mode_speed==normal) while(sensor!=0b00111100 && sensor!=0b01111110) {pid2(150,23,15);}
; 0000 0283 		count++;
; 0000 0284 	}
; 0000 0285 	rem(mode_rem);
; 0000 0286 }
;
;void pidsayap(unsigned char arah,unsigned char counter,unsigned char mode_speed,unsigned char mode_rem)
; 0000 0289 {
_pidsayap:
; 0000 028A 	unsigned char count=0;
; 0000 028B 	if(arah==kiri)
	ST   -Y,R17
;	arah -> Y+4
;	counter -> Y+3
;	mode_speed -> Y+2
;	mode_rem -> Y+1
;	count -> R17
	LDI  R17,0
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x147
; 0000 028C 	while(count<=counter)
_0x148:
	LDD  R30,Y+3
	CP   R30,R17
	BRLO _0x14A
; 0000 028D 	{
; 0000 028E 		if(mode_speed==fast) while(!syp_ki) {pid2(200,35,28);}
	LDD  R26,Y+2
	CPI  R26,LOW(0x2)
	BRNE _0x14B
_0x14C:
	SBIC 0x10,2
	RJMP _0x14E
	CALL SUBOPT_0x2B
	RJMP _0x14C
_0x14E:
; 0000 028F         else if(mode_speed==normal) while(!syp_ki) {pid2(150,23,15);}
	RJMP _0x14F
_0x14B:
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0x150
_0x151:
	SBIC 0x10,2
	RJMP _0x153
	CALL SUBOPT_0x2C
	RJMP _0x151
_0x153:
; 0000 0290         else if(mode_speed==slow) while(!syp_ki) {pid2(120,15,10);}
	RJMP _0x154
_0x150:
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x155
_0x156:
	SBIC 0x10,2
	RJMP _0x158
	CALL SUBOPT_0x2D
	RJMP _0x156
_0x158:
; 0000 0291 		count++;
_0x155:
_0x154:
_0x14F:
	SUBI R17,-1
; 0000 0292 	}
	RJMP _0x148
_0x14A:
; 0000 0293 	else if(arah==kanan)
	RJMP _0x159
_0x147:
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0x15A
; 0000 0294 	while(count<=counter)
_0x15B:
	LDD  R30,Y+3
	CP   R30,R17
	BRLO _0x15D
; 0000 0295 	{
; 0000 0296 		if(mode_speed==fast) while(!syp_ka) {pid2(200,35,28);}
	LDD  R26,Y+2
	CPI  R26,LOW(0x2)
	BRNE _0x15E
_0x15F:
	SBIC 0x10,3
	RJMP _0x161
	CALL SUBOPT_0x2B
	RJMP _0x15F
_0x161:
; 0000 0297         else if(mode_speed==normal) while(!syp_ka) {pid2(150,23,15);}
	RJMP _0x162
_0x15E:
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0x163
_0x164:
	SBIC 0x10,3
	RJMP _0x166
	CALL SUBOPT_0x2C
	RJMP _0x164
_0x166:
; 0000 0298         else if(mode_speed==slow) while(!syp_ki) {pid2(120,15,10);}
	RJMP _0x167
_0x163:
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x168
_0x169:
	SBIC 0x10,2
	RJMP _0x16B
	CALL SUBOPT_0x2D
	RJMP _0x169
_0x16B:
; 0000 0299 		count++;
_0x168:
_0x167:
_0x162:
	SUBI R17,-1
; 0000 029A 	}
	RJMP _0x15B
_0x15D:
; 0000 029B 	rem(mode_rem);
_0x15A:
_0x159:
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _rem
; 0000 029C }
	LDD  R17,Y+0
	RJMP _0x2080005
;
;void pidsayapglp(unsigned char arah,unsigned char counter,unsigned char mode_speed,unsigned char mode_rem)
; 0000 029F {
_pidsayapglp:
; 0000 02A0 	unsigned char count=0;
; 0000 02A1 	if(arah==kiri)
	ST   -Y,R17
;	arah -> Y+4
;	counter -> Y+3
;	mode_speed -> Y+2
;	mode_rem -> Y+1
;	count -> R17
	LDI  R17,0
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x16C
; 0000 02A2 	while(count<=counter)
_0x16D:
	LDD  R30,Y+3
	CP   R30,R17
	BRLO _0x16F
; 0000 02A3 	{
; 0000 02A4 		if(mode_speed==fast) while(syp_ki) {pid2(200,35,28);}
	LDD  R26,Y+2
	CPI  R26,LOW(0x2)
	BRNE _0x170
_0x171:
	SBIS 0x10,2
	RJMP _0x173
	CALL SUBOPT_0x2B
	RJMP _0x171
_0x173:
; 0000 02A5         else if(mode_speed==normal) while(syp_ki) {pid2(150,23,15);}
	RJMP _0x174
_0x170:
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0x175
_0x176:
	SBIS 0x10,2
	RJMP _0x178
	CALL SUBOPT_0x2C
	RJMP _0x176
_0x178:
; 0000 02A6         else if(mode_speed==slow) while(syp_ki) {pid2(120,15,10);}
	RJMP _0x179
_0x175:
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x17A
_0x17B:
	SBIS 0x10,2
	RJMP _0x17D
	CALL SUBOPT_0x2D
	RJMP _0x17B
_0x17D:
; 0000 02A7 		count++;
_0x17A:
_0x179:
_0x174:
	SUBI R17,-1
; 0000 02A8 	}
	RJMP _0x16D
_0x16F:
; 0000 02A9 	else if(arah==kanan)
	RJMP _0x17E
_0x16C:
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0x17F
; 0000 02AA 	while(count<=counter)
_0x180:
	LDD  R30,Y+3
	CP   R30,R17
	BRLO _0x182
; 0000 02AB 	{
; 0000 02AC 		if(mode_speed==fast) while(syp_ka) {pid2(200,35,28);}
	LDD  R26,Y+2
	CPI  R26,LOW(0x2)
	BRNE _0x183
_0x184:
	SBIS 0x10,3
	RJMP _0x186
	CALL SUBOPT_0x2B
	RJMP _0x184
_0x186:
; 0000 02AD         else if(mode_speed==normal) while(syp_ka) {pid2(150,23,15);}
	RJMP _0x187
_0x183:
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0x188
_0x189:
	SBIS 0x10,3
	RJMP _0x18B
	CALL SUBOPT_0x2C
	RJMP _0x189
_0x18B:
; 0000 02AE         else if(mode_speed==slow) while(syp_ki) {pid2(120,15,10);}
	RJMP _0x18C
_0x188:
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x18D
_0x18E:
	SBIS 0x10,2
	RJMP _0x190
	CALL SUBOPT_0x2D
	RJMP _0x18E
_0x190:
; 0000 02AF 		count++;
_0x18D:
_0x18C:
_0x187:
	SUBI R17,-1
; 0000 02B0 	}
	RJMP _0x180
_0x182:
; 0000 02B1 	rem(mode_rem);
_0x17F:
_0x17E:
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _rem
; 0000 02B2 }
	LDD  R17,Y+0
	RJMP _0x2080005
;
;void pidbit(unsigned char sen1, unsigned char sen2, unsigned char mode_speed,unsigned char mode_rem)
; 0000 02B5 {
_pidbit:
; 0000 02B6     if(mode_speed==fast) while(s[sen1]==0 || s[sen2]==0) {pid2(200,35,28);}
;	sen1 -> Y+3
;	sen2 -> Y+2
;	mode_speed -> Y+1
;	mode_rem -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x191
_0x192:
	CALL SUBOPT_0x2E
	BREQ _0x195
	CALL SUBOPT_0x2F
	BRNE _0x194
_0x195:
	CALL SUBOPT_0x2B
	RJMP _0x192
_0x194:
; 0000 02B7     else if(mode_speed==normal) while(s[sen1]==0 || s[sen2]==0) {pid2(150,23,15);}
	RJMP _0x197
_0x191:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x198
_0x199:
	CALL SUBOPT_0x2E
	BREQ _0x19C
	CALL SUBOPT_0x2F
	BRNE _0x19B
_0x19C:
	CALL SUBOPT_0x2C
	RJMP _0x199
_0x19B:
; 0000 02B8     else if(mode_speed==veryfast) while(s[sen1]==0 ||!syp_ki) pid2(200,35,28); //pid2(255,35,20);
	RJMP _0x19E
_0x198:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x19F
_0x1A0:
	CALL SUBOPT_0x2E
	BREQ _0x1A3
	SBIC 0x10,2
	RJMP _0x1A2
_0x1A3:
	CALL SUBOPT_0x2B
	RJMP _0x1A0
_0x1A2:
; 0000 02B9 else if(mode_speed==4) while(s[sen1]==0 ||!PIND.3) pid2(200,35,28);
	RJMP _0x1A5
_0x19F:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x1A6
_0x1A7:
	CALL SUBOPT_0x2E
	BREQ _0x1AA
	SBIC 0x10,3
	RJMP _0x1A9
_0x1AA:
	CALL SUBOPT_0x2B
	RJMP _0x1A7
_0x1A9:
; 0000 02BA else if(mode_speed==10) while(s[sen1]==0 || s[sen2]==0) {pid_putus2();}
	RJMP _0x1AC
_0x1A6:
	LDD  R26,Y+1
	CPI  R26,LOW(0xA)
	BRNE _0x1AD
_0x1AE:
	CALL SUBOPT_0x2E
	BREQ _0x1B1
	CALL SUBOPT_0x2F
	BRNE _0x1B0
_0x1B1:
	RCALL _pid_putus2
	RJMP _0x1AE
_0x1B0:
; 0000 02BB     else if(mode_speed==slow) while(!syp_ki) {pid2(120,15,10);}
	RJMP _0x1B3
_0x1AD:
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x1B4
_0x1B5:
	SBIC 0x10,2
	RJMP _0x1B7
	CALL SUBOPT_0x2D
	RJMP _0x1B5
_0x1B7:
; 0000 02BC     rem(mode_rem);
_0x1B4:
_0x1B3:
_0x1AC:
_0x1A5:
_0x19E:
_0x197:
	LD   R30,Y
	ST   -Y,R30
	RCALL _rem
; 0000 02BD }
_0x2080006:
	ADIW R28,4
	RET
;
;void zigzag(unsigned char arah,unsigned char mode_speed,unsigned char mode_rem)
; 0000 02C0 {
_zigzag:
; 0000 02C1     if(arah==kanan)
;	arah -> Y+2
;	mode_speed -> Y+1
;	mode_rem -> Y+0
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0x1B8
; 0000 02C2     {
; 0000 02C3         if(mode_speed==normal) while(s[0]==0 || s[2]==0) {pid2(150,23,15);}
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x1B9
_0x1BA:
	LDS  R26,_s
	CPI  R26,LOW(0x0)
	BREQ _0x1BD
	__GETB2MN _s,2
	CPI  R26,LOW(0x0)
	BRNE _0x1BC
_0x1BD:
	CALL SUBOPT_0x2C
	RJMP _0x1BA
_0x1BC:
; 0000 02C4         else if(mode_speed==fast) while(s[0]==0 || s[2]==0) {pid2(200,35,28);}
	RJMP _0x1BF
_0x1B9:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x1C0
_0x1C1:
	LDS  R26,_s
	CPI  R26,LOW(0x0)
	BREQ _0x1C4
	__GETB2MN _s,2
	CPI  R26,LOW(0x0)
	BRNE _0x1C3
_0x1C4:
	CALL SUBOPT_0x2B
	RJMP _0x1C1
_0x1C3:
; 0000 02C5     }
_0x1C0:
_0x1BF:
; 0000 02C6     else if(arah==kiri)
	RJMP _0x1C6
_0x1B8:
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x1C7
; 0000 02C7     {
; 0000 02C8         if(mode_speed==normal) while(s[5]==0 || s[7]==0) {pid2(150,23,15);}
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x1C8
_0x1C9:
	__GETB2MN _s,5
	CPI  R26,LOW(0x0)
	BREQ _0x1CC
	__GETB2MN _s,7
	CPI  R26,LOW(0x0)
	BRNE _0x1CB
_0x1CC:
	CALL SUBOPT_0x2C
	RJMP _0x1C9
_0x1CB:
; 0000 02C9         else if(mode_speed==fast) while(s[5]==0 || s[7]==0) {pid2(200,35,28);}
	RJMP _0x1CE
_0x1C8:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x1CF
_0x1D0:
	__GETB2MN _s,5
	CPI  R26,LOW(0x0)
	BREQ _0x1D3
	__GETB2MN _s,7
	CPI  R26,LOW(0x0)
	BRNE _0x1D2
_0x1D3:
	CALL SUBOPT_0x2B
	RJMP _0x1D0
_0x1D2:
; 0000 02CA     }
_0x1CF:
_0x1CE:
; 0000 02CB     rem(mode_rem);
_0x1C7:
_0x1C6:
	LD   R30,Y
	ST   -Y,R30
	RCALL _rem
; 0000 02CC }
	ADIW R28,3
	RET
;
;void program_lintasan2(unsigned char checkpoin)
; 0000 02CF {
_program_lintasan2:
; 0000 02D0     int i,j;
; 0000 02D1     if(checkpoin==0) goto start;
	CALL __SAVELOCR4
;	checkpoin -> Y+4
;	i -> R16,R17
;	j -> R18,R19
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x1D6
; 0000 02D2     else if(checkpoin==1) goto cp1;
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0x1D8
	RJMP _0x1D9
; 0000 02D3     else if(checkpoin==2) goto cp2;
_0x1D8:
	LDD  R26,Y+4
	CPI  R26,LOW(0x2)
	BRNE _0x1DB
	RJMP _0x1DC
; 0000 02D4     else if(checkpoin==3) goto cp3;
_0x1DB:
	LDD  R26,Y+4
	CPI  R26,LOW(0x3)
	BRNE _0x1DE
	RJMP _0x1DF
; 0000 02D5     else if(checkpoin==4) goto cp4;
_0x1DE:
	LDD  R26,Y+4
	CPI  R26,LOW(0x4)
	BRNE _0x1E1
	RJMP _0x1E2
; 0000 02D6     else if(checkpoin==5) goto cp5;
_0x1E1:
	LDD  R26,Y+4
	CPI  R26,LOW(0x5)
	BRNE _0x1E4
	RJMP _0x1E5
; 0000 02D7 
; 0000 02D8     start :
_0x1E4:
_0x1D6:
; 0000 02D9     gt=0;
	CALL SUBOPT_0x1C
; 0000 02DA     jalan(maju,200,maju,200,200);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 02DB     pidbit(0,1,normal,1);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
; 0000 02DC     jalan(maju,200,mundur,100,200);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x10
	CALL SUBOPT_0x34
; 0000 02DD     for(i=0;i<300;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x1E7:
	__CPWRN 16,17,300
	BRGE _0x1E8
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x1E7
_0x1E8:
; 0000 02E0 for(i=0;i<3;i++)
	__GETWRN 16,17,0
_0x1EA:
	__CPWRN 16,17,3
	BRGE _0x1EB
; 0000 02E1    {
; 0000 02E2 
; 0000 02E3         zigzag(kanan,normal,1);
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
; 0000 02E4         jalan(maju,250,mundur,100,200);
	CALL SUBOPT_0x10
	CALL SUBOPT_0x34
; 0000 02E5         zigzag(kiri,normal,1);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x37
; 0000 02E6         jalan(mundur,100,maju,250,200);
; 0000 02E7     }
	__ADDWRN 16,17,1
	RJMP _0x1EA
_0x1EB:
; 0000 02E8     gt=0;
	CALL SUBOPT_0x1C
; 0000 02E9     for(i=0;i<500;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x1ED:
	__CPWRN 16,17,500
	BRGE _0x1EE
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x1ED
_0x1EE:
; 0000 02EA cp1 :
_0x1D9:
; 0000 02EB     pidbit(6,7,normal,1);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x35
	CALL SUBOPT_0x39
; 0000 02EC     jalan(mundur,100,maju,200,200);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x31
; 0000 02ED     for(i=0;i<2250;i++) pid2(200,35,28);
	__GETWRN 16,17,0
_0x1F0:
	__CPWRN 16,17,2250
	BRGE _0x1F1
	CALL SUBOPT_0x2B
	__ADDWRN 16,17,1
	RJMP _0x1F0
_0x1F1:
; 0000 02EE for(i=0;i<3000;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x1F3:
	__CPWRN 16,17,3000
	BRGE _0x1F4
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x1F3
_0x1F4:
; 0000 02EF pidsayap(0,1,1,2);
	CALL SUBOPT_0x32
	LDI  R30,LOW(2)
	CALL SUBOPT_0x3B
; 0000 02F0     jalan(mundur,150,maju,200,200);
	LDI  R30,LOW(150)
	ST   -Y,R30
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 02F1 
; 0000 02F2     for(i=0;i<1300;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x1F6:
	__CPWRN 16,17,1300
	BRGE _0x1F7
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x1F6
_0x1F7:
; 0000 02F3 pidsayap(1,1,1,1);
	CALL SUBOPT_0x35
	CALL SUBOPT_0x35
	CALL SUBOPT_0x3C
; 0000 02F4     jalan(maju,200,mundur,100,150);
	CALL SUBOPT_0x3D
; 0000 02F5 
; 0000 02F6 
; 0000 02F7     for(i=0;i<1500;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x1F9:
	__CPWRN 16,17,1500
	BRGE _0x1FA
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x1F9
_0x1FA:
; 0000 02F8 pidbit(1,6,1,1);
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x35
	CALL SUBOPT_0x3F
; 0000 02F9     jalan(maju,200,mundur,100,150);
	CALL SUBOPT_0x3D
; 0000 02FA     last=0;
	CLR  R13
; 0000 02FB 
; 0000 02FC     for(i=0;i<800;i++) pid2(150,23,15); buz_on;
	__GETWRN 16,17,0
_0x1FC:
	__CPWRN 16,17,800
	BRGE _0x1FD
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x1FC
_0x1FD:
	CBI  0x15,7
; 0000 02FD     for(i=0;i<1300;i++) pid2(200,35,28); buz_off;
	__GETWRN 16,17,0
_0x201:
	__CPWRN 16,17,1300
	BRGE _0x202
	CALL SUBOPT_0x2B
	__ADDWRN 16,17,1
	RJMP _0x201
_0x202:
	SBI  0x15,7
; 0000 02FE     for(i=0;i<1000;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x206:
	__CPWRN 16,17,1000
	BRGE _0x207
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x206
_0x207:
; 0000 0300 cp2 :
_0x1DC:
; 0000 0301     gt=0;
	CALL SUBOPT_0x1C
; 0000 0302     if(checkpoin==2)
	LDD  R26,Y+4
	CPI  R26,LOW(0x2)
	BRNE _0x208
; 0000 0303     {
; 0000 0304     pidbit(1,6,normal,2);
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x40
	RCALL _pidbit
; 0000 0305     jalan(maju,0,maju,200,200);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0306     }
; 0000 0307     else
	RJMP _0x209
_0x208:
; 0000 0308     {
; 0000 0309     pidbit(1,6,normal,1);
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x35
	CALL SUBOPT_0x39
; 0000 030A     jalan(mundur,50,maju,200,150);
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
; 0000 030B     last = 0;
	CLR  R13
; 0000 030C     }
_0x209:
; 0000 030D     for(i=0;i<850;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x20B:
	__CPWRN 16,17,850
	BRGE _0x20C
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x20B
_0x20C:
; 0000 030E pidsayap(0,1,1,1);
	CALL SUBOPT_0x32
	LDI  R30,LOW(1)
	CALL SUBOPT_0x3B
; 0000 030F     jalan(mundur,100,maju,200,150);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x42
; 0000 0310     for(i=0;i<4000;i++) pid2(200,35,28);
	__GETWRN 16,17,0
_0x20E:
	__CPWRN 16,17,4000
	BRGE _0x20F
	CALL SUBOPT_0x2B
	__ADDWRN 16,17,1
	RJMP _0x20E
_0x20F:
; 0000 0311 PORTC.7=0;
	CBI  0x15,7
; 0000 0312     for(i=0;i<4000;i++) pid2(255,35,20);
	__GETWRN 16,17,0
_0x213:
	__CPWRN 16,17,4000
	BRGE _0x214
	CALL SUBOPT_0x43
	__ADDWRN 16,17,1
	RJMP _0x213
_0x214:
; 0000 0313 PORTC.7=1;
	SBI  0x15,7
; 0000 0314     for(i=0;i<2500;i++) pid2(200,35,28);
	__GETWRN 16,17,0
_0x218:
	__CPWRN 16,17,2500
	BRGE _0x219
	CALL SUBOPT_0x2B
	__ADDWRN 16,17,1
	RJMP _0x218
_0x219:
; 0000 0316 pidbit(7,0,4,1);
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
; 0000 0317 
; 0000 0318     gt=1; gt=1;
	CALL SUBOPT_0x1E
; 0000 0319 
; 0000 031A     gt=1; gt=1;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
; 0000 031B 
; 0000 031C     jalan(maju,100,maju,200,200);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x31
; 0000 031D     last=1;
	CALL SUBOPT_0x46
; 0000 031E     for(i=0;i<1500;i++) pid2(150,25,15);
_0x21B:
	__CPWRN 16,17,1500
	BRGE _0x21C
	CALL SUBOPT_0x47
	__ADDWRN 16,17,1
	RJMP _0x21B
_0x21C:
; 0000 0320 cp3 :
_0x1DF:
; 0000 0321     gt=1; gt=1;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
; 0000 0322     last=1;
	CALL SUBOPT_0x46
; 0000 0323     for(i=0;i<200;i++) pid2(150,25,15);
_0x21E:
	__CPWRN 16,17,200
	BRGE _0x21F
	CALL SUBOPT_0x47
	__ADDWRN 16,17,1
	RJMP _0x21E
_0x21F:
; 0000 0324 last=1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0325 
; 0000 0326     pidbit(0,1,1,1);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
; 0000 0327     jalan(maju,200,mundur,100,200);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x10
	CALL SUBOPT_0x34
; 0000 0328     for(i=0;i<100;i++) pid2(150,25,15);
	__GETWRN 16,17,0
_0x221:
	__CPWRN 16,17,100
	BRGE _0x222
	CALL SUBOPT_0x47
	__ADDWRN 16,17,1
	RJMP _0x221
_0x222:
; 0000 0329 pidbit(0,1,1,1);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
; 0000 032A     jalan(maju,200,mundur,0,200);
	CALL SUBOPT_0x48
	CALL SUBOPT_0x31
; 0000 032B     last=1;
	CALL SUBOPT_0x46
; 0000 032C     for(i=0;i<200;i++) pid2(150,25,15);
_0x224:
	__CPWRN 16,17,200
	BRGE _0x225
	CALL SUBOPT_0x47
	__ADDWRN 16,17,1
	RJMP _0x224
_0x225:
; 0000 0335 pidbit(0,7,1,1);
	CALL SUBOPT_0x49
	CALL SUBOPT_0x35
	RCALL _pidbit
; 0000 0336     gt=0; gt=0;
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1C
; 0000 0337 
; 0000 0338     jalan(maju,100,maju,100,180);
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x4A
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x34
; 0000 0339 
; 0000 033A     pidsayap(kanan,1,slow,1); buz_on;
	CALL SUBOPT_0x35
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4C
; 0000 033B     jalan(maju,150,maju,75,100);buz_off;
	RCALL _jalan
	SBI  0x15,7
; 0000 033C     for(i=0;i<100;i++)pid2(120,15,10);
	__GETWRN 16,17,0
_0x22B:
	__CPWRN 16,17,100
	BRGE _0x22C
	CALL SUBOPT_0x2D
	__ADDWRN 16,17,1
	RJMP _0x22B
_0x22C:
; 0000 033D pidsayap(0,1,0,1);
	CALL SUBOPT_0x4D
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0x4E
; 0000 033E     jalan(maju,150,maju,100,100);
	CALL SUBOPT_0x1
	RCALL _jalan
; 0000 033F 
; 0000 0340     for(i=0;i<=3000;i++) pid2(150,25,15);
	__GETWRN 16,17,0
_0x22E:
	__CPWRN 16,17,3001
	BRGE _0x22F
	CALL SUBOPT_0x47
	__ADDWRN 16,17,1
	RJMP _0x22E
_0x22F:
; 0000 0341 PORTC.7=0;
	CBI  0x15,7
; 0000 0342     pidbit(0,7,10,1);
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4F
; 0000 0343     jalan(maju,50,maju,200,100);
	CALL SUBOPT_0x41
	CALL SUBOPT_0x1
	RCALL _jalan
; 0000 0344     buz_off;
	SBI  0x15,7
; 0000 0345     gt=1; gt=1;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
; 0000 0346     pidbit(2,5,0,1);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x51
; 0000 0347 
; 0000 0348     for(i=0;i<=200;i++) pid2(120,15,10);
_0x235:
	__CPWRN 16,17,201
	BRGE _0x236
	CALL SUBOPT_0x2D
	__ADDWRN 16,17,1
	RJMP _0x235
_0x236:
; 0000 0349 pidsayapglp(1,0,1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0x32
	RCALL _pidsayapglp
; 0000 034A     jalan(maju,200,maju,200,100);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x30
	CALL SUBOPT_0x1
	RCALL _jalan
; 0000 034B 
; 0000 034C     cp4 :
_0x1E2:
; 0000 034D     if(checkpoin==4){
	LDD  R26,Y+4
	CPI  R26,LOW(0x4)
	BRNE _0x237
; 0000 034E         jalan(maju,70,maju,255,255);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	ST   -Y,R30
	CALL SUBOPT_0x52
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x32F
; 0000 034F         //jalan(maju,200,maju,200,100);
; 0000 0350         //jalan(maju,50,maju,200,300);
; 0000 0351     }
; 0000 0352     else jalan(mundur,50,maju,200,450);
_0x237:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0x41
	LDI  R30,LOW(450)
	LDI  R31,HIGH(450)
_0x32F:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _jalan
; 0000 0353     last=0;
	CLR  R13
; 0000 0354 
; 0000 0355     gt=0; gt=0;
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1C
; 0000 0356     for(i=0;i<300;i++) pid2(200,35,28);
	__GETWRN 16,17,0
_0x23A:
	__CPWRN 16,17,300
	BRGE _0x23B
	CALL SUBOPT_0x2B
	__ADDWRN 16,17,1
	RJMP _0x23A
_0x23B:
; 0000 0357 pidbit(0,7,2,1);
	CALL SUBOPT_0x49
	CALL SUBOPT_0x19
	CALL SUBOPT_0x45
; 0000 0358 
; 0000 0359     gt=1; gt=1;
	CALL SUBOPT_0x1E
; 0000 035A     //jalan(maju,200,maju,100,370);
; 0000 035B     buz_on;
	CBI  0x15,7
; 0000 035C     for(i=0;i<2000;i++) pid2(200,35,28);
	__GETWRN 16,17,0
_0x23F:
	__CPWRN 16,17,2000
	BRGE _0x240
	CALL SUBOPT_0x2B
	__ADDWRN 16,17,1
	RJMP _0x23F
_0x240:
; 0000 035D PORTC.7=1;
	SBI  0x15,7
; 0000 035E     for(i=0;i<800;i++) pid2(200,35,28);
	__GETWRN 16,17,0
_0x244:
	__CPWRN 16,17,800
	BRGE _0x245
	CALL SUBOPT_0x2B
	__ADDWRN 16,17,1
	RJMP _0x244
_0x245:
; 0000 035F pidbit(0,3,2,2);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL SUBOPT_0x53
	CALL SUBOPT_0x3F
; 0000 0360     jalan(maju,200,mundur,50,250);
	CALL SUBOPT_0x54
	CALL SUBOPT_0x55
; 0000 0361     last=1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0362     buz_on;
	CBI  0x15,7
; 0000 0363     for(i=0;i<100;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x249:
	__CPWRN 16,17,100
	BRGE _0x24A
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x249
_0x24A:
; 0000 0364 stop(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0xD
; 0000 0365     buz_off;
	SBI  0x15,7
; 0000 0366     jalan(maju,200,maju,50,150);
	CALL SUBOPT_0x30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	CALL SUBOPT_0x42
; 0000 0367     jalan(maju,200,maju,200,50);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x34
; 0000 0368     stop(100);
	CALL SUBOPT_0x1
	RCALL _stop
; 0000 0369 
; 0000 036A 
; 0000 036B     for(i=0;i<70;i++) pid2(150,25,15);
	__GETWRN 16,17,0
_0x24E:
	__CPWRN 16,17,70
	BRGE _0x24F
	CALL SUBOPT_0x47
	__ADDWRN 16,17,1
	RJMP _0x24E
_0x24F:
; 0000 036C cp5 :
_0x1E5:
; 0000 036D     gt=1; gt=1;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
; 0000 036E     pidbit(2,7,normal,2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL SUBOPT_0x40
	CALL SUBOPT_0x39
; 0000 036F     jalan(mundur,50,maju,200,150); //sarang lebah
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
; 0000 0370     last=0;
	CLR  R13
; 0000 0371     for(i=0;i<100;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x251:
	__CPWRN 16,17,100
	BRGE _0x252
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x251
_0x252:
; 0000 0372 pidbit(6,7,1,2);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x40
	RCALL _pidbit
; 0000 0373 
; 0000 0374     jalan(maju,50,maju,200,200);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x41
	CALL SUBOPT_0x31
; 0000 0375 
; 0000 0376     delay_ms(100);
	CALL SUBOPT_0x1
	CALL _delay_ms
; 0000 0377     last=0;
	CLR  R13
; 0000 0378     pidbit(0,7,1,1);
	CALL SUBOPT_0x49
	CALL SUBOPT_0x35
	RCALL _pidbit
; 0000 0379     last=1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 037A     jalan(maju,100,maju,200,100);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x1
	RCALL _jalan
; 0000 037B 
; 0000 037C     gt=0; gt=0;
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1C
; 0000 037D     for(i=0;i<1000;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x254:
	__CPWRN 16,17,1000
	BRGE _0x255
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x254
_0x255:
; 0000 037E pidbit(2,5,2,2);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x53
	CALL SUBOPT_0x39
; 0000 037F     pidbit(1,6,fast,1);
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL SUBOPT_0x19
	RCALL _pidbit
; 0000 0380     delay_ms(1000);
	CALL SUBOPT_0x17
; 0000 0381     jalan(maju,200,maju,200,200);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0382     pidbit(1,6,normal,1);
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x35
	CALL SUBOPT_0x51
; 0000 0383     for(i=0;i<10;i++) {delay_ms(100); bip;}
_0x257:
	__CPWRN 16,17,10
	BRGE _0x258
	CALL SUBOPT_0x1
	CALL _delay_ms
	CBI  0x15,7
	CALL SUBOPT_0x1
	CALL _delay_ms
	SBI  0x15,7
	__ADDWRN 16,17,1
	RJMP _0x257
_0x258:
; 0000 0384 
; 0000 0385 
; 0000 0386 }
	CALL __LOADLOCR4
_0x2080005:
	ADIW R28,5
	RET
;
;void program_lintasan1(unsigned char checkpoin)
; 0000 0389 {
_program_lintasan1:
; 0000 038A     int i,j;
; 0000 038B     if(checkpoin==0) goto start;
	CALL __SAVELOCR4
;	checkpoin -> Y+4
;	i -> R16,R17
;	j -> R18,R19
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x25E
; 0000 038C     else if(checkpoin==1) goto cp1;
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0x260
	RJMP _0x261
; 0000 038D     else if(checkpoin==2) goto cp2;
_0x260:
	LDD  R26,Y+4
	CPI  R26,LOW(0x2)
	BRNE _0x263
	RJMP _0x264
; 0000 038E     else if(checkpoin==3) goto cp3;
_0x263:
	LDD  R26,Y+4
	CPI  R26,LOW(0x3)
	BRNE _0x266
	RJMP _0x267
; 0000 038F     else if(checkpoin==4) goto cp4;
_0x266:
	LDD  R26,Y+4
	CPI  R26,LOW(0x4)
	BRNE _0x269
	RJMP _0x26A
; 0000 0390     else if(checkpoin==5) goto cp5;
_0x269:
	LDD  R26,Y+4
	CPI  R26,LOW(0x5)
	BRNE _0x26C
	RJMP _0x26D
; 0000 0391 
; 0000 0392     start :
_0x26C:
_0x25E:
; 0000 0393     gt=0;
	CALL SUBOPT_0x1C
; 0000 0394     jalan(maju,200,maju,200,200);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0395     pidbit(6,7,normal,1);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x35
	CALL SUBOPT_0x39
; 0000 0396     jalan(mundur,125,maju,200,200);
	LDI  R30,LOW(125)
	ST   -Y,R30
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0397     last=1;
	CALL SUBOPT_0x46
; 0000 0398     for(i=0;i<300;i++) pid2(150,23,15);
_0x26F:
	__CPWRN 16,17,300
	BRGE _0x270
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x26F
_0x270:
; 0000 039B for(i=0;i<3;i++)
	__GETWRN 16,17,0
_0x272:
	__CPWRN 16,17,3
	BRGE _0x273
; 0000 039C    {
; 0000 039D         zigzag(kiri,normal,1);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x37
; 0000 039E         jalan(mundur,100,maju,250,200);
; 0000 039F         zigzag(kanan,normal,1);
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
; 0000 03A0         jalan(maju,250,mundur,150,200);
	ST   -Y,R30
	LDI  R30,LOW(150)
	ST   -Y,R30
	CALL SUBOPT_0x31
; 0000 03A1    }
	__ADDWRN 16,17,1
	RJMP _0x272
_0x273:
; 0000 03A2 
; 0000 03A3    for(i=0;i<800;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x275:
	__CPWRN 16,17,800
	BRGE _0x276
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x275
_0x276:
; 0000 03A4 cp1 :
_0x261:
; 0000 03A5    gt=0;
	CALL SUBOPT_0x1C
; 0000 03A6 
; 0000 03A7    pidbit(0,1,1,1);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
; 0000 03A8    jalan(maju,200,mundur,100,200);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x10
	CALL SUBOPT_0x34
; 0000 03A9    for(i=0;i<2000;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x278:
	__CPWRN 16,17,2000
	BRGE _0x279
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x278
_0x279:
; 0000 03AA pidsayap(1,1,1,2);
	CALL SUBOPT_0x35
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3C
; 0000 03AB    jalan(maju,200,mundur,150,200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(150)
	ST   -Y,R30
	CALL SUBOPT_0x31
; 0000 03AC 
; 0000 03AD    for(i=0;i<1000;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x27B:
	__CPWRN 16,17,1000
	BRGE _0x27C
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x27B
_0x27C:
; 0000 03AE pidsayap(0,1,1,1);
	CALL SUBOPT_0x32
	LDI  R30,LOW(1)
	CALL SUBOPT_0x3B
; 0000 03AF    jalan(mundur,120,maju,200,150);
	LDI  R30,LOW(120)
	ST   -Y,R30
	CALL SUBOPT_0x30
	CALL SUBOPT_0x42
; 0000 03B0    last=1;
	CALL SUBOPT_0x46
; 0000 03B1 
; 0000 03B2    for(i=0;i<1000;i++) pid2(150,23,15);
_0x27E:
	__CPWRN 16,17,1000
	BRGE _0x27F
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x27E
_0x27F:
; 0000 03B3 pidbit(1,6,1,1);
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x35
	CALL SUBOPT_0x39
; 0000 03B4    jalan(mundur,100,maju,200,150);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x42
; 0000 03B5    last=1;
	CALL SUBOPT_0x46
; 0000 03B6    for(i=0;i<800;i++) pid2(150,23,15); buz_on;
_0x281:
	__CPWRN 16,17,800
	BRGE _0x282
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x281
_0x282:
	CBI  0x15,7
; 0000 03B7     for(i=0;i<1300;i++) pid2(200,35,28); buz_off;
	__GETWRN 16,17,0
_0x286:
	__CPWRN 16,17,1300
	BRGE _0x287
	CALL SUBOPT_0x2B
	__ADDWRN 16,17,1
	RJMP _0x286
_0x287:
	SBI  0x15,7
; 0000 03B8     for(i=0;i<1000;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x28B:
	__CPWRN 16,17,1000
	BRGE _0x28C
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x28B
_0x28C:
; 0000 03BA cp2 :
_0x264:
; 0000 03BB    gt=0;
	CALL SUBOPT_0x1C
; 0000 03BC    if(checkpoin==2)
	LDD  R26,Y+4
	CPI  R26,LOW(0x2)
	BRNE _0x28D
; 0000 03BD    {
; 0000 03BE     pidbit(1,6,normal,2);
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3F
; 0000 03BF     jalan(maju,200,maju,0,200);
	CALL SUBOPT_0xB
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP _0x330
; 0000 03C0     }
; 0000 03C1    else
_0x28D:
; 0000 03C2    {
; 0000 03C3     pidbit(1,6,normal,1);
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x35
	CALL SUBOPT_0x3F
; 0000 03C4     jalan(maju,200,mundur,50,150);
	CALL SUBOPT_0x54
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
_0x330:
	ST   -Y,R31
	ST   -Y,R30
	CALL _jalan
; 0000 03C5    }
; 0000 03C6    for(i=0;i<850;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x290:
	__CPWRN 16,17,850
	BRGE _0x291
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x290
_0x291:
; 0000 03C7 pidsayap(1,1,1,1);
	CALL SUBOPT_0x35
	CALL SUBOPT_0x35
	CALL SUBOPT_0x3C
; 0000 03C8    jalan(maju,200,mundur,200,200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(200)
	ST   -Y,R30
	CALL SUBOPT_0x31
; 0000 03C9    for(i=0;i<4000;i++) pid2(200,35,28);
	__GETWRN 16,17,0
_0x293:
	__CPWRN 16,17,4000
	BRGE _0x294
	CALL SUBOPT_0x2B
	__ADDWRN 16,17,1
	RJMP _0x293
_0x294:
; 0000 03CA PORTC.7=0;
	CBI  0x15,7
; 0000 03CB    for(i=0;i<4000;i++) pid2(255,35,20);
	__GETWRN 16,17,0
_0x298:
	__CPWRN 16,17,4000
	BRGE _0x299
	CALL SUBOPT_0x43
	__ADDWRN 16,17,1
	RJMP _0x298
_0x299:
; 0000 03CC PORTC.7=1;
	SBI  0x15,7
; 0000 03CD    for(i=0;i<2000;i++) pid2(200,35,28);
	__GETWRN 16,17,0
_0x29D:
	__CPWRN 16,17,2000
	BRGE _0x29E
	CALL SUBOPT_0x2B
	__ADDWRN 16,17,1
	RJMP _0x29D
_0x29E:
; 0000 03CE pidbit(7,0,4,1);
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
; 0000 03CF 
; 0000 03D0    gt=1; gt=1;
	CALL SUBOPT_0x1E
; 0000 03D1    gt=1; gt=1;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
; 0000 03D2 
; 0000 03D3    jalan(maju,200,maju,0,250);
	CALL SUBOPT_0x30
	CALL SUBOPT_0xB
	CALL SUBOPT_0x55
; 0000 03D4    last=0;
	CLR  R13
; 0000 03D5    for(i=0;i<500;i++) pid2(150,25,15);
	__GETWRN 16,17,0
_0x2A0:
	__CPWRN 16,17,500
	BRGE _0x2A1
	CALL SUBOPT_0x47
	__ADDWRN 16,17,1
	RJMP _0x2A0
_0x2A1:
; 0000 03D7 cp3 :
_0x267:
; 0000 03D8    gt=1; gt=1;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
; 0000 03D9    last=0;
	CLR  R13
; 0000 03DA    for(i=0;i<200;i++) pid2(150,25,15);
	__GETWRN 16,17,0
_0x2A3:
	__CPWRN 16,17,200
	BRGE _0x2A4
	CALL SUBOPT_0x47
	__ADDWRN 16,17,1
	RJMP _0x2A3
_0x2A4:
; 0000 03DB last=0;
	CLR  R13
; 0000 03DC    pidbit(6,7,1,1);  //
	CALL SUBOPT_0x38
	CALL SUBOPT_0x35
	CALL SUBOPT_0x39
; 0000 03DD    jalan(mundur,100,maju,200,200);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x31
; 0000 03DE    for(i=0;i<100;i++) pid2(150,25,15);
	__GETWRN 16,17,0
_0x2A6:
	__CPWRN 16,17,100
	BRGE _0x2A7
	CALL SUBOPT_0x47
	__ADDWRN 16,17,1
	RJMP _0x2A6
_0x2A7:
; 0000 03DF pidbit(6,7,1,1);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x35
	RCALL _pidbit
; 0000 03E0    jalan(maju,0,maju,200,200);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 03E1    last=0;
	CLR  R13
; 0000 03E2    for(i=0;i<200;i++) pid2(150,25,15);
	__GETWRN 16,17,0
_0x2A9:
	__CPWRN 16,17,200
	BRGE _0x2AA
	CALL SUBOPT_0x47
	__ADDWRN 16,17,1
	RJMP _0x2A9
_0x2AA:
; 0000 03E3 pidbit(0,7,1,1);
	CALL SUBOPT_0x49
	CALL SUBOPT_0x35
	RCALL _pidbit
; 0000 03E4    gt=0; gt=0;
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1C
; 0000 03E5 
; 0000 03E6 //   jalan(maju,100,maju,120,180);
; 0000 03E7 //   last=1;
; 0000 03E8 //   pidsayap(kiri,1,slow,1);
; 0000 03E9 //   jalan(maju,150,maju,50,100);
; 0000 03EA //   for(i=0;i<200;i++)pid2(120,15,10);
; 0000 03EB //   pidsayap(kanan,1,slow,1);
; 0000 03EC //   jalan(maju,100,maju,150,100);
; 0000 03ED //   for(i=0;i<2500;i++) pid2(150,25,15);
; 0000 03EE //   while(sensor!=0) pid2(120,15,10);
; 0000 03EF 
; 0000 03F0     jalan(maju,100,maju,100,180);
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x4A
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x34
; 0000 03F1     pidsayap(kiri,1,slow,1); buz_on;
	CALL SUBOPT_0x4D
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0x4C
; 0000 03F2     jalan(maju,150,maju,75,100);buz_off;
	CALL _jalan
	SBI  0x15,7
; 0000 03F3     for(i=0;i<100;i++)pid2(120,15,10);
	__GETWRN 16,17,0
_0x2B0:
	__CPWRN 16,17,100
	BRGE _0x2B1
	CALL SUBOPT_0x2D
	__ADDWRN 16,17,1
	RJMP _0x2B0
_0x2B1:
; 0000 03F4 pidsayap(1,1,0,1);
	CALL SUBOPT_0x35
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4E
; 0000 03F5     jalan(maju,150,maju,100,100);
	CALL SUBOPT_0x1
	CALL _jalan
; 0000 03F6     for(i=0;i<=3000;i++) pid2(150,25,15);
	__GETWRN 16,17,0
_0x2B3:
	__CPWRN 16,17,3001
	BRGE _0x2B4
	CALL SUBOPT_0x47
	__ADDWRN 16,17,1
	RJMP _0x2B3
_0x2B4:
; 0000 03F8 PORTC.7=0;
	CBI  0x15,7
; 0000 03F9    pidbit(0,7,10,1);
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4F
; 0000 03FA    jalan(maju,150,maju,0,100);
	LDI  R30,LOW(150)
	ST   -Y,R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0x1
	CALL _jalan
; 0000 03FB    buz_off;
	SBI  0x15,7
; 0000 03FC    gt=1; gt=1;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
; 0000 03FD    pidbit(2,5,0,1);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x51
; 0000 03FE 
; 0000 03FF    for(i=0;i<=500;i++) pid2(120,15,10);
_0x2BA:
	__CPWRN 16,17,501
	BRGE _0x2BB
	CALL SUBOPT_0x2D
	__ADDWRN 16,17,1
	RJMP _0x2BA
_0x2BB:
; 0000 0400 pidsayapglp(0,1,0,1);
	CALL SUBOPT_0x4D
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _pidsayapglp
; 0000 0401    jalan(maju,200,maju,200,75);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x30
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	CALL SUBOPT_0x34
; 0000 0402 
; 0000 0403    cp4 :
_0x26A:
; 0000 0404    if(checkpoin==4){
	LDD  R26,Y+4
	CPI  R26,LOW(0x4)
	BRNE _0x2BC
; 0000 0405        jalan(maju,255,maju,70,255);
	CALL SUBOPT_0x52
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(70)
	ST   -Y,R30
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x331
; 0000 0406 
; 0000 0407    }
; 0000 0408    else jalan(maju,200,mundur,50,450);
_0x2BC:
	CALL SUBOPT_0x30
	CALL SUBOPT_0x54
	LDI  R30,LOW(450)
	LDI  R31,HIGH(450)
_0x331:
	ST   -Y,R31
	ST   -Y,R30
	CALL _jalan
; 0000 0409    last=1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 040A 
; 0000 040B    gt=0; gt=0;
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1C
; 0000 040C    for(i=0;i<300;i++) pid2(200,35,28);
	__GETWRN 16,17,0
_0x2BF:
	__CPWRN 16,17,300
	BRGE _0x2C0
	CALL SUBOPT_0x2B
	__ADDWRN 16,17,1
	RJMP _0x2BF
_0x2C0:
; 0000 040D pidbit(0,7,2,1);
	CALL SUBOPT_0x49
	CALL SUBOPT_0x19
	CALL SUBOPT_0x45
; 0000 040E 
; 0000 040F    gt=1; gt=1;
	CALL SUBOPT_0x1E
; 0000 0410    buz_on;
	CBI  0x15,7
; 0000 0411    for(i=0;i<2000;i++) pid2(200,35,28);
	__GETWRN 16,17,0
_0x2C4:
	__CPWRN 16,17,2000
	BRGE _0x2C5
	CALL SUBOPT_0x2B
	__ADDWRN 16,17,1
	RJMP _0x2C4
_0x2C5:
; 0000 0412 PORTC.7=1;
	SBI  0x15,7
; 0000 0413    //jalan(maju,150,maju,200,325);
; 0000 0414    for(i=0;i<300;i++) pid2(200,35,28);
	__GETWRN 16,17,0
_0x2C9:
	__CPWRN 16,17,300
	BRGE _0x2CA
	CALL SUBOPT_0x2B
	__ADDWRN 16,17,1
	RJMP _0x2C9
_0x2CA:
; 0000 0415 pidbit(7,4,2,2);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL SUBOPT_0x53
	CALL SUBOPT_0x39
; 0000 0416    jalan(mundur,50,maju,200,250);
	CALL SUBOPT_0x41
	CALL SUBOPT_0x55
; 0000 0417    last=0;
	CLR  R13
; 0000 0418    buz_on;
	CBI  0x15,7
; 0000 0419 
; 0000 041A    for(i=0;i<100;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x2CE:
	__CPWRN 16,17,100
	BRGE _0x2CF
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x2CE
_0x2CF:
; 0000 041B stop(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0xD
; 0000 041C    buz_off;
	SBI  0x15,7
; 0000 041D    jalan(maju,50,maju,200,150);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
; 0000 041E    jalan(maju,200,maju,200,50);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x34
; 0000 041F    stop(100);
	CALL SUBOPT_0x1
	CALL _stop
; 0000 0420 
; 0000 0421    for(i=0;i<70;i++) pid2(150,25,15);
	__GETWRN 16,17,0
_0x2D3:
	__CPWRN 16,17,70
	BRGE _0x2D4
	CALL SUBOPT_0x47
	__ADDWRN 16,17,1
	RJMP _0x2D3
_0x2D4:
; 0000 0423 cp5 :
_0x26D:
; 0000 0424    gt=1; gt=1;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
; 0000 0425    pidbit(5,0,normal,2);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3F
; 0000 0426    jalan(maju,200,mundur,50,150); //sarang lebah
	CALL SUBOPT_0x54
	CALL SUBOPT_0x42
; 0000 0427    last=1;
	CALL SUBOPT_0x46
; 0000 0428    for(i=0;i<100;i++) pid2(150,23,15);
_0x2D6:
	__CPWRN 16,17,100
	BRGE _0x2D7
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x2D6
_0x2D7:
; 0000 0429 pidbit(1,0,1,2);
	CALL SUBOPT_0x48
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3F
; 0000 042A 
; 0000 042B    jalan(maju,200,maju,50,200);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	CALL SUBOPT_0x31
; 0000 042C 
; 0000 042D    delay_ms(100);
	CALL SUBOPT_0x1
	CALL _delay_ms
; 0000 042E    last=1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 042F    pidbit(0,7,1,1);
	CALL SUBOPT_0x49
	CALL SUBOPT_0x35
	RCALL _pidbit
; 0000 0430    last=0;
	CLR  R13
; 0000 0431    jalan(maju,200,maju,100,100);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x1
	CALL _jalan
; 0000 0432 
; 0000 0433    gt=0; gt=0;
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1C
; 0000 0434    for(i=0;i<1000;i++) pid2(150,23,15);
	__GETWRN 16,17,0
_0x2D9:
	__CPWRN 16,17,1000
	BRGE _0x2DA
	CALL SUBOPT_0x2C
	__ADDWRN 16,17,1
	RJMP _0x2D9
_0x2DA:
; 0000 0435 pidbit(2,5,2,2);
	CALL SUBOPT_0x50
	CALL SUBOPT_0x53
	CALL SUBOPT_0x39
; 0000 0436    pidbit(1,6,fast,1);
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL SUBOPT_0x19
	RCALL _pidbit
; 0000 0437    delay_ms(1000);
	CALL SUBOPT_0x17
; 0000 0438    jalan(maju,200,maju,200,200);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0439    pidbit(1,6,normal,1);
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x35
	CALL SUBOPT_0x51
; 0000 043A    for(i=0;i<10;i++) {delay_ms(100); bip;}
_0x2DC:
	__CPWRN 16,17,10
	BRGE _0x2DD
	CALL SUBOPT_0x1
	CALL _delay_ms
	CBI  0x15,7
	CALL SUBOPT_0x1
	CALL _delay_ms
	SBI  0x15,7
	__ADDWRN 16,17,1
	RJMP _0x2DC
_0x2DD:
; 0000 043B 
; 0000 043C }
	CALL __LOADLOCR4
	RJMP _0x2080004
;
;void pilih_start()
; 0000 043F {
_pilih_start:
; 0000 0440     lcd_clear();
	CALL _lcd_clear
; 0000 0441     lcd_putsf("  Masukan Mode ");
	__POINTW1FN _0x0,187
	CALL SUBOPT_0x7
; 0000 0442     lcd_putsf("     Start     ");
	__POINTW1FN _0x0,203
	CALL SUBOPT_0x7
; 0000 0443     while(key>5)
_0x2E2:
	LDI  R30,LOW(5)
	CP   R30,R5
	BRSH _0x2E4
; 0000 0444     {
; 0000 0445         key=keypad();
	CALL _keypad
	MOV  R5,R30
; 0000 0446         if(key==1 || key==4) pilihstart=0;
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ _0x2E6
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x2E5
_0x2E6:
	LDI  R26,LOW(_pilihstart)
	LDI  R27,HIGH(_pilihstart)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0447         if(key==2 || key==3) pilihstart=1;
_0x2E5:
	LDI  R30,LOW(2)
	CP   R30,R5
	BREQ _0x2E9
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x2E8
_0x2E9:
	LDI  R26,LOW(_pilihstart)
	LDI  R27,HIGH(_pilihstart)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0448     }
_0x2E8:
	RJMP _0x2E2
_0x2E4:
; 0000 0449     lcd_clear();
	CALL _lcd_clear
; 0000 044A     lcd_putsf(" Alhamdulillah ");
	__POINTW1FN _0x0,219
	CALL SUBOPT_0x7
; 0000 044B     delay_ms(500);
	CALL SUBOPT_0x2
; 0000 044C     lcd_clear();
	CALL _lcd_clear
; 0000 044D     key=kosong;
	LDI  R30,LOW(123)
	MOV  R5,R30
; 0000 044E }
	RET
;
;void menulama()
; 0000 0451 {
_menulama:
; 0000 0452     while(key!=12)
_0x2EB:
	LDI  R30,LOW(12)
	CP   R30,R5
	BRNE PC+3
	JMP _0x2ED
; 0000 0453     {
; 0000 0454         key=keypad();
	CALL _keypad
	MOV  R5,R30
; 0000 0455         if(key==1)
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x2EE
; 0000 0456         {
; 0000 0457             lcd_clear();
	CALL _lcd_clear
; 0000 0458             lcd_puts(" Masukan CheckP ");
	__POINTW1MN _0x2EF,0
	CALL SUBOPT_0x56
; 0000 0459             delay_ms(500);
; 0000 045A             key=inkeypad();
	CALL _inkeypad
	MOV  R5,R30
; 0000 045B             program_lintasan2(key);
	ST   -Y,R5
	RCALL _program_lintasan2
; 0000 045C             key=kosong;
	LDI  R30,LOW(123)
	MOV  R5,R30
; 0000 045D 
; 0000 045E 
; 0000 045F         }
; 0000 0460         while(key==3) kalibrasi();
_0x2EE:
_0x2F0:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x2F2
	CALL _kalibrasi
	RJMP _0x2F0
_0x2F2:
; 0000 0461 if(key==2)
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x2F3
; 0000 0462         {
; 0000 0463             lcd_clear();
	CALL _lcd_clear
; 0000 0464             while(key!=12)
_0x2F4:
	LDI  R30,LOW(12)
	CP   R30,R5
	BREQ _0x2F6
; 0000 0465             {
; 0000 0466                 key=keypad();
	CALL _keypad
	MOV  R5,R30
; 0000 0467                 cetak_sensor();
	CALL _cetak_sensor
; 0000 0468             }
	RJMP _0x2F4
_0x2F6:
; 0000 0469             lcd_clear();
	CALL _lcd_clear
; 0000 046A         }
; 0000 046B         if(key==5) {lcd_clear(); cek_adc();}
_0x2F3:
	LDI  R30,LOW(5)
	CP   R30,R5
	BRNE _0x2F7
	CALL _lcd_clear
	CALL _cek_adc
; 0000 046C         if(key==4) {delay_ms(300); set_baca();}
_0x2F7:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x2F8
	CALL SUBOPT_0x22
	CALL _set_baca
; 0000 046D         if(key==6) {
_0x2F8:
	LDI  R30,LOW(6)
	CP   R30,R5
	BRNE _0x2F9
; 0000 046E             lcd_clear();
	CALL _lcd_clear
; 0000 046F             lcd_puts(" Masukan CheckP ");
	__POINTW1MN _0x2EF,17
	CALL SUBOPT_0x56
; 0000 0470             delay_ms(500);
; 0000 0471             key=inkeypad();
	CALL _inkeypad
	MOV  R5,R30
; 0000 0472             program_lintasan1(key);
	ST   -Y,R5
	RCALL _program_lintasan1
; 0000 0473             key=kosong;
	LDI  R30,LOW(123)
	MOV  R5,R30
; 0000 0474 
; 0000 0475 
; 0000 0476         }
; 0000 0477          //program_masukhitam();
; 0000 0478         if(key==7) {
_0x2F9:
	LDI  R30,LOW(7)
	CP   R30,R5
	BREQ PC+3
	JMP _0x2FA
; 0000 0479             delay_ms(300);
	CALL SUBOPT_0x22
; 0000 047A             lcd_clear();
	CALL _lcd_clear
; 0000 047B             lcd_puts("   MOTOR KIRI   ");
	__POINTW1MN _0x2EF,34
	CALL SUBOPT_0x57
; 0000 047C             lcd_puts("1:Maju  2:Mundur");
	__POINTW1MN _0x2EF,51
	CALL SUBOPT_0x57
; 0000 047D             key2=inkeypad();
	CALL _inkeypad
	MOV  R4,R30
; 0000 047E             if(key2==1) in_arah_kiri=maju;
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x2FB
	CLR  R6
; 0000 047F             else in_arah_kiri=mundur;
	RJMP _0x2FC
_0x2FB:
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0480 
; 0000 0481             lcd_clear();
_0x2FC:
	CALL _lcd_clear
; 0000 0482             lcd_puts("Speed : ");
	__POINTW1MN _0x2EF,68
	CALL SUBOPT_0x57
; 0000 0483             in_kec_kiri=inputnilai(8);
	CALL SUBOPT_0x58
	MOV  R9,R30
; 0000 0484 
; 0000 0485             lcd_clear();
	CALL _lcd_clear
; 0000 0486             lcd_puts("  MOTOR  KANAN  ");
	__POINTW1MN _0x2EF,77
	CALL SUBOPT_0x57
; 0000 0487             lcd_puts("1:Maju  2:Mundur");
	__POINTW1MN _0x2EF,94
	CALL SUBOPT_0x57
; 0000 0488             key2=inkeypad();
	CALL _inkeypad
	MOV  R4,R30
; 0000 0489             if(key2==1) in_arah_kanan=maju;
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x2FD
	CLR  R8
; 0000 048A             else in_arah_kanan=mundur;
	RJMP _0x2FE
_0x2FD:
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 048B 
; 0000 048C             lcd_clear();
_0x2FE:
	CALL _lcd_clear
; 0000 048D             lcd_puts("Speed : ");
	__POINTW1MN _0x2EF,111
	CALL SUBOPT_0x57
; 0000 048E             in_kec_kanan=inputnilai(8);
	CALL SUBOPT_0x58
	MOV  R11,R30
; 0000 048F 
; 0000 0490             lcd_clear();
	CALL _lcd_clear
; 0000 0491             lcd_puts("Delay : ");
	__POINTW1MN _0x2EF,120
	CALL SUBOPT_0x57
; 0000 0492             delay_belok=inputnilai(8);
	CALL SUBOPT_0x58
	MOV  R10,R30
; 0000 0493 
; 0000 0494             lcd_clear();
	CALL _lcd_clear
; 0000 0495             jalan(in_arah_kiri,in_kec_kiri,in_arah_kanan,in_kec_kanan,delay_belok);
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R8
	ST   -Y,R11
	MOV  R30,R10
	LDI  R31,0
	CALL SUBOPT_0x34
; 0000 0496         }
; 0000 0497         if(key==8) {lcd_clear(); while(1) {pid2(150,23,15);}}
_0x2FA:
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x2FF
	CALL _lcd_clear
_0x300:
	CALL SUBOPT_0x2C
	RJMP _0x300
; 0000 0498         if(key==9) {
_0x2FF:
	LDI  R30,LOW(9)
	CP   R30,R5
	BRNE _0x303
; 0000 0499             delay_ms(300);
	CALL SUBOPT_0x22
; 0000 049A             lcd_clear(); lcd_puts("Speed : ");
	CALL _lcd_clear
	__POINTW1MN _0x2EF,129
	CALL SUBOPT_0x57
; 0000 049B             inkec=inputnilai(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _inputnilai
	LDI  R26,LOW(_inkec)
	LDI  R27,HIGH(_inkec)
	CALL __EEPROMWRB
; 0000 049C             lcd_clear(); lcd_puts("KP : ");
	CALL _lcd_clear
	__POINTW1MN _0x2EF,138
	CALL SUBOPT_0x57
; 0000 049D             inkp=inputnilai(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _inputnilai
	LDI  R26,LOW(_inkp)
	LDI  R27,HIGH(_inkp)
	CALL __EEPROMWRB
; 0000 049E             lcd_clear(); lcd_puts("KD : ");
	CALL _lcd_clear
	__POINTW1MN _0x2EF,144
	CALL SUBOPT_0x57
; 0000 049F             inkd=inputnilai(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _inputnilai
	LDI  R26,LOW(_inkd)
	LDI  R27,HIGH(_inkd)
	CALL __EEPROMWRB
; 0000 04A0             while(1) pid2(inkec,inkp,inkd);
_0x304:
	LDI  R26,LOW(_inkec)
	LDI  R27,HIGH(_inkec)
	CALL __EEPROMRDB
	ST   -Y,R30
	LDI  R26,LOW(_inkp)
	LDI  R27,HIGH(_inkp)
	CALL __EEPROMRDB
	ST   -Y,R30
	LDI  R26,LOW(_inkd)
	LDI  R27,HIGH(_inkd)
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _pid2
	RJMP _0x304
; 0000 04A2 }
; 0000 04A3         if(key==0) {motor_ki(maju,255); motor_ka(maju,255);}
_0x303:
	TST  R5
	BRNE _0x307
	CALL SUBOPT_0x52
	CALL _motor_ki
	CALL SUBOPT_0x52
	CALL _motor_ka
; 0000 04A4 
; 0000 04A5     }
_0x307:
	RJMP _0x2EB
_0x2ED:
; 0000 04A6 }
	RET

	.DSEG
_0x2EF:
	.BYTE 0x96
;
;void menubaru()
; 0000 04A9 {

	.CSEG
_menubaru:
; 0000 04AA     while(1)
_0x308:
; 0000 04AB     {
; 0000 04AC         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 04AD         lcd_putsf("   Bismillah    ");
	__POINTW1FN _0x0,333
	CALL SUBOPT_0x7
; 0000 04AE         if(pilihstart==0) lcd_putsf("Mode Start : 1/4");
	LDI  R26,LOW(_pilihstart)
	LDI  R27,HIGH(_pilihstart)
	CALL __EEPROMRDB
	CPI  R30,0
	BRNE _0x30B
	__POINTW1FN _0x0,350
	RJMP _0x332
; 0000 04AF         else lcd_putsf("Mode Start : 2/3");
_0x30B:
	__POINTW1FN _0x0,367
_0x332:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 04B0 
; 0000 04B1         key=keypad();
	CALL _keypad
	MOV  R5,R30
; 0000 04B2         if(key>=0 && key <=5)
	LDI  R30,LOW(0)
	CP   R5,R30
	BRLO _0x30E
	LDI  R30,LOW(5)
	CP   R30,R5
	BRSH _0x30F
_0x30E:
	RJMP _0x30D
_0x30F:
; 0000 04B3         {
; 0000 04B4             if(pilihstart == 0) program_lintasan1(key);
	LDI  R26,LOW(_pilihstart)
	LDI  R27,HIGH(_pilihstart)
	CALL __EEPROMRDB
	CPI  R30,0
	BRNE _0x310
	ST   -Y,R5
	RCALL _program_lintasan1
; 0000 04B5             else program_lintasan2(key);
	RJMP _0x311
_0x310:
	ST   -Y,R5
	RCALL _program_lintasan2
; 0000 04B6             key=kosong;
_0x311:
	LDI  R30,LOW(123)
	MOV  R5,R30
; 0000 04B7         }
; 0000 04B8         if(key==6)
_0x30D:
	LDI  R30,LOW(6)
	CP   R30,R5
	BRNE _0x312
; 0000 04B9         {
; 0000 04BA             delay_ms(500);
	CALL SUBOPT_0x2
; 0000 04BB             menulama();
	RCALL _menulama
; 0000 04BC         }
; 0000 04BD         if(key==7)
_0x312:
	LDI  R30,LOW(7)
	CP   R30,R5
	BRNE _0x313
; 0000 04BE         {
; 0000 04BF             kalibrasi();
	CALL _kalibrasi
; 0000 04C0 
; 0000 04C1         }
; 0000 04C2         if(key==8)
_0x313:
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x314
; 0000 04C3         {
; 0000 04C4             lcd_clear();
	CALL _lcd_clear
; 0000 04C5             while(key!=12)
_0x315:
	LDI  R30,LOW(12)
	CP   R30,R5
	BREQ _0x317
; 0000 04C6             {
; 0000 04C7                 key=keypad();
	CALL _keypad
	MOV  R5,R30
; 0000 04C8                 cetak_sensor();
	CALL _cetak_sensor
; 0000 04C9             }
	RJMP _0x315
_0x317:
; 0000 04CA             lcd_clear();
	CALL _lcd_clear
; 0000 04CB         }
; 0000 04CC         if(key==9)
_0x314:
	LDI  R30,LOW(9)
	CP   R30,R5
	BRNE _0x318
; 0000 04CD         {
; 0000 04CE             pilih_start();
	RCALL _pilih_start
; 0000 04CF         }
; 0000 04D0 
; 0000 04D1     }
_0x318:
	RJMP _0x308
; 0000 04D2 }
;
;// Declare your global variables here
;void main(void)
; 0000 04D6 {
_main:
; 0000 04D7 // Declare your local variables here
; 0000 04D8 
; 0000 04D9 // Input/Output Ports initialization
; 0000 04DA // Port A initialization
; 0000 04DB // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 04DC // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 04DD PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 04DE DDRA=0x00;
	OUT  0x1A,R30
; 0000 04DF 
; 0000 04E0 // Port B initialization
; 0000 04E1 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 04E2 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 04E3 PORTB=0x00;
	OUT  0x18,R30
; 0000 04E4 DDRB=0x00;
	OUT  0x17,R30
; 0000 04E5 
; 0000 04E6 // Port C initialization
; 0000 04E7 // Func7=Out Func6=Out Func5=Out Func4=In Func3=Out Func2=In Func1=Out Func0=In
; 0000 04E8 // State7=1 State6=1 State5=1 State4=P State3=1 State2=P State1=1 State0=P
; 0000 04E9 PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 04EA DDRC=0b11101010;
	LDI  R30,LOW(234)
	OUT  0x14,R30
; 0000 04EB 
; 0000 04EC // Port D initialization
; 0000 04ED // Func7=Out Func6=Out Func5=Out Func4=In Func3=Out Func2=In Func1=Out Func0=In
; 0000 04EE // State7=1 State6=1 State5=1 State4=P State3=1 State2=P State1=1 State0=P
; 0000 04EF PORTD=0x0C;
	LDI  R30,LOW(12)
	OUT  0x12,R30
; 0000 04F0 DDRD=0xF3;
	LDI  R30,LOW(243)
	OUT  0x11,R30
; 0000 04F1 
; 0000 04F2 // Timer/Counter 0 initialization
; 0000 04F3 // Clock source: System Clock
; 0000 04F4 // Clock value: Timer 0 Stopped
; 0000 04F5 // Mode: Normal top=FFh
; 0000 04F6 // OC0 output: Disconnected
; 0000 04F7 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 04F8 TCNT0=0x00;
	OUT  0x32,R30
; 0000 04F9 OCR0=0x00;
	OUT  0x3C,R30
; 0000 04FA // Timer/Counter 1 initialization
; 0000 04FB // Clock source: System Clock
; 0000 04FC // Clock value: 15,625 kHz
; 0000 04FD // Mode: Fast PWM top=0x00FF
; 0000 04FE // OC1A output: Non-Inv.
; 0000 04FF // OC1B output: Non-Inv.
; 0000 0500 // Noise Canceler: Off
; 0000 0501 // Input Capture on Falling Edge
; 0000 0502 // Timer1 Overflow Interrupt: Off
; 0000 0503 // Input Capture Interrupt: Off
; 0000 0504 // Compare A Match Interrupt: Off
; 0000 0505 // Compare B Match Interrupt: Off
; 0000 0506 TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0507 TCCR1B=0x0D;
	LDI  R30,LOW(13)
	OUT  0x2E,R30
; 0000 0508 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0509 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 050A ICR1H=0x00;
	OUT  0x27,R30
; 0000 050B ICR1L=0x00;
	OUT  0x26,R30
; 0000 050C OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 050D OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 050E OCR1BH=0x00;
	OUT  0x29,R30
; 0000 050F OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0510 
; 0000 0511 // Timer/Counter 2 initialization
; 0000 0512 // Clock source: System Clock
; 0000 0513 // Clock value: Timer 2 Stopped
; 0000 0514 // Mode: Normal top=FFh
; 0000 0515 // OC2 output: Disconnected
; 0000 0516 ASSR=0x00;
	OUT  0x22,R30
; 0000 0517 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0518 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0519 OCR2=0x00;
	OUT  0x23,R30
; 0000 051A 
; 0000 051B // External Interrupt(s) initialization
; 0000 051C // INT0: Off
; 0000 051D // INT1: Off
; 0000 051E // INT2: Off
; 0000 051F MCUCR=0x00;
	OUT  0x35,R30
; 0000 0520 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0521 
; 0000 0522 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0523 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0524 
; 0000 0525 // Analog Comparator initialization
; 0000 0526 // Analog Comparator: Off
; 0000 0527 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0528 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0529 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 052A 
; 0000 052B // ADC initialization
; 0000 052C // ADC Clock frequency: 691,200 kHz
; 0000 052D // ADC Voltage Reference: AREF pin
; 0000 052E // ADC Auto Trigger Source: ADC Stopped
; 0000 052F // Only the 8 most significant bits of
; 0000 0530 // the AD conversion result are used
; 0000 0531 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 0532 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 0533 
; 0000 0534 // LCD module initialization
; 0000 0535 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0536 
; 0000 0537 
; 0000 0538     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 0539     lcd_putsf("ASSALAMUALAIKUM ");
	__POINTW1FN _0x0,384
	CALL SUBOPT_0x7
; 0000 053A     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
; 0000 053B     lcd_putsf(" BISMILLAH :)  ");
	__POINTW1FN _0x0,401
	CALL SUBOPT_0x7
; 0000 053C     delay_ms(500);
	CALL SUBOPT_0x2
; 0000 053D     lcd_clear();
	CALL SUBOPT_0x1D
; 0000 053E     delay_ms(200);
; 0000 053F     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 0540     lcd_putsf("    TOOTHLESS   ");
	__POINTW1FN _0x0,417
	CALL SUBOPT_0x7
; 0000 0541     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
; 0000 0542     lcd_putsf("  Line Follower ");
	__POINTW1FN _0x0,434
	CALL SUBOPT_0x7
; 0000 0543     delay_ms(500);
	CALL SUBOPT_0x2
; 0000 0544     lcd_clear();
	CALL _lcd_clear
; 0000 0545     delay_ms(100);
	CALL SUBOPT_0x1
	CALL _delay_ms
; 0000 0546     lcd_putsf("  Pilih   Menu  ");
	__POINTW1FN _0x0,451
	CALL SUBOPT_0x7
; 0000 0547     if(pilihstart==255) pilih_start();
	LDI  R26,LOW(_pilihstart)
	LDI  R27,HIGH(_pilihstart)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xFF)
	BRNE _0x319
	RCALL _pilih_start
; 0000 0548 
; 0000 0549 
; 0000 054A while (1)
_0x319:
_0x31A:
; 0000 054B       {
; 0000 054C         menubaru();
	RCALL _menubaru
; 0000 054D       }
	RJMP _0x31A
; 0000 054E }
_0x31D:
	RJMP _0x31D
;
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
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
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
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2080004:
	ADIW R28,5
	RET
__print_G100:
	SBIW R28,6
	CALL __SAVELOCR6
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
	BRNE PC+3
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x59
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x59
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
	BREQ PC+3
	JMP _0x200001B
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
	CALL SUBOPT_0x5A
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x5B
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5C
	CALL _strlenf
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
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5D
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
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
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x5D
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
	CALL SUBOPT_0x59
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
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x59
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
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
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
	CALL SUBOPT_0x5B
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x59
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
	CALL SUBOPT_0x5B
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
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x5E
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080003
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x5E
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080003:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G101:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2080001
__lcd_read_nibble_G101:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
    andi  r30,0xf0
	RET
_lcd_read_byte0_G101:
	CALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	CALL SUBOPT_0x8
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R12,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R12,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	CP   R12,R30
	BRLO _0x2020004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2020004:
	INC  R12
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2080001
_lcd_puts:
	ST   -Y,R17
_0x2020005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020005
_0x2020007:
	RJMP _0x2080002
_lcd_putsf:
	ST   -Y,R17
_0x2020008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G101:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G101:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2080001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x5F
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x60
	LDI  R30,LOW(4)
	CALL SUBOPT_0x60
	LDI  R30,LOW(133)
	CALL SUBOPT_0x60
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x2080001
_0x202000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2080001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG
_strlen:
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

	.DSEG
_buf:
	.BYTE 0x3
_buf2:
	.BYTE 0x5
_buf3:
	.BYTE 0x10
_data_sensor:
	.BYTE 0x8
_data_gelap:
	.BYTE 0x8
_data_terang:
	.BYTE 0x8

	.ESEG
_data_ref:
	.DB  LOW(0x780078),HIGH(0x780078),BYTE3(0x780078),BYTE4(0x780078)
	.DB  LOW(0x780078),HIGH(0x780078),BYTE3(0x780078),BYTE4(0x780078)
	.DB  LOW(0x780078),HIGH(0x780078),BYTE3(0x780078),BYTE4(0x780078)
	.DB  LOW(0x780078),HIGH(0x780078),BYTE3(0x780078),BYTE4(0x780078)
_gt:
	.DB  0x0
_inkec:
	.BYTE 0x1
_inkp:
	.BYTE 0x1
_inkd:
	.BYTE 0x1
_pilihstart:
	.BYTE 0x1

	.DSEG
_s:
	.BYTE 0x8
_last_error:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(_buf2)
	LDI  R31,HIGH(_buf2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	CALL _motor_ka
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _jalan_mundur

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	ST   -Y,R30
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(_gt)
	LDI  R27,HIGH(_gt)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x13:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_data_sensor)
	SBCI R31,HIGH(-_data_sensor)
	LD   R0,Z
	MOV  R30,R17
	LDI  R26,LOW(_data_ref)
	LDI  R27,HIGH(_data_ref)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOV  R26,R0
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14:
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_s)
	SBCI R27,HIGH(-_s)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(_data_ref)
	LDI  R27,HIGH(_data_ref)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	MOV  R30,R19
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(_gt)
	LDI  R27,HIGH(_gt)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	CALL _lcd_clear
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(_gt)
	LDI  R27,HIGH(_gt)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(_buf3)
	LDI  R31,HIGH(_buf3)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x20:
	ST   -Y,R30
	CALL _read_adc
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	MOV  R30,R7
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	LDS  R26,_last_error
	LDS  R27,_last_error+1
	MOVW R30,R16
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	LDI  R27,0
	MOVW R30,R16
	CALL __MULW12
	MOVW R22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	CALL __CWD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	CALL __CWD2
	CALL __SWAPD12
	CALL __SUBD12
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	MOVW R26,R18
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(1)
	ST   -Y,R30
	MOV  R30,R18
	NEG  R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	MOVW R26,R20
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(200)
	ST   -Y,R30
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(28)
	ST   -Y,R30
	JMP  _pid2

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:171 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(150)
	ST   -Y,R30
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	JMP  _pid2

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(120)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	JMP  _pid2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2E:
	LDD  R30,Y+3
	LDI  R31,0
	SUBI R30,LOW(-_s)
	SBCI R31,HIGH(-_s)
	LD   R26,Z
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2F:
	LDD  R30,Y+2
	LDI  R31,0
	SUBI R30,LOW(-_s)
	SBCI R31,HIGH(-_s)
	LD   R26,Z
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 51 TIMES, CODE SIZE REDUCTION:97 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(200)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _jalan

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _pidbit
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x34:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _jalan

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _zigzag
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(250)
	ST   -Y,R30
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x37:
	CALL _zigzag
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(250)
	ST   -Y,R30
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x39:
	CALL _pidbit
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3A:
	LDI  R30,LOW(100)
	ST   -Y,R30
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	ST   -Y,R30
	CALL _pidsayap
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	CALL _pidsayap
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3F:
	CALL _pidbit
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x40:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x41:
	LDI  R30,LOW(50)
	ST   -Y,R30
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x42:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	JMP  _pid2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	CALL _pidbit
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x46:
	LDI  R30,LOW(1)
	MOV  R13,R30
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(150)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	JMP  _pid2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x48:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x49:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4A:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(100)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x4C:
	CALL _pidsayap
	CBI  0x15,7
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(150)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(75)
	ST   -Y,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4E:
	CALL _pidsayap
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(150)
	ST   -Y,R30
	RJMP SUBOPT_0x4A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _pidbit
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x51:
	CALL _pidbit
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x53:
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x57:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	LDI  R30,LOW(8)
	ST   -Y,R30
	JMP  _inputnilai

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x59:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5A:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5C:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5F:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G101


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
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

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

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

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
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

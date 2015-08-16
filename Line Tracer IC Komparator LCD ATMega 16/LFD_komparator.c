/*****************************************************
Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 12.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>
#include <delay.h>

// Alphanumeric LCD Module functions
#include <alcd.h>

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x30;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 11.719 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inv.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xA1;
TCCR1B=0x0D;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16
lcd_init(16);

// mendefinisikan input output
DDRB.0=0;
DDRB.1=0;
DDRD.0=1;
DDRD.1=1;
DDRD.2=1;
DDRD.3=1;

// mendefinisikan kecepatan motor PWM
OCR1A=200;
OCR1B=200;

// mendefinisikan kondisi awal
PORTB.0=1;   //sensor kiri
PORTB.1=1;   //sensor kanan
PORTD.0=0;
PORTD.1=0;
PORTD.2=0;
PORTD.3=0;


while (1)
      {
if (PINB.0==1 &  PINB.1==0)   //    sensor kiri hitam, kanan putih, maka belok kiri
{  
PORTD.0=0;
PORTD.1=0;
PORTD.2=0;
PORTD.3=1;
lcd_clear ();
lcd_gotoxy(0,0);
lcd_putsf("B0=1 B1=0");
lcd_gotoxy(0,1);
lcd_putsf("BELOK KIRI");
delay_ms(100);
}
else if (PINB.0==0 &  PINB.1==1)   //    sensor kiri putih, kanan hitam, maka belok kanan
{  
PORTD.0=0;
PORTD.1=1;
PORTD.2=0;
PORTD.3=0;
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("B0=0 B1=1");
lcd_gotoxy(0,1);
lcd_putsf("BELOK KANAN");
delay_ms(100);
}
else if (PINB.0==1 &  PINB.1==1)   //    sensor kiri hitam, kanan hitam, maka mati
{  
PORTD.0=0;
PORTD.1=0;
PORTD.2=0;
PORTD.3=0;
lcd_clear ();
lcd_gotoxy(0,0);
lcd_putsf("B0=1 B1=1");
lcd_gotoxy(0,1);
lcd_putsf("MATI");
delay_ms(100);
}
else      //    sensor kiri putih, kanan putih, maka bergerak maju
{  
PORTD.0=0;
PORTD.1=1;
PORTD.2=0;
PORTD.3=1;
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("B0=0 B1=0");
lcd_gotoxy(0,1);
lcd_putsf("MAJU");
delay_ms(100);
}


      }
}

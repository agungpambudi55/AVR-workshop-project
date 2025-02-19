unsigned char count, temp[16], indeks=0;
unsigned char detik=0, menit=0, jam=0;

#include <mega16.h>
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm
#include <lcd.h>

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0x8A;
count++;
}


void hitung_waktu()
{
if (count>=100)
    { 
    lcd_clear();
    detik++;
    count=0;
    }
    
if (detik>=60)
    {
    menit++;
    detik=0;
    }

if (menit>=60)
    {
    jam++;
    menit=0;
    }
}


void detek_tombol()
{
if (PINA.0==0 && (indeks==0 || indeks==2))//Start timer
    {
    indeks=1;
    TIMSK=0x01;
    lcd_clear();
    } 
    
if (PINA.1==0 && indeks==1)//Stop timer
    {   
    indeks=2;
    TIMSK=0x00;
    lcd_clear();
    } 

if (PINA.2==0 && indeks==2)//Reset timer
    {   
    indeks=0;
    count=0;
    detik=0;
    menit=0;
    jam=0;   
    lcd_clear();
    }
}

void tampil_lcd()
{
lcd_gotoxy(0,0);
sprintf(temp,"Timer %d:%d:%d:%d",jam,menit,detik,count);
lcd_puts(temp);//tampilkan waktu di LCD baris pertama

if (indeks==0)
    {
    lcd_gotoxy(0,1);
    lcd_putsf("START");
    }   
    
if (indeks==1)
    {
    lcd_gotoxy(0,1);
    lcd_putsf("STOP");
    }    
    
if (indeks==2)
    {
    lcd_gotoxy(0,1);
    lcd_putsf("START      RESET");
    }
}

void main(void)
{
PORTA=0x0f;
DDRA=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 11.719 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x05;
TCNT0=0x8A;
OCR0=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
//TIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// LCD module initialization
lcd_init(16);

// Global enable interrupts
#asm("sei")

while (1)
      {
      detek_tombol();
      hitung_waktu();
      tampil_lcd();
      };
}

#include <mega8.h>
#include <delay.h>

#define port_pwm PORTD

unsigned char x,count,pwm;

interrupt [TIM0_OVF] void timer0_ovf_isr(void)          //interupsi timer0
{
    count++;
        if(count<=pwm)port_pwm=255;                    //duty cycle generator
        else port_pwm=0;
        
        TCNT0=0xFF;
}

void main(void)
{
PORTB=0x00;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;
 
PORTD=0x00;
DDRD=0xFF;       //seeting portd jadi output

TCCR0=0x01;
TCNT0=0x00;

TCCR1A=0xA1;
TCCR1B=0x01;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;

TIMSK=0x01;

ACSR=0x80;
SFIOR=0x00;

#asm("sei")                       //set interupsi

while (1)
      {
        pwm=x;                     //main program
        x++;
        delay_ms(5);

      };
}

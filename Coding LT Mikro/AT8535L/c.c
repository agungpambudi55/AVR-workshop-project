/*****************************************************
Chip type               : ATmega8535L
Program type            : Application
AVR Core Clock frequency: 12.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 128
*****************************************************/

#include <mega32.h>

#include <delay.h>
#include <stdio.h>

#define down PINB.3
#define up PINB.2
#define cancel PINB.1
#define ok PINB.0
#define Lampu PORTD.7
#define Lpwm OCR1B
#define Rpwm OCR1A
#define Low 50
#define High 150
#define Mid 100

eeprom unsigned char kp=0;
eeprom unsigned char ki=0;
eeprom unsigned char kd=0;
eeprom unsigned char ts=0;
eeprom unsigned char max_speed=0;
eeprom unsigned char B[8];

// Alphanumeric LCD functions
#include <alcd.h>
char data[33];
 
#define ADC_VREF_TYPE 0x60

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

// Declare your global variables here
float tF, pid;
unsigned char a[8], c[8], S[8], SS[8];
unsigned char dd0, dd1, dd2, dd3;
unsigned char dat, dut, sayap, sensor, x;
int P, I, D, kpF, kiF, kdF, posisi, error, last_error, max_speedF, min, m1, m2, gas,
hasil;

/********************GERAKAN RODA************************/
void motor(unsigned char d0, unsigned char d1, unsigned char d2, unsigned char d3,
unsigned char L, unsigned char R)
{
PORTD.0=d0; //m_kiri_maju
PORTD.1=d1; //m_kiri_mundur
PORTD.2=d2; //m_kanan_mundur
PORTD.3=d3; //m_kanan_maju
Lpwm=L; //pwm m_kiri
Rpwm=R; //pwm m_kanan
}

void off()
{
PORTD.0=1;
PORTD.1=1;
PORTD.2=1;
PORTD.3=1;
Lpwm=Rpwm=255;
}

//*******************************ON_AIR SCAN*********************************************
void scan()
{ 
a[0]=read_adc(0); a[1]=read_adc(1); a[2]=read_adc(2); a[3]=read_adc(3);
a[4]=read_adc(4); a[5]=read_adc(5); a[6]=read_adc(6); a[7]=read_adc(7);
c[0]=B[0]; c[1]=B[1]; c[2]=B[2]; c[3]=B[3]; c[4]=B[4]; c[5]=B[5]; c[6]=B[6];
c[7]=B[7];

if (a[0]>c[0]) {SS[0]=Low;} if (a[0]<c[0]) {SS[0]=High;}
if (a[1]>c[1]) {SS[1]=Low;} if (a[1]<c[1]) {SS[1]=High;}
if (a[2]>c[2]) {SS[2]=Low;} if (a[2]<c[2]) {SS[2]=High;}
if (a[3]>c[3]) {SS[3]=Low;} if (a[3]<c[3]) {SS[3]=High;}
if (a[4]>c[4]) {SS[4]=Low;} if (a[4]<c[4]) {SS[4]=High;}
if (a[5]>c[5]) {SS[5]=Low;} if (a[5]<c[5]) {SS[5]=High;}
if (a[6]>c[6]) {SS[6]=Low;} if (a[6]<c[6]) {SS[6]=High;}
if (a[7]>c[7]) {SS[7]=Low;} if (a[7]<c[7]) {SS[7]=High;}

lcd_gotoxy(6,0);
if (PINB.4==1) {lcd_putchar('1');} else {lcd_putchar('0');}
if (SS[0]>Mid) {S[0]=1; lcd_putchar('1');} if (SS[0]<Mid) {S[0]=0; lcd_putchar('0');}
if (SS[1]>Mid) {S[1]=1; lcd_putchar('1');} if (SS[1]<Mid) {S[1]=0; lcd_putchar('0');}
if (SS[2]>Mid) {S[2]=1; lcd_putchar('1');} if (SS[2]<Mid) {S[2]=0; lcd_putchar('0');}
if (SS[3]>Mid) {S[3]=1; lcd_putchar('1');} if (SS[3]<Mid) {S[3]=0; lcd_putchar('0');}
if (SS[4]>Mid) {S[4]=1; lcd_putchar('1');} if (SS[4]<Mid) {S[4]=0; lcd_putchar('0');}
if (SS[5]>Mid) {S[5]=1; lcd_putchar('1');} if (SS[5]<Mid) {S[5]=0; lcd_putchar('0');}
if (SS[6]>Mid) {S[6]=1; lcd_putchar('1');} if (SS[6]<Mid) {S[6]=0; lcd_putchar('0');}
if (SS[7]>Mid) {S[7]=1; lcd_putchar('1');} if (SS[7]<Mid) {S[7]=0; lcd_putchar('0');}
if (PINB.5==1) {lcd_putchar('1');} else {lcd_putchar('0');}

dat=(S[7]*128)+(S[6]*64)+(S[5]*32)+(S[4]*16)+(S[3]*8)+(S[2]*4)+(S[1]*2)+(S[0]*
1);
sensor=dat;
dut=(PINB.4*2)+(PINB.5*1);
sayap=dut;
}

/********************DISPLAY SETTING************************/
void display()
{
warning1:
delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("^PID & Other^");
if (ok==0) { goto warning2; }
if (cancel==0) { goto start; }
goto warning1;

warning2:
delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("1.Sett PID");
if (up==0) { goto warning5; }
if (down==0) { goto warning3; }
if (ok==0) { goto set_kp; }
if (cancel==0) { goto warning1; }
goto warning2;
 
warning3:
delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("2.Sett Speed");
if (up==0) { goto warning2; }
if (down==0) { goto warning4; }
if (ok==0) { goto set_MAXspeed; }
if (cancel==0) { goto warning1; }
goto warning3;

warning4:
delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("3.Sett ADC");
if (up==0) { goto warning3; }
if (down==0) { goto warning5; }
if (ok==0) { delay_ms(100); lcd_clear(); goto disp; }
if (cancel==0) { goto warning1; }
goto warning4;

warning5:
delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); lcd_putsf("4.Reset EEPROM");
if (up==0) { goto warning4; }
if (down==0) { goto warning2; }
if (ok==0) {
kp=ki=kd=max_speed=ts=B[0]=B[1]=B[2]=B[3]=B[4]=B[5]=B[6]=B[7]=0;
lcd_gotoxy(0,0); lcd_putsf("Reset Success…"); delay_ms(500); lcd_clear();
}
if (cancel==0) { goto warning1; }
goto warning5;

//*******************************SETT PID*********************************************
set_kp:
delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); sprintf(data,"kp:%d ",kp);
lcd_puts(data);
if (up==0) { delay_ms(1); if (kp<255) {kp++;} }
if (down==0) { delay_ms(1); if (kp>0) {kp--;} }
if (ok==0) { goto set_ki; }
if (cancel==0) { goto warning2; }
goto set_kp;

set_ki:
delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); sprintf(data,"ki:%d ",ki); lcd_puts(data);
if (up==0) { delay_ms(1); if (ki<255) {ki++;} }
if (down==0) { delay_ms(1); if (ki>0) {ki--;} }
if (ok==0) { goto set_kd; }
if (cancel==0) { goto set_kp; }
goto set_ki;

set_kd:
delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); sprintf(data,"kd:%d ",kd);
lcd_puts(data);
if (up==0) { delay_ms(1); if (kd<255) {kd++;} } 
if (down==0) { delay_ms(1); if (kd>0) {kd--;} }
if (ok==0) { goto set_ts; }
if (cancel==0) { goto set_ki; }
goto set_kd;

set_ts:
delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); sprintf(data,"Ts:%d ",ts);
lcd_puts(data);
if (up==0) { delay_ms(1); if (ts<50) {ts++;} }
if (down==0) { delay_ms(1); if (ts>0) {ts--;} }
if (ok==0) { goto set_kp; }
if (cancel==0) { goto set_kd; }
goto set_ts;

//*******************************SETT SPEDD*********************************************
set_MAXspeed:
delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); sprintf(data,"Speed:%d ",max_speed);
lcd_puts(data);
if (up==0) { delay_ms(1); if (max_speed<255) {max_speed+=5;} }
if (down==0) { delay_ms(1); if (max_speed>0) {max_speed-=5;} }
if (cancel==0) { goto warning3; }
goto set_MAXspeed;

//*******************************SETT ADC*********************************************
disp: //01234567
lcd_gotoxy(0,0); lcd_putsf("SENS:");
scan();
if (ok==0) {x=0; goto settadc;}
if (cancel==0) {goto warning4;}
goto disp;

settadc: //01234567
delay_ms(100); lcd_clear(); lcd_gotoxy(0,0); sprintf(data,"ADC_%d=%3d , %3d", x,
read_adc(x), B[x] ); lcd_puts(data);
read_adc(x);
if (ok==0) {delay_ms(150); B[x]=read_adc(x);}
if (cancel==0) {delay_ms(150); lcd_clear(); goto disp;}

if (up==0) {delay_ms(150); if (x<7) {x++;}
}

if (down==0) {delay_ms(150); if (x>0) {x--;}
}
goto settadc;

//*******************************START****************************
start: 
delay_ms(100); lcd_clear(); x=0;

}

//*******************************WRITE ALL*********************************************
void write_all()
{lcd_gotoxy(0,0);
kpF=kp*5; lcd_putchar('R'); delay_ms(10);
kiF=ki;   lcd_putchar('E'); delay_ms(20);
kdF=kd; lcd_putchar('A'); delay_ms(30);
tF = (float) ts / (float) 10; lcd_putchar('D'); delay_ms(40);
max_speedF=max_speed; lcd_putchar('_'); delay_ms(50);
min=0-max_speed; lcd_putchar('E'); delay_ms(60);
lcd_putchar('E'); delay_ms(70);
lcd_putchar('P'); delay_ms(80);
lcd_putchar('R'); delay_ms(90);
lcd_putchar('O'); delay_ms(100);
lcd_putchar('M'); delay_ms(200); lcd_clear();
lcd_gotoxy(0,0); lcd_putsf("kp ki kd");
lcd_gotoxy(0,1); sprintf(data,"%3d %3d %5d", kpF, kiF, kdF); lcd_puts(data);
delay_ms(500); lcd_clear();
lcd_gotoxy(0,0); lcd_putsf("Speed Ts");
lcd_gotoxy(0,1); sprintf(data,"%3d %d", max_speedF, (int)tF); lcd_puts(data);
delay_ms(500); lcd_clear();
lcd_gotoxy(0,0); lcd_putsf("Read Complete"); delay_ms(500); lcd_clear();
}

//*******************************ON_AIR****************************
void program()
{
pilih:
lcd_gotoxy(0,1); lcd_putsf("TEKAN OK!");
if (ok==0 && x==150) {lcd_clear(); goto hitam;}
if (ok==0 && x==200) {lcd_clear(); goto putih;}
goto pilih;

hitam:
Lampu=0;
lcd_gotoxy(0,0); sprintf(data,"%5d", hasil); lcd_puts(data);
lcd_gotoxy(0,1); sprintf(data,"L%3d R%3d p%3d", m1, m2, posisi); lcd_puts(data);
scan();
if (sensor==0b11111110) {posisi=7;} // +error ujung kiri
if (sensor==0b11111101) {posisi=5;}
if (sensor==0b11111011) {posisi=3;}
if (sensor==0b11110111) {posisi=1;}
if (sensor==0b11101111) {posisi=-1;}
if (sensor==0b11011111) {posisi=-3;}
if (sensor==0b10111111) {posisi=-5;} 
if (sensor==0b01111111) {posisi=-7;} // -error ujung kanan

if (sensor==0b11111100) {posisi=6;}
if (sensor==0b11111001) {posisi=4;}
if (sensor==0b11110011) {posisi=2;}
if (sensor==0b11100111) {posisi=0;} //tengah
if (sensor==0b11001111) {posisi=-2;}
if (sensor==0b10011111) {posisi=-4;}
if (sensor==0b00111111) {posisi=-6;}

if (sensor==0b11111000) {posisi=5;}
if (sensor==0b11110001) {posisi=3;}
if (sensor==0b11100011) {posisi=1;}
if (sensor==0b11000111) {posisi=-1;}
if (sensor==0b10001111) {posisi=-3;}
if (sensor==0b00011111) {posisi=-5;}

if (sensor==0b11110000) {posisi=6;}
if (sensor==0b11100001) {posisi=5;}
if (sensor==0b11000011) {posisi=0;}
if (sensor==0b10000111) {posisi=-5;}
if (sensor==0b00001111) {posisi=-6;}

if (sensor==0b11100000) {posisi=7;}
if (sensor==0b11000001) {posisi=6;}
if (sensor==0b10000011) {posisi=-6;}
if (sensor==0b00000111) {posisi=-7;}

if (sensor==0b10000001) {posisi=0;}
if (sensor==0b00000000) {posisi=0;}
if (sensor==0b10000000) {posisi=0;}
if (sensor==0b00000001) {posisi=0;}

if ( sensor==0b11111111 && sayap==0b01 ) {posisi=9;} //sayap kiri
if ( sensor==0b11111111 && sayap==0b10 ) {posisi=-9;} //sayap kanan

if ( sensor==0b11111111 && sayap==0b11 ) //loss
{
if ( posisi >0 && posisi < 9) { posisi = 8; }
if ( posisi <0 && posisi > -9) { posisi = -8 ; }

if ( posisi > 8 ) { posisi = 10; }
if ( posisi < -8 ) {posisi = -10; }
}

error = (kpF * posisi);         //nilai error
P = error;                            //nilai P
I = kiF * (error + last_error);    //nilai I
D = kdF * (error - last_error);  //nilai D
last_error = error;                      //nilai last error 
pid = (float)P + ( (float)I / (float)10000 ) + (float)D;
hasil = (int)pid;

//motor kiri
m1 = max_speedF - hasil;
if ( m1 > max_speedF ) {m1 = max_speedF;}
if ( m1 < min ) {m1 = min;}
if ( m1 > 0 ) {dd0=1; dd1=0;} // kiri maju
if ( m1 < 0 ) {dd0=0; dd1=1; gas=0-m1; m1=gas;} // kiri mundur
if ( error == 0 ) {m1 = max_speedF; }

//motor kanan
m2 = max_speedF + hasil;
if ( m2 > max_speedF ) {m2 = max_speedF;}
if ( m2 < min ) {m2 = min;}
if ( m2 > 0 ) {dd2=0; dd3=1;} // kanan maju
if ( m2 < 0 ) {dd2=1; dd3=0; gas=0-m2; m2=gas;} // kanan mundur
if ( error == 0 ) {m2 = max_speedF; }

motor(dd0, dd1, dd2, dd3, m1, m2); // aksi motor
delay_ms(tF); // time sampling
goto hitam;

putih:
Lampu=1;
lcd_gotoxy(0,0); sprintf(data,"%5d", hasil); lcd_puts(data);
lcd_gotoxy(0,1); sprintf(data,"L%3d R%3d p%3d", m1, m2, posisi); lcd_puts(data);
scan();
if (sensor==0b00000001) {posisi=7;} // +error ujung kiri
if (sensor==0b00000010) {posisi=5;}
if (sensor==0b00000100) {posisi=3;}
if (sensor==0b00001000) {posisi=1;}
if (sensor==0b00010000) {posisi=-1;}
if (sensor==0b00100000) {posisi=-3;}
if (sensor==0b01000000) {posisi=-5;}
if (sensor==0b10000000) {posisi=-7;} // -error ujung kanan

if (sensor==0b00000011) {posisi=6;}
if (sensor==0b00000110) {posisi=4;}
if (sensor==0b00001100) {posisi=2;}
if (sensor==0b00011000) {posisi=0;} //tengah
if (sensor==0b00110000) {posisi=-2;}
if (sensor==0b01100000) {posisi=-4;}
if (sensor==0b11000000) {posisi=-6;}

if (sensor==0b00000111) {posisi=5;}
if (sensor==0b00001110) {posisi=3;}
if (sensor==0b00011100) {posisi=1;}
if (sensor==0b00111000) {posisi=-1;}
if (sensor==0b01110000) {posisi=-3;} 
if (sensor==0b11100000) {posisi=-5;}

if (sensor==0b00001111) {posisi=6;}
if (sensor==0b00011110) {posisi=5;}
if (sensor==0b00111100) {posisi=0;}
if (sensor==0b01111000) {posisi=-5;}
if (sensor==0b11110000) {posisi=-6;}

if (sensor==0b00011111) {posisi=7;}
if (sensor==0b00111110) {posisi=6;}
if (sensor==0b01111100) {posisi=-6;}
if (sensor==0b11111000) {posisi=-7;}

if (sensor==0b01111110) {posisi=0;}
if (sensor==0b11111111) {posisi=0;}
if (sensor==0b01111111) {posisi=0;}
if (sensor==0b11111110) {posisi=0;}

if ( sensor==0b00000000 && sayap==0b10 ) {posisi=9;} //sayap kiri
if ( sensor==0b00000000 && sayap==0b01 ) {posisi=-9;} //sayap kanan

if ( sensor==0b00000000 && sayap==0b00 ) //loss
{
if ( posisi >0 && posisi < 9) { posisi = 8; }
if ( posisi <0 && posisi > -9) { posisi = -8 ; }

if ( posisi > 8 ) { posisi = 10; }
if ( posisi < -8 ) {posisi = -10; }
}

error = (kpF * posisi);         //nilai error
P = error;                            //nilai P
I = kiF * (error + last_error);    //nilai I
D = kdF * (error - last_error);  //nilai D
last_error = error;                      //nilai last error
pid = (float)P + ( (float)I / (float)10000 ) + (float)D;
hasil = (int)pid;

//motor kiri
m1 = max_speedF - hasil;
if ( m1 > max_speedF ) {m1 = max_speedF;}
if ( m1 < min ) {m1 = min;}
if ( m1 > 0 ) {dd0=1; dd1=0;} // kiri maju
if ( m1 < 0 ) {dd0=0; dd1=1; gas=0-m1; m1=gas;} // kiri mundur
if ( error == 0 ) {m1 = max_speedF; }

//motor kanan
m2 = max_speedF + hasil;
if ( m2 > max_speedF ) {m2 = max_speedF;}
if ( m2 < min ) {m2 = min;} 
if ( m2 > 0 ) {dd2=0; dd3=1;} // kanan maju
if ( m2 < 0 ) {dd2=1; dd3=0; gas=0-m2; m2=gas;} // kanan mundur
if ( error == 0 ) {m2 = max_speedF; }

motor(dd0, dd1, dd2, dd3, m1, m2); // aksi motor
delay_ms(tF); //time sampling

goto putih;

}

//*******************************CEK WARNA TRACK*********************************************
void baca_track()
{
lcd_gotoxy(0,1); lcd_putsf("Scan Garis");
scan();
if (x<100)
{x++; motor(1, 0, 1, 0, 100, 100);}

if ( sensor==0b11111111 && x==100)
{lcd_clear(); off(); x=150; lcd_gotoxy(0,0); lcd_putsf("Hitam"); program(); }
if ( sensor==0b00000000 && x==100)
{lcd_clear(); off(); x=200; lcd_gotoxy(0,0); lcd_putsf("Putih"); program(); }
delay_ms(20);
}

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
// State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P 
PORTB=0xFF;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=0 State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;
 
// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out
//Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0xFF;

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
// Clock value: 187.500 kHz
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
TCCR1B=0x0B;
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
// ADC Clock frequency: 93.750 kHz
// ADC Voltage Reference: AVCC pin
// ADC High Speed Mode: Off
// ADC Auto Trigger Source: ADC Stopped
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x87;
SFIOR&=0xEF;

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
Lampu=1; //lampu lcd
display(); //call display(); untuk setup menu
write_all(); //call write_all(); untuk semua data di eeprom
while (1)
      {
      // Place your code here
      baca_track(); 
      }
} 
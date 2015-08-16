/*****************************************************
Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>
#include <delay.h>   
#include <stdio.h>
#include <stdbool.h>


// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>

//>KEYPAD<//
#define row0 PORTC.1
#define row1 PORTC.6
#define row2 PORTC.5
#define row3 PORTC.3
#define col0 PINC.2
#define col1 PINC.0
#define col2 PINC.4
#define kosong 123
//>KEYPAD<//

//>MOTOR<//
#define en_ki PORTD.6
#define en_ka PORTD.7
#define IN_1A PORTD.5
#define pwm_ki OCR1A
#define IN_2A PORTD.0
#define IN_1B PORTD.4
#define pwm_ka OCR1B
#define IN_2B PORTD.1
#define maju 0
#define mundur 1
//>MOTOR<//

//>BUZZER<//
#define buz PORTC.7
#define buz_on buz=0
#define buz_off buz=1
#define bip {buz_on; delay_ms(100); buz_off;} 
//>BUZZER<//

//>SENSOR SAYAP<//
#define syp_ki PIND.2
#define syp_ka PIND.3
//>SENSOR SAYAP<//

//>PERTIGAAN<//
#define kiri 0
#define kanan 1

//>MODE MOTOR<//
#define slow 0
#define normal 1
#define fast 2
#define veryfast 3
#define veryfast2 4

//>MODE MOTOR<//

#define ADC_VREF_TYPE 0x20

//>Deklarasi Variable Global<//
char key,key2;
char buf[3],buf2[5],buf3[16];

unsigned char data_sensor[8];
unsigned char data_gelap[8]={60,60,60,60,60,60,60,60};
unsigned char data_terang[8]={60,60,60,60,60,60,60,60};
unsigned char sensor;
eeprom unsigned data_ref[8]={120,120,120,120,120,120,120,120};
eeprom unsigned char gt=0;
eeprom unsigned char inkec,inkp,inkd;
eeprom unsigned char pilihstart;
unsigned char in_arah_kiri,in_kec_kiri,in_arah_kanan,in_kec_kanan,delay_belok;

//bit s1,s2,s3,s4,s5,s6,s7,s8,last;
bool s[8],last;
int last_error;
//>Deklarasi Variable Global<//

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
//>>>>>>>>>>>>>>>>>>> KEYPAD <<<<<<<<<<<<<<<<<<<\\
unsigned char keypad()
{
    delay_ms(1);
     row0=0; row1=1; row2=1; row3=1;
     if(!col0) return(1);
     if(!col1) return(2);
     if(!col2) return(3);
     
     delay_ms(1);
     row0=1; row1=0; row2=1; row3=1;
     if(!col0) return(4);
     if(!col1) return(5);
	 if(!col2) return(6);
     row1=1;
     
     delay_ms(1); 
     row0=1; row1=1; row2=0; row3=1;
     if(!col0) return(7);
     if(!col1) return(8);
	 if(!col2) return(9);
     
     delay_ms(1);
	 row0=1; row1=1; row2=1; row3=0;
     if(!col0) return(11); //*
     if(!col1) return(0);
     if(!col2) return(12); //#
     else return(kosong);
}

unsigned char inkeypad()
{
    unsigned char k=kosong,hit;
    k=kosong; 
    while(k==kosong)
    {
        k=keypad();
        if(k!=kosong) hit=k;
        if(k==hit) {while(k==hit) {k=keypad(); delay_ms(1);} return hit;}
//        if(k==1) { while(k==1){k=keypad(); delay_ms(1);} return(1);}
//        if(k==2) { while(k==2){k=keypad(); delay_ms(1);} return(2);}
        
    }
    delay_ms(100);
    return k;   
    
}

unsigned char inputnilai(unsigned char pointer)
{
    unsigned char stack[3];
    unsigned char hasil=0,pengali=1;
    int i=0;
    char k=0;
    pengali=1;
    delay_ms(500);
    while (i<3 && k!=12)
    {
        lcd_gotoxy(pointer,0);
        k=inkeypad();
        if(k==12) break;
        else stack[i]=k;
        sprintf(buf2,"%d",k);
        lcd_puts(buf2);
        i++; pointer++;
    }
    lcd_putsf("i:");
    sprintf(buf2,"%d",i);
        lcd_puts(buf2);
    lcd_putsf("+");
    i--;
    while(i>-1)
    {
        hasil+=(stack[i]*pengali);
        pengali*=10;
        i--;
        //lcd_putsf("*");
    }
    lcd_clear(); lcd_gotoxy(0,0); 
    if (hasil>255) {
    lcd_putsf("ERROR MAX = 255"); hasil=inputnilai(pointer);
    }
    else lcd_putsf("Alhamdulillah");
    delay_ms(500);
    lcd_clear();
    return hasil;
}

void coba()
{
    unsigned char inp; 
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("Input :");
    inp=inputnilai(9);
    lcd_putsf("Selesai :");
    sprintf(buf,"%d",inp);
    lcd_puts(buf);
}
//>>>>>>>>>>>>>>>>>>> KEYPAD <<<<<<<<<<<<<<<<<<<\\

//>>>>>>>>>>>>>>>>>>> MOTOR <<<<<<<<<<<<<<<<<<<\\
//     a=pwm; b=0-->maju; b=1-->mundur;
void motor_ki(unsigned char b,unsigned char a)
{
    en_ki=1;
    if(b==0) pwm_ki=a;
    else
    pwm_ki=255-a;
    IN_2A=b;
}

void motor_ka(unsigned char arah,unsigned char a)
{
    en_ka=1;
    if(arah==0) pwm_ka=a;
    else pwm_ka=255-a;
    IN_2B=arah;
}

void jalan_mundur(unsigned char ki,unsigned char ka,unsigned int delayms)
{
    motor_ki(mundur,ki);
    motor_ka(mundur,ka);
    delay_ms(delayms);
}

void cekmotor()
{
    key=inkeypad();
    if(key==1) motor_ki(0,1);
    if(key==2) motor_ki(1,0);
    if(key==3) en_ki=0;
    if(key==4) motor_ka(0,1);
    if(key==5) motor_ka(1,0);
    if(key==6) en_ka=0;    
}

void stop(unsigned int delayms)
{
    jalan_mundur(0,0,delayms);
}

void jalan(unsigned char arah_ki,unsigned char kecp_ki,unsigned char arah_ka,unsigned char kecp_ka,unsigned int delayms)
{
    motor_ki(arah_ki,kecp_ki);
    motor_ka(arah_ka,kecp_ka);
    delay_ms(delayms);
    stop(0);
}

void rem(unsigned char mode)
{
	buz_on;
	if(mode==3)             {stop(5);  jalan_mundur(150,150,225); stop(1);}
    else if(mode==2)        {stop(5);  jalan_mundur(100,100,200); stop(1);}   
    else if(mode==1)        {stop(5);  stop(1);}
    else if(mode==0)        {delay_ms(1);}
	buz_off;
}
//>>>>>>>>>>>>>>>>>>> MOTOR <<<<<<<<<<<<<<<<<<<\\

//>>>>>>>>>>>>>>>>>>> SENSOR <<<<<<<<<<<<<<<<<<<\\
void baca_sensor()
{
    unsigned char i,j=7;
    for(i=0;i<8;i++) {data_sensor[j]=read_adc(i); j--;}
    
}

void baca()  //gelap=1 terang=0
{
    unsigned char i;
    baca_sensor();
    if (gt==1) 
        for(i=0;i<8;i++) {if(data_sensor[i]<=data_ref[i]) {s[i]=1;}  else {s[i]=0;}}
    else 
        for(i=0;i<8;i++){if(data_sensor[i]<=data_ref[i]) {s[i]=0;}  else {s[i]=1;}}
    if (s[0]==1) last=0; else if (s[7]==1) last=1;
    sensor=(s[0]+s[1]*2+s[2]*4+s[3]*8+s[4]*16+s[5]*32+s[6]*64+s[7]*128);
}

void kalibrasi()
{
    unsigned char a,b,c;
    lcd_clear();
    lcd_gotoxy(0,0);
            // 1234567890123456
    lcd_putsf("    Bismillah   ");
    lcd_putsf("^_^ Kalibrasi^_^");
    for(a=0;a<10;a++)    data_ref[a]=120;
    buz_on;
    while(key==7 || key ==3)
    {
        key=keypad();
        baca_sensor();
        b=0;
        for(b=0;b<8;b++)
        {
            if(data_sensor[b]<=data_terang[b])  data_terang[b]=data_sensor[b];
            else if(data_sensor[b]>data_gelap[b])   data_gelap[b]=data_sensor[b];
        } 
        c=0;
        for(c=0;c<8;c++)
        {
            data_ref[c]=data_terang[c]+((data_gelap[c]-data_terang[c])/2);
        }
        
    }
    buz_off;
    lcd_clear();
    lcd_putsf(" Alhamdulillah  ");
    lcd_putsf("Semoga Sukses :)");
    delay_ms(1000);
    lcd_clear();
    
}


void tampil_bit(unsigned char xx){
     if(xx==0) lcd_putchar('0');
     else      lcd_putchar('1');
}

void cetak_sensor()
{
    unsigned char i,j=7;
    lcd_gotoxy(0,0);
             //1234567890123456 
    lcd_putsf(" >>> Sensor <<< ");
    delay_ms(1);
    baca();
    lcd_gotoxy(4,1);
    for(i=0;i<8;i++) {tampil_bit(s[j]); j--;}
    lcd_gotoxy(2,1);
    if(gt==1) tampil_bit(!syp_ki);
    else tampil_bit(syp_ki);
    lcd_gotoxy(13,1);
    if(gt==1) tampil_bit(!syp_ka);
    else tampil_bit(syp_ka); 
    delay_ms(10);
}

void set_baca()
{
    while(key!=12)
    {
        lcd_putsf("  Sensor  Baca  ");
        lcd_putsf("1:Gelap 2:Terang");
        key=inkeypad();
        if(key==1) {gt=0; lcd_clear(); delay_ms(200); break;}
        else if(key==2) {gt=1; lcd_clear(); delay_ms(200); break;}
    }
}

void cek_adc()
{
    while(key!=12)
    {
    key=keypad();
    lcd_clear();
    //lcd_gotoxy(0,0);
    //lcd_putsf("Sensor =");
    //lcd_gotoxy(6,0); 
    sprintf(buf3,"%d %d %d %d",read_adc(7),read_adc(6),read_adc(5),read_adc(4));
    lcd_puts(buf3);
    lcd_gotoxy(0,1);
    sprintf(buf3,"%d %d %d %d",read_adc(3),read_adc(2),read_adc(1),read_adc(0));
    lcd_puts(buf3);
    delay_ms(300);
    }
    lcd_clear();    
}

//void baca() //gelap=1 terang=0
//{
//    baca_sensor();
//    if(gt==1)
//    
//    {
//    if(data_sensor[0]<=data_ref[0]) {s1=1; last=0;}  else {s1=0;}
//    if(data_sensor[1]<=data_ref[1]) {s2=1;}  else {s2=0;}
//    if(data_sensor[2]<=data_ref[2]) {s3=1;}  else {s3=0;}
//    if(data_sensor[3]<=data_ref[3]) {s4=1;}  else {s4=0;}
//    if(data_sensor[4]<=data_ref[4]) {s5=1;}  else {s5=0;}
//    if(data_sensor[5]<=data_ref[5]) {s6=1;}  else {s6=0;}
//    if(data_sensor[6]<=data_ref[6]) {s7=1;}  else {s7=0;}
//    if(data_sensor[7]<=data_ref[7]) {s8=1; last=1;}  else {s8=0;}
//    }
//    else
//    {
//    if(data_sensor[0]<=data_ref[0]) {s1=0;}  else {s1=1; last=0;}
//    if(data_sensor[1]<=data_ref[1]) {s2=0;}  else {s2=1;}
//    if(data_sensor[2]<=data_ref[2]) {s3=0;}  else {s3=1;}
//    if(data_sensor[3]<=data_ref[3]) {s4=0;}  else {s4=1;}
//    if(data_sensor[4]<=data_ref[4]) {s5=0;}  else {s5=1;}
//    if(data_sensor[5]<=data_ref[5]) {s6=0;}  else {s6=1;}
//    if(data_sensor[6]<=data_ref[6]) {s7=0;}  else {s7=1;}
//    if(data_sensor[7]<=data_ref[7]) {s8=0;}  else {s8=1; last=1;}
//    }
//    sensor=(s1+s2*2+s3*4+s4*8+s5*16+s6*32+s7*64+s8*128);
//    //for(i=0;i<9;i++) if(data_sensor[i]<=data_ref[i]) {sensor[i]=1;}  else {sensor[i]=0;}
//}

//void cetak_sensor()
//{
//    lcd_gotoxy(0,0);
//             //1234567890123456 
//    lcd_putsf(" >>> Sensor <<< ");
//    delay_ms(1);
//    baca();
//    lcd_gotoxy(4,1);
//    tampil_bit(s1);
//    tampil_bit(s2);
//    tampil_bit(s3);
//    tampil_bit(s4);
//    tampil_bit(s5);
//    tampil_bit(s6);
//    tampil_bit(s7);
//    tampil_bit(s8);
//    lcd_gotoxy(2,1);
//    if(gt==1) tampil_bit(!syp_ki);
//    else tampil_bit(syp_ki);
//    lcd_gotoxy(13,1);
//    if(gt==1) tampil_bit(!syp_ka);
//    else tampil_bit(syp_ka); 
//    delay_ms(10);
//    //for(i=0;i<9;i++) if(sensor[i]==0) lcd_putchar('0'); else  lcd_putchar('1');
//}
//>>>>>>>>>>>>>>>>>>> SENSOR <<<<<<<<<<<<<<<<<<<\\

//>>>>>>>>>>>>>>>>>>> PD CONTROLER <<<<<<<<<<<<<<<<<<<\\
void pid()
{
    int error,kec_ki,kec_ka,rate;
    long int sterr;
    unsigned char kec=120;
    unsigned char kp=15,kd=10,kec_min=50,kec_max=255;
    cetak_sensor();
    kec=120;
//    if(sensor==0b00011000 || sensor==0b00010000 || sensor==0b00001000) kec++;
//    if(kec>=kec_max)kec=kec_max;
//    else if(kec<kec_min) kec=kec_min;
    switch(sensor)
    {
        case 0b00000001 : error=-8;  break;               
        case 0b00000011 : error=-6;  break;          
        case 0b00000010 : error=-5;  break;                 
        case 0b00000110 : error=-4;  break;                  
        case 0b00000100 : error=-3;  break;                 
        case 0b00001100 : error=-2;  break;                  
        case 0b00001000 : error=-1;  break;               
        case 0b00011000 : error=0;   break;   
        case 0b00010000 : error=1;   break;            
        case 0b00110000 : error=2;   break;               
        case 0b00100000 : error=3;   break;                
        case 0b01100000 : error=4;   break;               
        case 0b01000000 : error=5;   break;               
        case 0b11000000 : error=6;   break;                                                 
        case 0b10000000 : error=8;   break;
        case 0b11110000 : error=10;  break;
        case 0b00001111 : error=-10; break;
        case 0x00 : if (last==0) error=-10; else if(last==1) error=10; break;
        default : error=0; break;
    }
    rate = error - last_error;
    last_error = error;
    sterr= (kp*error) + (kd*rate);
    
    kec_ki= kec - sterr;
    kec_ka= kec + sterr;  
    
    if(kec_ki>kec) motor_ki(maju,kec);
    else if(kec_ki<0) motor_ki(mundur,-kec_ki);
    else motor_ki(maju,kec_ki);
    
    if(kec_ka>kec) motor_ka(maju,kec);
    else if(kec_ka<0) motor_ka(mundur,-kec_ki);
    else motor_ka(maju,kec_ka);
    
    delay_us(1);        
     
}

void pid2(unsigned char kec,unsigned char kp, unsigned char kd)
{
    int error,kec_ki,kec_ka,rate;
    long int sterr;
    //unsigned char kec=200;
    //unsigned char kp=30,kd=20;
    baca();
//    if(sensor==0b00011000 || sensor==0b00010000 || sensor==0b00001000) kec++;
//    if(kec>=kec_max)kec=kec_max;
//    else if(kec<kec_min) kec=kec_min;
    switch(sensor)
    {
        case 0b00000001 : error=-8;  break;               
        case 0b00000011 : error=-6;  break;          
        case 0b00000010 : error=-5;  break;                 
        case 0b00000110 : error=-4;  break;                  
        case 0b00000100 : error=-3;  break;                 
        case 0b00001100 : error=-2;  break;                  
        case 0b00001000 : error=-1;   break;               
        case 0b00011000 : error=0;   break;   
        case 0b00010000 : error=1;   break;            
        case 0b00110000 : error=2;   break;               
        case 0b00100000 : error=3;   break;                
        case 0b01100000 : error=4;   break;               
        case 0b01000000 : error=5;   break;               
        case 0b11000000 : error=6;   break;                                                 
        case 0b10000000 : error=8;   break;
        case 0b11110000 : error=10;  break;
        case 0b00001111 : error=-10; break;
        case 0x00 : if (last==0) error=-10; else if(last==1) error=10; break;
        default : error=0; break;
    }
    rate = error - last_error;
    last_error = error;
    sterr= (kp*error) + (kd*rate);
    
    kec_ki= kec - sterr;
    kec_ka= kec + sterr;  
    
    if(kec_ki>kec) motor_ki(maju,kec);
    else if(kec_ki<0) motor_ki(mundur,-kec_ki);
    else motor_ki(maju,kec_ki);
    
    if(kec_ka>kec) motor_ka(maju,kec);
    else if(kec_ka<0) motor_ka(mundur,-kec_ka);
    else motor_ka(maju,kec_ka);
    
    //delay_us(10);        
     
}

void pid_putus2()
{
    int error,kec_ki,kec_ka,rate;
    long int sterr;
    unsigned char kec=150;
    unsigned char kp=23,kd=15,kec_min=50,kec_max=255;
    cetak_sensor();
    kec=150;
//    if(sensor==0b00011000 || sensor==0b00010000 || sensor==0b00001000) kec++;
//    if(kec>=kec_max)kec=kec_max;
//    else if(kec<kec_min) kec=kec_min;
    switch(sensor)
    {
        case 0b00000001 : error=-8;  break;               
        case 0b00000011 : error=-6;  break;          
        case 0b00000010 : error=-5;  break;                 
        case 0b00000110 : error=-4;  break;                  
        case 0b00000100 : error=-3;  break;                 
        case 0b00001100 : error=-2;  break;                  
        case 0b00001000 : error=-1;  break;               
        case 0b00011000 : error=0;   break;   
        case 0b00010000 : error=1;   break;            
        case 0b00110000 : error=2;   break;               
        case 0b00100000 : error=3;   break;                
        case 0b01100000 : error=4;   break;               
        case 0b01000000 : error=5;   break;               
        case 0b11000000 : error=6;   break;                                                 
        case 0b10000000 : error=8;   break;
        case 0b11110000 : error=10;  break;
        case 0b00001111 : error=-10; break;
//        case 0x00 : if (last==0) error=-10; else if(last==1) error=10; break;
        default : error=0; break;
    }
    rate = error - last_error;
    last_error = error;
    sterr= (kp*error) + (kd*rate);
    
    kec_ki= kec - sterr;
    kec_ka= kec + sterr;  
    
    if(kec_ki>kec) motor_ki(maju,kec);
    else if(kec_ki<0) motor_ki(mundur,-kec_ki);
    else motor_ki(maju,kec_ki);
    
    if(kec_ka>kec) motor_ka(maju,kec);
    else if(kec_ka<0) motor_ka(mundur,-kec_ki);
    else motor_ka(maju,kec_ka);
    
    delay_us(10);        
     
}


void pid_sampai(unsigned char sens,unsigned char sens2,unsigned char mode_speed,unsigned char mode_rem)
{                                  
	if(mode_speed==1) while(sensor!=sens && sensor!=sens2) {pid2(150,23,15);}
    else if(mode_speed==2) while(sensor!=sens && sensor!=sens2) {pid2(200,32,25);}
	else if(mode_speed==slow) while(sensor!=sens && sensor!=sens2) {pid2(120,15,10);}
    rem(mode_rem);
}

void pid_p3an(unsigned char arah,unsigned char counter,unsigned char mode_speed,unsigned char mode_rem)
{
	unsigned char count=0;
	if(arah==kanan)
	while(count<=counter)
	{
		if(mode_speed==fast) while(sensor!=0b00001100 && sensor!=0b00001110) {pid2(200,35,28);}
		count++;
        while(sensor==0b00001100 || sensor==0b00001110) delay_ms(1);
	}
	else if(arah==kiri)
	while(count<=counter)
	{
		if(mode_speed==fast) while(sensor!=0b01110000 && sensor!=0b00111000) {pid2(200,35,28);}
		count++; 
        while(sensor==0b01110000 || sensor==0b11110000) delay_ms(1);
	}
	rem(mode_rem);
}

void pid_p4an(unsigned char counter,unsigned char mode_speed,unsigned char mode_rem)
{
    unsigned char count=0;
	while(count<=counter)
	{
		if(mode_speed==fast) while(sensor!=0b00111100 && sensor!=0b01111110) {pid2(200,35,28);}
        else if(mode_speed==normal) while(sensor!=0b00111100 && sensor!=0b01111110) {pid2(150,23,15);}
		count++;
	}
	rem(mode_rem);
}

void pidsayap(unsigned char arah,unsigned char counter,unsigned char mode_speed,unsigned char mode_rem)
{
	unsigned char count=0;
	if(arah==kiri)
	while(count<=counter)
	{
		if(mode_speed==fast) while(!syp_ki) {pid2(200,35,28);}
        else if(mode_speed==normal) while(!syp_ki) {pid2(150,23,15);}
        else if(mode_speed==slow) while(!syp_ki) {pid2(120,15,10);}
		count++;
	}
	else if(arah==kanan)
	while(count<=counter)
	{
		if(mode_speed==fast) while(!syp_ka) {pid2(200,35,28);}
        else if(mode_speed==normal) while(!syp_ka) {pid2(150,23,15);}
        else if(mode_speed==slow) while(!syp_ki) {pid2(120,15,10);}
		count++;
	}
	rem(mode_rem);
}

void pidsayapglp(unsigned char arah,unsigned char counter,unsigned char mode_speed,unsigned char mode_rem)
{
	unsigned char count=0;
	if(arah==kiri)
	while(count<=counter)
	{
		if(mode_speed==fast) while(syp_ki) {pid2(200,35,28);}
        else if(mode_speed==normal) while(syp_ki) {pid2(150,23,15);}
        else if(mode_speed==slow) while(syp_ki) {pid2(120,15,10);}
		count++;
	}
	else if(arah==kanan)
	while(count<=counter)
	{
		if(mode_speed==fast) while(syp_ka) {pid2(200,35,28);}
        else if(mode_speed==normal) while(syp_ka) {pid2(150,23,15);}
        else if(mode_speed==slow) while(syp_ki) {pid2(120,15,10);}
		count++;
	}
	rem(mode_rem);
}

void pidbit(unsigned char sen1, unsigned char sen2, unsigned char mode_speed,unsigned char mode_rem)
{
    if(mode_speed==fast) while(s[sen1]==0 || s[sen2]==0) {pid2(200,35,28);}
    else if(mode_speed==normal) while(s[sen1]==0 || s[sen2]==0) {pid2(150,23,15);}
    else if(mode_speed==veryfast) while(s[sen1]==0 ||!syp_ki) pid2(200,35,28); //pid2(255,35,20);
    else if(mode_speed==veryfast2) while(s[sen1]==0 ||!syp_ka) pid2(200,35,28);
    else if(mode_speed==10) while(s[sen1]==0 || s[sen2]==0) {pid_putus2();} 
    else if(mode_speed==slow) while(!syp_ki) {pid2(120,15,10);}
    rem(mode_rem);
}

void zigzag(unsigned char arah,unsigned char mode_speed,unsigned char mode_rem)
{
    if(arah==kanan)
    {
        if(mode_speed==normal) while(s[0]==0 || s[2]==0) {pid2(150,23,15);}
        else if(mode_speed==fast) while(s[0]==0 || s[2]==0) {pid2(200,35,28);} 
    }
    else if(arah==kiri)
    {
        if(mode_speed==normal) while(s[5]==0 || s[7]==0) {pid2(150,23,15);}
        else if(mode_speed==fast) while(s[5]==0 || s[7]==0) {pid2(200,35,28);}
    }
    rem(mode_rem);
}

void program_lintasan2(unsigned char checkpoin)
{
    int i,j;
    if(checkpoin==0) goto start;
    else if(checkpoin==1) goto cp1;
    else if(checkpoin==2) goto cp2;
    else if(checkpoin==3) goto cp3;
    else if(checkpoin==4) goto cp4;
    else if(checkpoin==5) goto cp5;
    
    start :
    gt=0;
    jalan(maju,200,maju,200,200);
    pidbit(0,1,normal,1);
    jalan(maju,200,mundur,100,200);
    for(i=0;i<300;i++) pid2(150,23,15);
    
    
    for(i=0;i<3;i++) //zig zag
   {   

        zigzag(kanan,normal,1);
        jalan(maju,250,mundur,100,200);
        zigzag(kiri,normal,1);         
        jalan(mundur,100,maju,250,200);
    }
    gt=0;
    for(i=0;i<500;i++) pid2(150,23,15);    
    cp1 :
    pidbit(6,7,normal,1);
    jalan(mundur,100,maju,200,200);
    for(i=0;i<2250;i++) pid2(200,35,28);
    for(i=0;i<3000;i++) pid2(150,23,15);
    pidsayap(kiri,1,normal,2);
    jalan(mundur,150,maju,200,200);
    
    for(i=0;i<1300;i++) pid2(150,23,15);
    pidsayap(kanan,1,1,1);  //
    jalan(maju,200,mundur,100,150);
    
    
    for(i=0;i<1500;i++) pid2(150,23,15);
    pidbit(1,6,normal,1);     
    jalan(maju,200,mundur,100,150);
    last=0;
    
    for(i=0;i<800;i++) pid2(150,23,15); buz_on;
    for(i=0;i<1300;i++) pid2(200,35,28); buz_off;
    for(i=0;i<1000;i++) pid2(150,23,15);   
    
    cp2 :
    gt=0;
    if(checkpoin==2)  
    {
    pidbit(1,6,normal,2);
    jalan(maju,0,maju,200,200);
    }
    else 
    {
    pidbit(1,6,normal,1);
    jalan(mundur,50,maju,200,150);
    last = 0;
    }
    for(i=0;i<850;i++) pid2(150,23,15);
    pidsayap(kiri,1,1,1);
    jalan(mundur,100,maju,200,150);
    for(i=0;i<4000;i++) pid2(200,35,28);
    buz_on;
    for(i=0;i<4000;i++) pid2(255,35,20); 
    buz_off;
    for(i=0;i<2500;i++) pid2(200,35,28);
    
    pidbit(7,0,veryfast2,1);
        
    gt=1; gt=1;
    
    gt=1; gt=1;
    
    jalan(maju,100,maju,200,200);
    last=1;
    for(i=0;i<1500;i++) pid2(150,25,15);
    
    cp3 :
    gt=1; gt=1;
    last=1;
    for(i=0;i<200;i++) pid2(150,25,15);
    last=1; 
    
    pidbit(0,1,1,1);
    jalan(maju,200,mundur,100,200);
    for(i=0;i<100;i++) pid2(150,25,15);
    pidbit(0,1,normal,1);
    jalan(maju,200,mundur,0,200);
    last=1;
    for(i=0;i<200;i++) pid2(150,25,15);
    /*
    pidbit(0,1,1,2);  //
    jalan(maju,150,maju,0,230);
    for(i=0;i<200;i++) pid2(150,25,15);
    pidbit(0,1,normal,2);  //
    jalan(maju,200,maju,0,245);
    */
    
    pidbit(0,7,1,1);
    gt=0; gt=0;
    
    jalan(maju,100,maju,100,180);
   
    pidsayap(kanan,1,slow,1); buz_on;
    jalan(maju,150,maju,75,100);buz_off;
    for(i=0;i<100;i++)pid2(120,15,10); 
    pidsayap(kiri,1,slow,1);
    jalan(maju,150,maju,100,100);
    
    for(i=0;i<=3000;i++) pid2(150,25,15);
    buz_on; 
    pidbit(0,7,10,1);
    jalan(maju,50,maju,200,100);
    buz_off;
    gt=1; gt=1;
    pidbit(2,5,0,1);
    
    for(i=0;i<=200;i++) pid2(120,15,10); 
    pidsayapglp(kanan,0,1,1);
    jalan(maju,200,maju,200,100);
    
    cp4 :
    if(checkpoin==4){
        jalan(maju,70,maju,255,255);
        //jalan(maju,200,maju,200,100);
        //jalan(maju,50,maju,200,300);
    }
    else jalan(mundur,50,maju,200,450);
    last=0;  
    
    gt=0; gt=0;
    for(i=0;i<300;i++) pid2(200,35,28);   
    pidbit(0,7,fast,1);   

    gt=1; gt=1;
    //jalan(maju,200,maju,100,370);
    buz_on;
    for(i=0;i<2000;i++) pid2(200,35,28);
    buz_off;
    for(i=0;i<800;i++) pid2(200,35,28);
    pidbit(0,3,fast,2);
    jalan(maju,200,mundur,50,250);
    last=1;
    buz_on;
    for(i=0;i<100;i++) pid2(150,23,15);
    stop(10);
    buz_off;
    jalan(maju,200,maju,50,150);
    jalan(maju,200,maju,200,50);
    stop(100);
    
    
    for(i=0;i<70;i++) pid2(150,25,15);
    cp5 :
    gt=1; gt=1;
    pidbit(2,7,normal,2);
    jalan(mundur,50,maju,200,150); //sarang lebah
    last=0;
    for(i=0;i<100;i++) pid2(150,23,15);
    pidbit(6,7,normal,2);
    
    jalan(maju,50,maju,200,200);
    
    delay_ms(100);
    last=0;
    pidbit(0,7,1,1);
    last=1;
    jalan(maju,100,maju,200,100);
    
    gt=0; gt=0;
    for(i=0;i<1000;i++) pid2(150,23,15);
    pidbit(2,5,fast,2);
    pidbit(1,6,fast,1);
    delay_ms(1000);
    jalan(maju,200,maju,200,200);
    pidbit(1,6,normal,1);
    for(i=0;i<10;i++) {delay_ms(100); bip;}
     
    
}

void program_lintasan1(unsigned char checkpoin)
{
    int i,j;
    if(checkpoin==0) goto start;
    else if(checkpoin==1) goto cp1;
    else if(checkpoin==2) goto cp2;
    else if(checkpoin==3) goto cp3;
    else if(checkpoin==4) goto cp4;
    else if(checkpoin==5) goto cp5;
    
    start :
    gt=0;
    jalan(maju,200,maju,200,200);
    pidbit(6,7,normal,1);
    jalan(mundur,125,maju,200,200);
    last=1;
    for(i=0;i<300;i++) pid2(150,23,15);
    
    
    for(i=0;i<3;i++) //zig zag
   {   
        zigzag(kiri,normal,1);         
        jalan(mundur,100,maju,250,200);
        zigzag(kanan,normal,1);
        jalan(maju,250,mundur,150,200);       
   }
   
   for(i=0;i<800;i++) pid2(150,23,15);
   cp1 :
   gt=0;
   
   pidbit(0,1,1,1);
   jalan(maju,200,mundur,100,200);
   for(i=0;i<2000;i++) pid2(150,23,15);
   pidsayap(kanan,1,normal,2);
   jalan(maju,200,mundur,150,200);
    
   for(i=0;i<1000;i++) pid2(150,23,15);
   pidsayap(kiri,1,1,1);  //
   jalan(mundur,120,maju,200,150);
   last=1;
    
   for(i=0;i<1000;i++) pid2(150,23,15);
   pidbit(1,6,normal,1);    
   jalan(mundur,100,maju,200,150);
   last=1;
   for(i=0;i<800;i++) pid2(150,23,15); buz_on;
    for(i=0;i<1300;i++) pid2(200,35,28); buz_off;
    for(i=0;i<1000;i++) pid2(150,23,15);   
   
   cp2 :
   gt=0;
   if(checkpoin==2)  
   {
    pidbit(1,6,normal,2);
    jalan(maju,200,maju,0,200);
    }
   else 
   {
    pidbit(1,6,normal,1);
    jalan(maju,200,mundur,50,150);
   }
   for(i=0;i<850;i++) pid2(150,23,15);
   pidsayap(kanan,1,1,1);
   jalan(maju,200,mundur,200,200);
   for(i=0;i<4000;i++) pid2(200,35,28);
   buz_on;
   for(i=0;i<4000;i++) pid2(255,35,20);
   buz_off;
   for(i=0;i<2000;i++) pid2(200,35,28);
   pidbit(7,0,veryfast2,1);
     
   gt=1; gt=1;
   gt=1; gt=1;
    
   jalan(maju,200,maju,0,250);
   last=0;
   for(i=0;i<500;i++) pid2(150,25,15);
   
   cp3 :
   gt=1; gt=1;
   last=0;
   for(i=0;i<200;i++) pid2(150,25,15);
   last=0;
   pidbit(6,7,1,1);  //
   jalan(mundur,100,maju,200,200);
   for(i=0;i<100;i++) pid2(150,25,15);
   pidbit(6,7,normal,1);  //
   jalan(maju,0,maju,200,200);
   last=0;
   for(i=0;i<200;i++) pid2(150,25,15); 
   pidbit(0,7,1,1);
   gt=0; gt=0;
    
//   jalan(maju,100,maju,120,180);
//   last=1; 
//   pidsayap(kiri,1,slow,1);
//   jalan(maju,150,maju,50,100);
//   for(i=0;i<200;i++)pid2(120,15,10);
//   pidsayap(kanan,1,slow,1);
//   jalan(maju,100,maju,150,100);
//   for(i=0;i<2500;i++) pid2(150,25,15);
//   while(sensor!=0) pid2(120,15,10);

    jalan(maju,100,maju,100,180);
    pidsayap(kiri,1,slow,1); buz_on;
    jalan(maju,150,maju,75,100);buz_off;
    for(i=0;i<100;i++)pid2(120,15,10); 
    pidsayap(kanan,1,slow,1);
    jalan(maju,150,maju,100,100);
    for(i=0;i<=3000;i++) pid2(150,25,15);
    
   buz_on;
   pidbit(0,7,10,1);
   jalan(maju,150,maju,0,100);
   buz_off;
   gt=1; gt=1;
   pidbit(2,5,0,1);
    
   for(i=0;i<=500;i++) pid2(120,15,10); 
   pidsayapglp(kiri,1,0,1);
   jalan(maju,200,maju,200,75);
   
   cp4 :
   if(checkpoin==4){
       jalan(maju,255,maju,70,255);
        
   }
   else jalan(maju,200,mundur,50,450);
   last=1;  
    
   gt=0; gt=0;
   for(i=0;i<300;i++) pid2(200,35,28);   
   pidbit(0,7,fast,1);   

   gt=1; gt=1;
   buz_on;
   for(i=0;i<2000;i++) pid2(200,35,28);
   buz_off;
   //jalan(maju,150,maju,200,325);
   for(i=0;i<300;i++) pid2(200,35,28);
   pidbit(7,4,fast,2);
   jalan(mundur,50,maju,200,250);
   last=0;
   buz_on;
    
   for(i=0;i<100;i++) pid2(150,23,15);
   stop(10);
   buz_off;
   jalan(maju,50,maju,200,150);
   jalan(maju,200,maju,200,50);
   stop(100);
    
   for(i=0;i<70;i++) pid2(150,25,15);

   cp5 :
   gt=1; gt=1;
   pidbit(5,0,normal,2);
   jalan(maju,200,mundur,50,150); //sarang lebah
   last=1;
   for(i=0;i<100;i++) pid2(150,23,15);
   pidbit(1,0,normal,2);
    
   jalan(maju,200,maju,50,200);
    
   delay_ms(100);
   last=1;
   pidbit(0,7,1,1);
   last=0;
   jalan(maju,200,maju,100,100);
    
   gt=0; gt=0;
   for(i=0;i<1000;i++) pid2(150,23,15);
   pidbit(2,5,fast,2);
   pidbit(1,6,fast,1);
   delay_ms(1000);
   jalan(maju,200,maju,200,200);
   pidbit(1,6,normal,1);
   for(i=0;i<10;i++) {delay_ms(100); bip;}
 
}

void pilih_start()
{
    lcd_clear();
    lcd_putsf("  Masukan Mode ");
    lcd_putsf("     Start     ");
    while(key>5)
    {
        key=keypad();
        if(key==1 || key==4) pilihstart=0;
        if(key==2 || key==3) pilihstart=1;
    }
    lcd_clear();
    lcd_putsf(" Alhamdulillah ");
    delay_ms(500);            
    lcd_clear();
    key=kosong;    
}

void menulama()
{
    while(key!=12)
    {
        key=keypad(); 
        if(key==1)
        {
            lcd_clear();
            lcd_puts(" Masukan CheckP ");
            delay_ms(500);
            key=inkeypad();
            program_lintasan2(key);
            key=kosong;
            
            
        }
        while(key==3) kalibrasi();
        if(key==2)
        {
            lcd_clear();
            while(key!=12)
            {
                key=keypad();
                cetak_sensor();
            }
            lcd_clear();    
        }
        if(key==5) {lcd_clear(); cek_adc();}
        if(key==4) {delay_ms(300); set_baca();}
        if(key==6) {
            lcd_clear();
            lcd_puts(" Masukan CheckP ");
            delay_ms(500);
            key=inkeypad();
            program_lintasan1(key);
            key=kosong;
            
            
        }
         //program_masukhitam();
        if(key==7) {
            delay_ms(300);
            lcd_clear();
            lcd_puts("   MOTOR KIRI   ");
            lcd_puts("1:Maju  2:Mundur");
            key2=inkeypad();
            if(key2==1) in_arah_kiri=maju;
            else in_arah_kiri=mundur;
            
            lcd_clear();
            lcd_puts("Speed : ");
            in_kec_kiri=inputnilai(8);
            
            lcd_clear();
            lcd_puts("  MOTOR  KANAN  ");
            lcd_puts("1:Maju  2:Mundur");
            key2=inkeypad();
            if(key2==1) in_arah_kanan=maju;
            else in_arah_kanan=mundur;
            
            lcd_clear();
            lcd_puts("Speed : ");
            in_kec_kanan=inputnilai(8);
            
            lcd_clear();
            lcd_puts("Delay : ");
            delay_belok=inputnilai(8);
            
            lcd_clear();
            jalan(in_arah_kiri,in_kec_kiri,in_arah_kanan,in_kec_kanan,delay_belok);
        } 
        if(key==8) {lcd_clear(); while(1) {pid2(150,23,15);}}
        if(key==9) {
            delay_ms(300);
            lcd_clear(); lcd_puts("Speed : ");
            inkec=inputnilai(7);
            lcd_clear(); lcd_puts("KP : ");
            inkp=inputnilai(5);
            lcd_clear(); lcd_puts("KD : ");
            inkd=inputnilai(5);
            while(1) pid2(inkec,inkp,inkd);
                        
        }
        if(key==0) {motor_ki(maju,255); motor_ka(maju,255);}           

    }
}

void menubaru()
{
    while(1)
    {
        lcd_gotoxy(0,0);
        lcd_putsf("   Bismillah    ");
        if(pilihstart==0) lcd_putsf("Mode Start : 1/4");
        else lcd_putsf("Mode Start : 2/3");
        
        key=keypad();
        if(key>=0 && key <=5)
        {
            if(pilihstart == 0) program_lintasan1(key);
            else program_lintasan2(key);
            key=kosong;
        }
        if(key==6)
        {
            delay_ms(500);
            menulama();
        }
        if(key==7) 
        {
            kalibrasi();
         
        }
        if(key==8)
        {
            lcd_clear();
            while(key!=12)
            {
                key=keypad();
                cetak_sensor();
            }
            lcd_clear();    
        }
        if(key==9)
        {
            pilih_start();         
        }
        
    }
}

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
// Func7=Out Func6=Out Func5=Out Func4=In Func3=Out Func2=In Func1=Out Func0=In 
// State7=1 State6=1 State5=1 State4=P State3=1 State2=P State1=1 State0=P 
PORTC=0xFF;
DDRC=0b11101010;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=In Func3=Out Func2=In Func1=Out Func0=In 
// State7=1 State6=1 State5=1 State4=P State3=1 State2=P State1=1 State0=P 
PORTD=0x0C;
DDRD=0xF3;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 15,625 kHz
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
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
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

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 691,200 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

// LCD module initialization
lcd_init(16);
    
    
    lcd_gotoxy(0,0);
    lcd_putsf("ASSALAMUALAIKUM ");
    lcd_gotoxy(0,1);
    lcd_putsf(" BISMILLAH :)  ");
    delay_ms(500);
    lcd_clear();
    delay_ms(200);
    lcd_gotoxy(0,0);                                                                                                        
    lcd_putsf("    TOOTHLESS   ");
    lcd_gotoxy(0,1);
    lcd_putsf("  Line Follower ");
    delay_ms(500);
    lcd_clear();   
    delay_ms(100);
    lcd_putsf("  Pilih   Menu  ");
    if(pilihstart==255) pilih_start();
     
         
while (1)
      {
        menubaru();
      }
}


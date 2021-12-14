# 1 "main.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "D:/packs/Microchip/PIC18Fxxxx_DFP/1.2.26/xc8\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "main.c" 2







# 1 "./adc.h" 1
# 22 "./adc.h"
 void adcInit(void);
 int adcRead(unsigned int channel);
# 8 "main.c" 2

# 1 "./lcd.h" 1


  void lcdCommand(char value);
  void lcdChar(char value);
  void lcdString(char msg[]);
  void lcdNumber(int value);
  void lcdPosition(int line, int col);
  void lcdInit(void);
# 9 "main.c" 2

# 1 "./ds1307.h" 1
# 14 "./ds1307.h"
 void dsInit(void);
 void dsStartClock(void);
 void dsStopClock(void);
 int dec2bcd(int value);
 int bcd2dec(int value);
 void dsWriteData(unsigned char value, int address);
 int dsReadData(int address);
# 10 "main.c" 2

# 1 "./keypad.h" 1


 unsigned int kpRead(void);
    char kpReadKey(void);
 void kpDebounce(void);
 void kpInit(void);
# 11 "main.c" 2

# 1 "./bits.h" 1
# 12 "main.c" 2

# 1 "./rgb.h" 1
# 20 "./rgb.h"
 void rgbColor(int led);
 void turnOn(int led);
 void turnOff(int led);
 void rgbInit(void);
# 13 "main.c" 2


static const int radio[] = {856,879,901,963,1005,1016,1074,1108};
void main(void) {
    int vel=0;
    unsigned char marcha=0,tecla,i,painel=0,fm=0,vol=0;
    rgbInit();
    kpInit();
    adcInit();
    lcdInit();
    turnOn(2);
    for(;;){
        vel = adcRead(1);
        if(vel<500)
           rgbColor(2);
        else if(vel<700)
           rgbColor(3);
        else if(vel<900)
           rgbColor(1);
        if(marcha==0)
                vel=0;
        else if(marcha==1)
                vel/=50;
        else if(marcha==2)
                vel/=20;
        else if(marcha==3)
                vel/=10;
        else if(marcha==4)
                vel/=7;
       else if(marcha==5)
                vel/=5;
        for(i=0;i<8;i++){
            kpDebounce();
            if (kpRead() != tecla){
                tecla = kpRead();
                    if (((tecla) & (1<<(5)))&&marcha!=5){
                        marcha++;
                        painel=0;
                    }
                    if (((tecla) & (1<<(7)))&&marcha!=0){
                        marcha--;
                        painel=0;
                    }
                    if (((tecla) & (1<<(1)))&&fm!=0){
                        fm--;
                        painel=1;
                    }
                    if (((tecla) & (1<<(3)))&&fm!=7){
                        fm++;
                        painel=1;
                    }
                    if (((tecla) & (1<<(0)))&&vol!=12){
                        vol++;
                        painel=1;
                    }
                    if (((tecla) & (1<<(2)))&&vol!=0){
                        vol--;
                        painel=1;
                    }
            }
        }
        switch(painel){
            case 0:
                lcdPosition(0,0);
                lcdChar(((bcd2dec(dsReadData(2)& 0x5f))/10%10)+48);
                lcdChar(((bcd2dec(dsReadData(2)& 0x5f))%10)+48);
                lcdChar(':');
                lcdChar(((bcd2dec(dsReadData(1)& 0x7f))/10%10)+48);
                lcdChar(((bcd2dec(dsReadData(1)& 0x7f))%10)+48);
                lcdPosition(0,5);
                lcdString(" Marcha ");
                lcdChar(marcha+48);
                lcdPosition(1,0);
                lcdString(" Vel: ");
                lcdChar((vel/100%10)+48);
                lcdChar((vel/10%10)+48);
                lcdChar((vel%10)+48);
                lcdString(" Km/h");
                break;
            case 1:
                lcdPosition(0,0);
                lcdString("Radio: ");
                lcdChar((radio[fm]/1000%10)+48);
                lcdChar((radio[fm]/100%10)+48);
                lcdChar((radio[fm]/10%10)+48);
                lcdChar(',');
                lcdChar((radio[fm]%10)+48);
                lcdString("   ");
                lcdPosition(1,0);
                lcdString("Vol:");
                for(i=0;i<12;i++)
                    if(i<vol+1)
                        lcdChar('*');
                    else
                        lcdChar(' ');
                break;
        }
    }
}

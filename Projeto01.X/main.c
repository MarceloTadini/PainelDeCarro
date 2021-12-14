/*
 * Aluno: Marcelo Barbosa Tadini Patta
 * Matrícula: 2019000439
 * Turma 03
 * Projeto final - Painel de Carro com PQDB
 */

#include "adc.h"
#include "lcd.h"
#include "ds1307.h"
#include "keypad.h"
#include "bits.h"
#include "rgb.h"

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
                    if (bitTst(tecla, 5)&&marcha!=5){
                        marcha++;
                        painel=0;
                    }
                    if (bitTst(tecla, 7)&&marcha!=0){
                        marcha--;
                        painel=0;
                    }
                    if (bitTst(tecla, 1)&&fm!=0){
                        fm--;
                        painel=1;
                    }
                    if (bitTst(tecla, 3)&&fm!=7){
                        fm++;
                        painel=1;
                    }
                    if (bitTst(tecla, 0)&&vol!=12){
                        vol++;
                        painel=1;
                    }
                    if (bitTst(tecla, 2)&&vol!=0){
                        vol--;
                        painel=1;
                    }
            }
        }
        switch(painel){
            case 0:
                lcdPosition(0,0);
                lcdChar((getHours()/10%10)+48);
                lcdChar((getHours()%10)+48);
                lcdChar(':');
                lcdChar((getMinutes()/10%10)+48);
                lcdChar((getMinutes()%10)+48);
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
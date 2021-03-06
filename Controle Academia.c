/*******************************************************

This program was created by the CodeWizardAVR V3.42 
Automatic Program Generator
? Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
http://www.hpinfotech.ro

Project : 
Version : 
Date    :
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 14,745600 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

// Alphanumeric LCD functions
#include <alcd.h>
#include <mega16.h>
#include <delay.h>



// PINA0..3 will be row inputs
#define KEYIN PINA
// PORTA4..7 will be column outputs
#define KEYOUT PORTA
#define FIRST_COLUMN 0x80
#define LAST_COLUMN 0x10

typedef unsigned char byte;
// store here every key state as a bit,
// bit 0 will be KEY0, bit 1 KEY1,...
unsigned keys;

// Declare your global variables here
 char flag0=0;
 
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
static byte key_pressed_counter=20;
static byte key_released_counter,column=FIRST_COLUMN;
static unsigned row_data,crt_key;
// Reinitialize Timer 0 value
TCNT0=0x8D; // para 2ms
// Place your code here
row_data<<=4;
// get a group of 4 keys in in row_data
row_data|=~KEYIN&0xf;
column>>=1;
if (column==(LAST_COLUMN>>1))
   {
   column=FIRST_COLUMN;
   if (row_data==0) goto new_key;
   if (key_released_counter) --key_released_counter;
   else
      {
      if (--key_pressed_counter==9) crt_key=row_data;
      else
         {
         if (row_data!=crt_key)
            {
            new_key:
            key_pressed_counter=10;
            key_released_counter=0;
            goto end_key;
            };
         if (!key_pressed_counter)
            {
            keys=row_data;
            key_released_counter=20;
            };
         };
      };
   end_key:;
   row_data=0;
   };
// select next column, inputs will be with pull-up
KEYOUT=~column;
}


unsigned inkey(void)
{
unsigned k;
if (k=keys) keys=0;
return k;
}


void init_keypad(void)
{
// PORT D initialization
// Bits 0..3 inputs
// Bits 4..7 outputs
DDRA=0xf0;
// Use pull-ups on bits 0..3 inputs
// Output 1 on 4..7 outputs
PORTA=0xff;
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 57.600 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
//TCCR0=0x03;
//INIT_TIMER0;
TCCR0=0x04;
TCNT0=0x8D;
OCR0=0x00;

// External Interrupts are off
//MCUCR=0x00;
//EMCUCR=0x00;
// Timer 0 overflow interrupt is on
//TIMSK=0x02;
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;
#asm("sei")
}

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 32
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;
bit rx_message; // Flag de recep??o de mensagem

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   
   if ( data == 0xd )
    {
      data = 0;
      rx_message = 1;
    }
    
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0)
      {
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
#endif
      rx_buffer_overflow=1;
      }
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 32
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
          flag0=1; 
}

int entrada(int np)
{
  unsigned k = 0;
  char message[20];
  char chave[20];
  char opcao[2][10] = {"Digital","Senha"};
  char cadastro[3][20] = {"Aluno","Experimental","Personal"};  
  char senha[10] = "201769024"; 
  char senha_botoes[9];
  char comando[2];
  int i, j, trava = 1, validado = 1, valida_senha = 1, contaux = 0, tam_chave=0;


    printf("\nEntrar com digital ou senha?\n\r");
    for (i=0; i<2 ; i++) 
    {                                               
        printf("[%i] = %s\n", i+1, opcao[i]);
    }
    
    while(trava)
    {
    if(rx_message)
    {
        rx_message = 0;
        for (i=0, j=rx_counter;i<j;i++) 
        {
            comando[i] = getchar();
        };
        trava = 0;
    }
    }
    
    switch(comando[0]) 
    {
    case 49:
        printf("\nColoque sua digital no leitor!\n");
    break;
    
    case 50:
        printf("\nDigite sua senha:");
    break;
    
    default:
        printf("Comando Incorreto!\n\r");
        printf("\n\rBem vindo a MPR Academia!\n\r");
        printf("[1] = Registrar Entrada\n\r");
    break;
    }; 

    if(comando[0] == 49)
    {   
        trava = 1;
                
        while(trava)
        {
            if(rx_message)
            {   
                rx_message = 0;
                tam_chave = rx_counter;
                   
                for (i=0, j=rx_counter; i<j ; i++) 
                {                                               
                    message[i]= getchar();
                };                             
                   
                for (i=0;i<tam_chave;i++)      // L? O BUFFER AT? O TAMANHO DA CHAVE E SALVA ISSO COMO ENTRADA 
                {
                    chave[i] = message[i];                      
                };
                                                                                                              

                for (j=0; j<3; j++)
                {   
                    validado = 1;  
        
                    for (i=0;i<tam_chave;i++)      // L? O BUFFER AT? O TAMANHO DA CHAVE E SALVA ISSO COMO ENTRADA 
                    {
                        if (chave[i] != cadastro[j][i])   // VERIFICA SE A CHAVE ? IGUAL AO CADASTRO PARA VALIDAR O ACESSO
                        {          
                        validado = 0;
                        break;
                        }
                    };
                    
                    if (validado == 1)
                    {
                    break;
                    }
                };                                 
            
            if (validado) 
            {                                      
               PORTB.0=1;
               PORTB.1=0;
               printf("\nEntrada: %s\n\r",chave);
               printf("ACESSO PERMITIDO\n\r");
               validado = 0;
               np--;
               delay_ms(2000);
               PORTB.0=0;
               printf("Bem vindo a MPR Academia!\n\r");
               printf("[1] = Registrar Entrada\n\r");
               trava = 0;
            }
            else
            {
               PORTB.0=0;
               PORTB.1=1;   
               printf("\nACESSO NEGADO OU LEITURA INCORRETA\n");
               validado = 1;
               trava = 0;
               delay_ms(2000);
               PORTB.1=0;
               printf("\nBem vindo a MPR Academia!\n");
               printf("\n[1] = Registrar Entrada\n\r");
            };       
            };
        };     
    } 
       
    if(comando[0] == 50)
    {
     do
     {
      if (k=inkey()) 
      {
        switch(k)
        {        
         case 4096:
            printf("0");
            senha_botoes[contaux] = '0';
            contaux = contaux + 1;
         break;
         
         case 1:
            printf("1");
            senha_botoes[contaux] = '1';
            contaux = contaux + 1;
         break;   
         
         case 2:
            printf("2");
            senha_botoes[contaux] = '2';
            contaux = contaux + 1;
         break;
         
         case 4:
            printf("3");
            senha_botoes[contaux] = '3';
            contaux = contaux + 1;
         break;
          
         case 16:
            printf("4");
            senha_botoes[contaux] = '4';
            contaux = contaux + 1;
         break;
         
         case 32:
            printf("5"); 
            senha_botoes[contaux] = '5';
            contaux = contaux + 1;
         break;
         
         case 64:
            printf("6");
            senha_botoes[contaux] = '6';
            contaux = contaux + 1;
         break;
         
         case 256:
            printf("7"); 
            senha_botoes[contaux] = '7';
            contaux = contaux + 1;
         break;
           
         case 512:
            printf("8"); 
            senha_botoes[contaux] = '8';
            contaux = contaux + 1;
         break;
           
         case 1024:
            printf("9");
            senha_botoes[contaux] = '9';
            contaux = contaux + 1;   
         break;
        } 
      }
     }while (contaux<9);
        
        if(contaux == 9)
        { 
        for (i=0;i<(sizeof(senha_botoes)/(sizeof(senha_botoes[0])));i++)     
            {
            if (senha_botoes[i] != senha[i])                         // VERIFICA SE A ENTRADA ? IGUAL A CHAVE PARA HABILITAR O ACESSO
            {          
            valida_senha = 0;
            }
            }
         }
            
        if (valida_senha)
        {
            PORTB.0=1;
            PORTB.1=0;
            printf("\n\rACESSO PERMITIDO\n\r");
            np--;
            delay_ms(2000);
            PORTB.0=0;
            printf("Bem vindo a MPR Academia!\n\r");
            printf("[1] = Registrar Entrada\n\r");
            
        }  
        else
        {
            PORTB.0=0;
            PORTB.1=1;   
            printf("\n\rACESSO NEGADO OU SENHA INCORRETA\n");
            delay_ms(2000);
            PORTB.1=0;
            validado = 1;
            valida_senha = 1;
            printf("\nBem vindo a MPR Academia!\n");
            printf("\n[1] = Registrar Entrada\n\r");
        }
    }
    
    contaux = 0;
    return (np);
}           

void main(void)
{
// Declare your local variables here
  
  char texto[32];
  char ent[2];  
  char aux1, aux2, aux3; 
  int i, j, nump = 15;    
                                                                
{// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (1<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=Out 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
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
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Any change
// INT1: Off
// INT1 Mode: Any change
// INT2: Off
GICR|=0x40;  // 0100 0000
MCUCR=0x02;  // 0000 1111
GIFR=0x40;   // 1100 0000
//GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
//MCUCR=(0<<ISC11) | (1<<ISC10) | (0<<ISC01) | (1<<ISC00);
//MCUCSR=(0<<ISC2);
//GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 19200
//UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
//UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
//UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);

UCSRA=0x00;    
UCSRB=0xD8;    // 11011000 - Habilitado recep??o e transmiss?o com interrup?oes                                                   \\\\\\\
UCSRC=0x86;    // 10000110 - Habilitado ,Modo ass?ncrono, Paridade desabilitada, 1 stop bit, 9 bits ,borda de descida             \\\\\\\
UBRRH=0x00;    //                                                                                                                 \\\\\\\
UBRRL=0x2F;    // FREQU?NCIA 19.200

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 8
}

lcd_init(16);

// Globally enable interrupts
#asm("sei")
init_keypad();
lcd_clear();
lcd_gotoxy(5,0);
sprintf(texto,"VAGAS");
lcd_puts(texto);
      
lcd_gotoxy(6,1);
lcd_putchar(48);
lcd_gotoxy(7,1);
lcd_putchar(49);
lcd_gotoxy(8,1);
lcd_putchar(53);

printf("Bem vindo a MPR Academia!\n");
printf("\n[1] = Registrar Entrada\n");

while (1)
{
// Place your code here  
  
    PORTB.0 = 0;
    PORTB.1 = 0;
    
    if(rx_message)
    {  
        rx_message=0;
        
        for(i=0, j=rx_counter; i<j; i++) 
        {
            ent[i] = getchar();
        };

       
       if(ent[0] == 49)
        {
           nump = entrada(nump); 
        }
        else
        {   
            printf("\nComando invalido!\n");
            delay_ms(1000);
            printf("\nBem vindo a MPR Academia!\n");
            printf("\n[1] = Registrar Entrada\n");
        } 
    }
                   
    if(flag0==1)
    {
        flag0=0;
        printf("\nSa?da registrada!\nVolte Sempre!\n");
        nump++;
        PORTB.1 = 1;
        delay_ms(1000);
        
        printf("\nBem vindo a MPR Academia!\n");
        printf("\n[1] = Registrar Entrada\n");
    }; 
    
    if (nump<10)
    {
        aux1 = (char) nump+48;
        aux2 = '0';
        aux3= '0';
    }
    if (nump>=10 && nump<16)
    {
        aux1 = (char)(nump-((nump/10)*10)+48);
        aux2 = (char)((nump/10)+48);
        aux3 = '0';
    }
   
    if(nump>=16)
    {
        nump = 15;
    }          
            
    lcd_gotoxy(5,0);
    sprintf(texto,"VAGAS");
    lcd_puts(texto);
      
    lcd_gotoxy(6,1);
    lcd_putchar(aux3);
    lcd_gotoxy(7,1);
    lcd_putchar(aux2);
    lcd_gotoxy(8,1);
    lcd_putchar(aux1);    
}              
}
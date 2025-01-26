; Configuratia unui ceas cu afisaj pe 7 segmente, utilizând 8255A si 8253
; Adrese de memorie:
; 8255_0: PA = 8000h, PB = 8001h, PC = 8002h, CC = 8003h
; 8255_1: PA = 8004h, PB = 8005h, PC = 8006h, CC = 8007h
; 8253: Canal 0 = 8008h, CC = 800Bh

;Primul 8255 
P8255_0_PA EQU 8000H ;sec0
P8255_0_PB EQU 8001H ;sec 1
P8255_0_PC EQU 8002H; min0
P8255_0_CC EQU 8003H; 
;al doilea 8255
P8255_1_PA EQU 8004H ;min1
P8255_1_PB EQU 8005H ;ore 0
P8255_1_PC EQU 8006H ;ore 1
P8255_1_CC EQU 8007H

P8253_Canal0 EQU 8008h
P8253_CC     EQU 800Bh 
	
CC_8255_0       EQU 80h         
CC_8255_1       EQU 80h
	
CC_8253         EQU 34h    
CT_LSB_8253     EQU 0CBh
CT_MSB_8253     EQU 00h



; SECTIUNE COD
ORG 0H
LJMP START

ORG 03h
LJMP RUTINA0

ORG 100h

START:
   CLR IE.7       ;dezactivare globala a intreruperilor
	MOV R0,#00h    ;contor pe 0
	SETB IE.0      ;init Int0
	SETB TCON.0  
	
	MOV DPTR,#P8255_0_CC    ;init primul circuit 8255 
	MOV A,#CC_8255_0    
	MOVX @DPTR,A   
	
	MOV DPTR,#P8255_1_CC   ;init al doilea circuit 8255
	MOV A,#CC_8255_1    
	MOVX @DPTR,A    
	
	MOV DPTR,#P8253_CC     ;init 8253
	MOV A,#CC_8253 
	MOVX @DPTR,A    
	
	MOV DPTR,#P8253_Canal0    
	MOV A,#CT_LSB_8253 
	MOVX @DPTR,A    
	MOV A,#CT_MSB_8253    
	MOVX @DPTR,A    
	SETB IE.7   
    SJMP $
    
ORG 200h
RUTINA0:
INC R0    
	CJNE R0,#05h,afisare  
	MOV R0,#00h     ;reinit contor
	
	MOV A,R1        ;SECUNDE
	ADD A,#01h    
	DA A            ;ajustare zecimala a adunarii pentru numere reprezentate in cod BCD, – corecteaza
                    ;rezultatul.Suma zecimala este depusa in acumulator, CY este setat daca rez > 77.
	MOV R1,A                 ;A este salvat in R1
	CJNE R1,#60h,afisare     ;daca rez din R1<60h se sare la afisare, daca rez=60h, se reinit R1 cu 0h
	MOV R1,#00h    
	
	
	MOV A,R2         ;MINUTE
	ADD A,#01h   
	DA A   
	MOV R2,A   
	CJNE R2,#60h,afisare   
	MOV R2,#00h    
	
	
	MOV A,R3         ;ORE
	ADD A,#01h    
	DA A   
	MOV R3,A    
	CJNE R3,#24h,afisare   
	MOV R3,#00h    

Afisare:
    MOV DPTR,#P8255_0_PA
	MOV A,R1  
	LCALL Afisseg   
	MOV DPTR,#P8255_0_PB 
	MOV A,R1  
	SWAP A    
	LCALL Afisseg
	MOV DPTR,#P8255_0_PC
	MOV A,R2   
	LCALL Afisseg
	MOV DPTR,#P8255_1_PA
	MOV A,R2   
	SWAP A   
	LCALL Afisseg  
	MOV DPTR,#P8255_1_PB
	MOV A,R3   
	LCALL Afisseg
	MOV DPTR,#P8255_1_PC 
	MOV A,R3  
	SWAP A   
	LCALL Afisseg
	RETI
	

ORG 300h
Afisseg: 
	ANL A,#0Fh 
	PUSH DPL   
	PUSH DPH  
	MOV DPTR,#TABELHEX  
	MOVC A,@A+DPTR    
	POP DPH   
	POP DPL   
	MOVX @DPTR,A   
    RET

 TABELHEX:
 DB 3Fh,06h,5Bh,4Fh,66h,6Dh,7Dh,07h,7Fh,6Fh
 END
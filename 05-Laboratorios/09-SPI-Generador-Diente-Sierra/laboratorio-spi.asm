;*******************************************************************************
;                    LABORATORIO - GENERADOR DIENTE DE SIERRA
;*******************************************************************************
#include registers.inc
;*******************************************************************************

;*******************************************************************************
;                   RELOCALIZACION DE VECTORES DE INTERRUPCION
;*******************************************************************************

                ORG $3E70
             dw RTI_ISR
             
                ORG $3E52
             dw ATD0_ISR

;*******************************************************************************
;                              ESTRUCTURAS DE DATOS
;*******************************************************************************

Comparador:     ds 1
CONT_DA:        ds 2
LEDs:           ds 1

;*******************************************************************************
;                              PROGRAMA PRINCIPAL
;*******************************************************************************

                ORG $2000
SPI
                Movb #$49,RTICTL
                Movb #$80,CRGINT
                
                Movb #$FF,DDRB
                Movb #$00,PORTB
                BSet DDRJ,$02
                BClr PTJ,$02
                Movb #$0F,DDRP
                Movb #$0F,PTP
                
                Movb #$C2,ATD0CTL2
                Ldaa #160
Retardo         Dbne A,Retardo
                Movb #$08,ATD0CTL3
                Movb #$97,ATD0CTL4
                
                Movb #$50,SPI0CR1
                Movb #$00,SPI0CR2
                Movb #$45,SPI0BR
                
                BSet DDRM,$40
                BSet PTM,$40
                
                Lds #$3BFF
                Cli
                Movb #32,Comparador
                Movb #$01,LEDs
                Movb #$00,CONT_DA ;word
                Bra *
                
;*******************************************************************************
;                  SUBRUTINA DE ATENCION A INTERRUPCION RTI
;*******************************************************************************

RTI_ISR        ; Movb #$FF,PORTB
                Ldx CONT_DA
                Inx
                Stx CONT_DA
                Cpx #1024
                Bne Skip_Reset
                Movw #$0000,CONT_DA
Skip_Reset      BClr PTM,$40
Loop            BrClr SPI0SR,$20,Loop
                Ldd CONT_DA
                Lsld
                Lsld
                Anda #$0F
                Adda #$90
                Staa SPI0DR
Loop_2          BrClr SPI0SR,$20,Loop_2
                Stab SPI0DR
Loop_3          BrClr SPI0SR,$20,Loop_3
                BSet PTM,$40
                BSet CRGFLG,$80
                Movb #$86,ATD0CTL5
FIN_RTI_ISR     Rti

;*******************************************************************************
;                  SUBRUTINA DE ATENCION A INTERRUPCION ATD0
;*******************************************************************************

ATD0_ISR
                Ldd ADR00H
                Cmpb #31
                Bcs Reset
                Cmpb Comparador
                Bcs FIN_ATD0_ISR
                Movb LEDs,PORTB
                Ldaa Comparador
                Adda #31
                Staa Comparador
                Ldaa LEDs
                Lsla
                Oraa LEDs
                Staa LEDs
                Bra FIN_ATD0_ISR
Reset           Movb #$00,PORTB
                Movb #31,Comparador
                Movb #$01,LEDs
FIN_ATD0_ISR    Rti
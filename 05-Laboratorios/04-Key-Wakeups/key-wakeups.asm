;*******************************************************************************
;                               LABORATORIO 4
;*******************************************************************************
;         Laboratorio: Key-wakeups
;       Autora: Daniela Fonseca Zumbado
;       Version: 1.0
;*******************************************************************************
#include registers.inc
;*******************************************************************************
;                            ESTRUCTURAS DE DATOS
;*******************************************************************************
                ORG $3E4C                       ; Relocalizacion del vector
                dw PTH_ISR                      ; de interrupciones
                
                ORG $1000
LEDS:           ds 1
                
;*******************************************************************************
;                                 PROGRAMA
;*******************************************************************************

                ORG $2000

Despl_LED:      Movb #$FF,DDRB                  ; Habilitar los LEDs
                BSet DDRJ,$02
                BClr PTJ,$02
                Movb #$0F,DDRP                  ; Apaga los displays
                Movb #$0F,PTP
                BSet PIEH,$01
                BSet PPSH,$01
                Lds #$3BFF
                CLI                             ; Habilitar interrupciones
                Movb #$01,LEDS
ESPERE          Bra ESPERE

;*******************************************************************************
;                               SUBRUTINA PTH_ISR
;*******************************************************************************

PTH_ISR         BSet PIFH,$01
                Movb LEDS,PORTB                 ; Encender LED
                Brset LEDS,$80,Desplazar        ; Corregir*
                Lsl LEDS
                Bra Retornar
Desplazar       Movb #$01,LEDS
Retornar        Rti
                
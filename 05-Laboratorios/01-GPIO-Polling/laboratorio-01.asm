;*******************************************************************************
;                               LABORATORIO 1
;*******************************************************************************
; 	Autora: Daniela Fonseca
; 	Version: 1.0
;*******************************************************************************

#include registers.inc

        ORG $2000
        Movb #0,DDRH             ; Escribir 0 en el registro DDRH
        Movb #$FF,DDRB           ; Escribir 0xFF en el registro DDRB
        BSet DDRJ,$02            ; Poner en 1 el bit 1 de DDRJ
        BClr PTJ,$02             ; Poner en 0 el bit 0 de PTJ
Ciclo   Ldaa PTIH                ; Guardar el valor del registro PTIH
        Staa PORTB               ; en el registro PORTB
        Bra Ciclo                ; Terminar programa
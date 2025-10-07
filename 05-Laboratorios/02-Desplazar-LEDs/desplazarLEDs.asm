;*******************************************************************************
;                               LABORATORIO 2
;*******************************************************************************
#include registers.inc
;*******************************************************************************
;                            ESTRUCTURAS DE DATOS
;*******************************************************************************
                ORG $3E70                       ; Relocalizacion del vector
                dw RTI_ISR                      ; de interrupciones
                
                ORG $1000
LEDS:           ds 1
CONT_RTI:       ds 1
                
;*******************************************************************************
;                                 PROGRAMA
;*******************************************************************************

                ORG $2000

Despl_LED:      Movb #$FF,DDRB                  ; Habilitar los LEDs
                BSet DDRJ,$02
                BClr PTJ,$02
                Movb #$0F,DDRP                  ; Apaga los displays
                Movb #$0F,PTP
                BSet CRGINT,$80                ; Habilitar RTI
                Movb #$17,RTICTL                ; Cargar duracion M=1, N=7
                Lds #$3BFF
                CLI                       ; Habilitar interrupciones
                Movb #$01,LEDS
                Movb #250,CONT_RTI
ESPERE          Bra ESPERE

;*******************************************************************************
;                               SUBRUTINA RTI_ISR
;*******************************************************************************

RTI_ISR         BSet CRGFLG,$80                ; Borrar solicitud de atencion
                Dec CONT_RTI
                Bne Retornar
                Movb #250,CONT_RTI              ; Recargar contador
                Movb LEDS,PORTB                 ; Encender LED
                Brset LEDS,$80,Desplazar        ; Corregir*
                Lsl LEDS
                Bra Retornar
Desplazar       Movb #$01,LEDS
Retornar        Rti
                
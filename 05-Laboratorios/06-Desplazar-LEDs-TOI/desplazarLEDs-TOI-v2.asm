;*******************************************************************************
;                               LABORATORIO 6
;*******************************************************************************
#include registers.inc
;*******************************************************************************
;                            ESTRUCTURAS DE DATOS
;*******************************************************************************
                ORG $3E5E                       ; Relocalizacion del vector
                dw TOI_ISR                      ; de interrupciones
                
                ORG $1000
LEDS:           ds 1
CONT_TOI:       ds 1
                
;*******************************************************************************
;                                 PROGRAMA
;*******************************************************************************

                ORG $2000

Despl_LED:      Movb #$FF,DDRB                  ; Habilitar los LEDs
                BSet DDRJ,$02
                BClr PTJ,$02
                Movb #$0F,DDRP                  ; Apaga los displays
                Movb #$0F,PTP
                BSet TSCR1,$90                  ; Habilitar Timer y borrado autom.
                BSet TSCR2,$82                  ; Habilitar Interrupcion y PR1
                Lds #$3BFF
                Cli                             ; Habilitar interrupciones
                Movb #$01,LEDS
                Movb #25,CONT_TOI
ESPERE          Bra ESPERE

;*******************************************************************************
;                               SUBRUTINA TOI_ISR
;*******************************************************************************

TOI_ISR         Ldd TCNT
                Dec CONT_TOI
                Bne Retornar
                Movb #25,CONT_TOI               ; Recargar contador
                Movb LEDS,PORTB                 ; Encender LED
                BrClr LEDS,$80,No_Desplazar
                Movb #$01,LEDS
                Bra Retornar
No_Desplazar    Lsl LEDS
Retornar        Rti
                
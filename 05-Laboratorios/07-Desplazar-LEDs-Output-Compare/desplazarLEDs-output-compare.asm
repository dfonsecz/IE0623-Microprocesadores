;*******************************************************************************
;                               LABORATORIO 6
;*******************************************************************************
#include registers.inc
;*******************************************************************************
;                            ESTRUCTURAS DE DATOS
;*******************************************************************************
                ORG $3E64                       ; Relocalizacion del vector
                dw OC5_ISR                      ; de interrupciones
                
                ORG $1000
LEDS:           ds 1
CONT_OC:        ds 1
                
;*******************************************************************************
;                                 PROGRAMA
;*******************************************************************************

                ORG $2000

Despl_LED:      Movb #$FF,DDRB                  ; Habilitar los LEDs
                BSet DDRJ,$02
                BClr PTJ,$02
                Movb #$0F,DDRP                  ; Apaga los displays
                Movb #$0F,PTP
                BSet TSCR1,$90                  ; Habilitar Timer con borrado autom.
                BSet TSCR2,$04                  ; Habilitar PR2
                BSet TIOS,$20                   ; Establecer IOS1 como salida
                BSet TIE,$20                    ; Habilitar interrupcion
                Ldd TCNT
                Addd #15000
                Std TC5
                Lds #$3BFF
                Cli                             ; Habilitar interrupciones
                Movb #$01,LEDS
                Movb #25,CONT_OC
ESPERE          Bra ESPERE

;*******************************************************************************
;                               SUBRUTINA TOI_ISR
;*******************************************************************************

OC5_ISR         Dec CONT_OC
                Bne Finalizar
                Movb #25,CONT_OC                ; Recargar contador
                Movb LEDS,PORTB                 ; Encender LED
                BrClr LEDS,$80,Desplazar
                Movb #$01,LEDS
                Bra Finalizar
Desplazar       Lsl LEDS
Finalizar       Ldd TCNT
                Addd #15000
                Std TC5
		Rti
                
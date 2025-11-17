;*******************************************************************************
;                       MICROPROCESADORES - EXAMEN II
;*******************************************************************************
#include registers.inc
;*******************************************************************************
; Autora: Daniela Fonseca Zumbado
; Version: 1.0
;
;*******************************************************************************
;                 RELOCALIZACION DE VECTORES DE INTERRUPCION
;*******************************************************************************
                ORG $3E4C
             dw PORTH_ISR               ; Subrutina PORTH_ISR
             
                ORG $3E70
             dw RTI_ISR                 ; Subrutina RTI_ISR
             
                ORG $3E60
             dw ECT_ISR                 ; Subrutina ECT_ISR

;*******************************************************************************
;                          DEFINICION DE VALORES
;*******************************************************************************

RTIF:           EQU $80

tTC7H:          EQU 56250
tTC7L:          EQU 7812

tCONT_7:        EQU 12
tCONT_2:        EQU 42

;*******************************************************************************
;                    DECLARACION DE ESTRUCTURAS DE DATOS
;*******************************************************************************

                ORG $1000
Banderas:       ds 1
WFLG1:          EQU $01
WFLG2:          EQU $02

Cont_RTI:       ds 1                ; Contador para interrupciones RTI
             
;*******************************************************************************
;                           PROGRAMA PRINCIPAL
;*******************************************************************************

                ORG $2000
ONDAS:          BClr CLKSEL,$80     ; Apagar PLL

                BSet PIEH,$01       ; Habilitar bit 0 del Puerto H como salida
                BClr PPSH,$01       ; Seleccionar polaridad (flanco decreciente)
                Movb #$FF,DDRB      ; Habilitar Puerto B como salida
                Movb #$00,PORTB     ; Borrar valores de Puerto B
                BSet DDRJ,$02       ; Habilitar Leds
                BClr PTJ,$02
                Movb #$0F,DDRP      ; Deshabilitar display de 7 segmentos
                Movb #$0F,PTP
                
                Movb #$80,TIOS      ; Habilitar canal 7 como salida de OC
                Movb #$90,TSCR1     ; Habilitar timer con borrado automatico
                                    ; de interrupciones por lectura
                Movb #$0F,TSCR2     ; Establecer Prescaler = 128 y borrado
                                    ; automatico de contador
                Movb #$80,TIE       ; Habilitar interrupciones del canal 7
                Movw #tTC7L,TC7     ; Cargar timer de canal 7
                
                Movb #$80,CRGINT    ; Habilitar interrupciones del RTI
                Movb #$63,RTICTL
                
                Lds #$3BFF          ; Mover puntero de pila
                Cli                 ; Habilitar interrupciones
                BClr Banderas,WFLG1
                BClr Banderas,WFLG2
                Movb #tCONT_7,CONT_RTI
                
                Bra *

;*******************************************************************************
;                SUBRUTINA DE ATENCION A INTERRUPCIONES PORTH
;*******************************************************************************

PORTH_ISR:
                Ldd #13000
Decrementar_D   Dbne D,Decrementar_D
                Ldaa Banderas        ; Hacer toggle a WFLG1
                Eora #WFLG1
                Staa Banderas
                BSet PIFH,$01        ; Borrar bandera de interrupcion de PORTH.0
                Rti

;*******************************************************************************
;                 SUBRUTINA DE ATENCION A INTERRUPCIONES RTI
;*******************************************************************************

RTI_ISR:
                Dec Cont_RTI           ; Decrementar contador RTI
                Bne FIN_RTI_ISR        ; Si no ha llegado a cero, salir de interrupcion
                BrSet Banderas,WFLG1,Cargar_CONT7
                Movb #tCONT_2,CONT_RTI
                Bra Toggle_PB0
Cargar_CONT7    Movb #tCONT_7,CONT_RTI
Toggle_PB0      Ldaa PORTB             ; Hacer toggle a PB0
                Eora #$01
                Staa PORTB
FIN_RTI_ISR     BSet CRGFLG,RTIF       ; Borrar bandera de interrupcion RTI
                Rti

;*******************************************************************************
;               SUBRUTINA DE ATENCION A INTERRUPCIONES ECT_ISR
;*******************************************************************************

ECT_ISR:
		Ldd TCNT               ; Borrar bandera de interrupcion del EC7
                BrSet Banderas,WFLG2,PB7_OFF
                BSet PORTB,$80         ; Encender LED PB7
                BSet Banderas,WFLG2
                BrSet Banderas,WFLG1,Cargar_TC7L
                Movw #tTC7H,TC7
                Bra FIN_ECT_ISR
Cargar_TC7L     Movw #tTC7L,TC7
                Bra FIN_ECT_ISR
PB7_OFF         BClr PORTB,$80         ; Apagar LED PB7
                BClr Banderas,WFLG2
                BrSet Banderas,WFLG1,Cargar_TC7H
                Movw #tTC7L,TC7
                Bra FIN_ECT_ISR
Cargar_TC7H     Movw #tTC7H,TC7
FIN_ECT_ISR     Rti
                
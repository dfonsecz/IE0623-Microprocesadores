
 ;******************************************************************************
 ;                          TAREA 5 - PANTALLAS LCD
 ;******************************************************************************
#include registers.inc
 ;******************************************************************************
 ;                 RELOCALIZACION DE VECTOR DE INTERRUPCION
 ;******************************************************************************
                                Org $3E4A
                                dw Maquina_Tiempos
;******************************************************************************
;                   DECLARACION DE LAS ESTRUCTURAS DE DATOS
;******************************************************************************

;--- Aqui se colocan los valores de carga para los timers baseT  ----

tTimer1mS:        EQU 50     ;Base de tiempo de 1 mS (20uS x 50)
tTimer10mS:       EQU 500    ;Base de tiempo de 10 mS (20uS x 500)
tTimer100mS:      EQU 5000   ;Base de tiempo de 100 mS (20uS x 5000)
tTimer1S:         EQU 50000  ;Base de tiempo de 1 segundo (20uS x 50000)

;--- Aqui se colocan los valores de carga para los timers de la aplicacion  ----

tTimer2ms:        EQU 100
tSupRebPB:        EQU 10     ;Tiempo de supresion de rebotes x 1 mS (PB)
tSupRebTCL:       EQU 10     ;Tiempo de supresion de rebotes x 1 mS (Teclado)
tShortP:          EQU 25     ;Tiempo minimo ShortPress x 10 mS
tLongP:           EQU 3      ;Tiempo minimo LongPress en segundos
tTimerLDTst:      EQU 5      ;Tiempo de parpadeo de LED testigo x 100 mS

PortPB:           EQU PTIH   ;Se define el puerto donde se ubica el PB
MaskPB:           EQU $01    ;Se define el bit del PB en el puerto

;=============================== TAREA TECLADO =================================

                  ORG $1000

MAX_TCL:          db $05     ; Limite maximo del tamano de Num_Array
Tecla:            ds 1       ; Variable para guardar la tecla actual
Tecla_IN:         ds 1       ; Variable para guardar la tecla ingresada
Cont_TCL:         ds 1       ; Variable para guardar tamano actual de Num_Array
Patron:           ds 1       ; Variable para guardar patron a escribir y leer
                             ; en el teclado
Funcion:          ds 1       ; Variable para guardar patron a escribir en LEDs
Est_Pres_TCL:     ds 2       ; Variable para direccion de estado de maquina de
                             ; estados Tarea_Teclado

; Arreglo de teclas presionadas
                  ORG $1010
Num_Array:        ds 5       ; Array donde guardar valores ingresados por el
                             ; teclado
                             
;============================ TAREA PANTALLA MUX ===============================

                          ORG $1020
EstPres_PantallaMUX:    ds 2 ; Variable para guardar estado de tarea de pantalla
                             ; multiplexada
Dsp1:             ds 1
Dsp2:             ds 1
Dsp3:             ds 1
Dsp4:             ds 1
LEDS:             ds 1
Cont_Dig:         ds 1
Brillo:           ds 1
BIN1:             ds 1
BIN2:             ds 1
BCD:              ds 1
Cont_BCD:         ds 1
BCD1:             ds 1
BCD2:             ds 1

; Valores
MaxCountTicks     EQU 5
DIG1              EQU $01
DIG2              EQU $02
DIG3              EQU $04
DIG4              EQU $08

;================================== TAREA LCD ==================================

                  ORG $102F
IniDsp:           ds 5
Punt_LCD:         ds 2
CharLCD:          ds 1
Msg_L1:           ds 2
Msg_L2:           ds 2
EstPres_SendLCD:  ds 2       ; Variable para guardar estado de Tarea Send LCD
EstPres_TareaLCD: ds 2       ; Variable para guardar estado de Tarea LCD

;================================ TAREA LEER PB1 ===============================

                  ORG $103F
EstPres_LeerPB1:  ds 2       ; Variable para guardar estado de Leer PB 1

;================================== TAREA TCM ==================================

                  ORG $1041
EstPres_TCM:      ds 2       ; Variable para guardar el estado de Tarea TCM
MinutosTCM:       ds 1

;=================================== BANDERAS ==================================

                  ORG $1070
Banderas_1:       ds 1
ShortP0:          EQU $01
LongP0:           EQU $02
ShortP1:          EQU $04
LongP1:           EQU $08
ArrayOK:          EQU $10

Banderas_2:       ds 1
RS:               EQU $01
LCD_OK:           EQU $02
FinSendLCD:       EQU $04
Second_Line:      EQU $08

LD_Red:           EQU $10
LD_Green:         EQU $20
LD_Blue:          EQU $40

;============================== TAREA LED TESTIGO ==============================

                  ORG $1080
EstPres_LDTst     ds 1

;================================== GENERALES ==================================

;==================================== TABLAS ===================================

                  ORG $1100
Segment:

; Codigos de Teclas validas
                  ORG $1110
Teclas:           db $01,$02,$03
                  db $04,$05,$06
                  db $07,$08,$09
                  db $0B,$00,$0E
                  
;================================== MENSAJES ===================================

MSG1_P1:
MSG1_P2:
MSG2_P1:
MSG2_P2:
                                
;===============================================================================
;                              TABLA DE TIMERS
;===============================================================================
                  ORG $1500
Tabla_Timers_BaseT:

Timer1mS:       ds 2       ;Timer 1 ms con base a tiempo de interrupcion
Timer10mS:      ds 2       ;Timer para generar la base de tiempo 10 mS
Timer100mS:     ds 2       ;Timer para generar la base de tiempo de 100 mS
Timer1S:        ds 2       ;Timer para generar la base de tiempo de 1 Seg.
CounterTicks:   ds 2

Fin_BaseT       dW $FFFF

Tabla_Timers_Base1mS

Timer_RebPB:    ds 1
Timer_RebTCL:   ds 1
Timer_Digito:   ds 1
Timer2mS:       ds 1

Fin_Base1mS:    dB $FF

Tabla_Timers_Base10mS

Timer_SHP:      ds 1

Fin_Base10ms:   dB $FF

Tabla_Timers_Base100mS

Timer1_100mS:   ds 1

TimerLDTst:      ds 1
Fin_Base100mS:  dB $FF

Tabla_Timers_Base1S

Timer_LP:        ds 1

Fin_Base1S:      dB $FF

;===============================================================================
;                              CONFIGURACION DE HARDWARE
;===============================================================================
                              Org $2000

        BSet DDRB,$FF     ;Habilitacion de los LEDs
        BSet DDRJ,$02     ;como comprobacion del timer de 1 segundo
        BClr PTJ,$02      ;haciendo toogle

        BSet DDRP,$7F
        BClr PTP,$0F
        
        BClr MCCTL,#$04   ; Borrar enable
        Movb #$E3,MCCTL   ; Habilitar interrupciones module count down con
                          ; divisor 16
        BSet MCCTL,#$04   ; Poner el enable
        Movw #30,MCCNT    ; Cargar valor inicial de contador
        
        Movb #$F0,DDRA
        BSet PUCR,$01
        
;===============================================================================
;                           PROGRAMA PRINCIPAL
;===============================================================================

        Movw #tTimer1mS,Timer1mS
        Movw #tTimer10mS,Timer10mS         ;Inicia los timers de bases de tiempo
        Movw #tTimer100mS,Timer100mS
        Movw #tTimer1S,Timer1S
        
        Movb #tTimerLDTst,TimerLDTst  ;inicia timer parpadeo led testigo
        Movb #0,Timer_LP
        
        Movw #LeerPB_Est1,EstPres_LeerPB1
        Movw #Teclado_Est1,Est_Pres_TCL
        
        Movb #$FF,Tecla
        Movb #$FF,Tecla_IN
        Movb #$00,Cont_TCL
        Movb #$FF,Num_Array
        
        Movb #$00,Patron
        Movb #$FF,Funcion
        
        Lds #$3BFF
        Cli
        Clr Banderas_1

        
;===============================================================================
;                          DESPACHADOR DE TAREAS
;===============================================================================

Despachador_Tareas

        Jsr Decre_TablaTimers
        Jsr Tarea_Led_Testigo
        ;Jsr Tarea_LeerPB
        ;Jsr Tarea_Teclado
        Jsr Tarea_Leds
        Bra Despachador_Tareas
       
;******************************************************************************
;                               TAREA LED TESTIGO
;******************************************************************************

Tarea_Led_Testigo
                Ldx EstPres_LDTst
                Jsr 0,X
FinLedTest      Rts

;========================= TAREA LED TESTIGO ESTADO 1 ==========================

TareaLDTst_Est1
                Tst TimerLDTst
                Bne FIN_LDTst_1
                BSet PTP,LD_Red
                BClr PTP,LD_Green
                BClr PTP,LD_Blue
                Movw #TareaLDTst_Est2,EstPres_LDTst
                Movb #tTimerLDTst,TimerLDTst
FIN_LDTst_1     Rts

;========================= TAREA LED TESTIGO ESTADO 2 ==========================

TareaLDTst_Est2
                Tst TimerLDTst
                Bne FIN_LDTst_2
                BClr PTP,LD_Red
                BSet PTP,LD_Green
                BClr PTP,LD_Blue
                Movw #TareaLDTst_Est3,EstPres_LDTst
                Movb #tTimerLDTst,TimerLDTst
FIN_LDTst_2     Rts

;========================= TAREA LED TESTIGO ESTADO 3 ==========================

TareaLDTst_Est3
                Tst TimerLDTst
                Bne FIN_LDTst_3
                BClr PTP,LD_Red
                BClr PTP,LD_Green
                BSet PTP,LD_Blue
                Movw #TareaLDTst_Est1,EstPres_LDTst
                Movb #tTimerLDTst,TimerLDTst
FIN_LDTst_3     Rts

;******************************************************************************
;                                  TAREA LEDS
;******************************************************************************

Tarea_Leds
                BrSet Banderas_1,ShortP0,ON     ; ShortPress enciende PH6
                BrSet Banderas_1,LongP0,OFF
                Bra Function_Leds
ON              BClr Banderas_1,ShortP0         ; Borra banderas asociadas
                BSet PORTB,$40                  ; Encender PB6
                Bra FIN_Tarea_Leds
OFF             BClr Banderas_1,LongP0          ; Borra banderas asociadas
                BClr PORTB,$40                  ; Apagar PB6
                Jsr Borrar_Num_Array
                Bra FIN_Tarea_Leds
Function_Leds   BClr PORTB,$0F                  ; Apaga leds de la parte baja
                BrClr Funcion,$10,Led_0         ; Si Funcion = 00010000, PB0 ON
                BrClr Funcion,$20,Led_1         ; Si Funcion = 00100000, PB1 ON
                BrClr Funcion,$40,Led_2         ; Si Funcion = 01000000, PB2 ON
                BrClr Funcion,$80,Led_3         ; Si Funcion = 10000000, PB3 ON
                Bra FIN_Tarea_Leds
Led_0           BSet PORTB,$01                  ; Encender PB0
                Bra FIN_Tarea_Leds
Led_1           BSet PORTB,$02                  ; Encender PB1
                Bra FIN_Tarea_Leds
Led_2           BSet PORTB,$04                  ; Encender PB2
                Bra FIN_Tarea_Leds
Led_3           BSet PORTB,$08                  ; Encender PB3
                Bra FIN_Tarea_Leds
FIN_Tarea_Leds  Rts

;******************************************************************************
;                               TAREA LEER PB
;******************************************************************************

Tarea_LeerPB
                Ldx EstPres_LeerPB1
                Jsr 0,X
FinTareaPB      Rts

;============================= LEER PB ESTADO 1 ================================

LeerPB_Est1
                BrSet PortPB,MaskPB,FIN_Est1      ; Si el boton es presionado
No_FIN_Est1     Movb #tSupRebPB,Timer_RebPB       ; Cargar timers
                Movb #tShortP,Timer_SHP
                Movb #tLongP,Timer_LP
                Movw #LeerPB_Est2,EstPres_LeerPB1 ; Continuar a estado 2
FIN_Est1        Rts

;============================= LEER PB ESTADO 2 ================================

LeerPB_Est2
                Tst Timer_RebPB                   ; Si se agota el timer
                Bne FIN_Est2                      ; verificar si aun sigue pre-
                BrSet PortPB,MaskPB,Ret_Est1_1    ; sionado el boton
                Movw #LeerPB_Est3,EstPres_LeerPB1
                Bra FIN_Est2
Ret_Est1_1      Movw #LeerPB_Est1,EstPres_LeerPB1; Sino regresar a estado 1
FIN_Est2        Rts

;============================= LEER PB ESTADO 3 ================================

LeerPB_Est3
                Tst Timer_SHP                     ; Verificar si el timer short
                Bne FIN_Est3                      ; press se agoto
                BrSet PortPB,MaskPB,Ret_Est1_2    ; Si se presiona el boton
                Movw #LeerPB_Est4,EstPres_LeerPB1 ; Sino, pasar a estado 4
                Bra FIN_Est3
Ret_Est1_2      BSet Banderas_1,ShortP0           ; Levantar bandera ShortP y
                Movw #LeerPB_Est1,EstPres_LeerPB1 ; regresar a estado 1
FIN_Est3        Rts

;============================= LEER PB ESTADO 4 ================================

LeerPB_Est4     Tst Timer_LP                      ; Si no se agota el timer long
                Bne TestPB                        ; press, y se presiona el boton
                BrClr PortPB,MaskPB,FIN_Est4      ; es un short press
                BSet Banderas_1,LongP0
Ret_Est1_3      Movw #LeerPB_Est1,EstPres_LeerPB1 ; sino es un long press
                Bra FIN_Est4
TestPB          BrClr PortPB,MaskPB,FIN_Est4
                BSet Banderas_1,ShortP0
                Bra Ret_Est1_3
FIN_Est4        Rts

;******************************************************************************
;                             TAREA PANTALLA MUX
;******************************************************************************

Tarea_PantallaMUX
                Ldx #PantallaMUX_Est1
                Jsr 0,X
                Rts
                
;=========================== PANTALLA MUX ESTADO 1 =============================

PantallaMUX_Est1:
                Tst Timer_Digito
                Beq FIN_PantMUX_1
                Ldaa Cont_Dig
                Cmpa #$01
                Bne GoTo_Disp2
                BClr PTP,$01
                Movb #DSP1,PORTB
                Bra Dec_Cont_Dig
GoTo_Disp2      Cmpa #$02
                Bne GoTo_Disp3
                BClr PTP,$02
                Movb #DSP2,PORTB
                Bra Dec_Cont_Dig
GoTo_Disp3      Cmpa #$03
                Bne GoTo_Disp4
                BClr PTP,$03
                Movb #DSP3,PORTB
                Bra Dec_Cont_Dig
GoTo_Disp4      Cmpa #$03
                Bne FIN_PantMUX_1
                BClr PTP,$04
                Movb #DSP4,PORTB
Dec_Cont_Dig    Dec Cont_Dig
FIN_PantMUX_1   Movb #MaxCountTicks,CounterTicks
                Movw #PantallaMUX_Est2,EstPres_PantallaMUX
                Rts
                
;=========================== PANTALLA MUX ESTADO 2 =============================

PantallaMUX_Est2:
                Ldaa CounterTicks
                Cmpa Brillo
                Bne FIN_PantMUX_2
                BSet PTP,$0F
                BSet PTJ,$02
                ;Movw #PantallaMUX_Est3,EstPres_PantallaMUX
FIN_PantMUX_2   Rts

;******************************************************************************
;                                  SEND LCD
;******************************************************************************

SendLCD:
                Ldx #SendLCD_Est1
                
;============================= SEND LCD ESTADO 1 ===============================

SendLCD_Est1:
                Ldaa CharLCD
                Anda $F0
                Lsr CharLCD
                Lsr CharLCD
                Staa PORTK

;============================= SEND LCD ESTADO 2 ===============================

SendLCD_Est2:

;============================= SEND LCD ESTADO 3 ===============================

SendLCD_Est3:

;============================= SEND LCD ESTADO 4 ===============================

SendLCD_Est4:
                

;******************************************************************************
;                               TAREA TECLADO
;******************************************************************************

Tarea_Teclado   Ldx Est_Pres_TCL
                Jsr 0,X
                Rts

;============================= TECLADO ESTADO 1 ================================

Teclado_Est1    Jsr Leer_Teclado                  ; Si se presiona alguna tecla
                Ldaa Tecla
                Cmpa #$FF
                Beq FIN_Tecl_Est1
                Movb #tSupRebTCL,Timer_RebTCL     ; carga timer de supresion de
                Movw #Teclado_Est2,Est_Pres_TCL   ; rebotes y siguiente estado
FIN_Tecl_Est1   Rts
                
;============================= TECLADO ESTADO 2 ================================

Teclado_Est2    Tst Timer_RebTCL                  ; Si no se agota el timer,
                Bne FIN_Tecl_Est2                 ; verifica si Tecla = Tecla_IN
                Movb Tecla,Tecla_IN
                Jsr Leer_Teclado
                Ldaa Tecla_IN
                Cmpa Tecla
                Bne Regr_Tecl_Est1
                Movw #Teclado_Est3,Est_Pres_TCL   ; Si son iguales pasa a est 3
                Bra FIN_Tecl_Est2
Regr_Tecl_Est1  Movw #Teclado_Est1,Est_Pres_TCL   ; Sino se devuelve al 1
FIN_Tecl_Est2   Rts
;============================= TECLADO ESTADO 3 ================================

Teclado_Est3    Jsr Leer_Teclado
                Ldaa Tecla
                Cmpa #$FF
                Bne FIN_Tecl_Est3
                Ldaa Tecla_IN                     ; Si la tecla ingresada es de
                Cmpa #15                          ; funcion, la guarda se
                Bhi Guardar_Funcion
                Movw #Teclado_Est4,Est_Pres_TCL   ; devuelve al estado 1
                Bra FIN_Tecl_Est3
Guardar_Funcion Movb Tecla_IN,Funcion             ; sino pasa al estado 4
                Movw #Teclado_Est1,Est_Pres_TCL
FIN_Tecl_Est3   Rts

;============================= TECLADO ESTADO 4 ================================

Teclado_Est4    Ldaa Tecla_IN
                Ldab Cont_TCL
                Ldx #Num_Array
                Cmpb Max_TCL                    ; Si alcanzo el maximo de cifras
                Beq Es_Borrar
                Tstb                            ; Es la primera tecla?
                Beq Primera_Tecla
                Cmpa #$0B                       ; Es la tecla Borrar ($0B)?
                Bne Es_Enter2
                Tst Cont_TCL                    ; El offset llego a 0?
                Bne Borrar_Tecl
                Bra FIN_Tecl_Est4
Es_Borrar       Cmpa #$0B                       ; Es la tecla Borrar ($0B)?
                Bne Es_Enter
Borrar_Tecl     Dec Cont_TCL                    ; Borrar la tecla de Num_Array
                Ldab Cont_TCL
                Movb #$FF,B,X
                Bra FIN_Tecl_Est4
Es_Enter        Cmpa #$0E                       ; Es la tecla Enter ($0E)?
                Bne FIN_Tecl_Est4
Fin_Num_Arr     Movb #0,Cont_TCL                ; Resetear offset
                Movw #Teclado_Est1,Est_Pres_TCL
                BSet Banderas_1,ArrayOK         ; Indicar que Num_Array esta listo
                Bra FIN_Tecl_Est4
Primera_Tecla   Cmpa #$0B                       ; Es la tecla Borrar ($0B)?
                Beq FIN_Tecl_Est4
                Cmpa #$0E                       ; Es la tecla Enter ($0E)?
                Beq FIN_Tecl_Est4
                Bra Agregar_Tecl
Es_Enter2       Cmpa #$0E
                Beq Fin_Num_Arr
Agregar_Tecl    Movb Tecla_IN,B,X               ; Guardar la tecla ingresada
                Inc Cont_TCL                    ; en Num_Array
FIN_Tecl_Est4   Movb #$FF,Tecla_IN              ; Limpiar valor Tecla_IN
                Movw #Teclado_Est1,Est_Pres_TCL ; Regresar a estado 1
                Rts

;******************************************************************************
;                          SUBRUTINA LEER TECLADO
;******************************************************************************

Leer_Teclado    Clra
                Movb #$EF,Patron                ; Patron 11101111 para puerto A
                Ldx #Teclas                     ; Direccion de tabla Teclas
Cont_Lectura    Movb Patron,PORTA               ; Escribir Patron en puerto A
                BrClr PORTA,$01,Obt_Tecla       ; Si el bit 0 de PORTA es 0,
                Inca                            ; el btn esta en la 1er columna
                BrClr PORTA,$02,Obt_Tecla       ; Si el bit 1 de PORTA es 0,
                Inca                            ; el btn esta en la 2da columna
                BrClr PORTA,$04,Obt_Tecla       ; Si el bit 2 de PORTA es 0,
                Inca                            ; el btn esta en la 2da columna
                BrClr PORTA,$08,Escribir_Patron
                Ldab Patron
                Cmpb #$78                       ; Si Patron llega a 01111000,
                Beq Clr_Tecla                   ; no se presiono ninguna tecla
                Lsl Patron                      ; Desplazar a la izquierda
                Bra Cont_Lectura
Clr_Tecla       Movb #$FF,Tecla                 ; Limpiar valor de Tecla
                Bra FIN_Leer_Tecl
Obt_Tecla       Movb A,X,Tecla                  ; Cargar valor de Tecla de tabla
                Bra FIN_Leer_Tecl
Borrar_Tecl_2   Movb #$FF,Tecla                 ; Limpiar valor de Tecla
                Bra FIN_Leer_Tecl
Escribir_Patron BSet Patron,$0F                 ; Patron.3:Patron.0 = $F
                Movb Patron,Tecla               ; Pasar Patron a Tecla
FIN_Leer_Tecl   Rts

;******************************************************************************
;                        SUBRUTINA BORRAR NUM ARRAY
;******************************************************************************

Borrar_Num_Array
                Ldx #Num_Array
                Clra
Ciclo_BNA       Movb #$FF,1,X+                  ; Limpiar posicion de memoria
                Inca                            ; actual en Num_Array con $FF
                Cmpa MAX_TCL                    ; Si llega al maximo de elementos
                Bne Ciclo_BNA                   ; salir
                Rts

;******************************************************************************
;                       SUBRUTINA DECRE_TABLATIMERS
;******************************************************************************

Decre_TablaTimers:
                Ldd Timer1mS
                Bne Timer_10mS
                Movw #tTimer1mS,Timer1mS
                Ldx #Tabla_Timers_Base1mS
                Jsr Decre_Timers
Timer_10mS      Ldd Timer10mS
                Bne Timer_100mS
                Movw #tTimer10mS,Timer10mS
                Ldx #Tabla_Timers_Base10mS
                Jsr Decre_Timers
Timer_100mS     Ldd Timer100mS
                Bne Timer_1S
                Movw #tTimer100mS,Timer100mS
                Ldx #Tabla_Timers_Base100mS
                Jsr Decre_Timers
Timer_1S        Ldd Timer1S
                Bne Rt_Decre_Timers
                Movw #tTimer1S,Timer1S
                Ldx #Tabla_Timers_Base1S
                Jsr Decre_Timers
Rt_Decre_Table  Rts

Decre_Timers:
                Ldaa 0,X
                Beq Inc_X_Index
                Cmpa #$FF
                Beq Rt_Decre_Timers
                Dec 0,X
Inc_X_Index     Inx
                Bra Decre_Timers
Rt_Decre_Timers Rts

;******************************************************************************
;                       SUBRUTINA DE ATENCION A RTI
;******************************************************************************

Maquina_Tiempos:
               Ldx #Tabla_Timers_BaseT
               Jsr Decre_Timers_BaseT
               BSet MCFLG,$80
               Rti

Decre_Timers_BaseT:
               Ldy 2,X+
               Cpy #0
               Beq Decre_Timers_BaseT
               Cpy #$FFFF
               Beq Rt_Decre_BaseT
               Dey
               Sty -2,X
               Bra Decre_Timers_BaseT
Rt_Decre_BaseT Rts
               
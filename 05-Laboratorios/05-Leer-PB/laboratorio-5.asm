 ;******************************************************************************
 ;                              MAQUINA DE TIEMPOS
 ;                                     (RTI)
 ;******************************************************************************
#include registers.inc
 ;******************************************************************************
 ;                 RELOCALIZACION DE VECTOR DE INTERRUPCION
 ;******************************************************************************
                                Org $3E70
                                dw Maquina_Tiempos
;******************************************************************************
;                       DECLARACION DE LAS ESTRUCTURAS DE DATOS
;******************************************************************************

;--- Aqui se colocan los valores de carga para los timers baseT  ----

tTimer1mS:        EQU 2     ;Base de tiempo de 1 mS (0.5 ms x 2)
tTimer10mS:       EQU 20    ;Base de tiempo de 10 mS (0.5 mS x 20)
tTimer100mS:      EQU 200    ;Base de tiempo de 100 mS (0.5 mS x 200)
tTimer1S:         EQU 2000    ;Base de tiempo de 1 segundo (0.5 mS x 2000)

;--- Aqui se colocan los valores de carga para los timers de la aplicacion  ----

tSupRebPB:        EQU 10     ;Tiempo de supresion de rebotes x 1 mS
tShortP:          EQU 25     ;Tiempo minimo ShortPress x 10 mS
tLongP:           EQU 5      ;Tiempo minimo LongPress en segundos
tTimerLDTst:      EQU 1      ;Tiempo de parpadeo de LED testigo en segundos

PortPB:           EQU PTIH   ;Se define el puerto donde se ubica el PB
MaskPB:           EQU $01    ;Se define el bit del PB en el puerto

                                Org $1000

;Aqui se colocan las estructuras de datos de la aplicacion

Est_Pres_LeerPB:  ds 2
Banderas_PB:      ds 1

ShortP:           EQU $01
LongP:            EQU $02
                                
;===============================================================================
;                              TABLA DE TIMERS
;===============================================================================
                                Org $1040
Tabla_Timers_BaseT:

Timer1mS        ds 2       ;Timer 1 ms con base a tiempo de interrupcion
Timer10mS:      ds 2       ;Timer para generar la base de tiempo 10 mS
Timer100mS:     ds 2       ;Timer para generar la base de tiempo de 100 mS
Timer1S:        ds 2       ;Timer para generar la base de tiempo de 1 Seg.

Fin_BaseT       dW $FFFF

Tabla_Timers_Base1mS

Timer_RebPB:    ds 1

Fin_Base1mS:    dB $FF

Tabla_Timers_Base10mS

Timer_SHP:      ds 1

Fin_Base10ms:   dB $FF

Tabla_Timers_Base100mS

Timer1_100mS:   ds 1

Fin_Base100mS:  dB $FF

Tabla_Timers_Base1S

Timer_LP:               ds 1
Timer_LED_Testigo:      ds 1

Fin_Base1S:       dB $FF

;===============================================================================
;                              CONFIGURACION DE HARDWARE
;===============================================================================
                              Org $2000

        BSet DDRB,$81     ;Habilitacion del LED Testigo
        BSet DDRJ,$02     ;como comprobacion del timer de 1 segundo
        BClr PTJ,$02      ;haciendo toogle
        
        Movb #$0F,DDRP    ;bloquea los display de 7 Segmentos
        Movb #$0F,PTP
        
        Movb #$13,RTICTL   ;Se configura RTI con un periodo de 0.5 mS
        Bset CRGINT,$80
;===============================================================================
;                           PROGRAMA PRINCIPAL
;===============================================================================
        Movw #tTimer1mS,Timer1mS
        Movw #tTimer10mS,Timer10mS         ;Inicia los timers de bases de tiempo
        Movw #tTimer100mS,Timer100mS
        Movw #tTimer1S,Timer1S
        
        Movb #tTimerLDTst,Timer_LED_Testigo  ;inicia timer parpadeo led testigo
        Movb #0,Timer_LP
        
        Lds #$3BFF
        Cli
        Clr Banderas_PB
        Movw #LeerPB_Est1,Est_Pres_LeerPB
        
;===============================================================================
;                          DESPACHADOR DE TAREAS
;===============================================================================

Despachador_Tareas

        Jsr Tarea_Led_Testigo
        Jsr Tarea_Led_PB
        Jsr Tarea_LeerPB
        Jsr Decre_TablaTimers
        Bra Despachador_Tareas
        
;******************************************************************************
;                                  TAREA LED PB
;******************************************************************************

Tarea_LED_PB
                BrSet Banderas_PB,ShortP,ON ;Si se presiona ShortP enciende LED
                BrSet Banderas_PB,LongP,OFF ;Si se presiona LongP apaga LED
                Bra FIN_Led
ON              BClr Banderas_PB,ShortP     ;Borra las banderas asociadas y
                BSet PORTB,$01              ;ejecuta la accion
                Bra FIN_Led
OFF             BClr Banderas_PB,LongP
                BClr PORTB,$01
FIN_Led         Rts
       
;******************************************************************************
;                               TAREA LED TESTIGO
;******************************************************************************

Tarea_Led_Testigo
                Tst Timer_LED_Testigo
                Bne FinLedTest
                Movb #tTimerLDTst,Timer_LED_Testigo
                Ldaa PORTB
                Eora #$80
                Staa PORTB
FinLedTest      Rts

;******************************************************************************
;                               TAREA LEER PB
;******************************************************************************

Tarea_LeerPB
                Ldx Est_Pres_LeerPB
                Jsr 0,X
FinTareaPB      Rts

;============================= LEER PB ESTADO 1 ================================

LeerPB_Est1
                BrSet PortPB,MaskPB,FIN_Est1
No_FIN_Est1     Movb #tSupRebPB,Timer_RebPB
                Movb #tShortP,Timer_SHP
                Movb #tLongP,Timer_LP
                Movw #LeerPB_Est2,Est_Pres_LeerPB
FIN_Est1        Rts

;============================= LEER PB ESTADO 2 ================================

LeerPB_Est2
                Tst Timer_RebPB
                Bne FIN_Est2
                BrSet PortPB,MaskPB,Ret_Est1_1
                Movw #LeerPB_Est3,Est_Pres_LeerPB
                Bra FIN_Est2
Ret_Est1_1      Movw #LeerPB_Est1,Est_Pres_LeerPB
FIN_Est2        Rts

;============================= LEER PB ESTADO 3 ================================

LeerPB_Est3
                Tst Timer_SHP
                Bne FIN_Est3
                BrSet PortPB,MaskPB,Ret_Est1_2
                Movw #LeerPB_Est4,Est_Pres_LeerPB
                Bra FIN_Est3
Ret_Est1_2      BSet Banderas_PB,ShortP
                Movw #LeerPB_Est1,Est_Pres_LeerPB
FIN_Est3        Rts

;============================= LEER PB ESTADO 4 ================================

LeerPB_Est4     Tst Timer_LP
                Bne TestPB
                BrClr PortPB,MaskPB,FIN_Est4
                BSet Banderas_PB,LongP
Ret_Est1_3      Movw #LeerPB_Est1,Est_Pres_LeerPB
                Bra FIN_Est4
TestPB          BrClr PortPB,MaskPB,FIN_Est4
                BSet Banderas_PB,ShortP
                Bra Ret_Est1_3
FIN_Est4        Rts

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
               BSet CRGFLG,$80
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
               
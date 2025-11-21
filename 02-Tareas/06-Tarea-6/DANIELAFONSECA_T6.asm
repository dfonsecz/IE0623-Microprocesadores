;******************************************************************************
;                       TAREA 6 - Control ON/OFF Nivel
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

tTimer40uS:       EQU 2      ; Tiempo de timer de 40 uS (20uS x 2)
tTimer260uS:      EQU 13     ; Tiempo de timer de 260 uS (20uS x 13)
tTimer2ms:        EQU 100    ; Tiempo de timer de 2 mS (20uS x 100)
tSupRebTCL:       EQU 10     ; Tiempo de supresion de rebotes x 1 mS (Teclado)
tShortP:          EQU 25     ; Tiempo minimo ShortPress x 10 mS
tLongP:           EQU 3      ; Tiempo minimo LongPress en segundos
tTimerLDTst:      EQU 5      ; Tiempo de parpadeo de LED testigo x 100 mS
tTimerDigito:     EQU 2
tTimerATD:        EQU 5
tTimerTerminal:   EQU 1

PortPB:           EQU PTIH   ; Se define el puerto donde se ubica el PB
MaskPB0:          EQU $01    ; Se define el bit 0 del PB en el puerto
MaskPB1:          EQU $08    ; Se define el bit 3 del PB en el puerto

;================================== TAREA LCD ==================================

                  ORG $102F  ; Comandos
IniDsp:           db $28     ; Function Set
                  db $28     ; Function Set
                  db $06     ; Entry Mode Set
                  db $0C     ; Display ON/OFF - (D) = 1, (C) = 0, (B) = 0
                  db $FF     ; Fin de trama
Punt_LCD:         ds 2
CharLCD:          ds 1
Msg_L1:           ds 2
Msg_L2:           ds 2
EstPres_SendLCD:  ds 2       ; Variable para guardar estado de Tarea Send LCD
EstPres_TareaLCD: ds 2       ; Variable para guardar estado de Tarea LCD

; Comandos
Clear_Display:    EQU $01

; Direcciones de las lineas del LCD
ADD_L1:           EQU $80
ADD_L2:           EQU $C0


;================================== TAREA ATD ==================================

                  ORG $103F
EstPres_ATD:      ds 2       ; Variable para guardar estado de Tarea ATD

;================================ TAREA TERMINAL ===============================

                  ORG $1041
EstPres_Terminal: ds 2       ; Variable para guardar el estado de Tarea Terminal

Nivel:            ds 1
NivelProm:        ds 1
Volumen:          ds 1
Puntero_Msg:      ds 2
Cont_Seg:         ds 1

;=================================== BANDERAS ==================================

                  ORG $1070
Banderas_1:       ds 1
MostrarAlarma:    EQU $01
Vaciar:           EQU $02

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
EstPres_LDTst     ds 2

;================================== GENERALES ==================================

InicioLD:         EQU $55
TemporalLD:       EQU $AA

;==================================== TABLAS ===================================

                  ORG $1100
Segment:          db $3F                ; "0"
                  db $06                ; "1"
                  db $5B                ; "2"
                  db $4F                ; "3"
                  db $66                ; "4"
                  db $6D                ; "5"
                  db $7D                ; "6"
                  db $07                ; "7"
                  db $7F                ; "8"
                  db $6F                ; "9"

;================================== MENSAJES ===================================

CR:               EQU $0D
LF:               EQU $0A

Msg_Operacion:    db CR,CR,LF
		  fcc "                           "
		  fcc "UNIVERSIDAD DE COSTA RICA"
                  db CR,CR,LF
                  fcc "                        "
                  fcc "ESCUELA DE INGENIERIA ELECTRICA"
                  db CR,CR,LF
                  fcc "                               "
                  fcc "MICROPROCESADORES"
                  db CR,CR,LF
                  fcc "                                    "
                  fcc "IE0623"
                  db CR,CR,LF
                  db CR,CR,LF
                  fcc "              "
                  fcc "VOLUMEN CALCULADO: "
                  db CR,CR,LF
                  db $FF
Msg_Alarma:       db CR,CR,LF
                  db CR,CR,LF
		  fcc "Alarma: El Nivel esta Bajo"
                  db $FF
Msg_Vaciado:      db CR,CR,LF
                  db CR,CR,LF
		  fcc "Vaciando Tanque, Bomba Apagada"
                  db $FF
Msg_En_Blanco:    fcc " "
                  db $FF

;===============================================================================
;                              TABLA DE TIMERS
;===============================================================================
                  ORG $1500
Tabla_Timers_BaseT:

Timer1mS:       ds 2       ;Timer 1 ms con base a tiempo de interrupcion
Timer10mS:      ds 2       ;Timer para generar la base de tiempo 10 mS
Timer100mS:     ds 2       ;Timer para generar la base de tiempo de 100 mS
Timer1S:        ds 2       ;Timer para generar la base de tiempo de 1 Seg.
Timer40uS:      ds 2
Timer260uS:     ds 2
CounterTicks:   ds 2

Fin_BaseT       dW $FFFF

Tabla_Timers_Base1mS

Timer_Digito:   ds 1
Timer2mS:       ds 1

Fin_Base1mS:    dB $FF

Tabla_Timers_Base10mS

Fin_Base10ms:   dB $FF

Tabla_Timers_Base100mS

TimerLDTst:     ds 1
TimerATD:       ds 1       ; Timer para la Tarea_ATD

Fin_Base100mS:  dB $FF

Tabla_Timers_Base1S

TimerTerminal:  ds 1       ; Timer de refrescamiento de terminal

Fin_Base1S:     dB $FF

;===============================================================================
;                              CONFIGURACION DE HARDWARE
;===============================================================================
                              Org $2000

        BSet DDRB,$FF     ;Habilitacion de los LEDs
        BSet DDRJ,$02     ;como comprobacion del timer de 1 segundo
        BSet PTJ,$02      ;haciendo toogle

        BSet DDRP,$7F
        BSet PTP,$0F      ; Apaga display

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
        Movb #tTimerTerminal,TimerTerminal

        ; Inicializacion de estados de maquinas de estado
        Movw #TareaLDTst_Est1,EstPres_LDTst
        Movw #TareaLCD_Est1,EstPres_TareaLCD
        Movw #TareaSendLCD_Est1,EstPres_SendLCD
        Movw #TareaATD_Est1,EstPres_ATD
        Movw #Terminal_Est1,EstPres_Terminal
        
        ; Inicializacion de ATD
        Movb #$C0,ATD0CTL2
        Ldaa #160
InitATD Dbne A,InitATD
        Movb #$20,ATD0CTL3
        Movb #$10,ATD0CTL4
        
        ; Inicializacion de SCI
        Movw #39,SC1BDH
        Movb #$00,SC1CR1
        Movb #$08,SC1CR2
        Ldaa SC1SR1                     ; Dummy read
        Movb #$00,SC1DRL

        ; Inicializacion de Pantalla LCD (timers)
        Movw #tTimer260uS,Timer260uS
        Movw #tTimer40uS,Timer40uS
        
        ; Terminal
        Movw #Msg_Operacion,Puntero_Msg
        Clr Cont_Seg

        ; Pantalla LCD
        Clr Banderas_1

        Lds #$3BFF
        Cli
        Clr Banderas_1
        
        Ldaa SC1SR1
        Movb #$0C,SC1DRL

        Jsr Init_LCD
        Bra Despachador_Tareas

;******************************************************************************
;                              INICIALICION LCD
;******************************************************************************

Init_LCD        ; Inicializacion de Pantalla LCD (otros)
                ;Movw #MSG1_P1,Msg_L1
                ;Movw #MSG1_P2,Msg_L2
                Movb #$FF,DDRK                    ; Inicializar como salida
                Movw #IniDsp,Punt_LCD             ; Cargar direccion de comandos
                BClr Banderas_2,RS                ; Inicializar banderas en 0
                BClr Banderas_2,Second_Line
                BClr Banderas_2,LCD_OK
                Ldx Punt_LCD                      ; Cargar direccion de tabla
Init_LCD_Loop   Movb 1,X+,CharLCD                 ; Pasar dato de IniDsp a CharLCD
                Ldaa CharLCD                      ; Cargar dato desde CharLCD
                Cmpa #$FF                         ; Llego a End of Block (EOB)?
                Bne Call_SendLCD_2
                Movb #Clear_Display,CharLCD       ; Cargar en CharLCD cmd Clear
Call_SendLCD_1  Jsr SendLCD                       ; Enviar cmd Clear
                BrClr Banderas_2,FinSendLCD,Call_SendLCD_1
                Bra FIN_Init_LCD
Call_SendLCD_2  Jsr SendLCD                       ; Si no, enviar dato
                BrClr Banderas_2,FinSendLCD,Call_SendLCD_2
                BClr Banderas_2,FinSendLCD        ; Apagar bandera FinSendLCD
                Bra Init_LCD_Loop                 ; Cargar siguiente dato
FIN_Init_LCD    Movb tTimer2mS,Timer2mS
Timer2mS_Reach0 Jsr Decre_TablaTimers             ; Decrementar timers
                Tst Timer2mS
                Bne Timer2mS_Reach0
                Rts

;===============================================================================
;                          DESPACHADOR DE TAREAS
;===============================================================================

Despachador_Tareas
                BrSet Banderas_2,LCD_OK,NoNewMsg
                ;Jsr Tarea_LCD
NoNewMsg        Jsr Decre_TablaTimers
                Jsr Tarea_Led_Testigo
                Jsr Tarea_ATD
                Jsr Tarea_Terminal
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
                Tst TimerLDTst                    ; Si el timer no se ha acabado
                Bne FIN_LDTst_1                   ; se mantiene en este estado
                BSet PTP,LD_Red                   ; Encender color rojo y apagar
                BClr PTP,LD_Green                 ; el resto
                BClr PTP,LD_Blue
                Movw #TareaLDTst_Est2,EstPres_LDTst
                Movb #tTimerLDTst,TimerLDTst
FIN_LDTst_1     Rts

;========================= TAREA LED TESTIGO ESTADO 2 ==========================

TareaLDTst_Est2
                Tst TimerLDTst                    ; Si el timer no se ha acabado
                Bne FIN_LDTst_2                   ; se mantiene en este estado
                BClr PTP,LD_Red                   ; Encender color verde y apagar
                BSet PTP,LD_Green                 ; el resto
                BClr PTP,LD_Blue
                Movw #TareaLDTst_Est3,EstPres_LDTst
                Movb #tTimerLDTst,TimerLDTst
FIN_LDTst_2     Rts

;========================= TAREA LED TESTIGO ESTADO 3 ==========================

TareaLDTst_Est3
                Tst TimerLDTst                    ; Si el timer no se ha acabado
                Bne FIN_LDTst_3                   ; se mantiene en este estado
                BClr PTP,LD_Red                   ; Encender color azul y apagar
                BClr PTP,LD_Green                 ; el resto
                BSet PTP,LD_Blue
                Movw #TareaLDTst_Est1,EstPres_LDTst
                Movb #tTimerLDTst,TimerLDTst
FIN_LDTst_3     Rts

;******************************************************************************
;                                  SEND LCD
;******************************************************************************

SendLCD:
                Ldy EstPres_SendLCD
                Jsr 0,Y
                Rts

;============================= SEND LCD ESTADO 1 ===============================

TareaSendLCD_Est1:
                Ldaa CharLCD                      ; Cargar caracter a enviar
                Anda #$F0                         ; Filtrar la parte alta
                Lsra                              ; Guardar en los bits 5:2 del
                Lsra                              ; puerto K
                Staa PORTK
                BrSet Banderas_2,RS,Set_RS        ; Si es un comando, borrar
                BClr PORTK,RS                     ; PORTK.0
                Bra Enable_LCD
Set_RS          BSet PORTK,RS                     ; Si es dato, levantar PORTK.0
Enable_LCD      BSet PORTK,$02                    ; Habilitar LCD
                Movw #tTimer260uS,Timer260uS
                Movw #TareaSendLCD_Est2,EstPres_SendLCD
FIN_SendLCD_1   Rts

;============================= SEND LCD ESTADO 2 ===============================

TareaSendLCD_Est2:
                Ldd Timer260uS                    ; Mientras no se acabe el timer
                Bne FIN_SendLCD_2                 ; se mantiene en este estado
                BClr PORTK,$02                    ; Deshabilita LCD
                Ldaa CharLCD                      ; Carga caracter a enviar
                Anda #$0F                         ; Filtra solo la parte baja
                Lsla                              ; Guarda en los bits 5:2 del
                Lsla                              ; puerto K
                Staa PORTK
                BrSet Banderas_2,RS,Set_RS_2      ; Si es un comando, borrar
                BClr PORTK,RS                     ; PORTK.0
                Bra Load_Timer
Set_RS_2        BSet PORTK,RS                     ; Si es dato, levantar PORTK.0
Load_Timer      BSet PORTK,$02                    ; Habilitar LCD
                Movw #tTimer260uS,Timer260uS
                Movw #TareaSendLCD_Est3,EstPres_SendLCD
FIN_SendLCD_2   Rts

;============================= SEND LCD ESTADO 3 ===============================

TareaSendLCD_Est3:
                Ldd Timer260uS                    ; Mientras no se acabe el timer
                Bne FIN_SendLCD_3                 ; se mantiene en este estado
                BClr PORTK,$02                    ; Deshabilitar LCD
                Movw #tTimer40uS,Timer40uS
                Movw #TareaSendLCD_Est4,EstPres_SendLCD
FIN_SendLCD_3   Rts

;============================= SEND LCD ESTADO 4 ===============================

TareaSendLCD_Est4:
                Ldd Timer40uS                     ; Mientras no se acabe el timer
                Bne FIN_SendLCD_4                 ; se mantiene en este estado
                BSet Banderas_2,FinSendLCD        ; Activa bandera FinSendLCD
                Movw #TareaSendLCD_Est1,EstPres_SendLCD
FIN_SendLCD_4   Rts

;******************************************************************************
;                                  TAREA ATD
;******************************************************************************

Tarea_ATD:
                Ldx EstPres_ATD
                Jsr 0,X
                Rts

;============================= TAREA ATD ESTADO 1 ==============================

TareaATD_Est1:
                Tst TimerATD
                Bne FIN_ATD_1
                Movb #$87,ATD0CTL5
                Movb #tTimerATD,TimerATD
                Movw #TareaATD_Est2,EstPres_ATD
FIN_ATD_1       Rts

;============================= TAREA ATD ESTADO 2 ==============================

TareaATD_Est2:
                BrClr ATD0STAT0,$80,FIN_ATD_2
                Jsr Calcula
                Ldaa Volumen
                Cmpa #14
                Bls AlarmaAct
                Cmpa #30
                Bhi AlarmaDes
                Bra CheckVaciar_1
AlarmaAct	BSet Banderas_1,MostrarAlarma
                Bra CheckVaciar_1
AlarmaDes	BClr Banderas_1,MostrarAlarma
CheckVaciar_1	Cmpa #82
                Bls VaciarOFF
                BSet Banderas_1,Vaciar
                Bra PrevState_ATD
VaciarOFF       BClr Banderas_1,Vaciar
PrevState_ATD	Movw #TareaATD_Est1,EstPres_ATD
FIN_ATD_2 	Rts

;******************************************************************************
;                                TAREA TERMINAL
;******************************************************************************

Tarea_Terminal:
                Ldx EstPres_Terminal
                Jsr 0,X
                Rts
                
;=========================== TAREA TERMINAL ESTADO 1 ===========================

Terminal_Est1:
                Tst TimerTerminal
                Bne FIN_Terminal_1
                BrClr SC1SR1,$80,FIN_Terminal_1
		Ldx Puntero_Msg
                Ldaa 1,X+
                Cmpa #$FF
                Beq NextState_Term
                Staa SC1DRL
                Stx Puntero_Msg
                Bra FIN_Terminal_1
NextState_Term  BClr SC1CR2,$08
                Movb #tTimerTerminal,TimerTerminal
		Movw #Terminal_Est2,EstPres_Terminal
FIN_Terminal_1  Rts

;=========================== TAREA TERMINAL ESTADO 2 ===========================

Terminal_Est2:
                BrClr Banderas_1,MostrarAlarma,CheckVaciar_2
                Movw #Msg_Alarma,Puntero_Msg
                BSet SC1CR2,$08
                Movw #Terminal_Est3,EstPres_Terminal
                Bra FIN_Terminal_2
CheckVaciar_2   BrClr Banderas_1,Vaciar,Cargar_Msg_Op
                Tst Cont_Seg
                Bne FIN_Terminal_2
                Movw #Msg_Vaciado,Puntero_Msg
                BSet SC1CR2,$08
                Movw #Terminal_Est3,EstPres_Terminal
                Bra FIN_Terminal_2
Cargar_Msg_Op   ;BSet SC1CR2,$08
		;Movw #Msg_Operacion,Puntero_Msg
                Movw #Terminal_Est1,EstPres_Terminal
FIN_Terminal_2  Rts

;=========================== TAREA TERMINAL ESTADO 3 ===========================

Terminal_Est3:
                BrClr SC1SR1,$80,FIN_Terminal_3
                Ldx Puntero_Msg
                Ldaa 1,X+
                Cmpa #$FF
                Beq PrevState_Term3
                Staa SC1DRL
                Stx Puntero_Msg
                Bra FIN_Terminal_3
PrevState_Term3 ;BClr SC1CR2,$08
                Movb #tTimerTerminal,TimerTerminal
                Movw #Terminal_Est1,EstPres_Terminal
FIN_Terminal_3  Rts

;******************************************************************************
;                                  TAREA LCD
;******************************************************************************

Tarea_LCD:
                Ldx EstPres_TareaLCD
                Jsr 0,X
                Rts

;============================= TAREA LCD ESTADO 1 ===============================

TareaLCD_Est1:
                BClr Banderas_2,FinSendLCD        ; Borrar banderas FinSendLCD
                BClr Banderas_2,RS                ; y RS
                BrSet Banderas_2,Second_Line,Line_2
                Movb #ADD_L1,CharLCD              ;
                Movw Msg_L1,Punt_LCD
                Bra FIN_TareaLCD_1
Line_2          Movb #ADD_L2,CharLCD
                Movw Msg_L2,Punt_LCD
FIN_TareaLCD_1  Jsr SendLCD
                Movw #TareaLCD_Est2,EstPres_TareaLCD
                Rts

;============================= TAREA LCD ESTADO 2 ===============================

TareaLCD_Est2
                BrClr Banderas_2,FinSendLCD,Call_SendLCD_4
                BClr Banderas_2,FinSendLCD
                BSet Banderas_2,RS
                Ldx Punt_LCD
                Movb 1,X+,CharLCD
                Stx Punt_LCD
                Ldaa CharLCD
                Cmpa #$FF
                Bne Call_SendLCD_4
                BrSet Banderas_2,Second_Line,SwitchLine
                BSet Banderas_2,Second_Line
                Bra SigEst_LCD
SwitchLine      BClr Banderas_2,Second_Line
                BSet Banderas_2,LCD_OK
SigEst_LCD      Movw #TareaLCD_Est1,EstPres_TareaLCD
                Bra FIN_TareaLCD_2
Call_SendLCD_4  Jsr SendLCD
FIN_TareaLCD_2  Rts

;******************************************************************************
;                                SUBRUTINA CALCULA
;******************************************************************************

Calcula:
                Ldd ADR00H
                Addd ADR01H
                Addd ADR02H
                Addd ADR03H
                Lsrd
                Lsrd
                Std NivelProm
                Ldy #20
                Emul
                Ldx #1023
                Idiv
                Tfr X,A
                Staa Nivel
                Ldab #7                 ; Aproximado de Pi*(Radio**2)
                Mul                     ; Volumen = Pi*(Radio**2)*(Nivel)
                Stab Volumen
FIN_Calcula     Rts

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
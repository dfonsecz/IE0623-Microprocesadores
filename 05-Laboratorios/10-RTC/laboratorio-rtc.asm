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

tTimer40uS:       EQU 2      ; Tiempo de timer de 40 uS (20uS x 2)
tTimer260uS:      EQU 13     ; Tiempo de timer de 260 uS (20uS x 13)
tTimer2ms:        EQU 100    ; Tiempo de timer de 2 mS (20uS x 100)
tSupRebPB1:       EQU 10     ; Tiempo de supresion de rebotes x 1 mS (PB)
tSupRebPB2:       EQU 10     ; Tiempo de supresion de rebotes x 1 mS (PB)
tSupRebTCL:       EQU 10     ; Tiempo de supresion de rebotes x 1 mS (Teclado)
tShortP1:         EQU 25     ; Tiempo minimo ShortPress x 10 mS
tShortP2:         EQU 25     ; Tiempo minimo ShortPress x 10 mS
tLongP1:          EQU 3      ; Tiempo minimo LongPress en segundos
tLongP2:          EQU 3      ; Tiempo minimo LongPress en segundos
tTimerLDTst:      EQU 5      ; Tiempo de parpadeo de LED testigo x 100 mS
tTimerDigito:     EQU 2
tTimerRead_RTC:   EQU 10     ; Timer de 1 segundo para leer RTC

PortPB:           EQU PTIH   ; Se define el puerto donde se ubica el PB
MaskPB1:          EQU $08    ; Se define el bit 3 del PB en el puerto
MaskPB2:          EQU $01    ; Se define el bit 0 del PB en el puerto

;=============================== TAREA TECLADO =================================

                  ORG $1000

MAX_TCL:          db $05     ; Limite maximo del tamano de Num_Array
Tecla:            ds 1       ; Variable para guardar la tecla actual
Tecla_IN:         ds 1       ; Variable para guardar la tecla ingresada
Cont_TCL:         ds 1       ; Variable para guardar tamano actual de Num_Array
Patron:           ds 1       ; Variable para guardar patron a escribir y leer
                             ; en el teclado
Funcion:          ds 1       ; Variable para guardar patron a escribir en LEDs
EstPres_TCL:     ds 2       ; Variable para direccion de estado de maquina de
                             ; estados Tarea_Teclado

; Arreglo de teclas presionadas
                  ORG $1010
Num_Array:        ds 5       ; Array donde guardar valores ingresados por el
                             ; teclado

;============================ TAREA PANTALLA MUX ===============================

                          ORG $1020
EstPres_PantallaMUX:    ds 2 ; Variable para guardar estado de tarea de pantalla
                             ; multiplexada
DSP1:             ds 1
DSP2:             ds 1
DSP3:             ds 1
DSP4:             ds 1
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
MaxCountTicks     EQU 100
DIG1              EQU $01
DIG2              EQU $02
DIG3              EQU $04
DIG4              EQU $08

;================================== TAREA LCD ==================================

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


;================================ TAREA LEER PB1 ===============================

EstPres_LeerPB1:  ds 2       ; Variable para guardar estado de Leer PB 1

;================================ TAREA LEER PB2 ===============================

EstPres_LeerPB2:  ds 2       ; Variable para guardar estado de Leer PB 2

;================================== TAREA RTC ==================================

EstPres_RTC:      ds 2       ; Variable para guardar el estado de Tarea RTC
Index_RTC:        ds 1
T_Read_RTC:       ds 7

Dir_WR:           EQU $D0    ; Direccion de escritura de DS1307
Dir_RD:           EQU $D1    ; Direccion de lectura de DS1307
Dir_Seg:          EQU $00    ; Direccion de registro de Segundos en el DS1307

IBEN:             EQU $80    ; Mascara del bit IBEN en IBCR
MS_SL:            EQU $20    ; Mascara del bit MS/SL en IBCR
TX_RX:            EQU $10    ; Mascara del bit TX/RX en IBCR
TXAK:             EQU $08    ; Mascara del bit TXAK en IBCR
RSTA:             EQU $04    ; Mascara del bit RSTA en IBCR

IBIF:             EQU $02    ; Mascara del bit IBIF en IBSR

;=================================== BANDERAS ==================================

                  ORG $1070
Banderas_1:       ds 1
ShortP1:          EQU $01
LongP1:           EQU $02
ShortP2:          EQU $04
LongP2:           EQU $08
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

; Codigos de Teclas validas
                  ORG $1110
Teclas:           db $01,$02,$03
                  db $04,$05,$06
                  db $07,$08,$09
                  db $0B,$00,$0E

                  ORG $1120
T_Write_RTC:      db $00
                  db $50
                  db $11
                  db $05
                  db $28
                  db $11
                  db $25

;================================== MENSAJES ===================================

MSG1_P1:          fcc "    ESCUELA DE   "
                  db $FF
MSG1_P2:          fcc " ING. ELECTRICA  "
                  db $FF
MSG2_P1:          fcc "  uPROCESADORES  "
                  db $FF
MSG2_P2:          fcc "    TAREA #5     "
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

Timer_RebPB1:   ds 1
Timer_RebPB2:   ds 1
Timer_RebTCL:   ds 1
Timer_Digito:   ds 1
Timer2mS:       ds 1

Fin_Base1mS:    dB $FF

Tabla_Timers_Base10mS

Timer_SHP1:     ds 1
Timer_SHP2:     ds 1

Fin_Base10ms:   dB $FF

Tabla_Timers_Base100mS

Timer1_100mS:   ds 1
TimerRead_RTC:  ds 1

TimerLDTst:     ds 1
Fin_Base100mS:  dB $FF

Tabla_Timers_Base1S

Timer_LP1:      ds 1
Timer_LP2:      ds 1
SegundosTCM:    ds 1

Fin_Base1S:      dB $FF

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
        
        Movb #$25,IBFD
        Movb #$80,IBCR

;===============================================================================
;                           PROGRAMA PRINCIPAL
;===============================================================================

        Movw #tTimer1mS,Timer1mS
        Movw #tTimer10mS,Timer10mS         ;Inicia los timers de bases de tiempo
        Movw #tTimer100mS,Timer100mS
        Movw #tTimer1S,Timer1S

        Movb #tTimerLDTst,TimerLDTst  ;inicia timer parpadeo led testigo
        Movb #0,Timer_LP1
        Movb #0,Timer_LP2
        ;Movb #tTimerRead_RTC,TimerRead_RTC

        ; Inicializacion de estados de maquinas de estado
        Movw #RTC_Est1,EstPres_RTC
        Movw #TareaLDTst_Est1,EstPres_LDTst
        Movw #PantallaMUX_Est1,EstPres_PantallaMUX
        Movw #LeerPB1_Est1,EstPres_LeerPB1
        Movw #LeerPB2_Est1,EstPres_LeerPB2
        Movw #Teclado_Est1,EstPres_TCL
        Movw #TareaLCD_Est1,EstPres_TareaLCD
        Movw #TareaSendLCD_Est1,EstPres_SendLCD

        ; Inicializacion de Pantalla LCD (timers)
        Movw #tTimer260uS,Timer260uS
        Movw #tTimer40uS,Timer40uS

        ; Pantalla MUX
        Movb #$01,Cont_Dig
        Movb #99,Brillo

        ; Pantalla LCD
        Clr Banderas_1

        ; Teclado
        Movb #$FF,Tecla
        Movb #$FF,Tecla_IN
        Movb #$00,Cont_TCL
        Movb #$FF,Num_Array

        Movb #$00,Patron
        Movb #$FF,Funcion

        Lds #$3BFF
        Cli
        Clr Banderas_1

        Jsr Init_LCD
        Bra Despachador_Tareas

;******************************************************************************
;                              INICIALICION LCD
;******************************************************************************

Init_LCD        ; Inicializacion de Pantalla LCD (otros)
                Movw #MSG1_P1,Msg_L1
                Movw #MSG1_P2,Msg_L2
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
                Jsr Tarea_LCD
NoNewMsg        Jsr Decre_TablaTimers
                Jsr Tarea_RTC
                Jsr Tarea_Led_Testigo
                Jsr Tarea_Conversion
                Jsr Tarea_PantallaMUX
                Jsr Tarea_LeerPB1
                Jsr Tarea_LeerPB2
                Jsr Tarea_Teclado
                Bra Despachador_Tareas

;******************************************************************************
;                               TAREA CONVERSIONES
;******************************************************************************

Tarea_Conversion:
                ;Ldaa BIN1                         ; Cargar primer binario
                ;Jsr BIN_BCD_MUXP                  ; Convertirlo a BCD
                ;Movb BCD,BCD1                     ; Guardarlo en BCD
                ;Ldaa BIN2                         ; Cargar segundo binario
                ;Jsr BIN_BCD_MUXP                  ; Convertirlo a BCD
                ;Movb BCD,BCD2                     ; Guardarlo en BCD
                Jsr BCD_7Seg                      ; Convertir a valor de lectura
FIN_TareaConv:  Rts                               ; valido para la pantalla

;=============================== BCD 7 SEGMENTOS ===============================
;
; Descripcion: Esta subrutina toma los valores de BCD1 y BCD2, y busca en la
; tabla de patrones de segmentos el segmento correspondiente al digito de cada
; nibble. Luego, guarda los resultados en las variables Dsp1, Dsp2, Dsp3 y Dsp4
; de la siguiente forma:
;
;       BCD2 -> Dsp1:Dsp2
;       BCD1 -> Dsp3:Dsp4

BCD_7Seg:
                Ldx #Segment
                Ldaa BCD2
                Anda #$F0                         ; Obtener nibble alto de BCD2
                Lsra                              ; y desplazar a la parte baja
                Lsra
                Lsra
                Lsra
                Ldab A,X                          ; Cargar patron de segmento
                Stab DSP1                         ; Guardar en DISP1
                Ldaa BCD2
                Anda #$0F                         ; Obtener nibble bajo de BCD2
                Ldab A,X                          ; Cargar patron de segmento
                Stab DSP2                         ; Guardar en DISP2
                Ldaa BCD1
                Anda #$F0                         ; Obtener nibble alto de BCD1
                Lsra                              ; y desplazar a la parte baja
                Lsra
                Lsra
                Lsra
                Ldab A,X                          ; Cargar patron de segmento
                Stab DSP3                         ; Guardar en DISP3
                Ldaa BCD1
                Anda #$0F                         ; Obtener nibble bajo de BCD1
                Ldab A,X                          ; Cargar patron de segmento
                Stab DSP4                         ; Guardar en DISP4
FIN_BCD7_Seg    Rts

;================================= BIN BCD MUXP ================================

BIN_BCD_MUXP
                Movb #7,Cont_BCD
                Clr BCD
BIN_BCD_Loop    Lsla                              ; Pasar bits a BCD por medio
                Rol BCD                           ; del carry
                Psha                              ; Guardar entrada en la pila
                Ldab BCD
                Andb #$0F                         ; Obtener nibble bajo de BCD
                Cmpb #$05
                Bcs Nibble_Alto
                Addb #$03
Nibble_Alto     Pshb                              ; Guardar nibble bajo actuali-
                Ldab BCD                          ; zado en la pila
                Andb #$F0
                Cmpb #$50
                Bcs Dec_Cont_BCD
                Addb #$30
Dec_Cont_BCD    Pula                              ; Cargar nibble bajo
                Aba                               ; Sumar nibble bajo y alto
                Staa BCD                          ; Actualizar valor en BCD
                Pula                              ; Recargar valor de entrada
                Dec Cont_BCD                      ; Decrementar #de desplazamiento
                Tst Cont_BCD                      ; Verificar si llego a cero,
                Bne BIN_BCD_Loop                  ; Si no, continuar loop
                Lsla                              ; Desplazar x ultima vez a la
                Rol BCD                           ; izquierda
FIN_BIN_BCD     Rts

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
;                                 TAREA RTC
;******************************************************************************

Tarea_RTC:
                Ldx EstPres_RTC
                Jsr 0,X
                Rts

;============================= TAREA RTC ESTADO 1 ==============================

RTC_Est1:       Ldaa Banderas_1
                BrClr Banderas_1,LongP1,GoToRTC_Est3
                Movb #$07,Index_RTC             ; Se carga el Index_RTC y se
                BSet IBCR,MS_SL                 ; envia el start
                BSet IBCR,TX_RX
                Movb #Dir_WR,IBDR               ; Se envia la direccion de escritura
                Movw #RTC_Est2,EstPres_RTC
                Bra FIN_RTC_1
GoToRTC_Est3    Movb #tTimerRead_RTC,TimerRead_RTC
                Movw #RTC_Est3,EstPres_RTC
FIN_RTC_1  Rts

;============================= TAREA RTC ESTADO 2 ==============================

RTC_Est2:
                BrClr IBSR,IBIF,FIN_RTC_2
                BSet IBSR,IBIF
                Jsr Write_RTC
                BrSet Banderas_1,LongP1,FIN_RTC_2
                Movw #RTC_Est1,EstPres_RTC
FIN_RTC_2  Rts

;============================= TAREA RTC ESTADO 3 ==============================

RTC_Est3:
                Tst TimerRead_RTC
                Bne FIN_RTC_3
                Movb #$07,Index_RTC
                BSet IBCR,TX_RX
                BSet IBCR,MS_SL
                Movb #Dir_WR,IBDR
                Movw #RTC_Est4,EstPres_RTC
FIN_RTC_3  Rts

;============================= TAREA RTC ESTADO 4 ==============================

RTC_Est4:
                BrClr IBSR,IBIF,FIN_RTC_4
                BSet IBSR,IBIF
                Jsr Read_RTC
                Ldaa Index_RTC
                Cmpa #$07
                Bne FIN_RTC_4
                Movb T_Read_RTC,BCD1
                Movb T_Read_RTC+1,BCD2
                Movw #RTC_Est1,EstPres_RTC
FIN_RTC_4  Rts

;******************************************************************************
;                               TAREA LEER PB1
;******************************************************************************

Tarea_LeerPB1:
                Ldx EstPres_LeerPB1
                Jsr 0,X
FinTareaPB1     Rts

;============================= LEER PB1 ESTADO 1 ===============================

LeerPB1_Est1
                BrSet PortPB,MaskPB1,FIN_Est1      ; Si el boton es presionado
No_FIN_Est1     Movb #tSupRebPB1,Timer_RebPB1       ; Cargar timers
                Movb #tShortP1,Timer_SHP1
                Movb #tLongP1,Timer_LP1
                Movw #LeerPB1_Est2,EstPres_LeerPB1 ; Continuar a estado 2
FIN_Est1        Rts

;============================= LEER PB1 ESTADO 2 ===============================

LeerPB1_Est2
                Tst Timer_RebPB1                   ; Si se agota el timer
                Bne FIN_Est2                      ; verificar si aun sigue pre-
                BrSet PortPB,MaskPB1,Ret_Est1_1    ; sionado el boton
                Movw #LeerPB1_Est3,EstPres_LeerPB1
                Bra FIN_Est2
Ret_Est1_1      Movw #LeerPB1_Est1,EstPres_LeerPB1 ; Sino regresar a estado 1
FIN_Est2        Rts

;============================= LEER PB1 ESTADO 3 ===============================

LeerPB1_Est3
                Tst Timer_SHP1                     ; Verificar si el timer short
                Bne FIN_Est3                      ; press se agoto
                BrSet PortPB,MaskPB1,Ret_Est1_2    ; Si se presiona el boton
                Movw #LeerPB1_Est4,EstPres_LeerPB1 ; Sino, pasar a estado 4
                Bra FIN_Est3
Ret_Est1_2      BSet Banderas_1,ShortP1              ; Levantar bandera ShortP y
                Movw #LeerPB1_Est1,EstPres_LeerPB1 ; regresar a estado 1
FIN_Est3        Rts

;============================= LEER PB1 ESTADO 4 ===============================

LeerPB1_Est4
                Tst Timer_LP1                      ; Si no se agota el timer long
                Bne TestPB1                        ; press, y se presiona el boton
                BrClr PortPB,MaskPB1,FIN_Est4      ; es un short press
                BSet Banderas_1,LongP1
Ret_Est1_3      Movw #LeerPB1_Est1,EstPres_LeerPB1 ; sino es un long press
                Bra FIN_Est4
TestPB1         BrClr PortPB,MaskPB1,FIN_Est4
                BSet Banderas_1,ShortP1
                Bra Ret_Est1_3
FIN_Est4        Rts

;******************************************************************************
;                               TAREA LEER PB2
;******************************************************************************

Tarea_LeerPB2:
                Ldx EstPres_LeerPB2
                Jsr 0,X
FinTareaPB2     Rts

;============================= LEER PB2 ESTADO 1 ===============================

LeerPB2_Est1
                BrSet PortPB,MaskPB2,FIN_Est1_2    ; Si el boton es presionado
No_FIN_Est1_2   Movb #tSupRebPB2,Timer_RebPB2      ; Cargar timers
                Movb #tShortP2,Timer_SHP2
                Movb #tLongP2,Timer_LP2
                Movw #LeerPB2_Est2,EstPres_LeerPB2 ; Continuar a estado 2
FIN_Est1_2      Rts

;============================= LEER PB2 ESTADO 2 ===============================

LeerPB2_Est2
                Tst Timer_RebPB2                   ; Si se agota el timer
                Bne FIN_Est2_2                     ; verificar si aun sigue pre-
                BrSet PortPB,MaskPB2,Ret_Est1_1_2  ; sionado el boton
                Movw #LeerPB2_Est3,EstPres_LeerPB2
                Bra FIN_Est2_2
Ret_Est1_1_2    Movw #LeerPB2_Est1,EstPres_LeerPB2 ; Sino regresar a estado 1
FIN_Est2_2      Rts

;============================= LEER PB2 ESTADO 3 ===============================

LeerPB2_Est3
                Tst Timer_SHP2                     ; Verificar si el timer short
                Bne FIN_Est3_2                     ; press se agoto
                BrSet PortPB,MaskPB2,Ret_Est1_2_2  ; Si se presiona el boton
                Movw #LeerPB2_Est4,EstPres_LeerPB2 ; Sino, pasar a estado 4
                Bra FIN_Est3_2
Ret_Est1_2_2    BSet Banderas_1,ShortP2            ; Levantar bandera ShortP y
                Movw #LeerPB2_Est1,EstPres_LeerPB2 ; regresar a estado 1
FIN_Est3_2      Rts

;============================= LEER PB2 ESTADO 4 ===============================

LeerPB2_Est4
                Tst Timer_LP2                      ; Si no se agota el timer long
                Bne TestPB2                        ; press, y se presiona el boton
                BrClr PortPB,MaskPB2,FIN_Est4_2    ; es un short press
                BSet Banderas_1,LongP2
Ret_Est1_3_2    Movw #LeerPB2_Est1,EstPres_LeerPB2 ; sino es un long press
                Bra FIN_Est4
TestPB2         BrClr PortPB,MaskPB2,FIN_Est4_2
                BSet Banderas_1,ShortP2
                Bra Ret_Est1_3_2
FIN_Est4_2      Rts

;******************************************************************************
;                             TAREA PANTALLA MUX
;******************************************************************************

Tarea_PantallaMUX
                Ldx EstPres_PantallaMUX
                Jsr 0,X
                Rts

;=========================== PANTALLA MUX ESTADO 1 =============================

PantallaMUX_Est1:
                Tst Timer_Digito
                Bne FIN_PantMUX_1
                Movb #tTimerDigito,Timer_Digito
                Ldaa Cont_Dig
                Cmpa #$01
                Bne GoTo_Disp2
                BClr PTP,DIG1
                Movb DSP1,PORTB
                Bra Inc_Cont_Dig
GoTo_Disp2      Cmpa #$02
                Bne GoTo_Disp3
                BClr PTP,DIG2
                Movb DSP2,PORTB
                Bra Inc_Cont_Dig
GoTo_Disp3      Cmpa #$03
                Bne GoTo_Disp4
                BClr PTP,DIG3
                Movb DSP3,PORTB
                Bra Inc_Cont_Dig
GoTo_Disp4      Cmpa #$04
                Bne GoTo_Leds
                BClr PTP,DIG4
                Movb DSP4,PORTB
                Bra Inc_Cont_Dig
GoTo_Leds       BClr PTJ,$02
                Movb LEDS,PORTB
                Movb #$01,Cont_Dig
                Bra Inc_Ticks
Inc_Cont_Dig    Inc Cont_Dig
Inc_Ticks       Movw #MaxCountTicks,CounterTicks
                Movw #PantallaMUX_Est2,EstPres_PantallaMUX
FIN_PantMUX_1   Rts

;=========================== PANTALLA MUX ESTADO 2 =============================

PantallaMUX_Est2:
                Ldaa #MaxCountTicks
                Suba Brillo
                Sex A,D
                Cpd CounterTicks
                Bls FIN_PantMUX_2
                BSet PTP,$0F
                BSet PTJ,$02
                Movw #PantallaMUX_Est1,EstPres_PantallaMUX
FIN_PantMUX_2   Rts

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
;                               TAREA TECLADO
;******************************************************************************

Tarea_Teclado   Ldx EstPres_TCL
                Jsr 0,X
                Rts

;============================= TECLADO ESTADO 1 ================================

Teclado_Est1    Jsr Leer_Teclado                  ; Si se presiona alguna tecla
                Ldaa Tecla
                Cmpa #$FF
                Beq FIN_Tecl_Est1
                Movb #tSupRebTCL,Timer_RebTCL     ; carga timer de supresion de
                Movw #Teclado_Est2,EstPres_TCL   ; rebotes y siguiente estado
FIN_Tecl_Est1   Rts

;============================= TECLADO ESTADO 2 ================================

Teclado_Est2    Tst Timer_RebTCL                  ; Si no se agota el timer,
                Bne FIN_Tecl_Est2                 ; verifica si Tecla = Tecla_IN
                Movb Tecla,Tecla_IN
                Jsr Leer_Teclado
                Ldaa Tecla_IN
                Cmpa Tecla
                Bne Regr_Tecl_Est1
                Movw #Teclado_Est3,EstPres_TCL   ; Si son iguales pasa a est 3
                Bra FIN_Tecl_Est2
Regr_Tecl_Est1  Movw #Teclado_Est1,EstPres_TCL   ; Sino se devuelve al 1
FIN_Tecl_Est2   Rts
;============================= TECLADO ESTADO 3 ================================

Teclado_Est3    Jsr Leer_Teclado
                Ldaa Tecla
                Cmpa #$FF
                Bne FIN_Tecl_Est3
                Ldaa Tecla_IN                     ; Si la tecla ingresada es de
                Cmpa #15                          ; funcion, la guarda se
                Bhi Guardar_Funcion
                Movw #Teclado_Est4,EstPres_TCL   ; devuelve al estado 1
                Bra FIN_Tecl_Est3
Guardar_Funcion Movb Tecla_IN,Funcion             ; sino pasa al estado 4
                Movw #Teclado_Est1,EstPres_TCL
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
                Movw #Teclado_Est1,EstPres_TCL
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
                Movw #Teclado_Est1,EstPres_TCL ; Regresar a estado 1
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
;                            SUBRUTINA READ RTC
;******************************************************************************

Read_RTC:
                Ldaa Index_RTC
                Cmpa #$07
                Bne Cmp_Idx_08
                Movb #Dir_Seg,IBDR
                Bra Inc_Idx_Rtc
Cmp_Idx_08      Cmpa #$08
                Bne Cmp_Idx_09
                BSet IBCR,RSTA
                Movb #Dir_RD,IBDR
                Bra Inc_Idx_Rtc
Cmp_Idx_09      Cmpa #$09
                Beq Tx_On
                Ldx #T_Read_RTC
                Ldaa Index_RTC
                Cmpa #5
                Blo Read_IBDR
                Cmpa #6
                Bne Tx_Off
                BClr IBCR,MS_SL
                Movb #$07,Index_RTC
                Movb IBDR,A,X
                Bra FIN_Read_RTC
Tx_On           BClr IBCR,RSTA
                BClr IBCR,TX_RX
                BClr IBCR,TXAK
                Clr Index_RTC
                Ldaa IBDR
                Bra FIN_Read_RTC
Tx_Off          BSet IBCR,TXAK
Read_IBDR       Movb IBDR,A,X
Inc_Idx_Rtc     Inc Index_RTC
FIN_Read_RTC    Rts

;******************************************************************************
;                            SUBRUTINA WRITE RTC
;******************************************************************************

Write_RTC:
                Ldaa Index_RTC
                Cmpa #$07
                Beq Reset_Index
                Ldx #T_Write_RTC
                Ldaa Index_RTC
                Movb A,X,IBDR
                Cmpa #$06
                Bne Inc_IndexRTC
                BClr IBCR,MS_SL
                BClr Banderas_1,LongP1
                Bra FIN_Write_RTC
Inc_IndexRTC    Inc Index_RTC
                Bra FIN_Write_RTC
Reset_Index     Movb #Dir_Seg,IBDR
                Clr Index_RTC
FIN_Write_RTC   Rts

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
               
;*******************************************************************************
;                               TAREA 3
;*******************************************************************************
;       Autora: Daniela Fonseca Zumbado
;       Version: 1.0
;
; Descripcion:
;...............................................................................
;
;*******************************************************************************
;                         ESTRUCTURAS DE DATOS
;*******************************************************************************
Nibble_UP:      EQU $1630
Nibble_MED:     EQU $1660
Nibble_Low:     EQU $1690
CR:      EQU $0D
LF:      EQU $0A
GetChar: EQU $EE84
PutChar: EQU $EE86
Printf:  EQU $EE88
FINMSG:  EQU $0

        ORG $1000
CANT:   ds 1            ; Cantidad de datos a recorrer
CONT:   ds 1            ; Cantidad de datos recorridos
Offset: ds 1            ; Variable para almacenar puntero de barrido de tabla
ACC:    ds 2            ; Acumulado de calculo de conversion ASCII_BIN

        ORG $1030
MSG1:   FCC "INGRESE UN VALOR (ENTRE 0 Y 50): "
        db FINMSG
MSG2:   db CR,CR,LF
	db CR,CR,LF
	FCC "CANTIDAD DE VALORES PROCESADOS: %i"
	db CR,CR,LF
	db CR,CR,LF
        db FINMSG
MSG3:   FCC "Nibble_UP: "
        db FINMSG
MSG4:   FCC "Nibble_MED: "
        db FINMSG
MSG5:   FCC "Nibble_LOW: "
        db FINMSG
MSG6:   FCC "%01x"
        db FINMSG
MSG7:   FCC ", "
        db FINMSG
        
CRLF:   db CR,CR,LF

                ORG $1500
Datos_IoT:      db $00,$01,$02,$09      ; 129
                db $00,$07,$02,$09      ; 729

                ORG $1600
Datos_BIN:      ds 100
;...............................................................................
;
;*******************************************************************************
;                                PROGRAMA
;*******************************************************************************
                ORG $2000
                
MAIN            Lds #$3BFF
                Jsr GET_CANT
                Ldx #Datos_BIN
                Ldy #Datos_IoT
                Pshx
                Pshy
                Jsr ASCII_BIN
                Ldx #Datos_BIN
                Jsr MOVER
                Jsr IMPRIMIR
                Bra *

;*******************************************************************************
;                           SUBRUTINA GET_CANT
;*******************************************************************************

GET_CANT        Ldx #0
                Ldd #MSG1
                Jsr [Printf,X]
ObtenerChar1    Ldx #0
                Jsr [GetChar,X]               ; Leer valor de teclado
                Cmpb #$30                     ; Comparar entrada con 0 en ASCII
                Bcs ObtenerChar1
                Cmpb #$35                     ; Comparar entrada con 5 en ASCII
                Bhi ObtenerChar1
                Ldx #0
                Jsr [PutChar,X]
                Subb #$30                      ; Obtener valor del digito
                Ldaa #10
                Mul
                Stab CANT                     ; Convertir a decenas
ObtenerChar2    Ldx #$0
                Jsr [GetChar,X]               ; Leer valor de botones
                Cmpb #$30                     ; Comparar entrada con 0 en ASCII
                Bcs ObtenerChar2
                Cmpb #$39                     ; Comparar entrada con 9 en ASCII
                Bhi ObtenerChar2
                Ldx #0
                Jsr [PutChar,X]
                Subb #$30                      ; Obtener valor del digito
                Addb CANT                     ; Sumar decenas y unidades
                Stab CANT
                Cmpb #0                       ; Si el valor es menor a 1,
                Beq ResetCant                 ; descartar
                Cmpb #50                      ; Si el valor es mayor a 50,
                Bhi ResetCant                 ; descartar
                Rts
ResetCant       Movb #0,CANT                  ; Resetear CANT
                ;Ldx #0
                ;Ldd CRLF
                ;Jsr [PutChar,X]
                Bra ObtenerChar1

;*******************************************************************************
;                           SUBRUTINA ASCII_BIN
;*******************************************************************************

ASCII_BIN       Leas 2,SP                     ; Saltar la direccion de retorno
                Pulx                          ; Desapilar direccion Datos_Iot
                Movb #0,CONT
                Movb #0,ACC
                Movb #0,Offset
Loop            Ldaa Offset
                Ldab A,X                      ; Cargar byte de tabla Datos_IoT
                Clra
                Inc Offset
                Subb #$30                      ; Convertir a valor BCD
                Ldy #1000
                Emul
                Std ACC                       ; Guardar resultado preliminar
                Ldaa Offset
                Ldab A,X
                Inc Offset
                Subb #$30                     ; Convertir a valor BCD
                Ldaa #100
                Mul
                Addd ACC                      ; Sumar millares a centenas
                Std ACC                       ; Guardar resultado preliminar
                Ldaa Offset                   ; Cargar el siguiente byte
                Ldab A,X
                Inc Offset
                Subb #$30
MUL_DEC         Ldaa #10
                Mul
                Addd ACC                      ; Sumar decenas a centenas y millares
                Std ACC                       ; Guardar resultado preliminar
                Ldaa Offset                   ; Cargar siguiente byte
                Ldab A,X
                Inc Offset
                Clra
                Subb #$30
                Addd ACC                      ; Sumar unidades a decenas, cen-
                Std ACC                       ; tenas y millares
                Puly                          ; Desapilar direccion Datos_BIN
                Ldaa CONT
                Movw ACC,A,Y                  ; Guardar resultado en Datos_BIN
                Pshy                          ; Reapilar direccion Datos_BIN
                Adda #2
                Staa CONT
                Lsra
                Cmpa CANT
                Bne Loop
                Staa CONT
                Leas -4,SP                    ; Reestablecer direccion de retorno
                Rts

;*******************************************************************************
;                               SUBRUTINA MOVER
;*******************************************************************************

MOVER           Ldaa 0                        ; Guardar CANT en la pila
Loop_2          Ldab 1,X+
                Ldy #Nibble_UP
                Stab A,Y
                Ldab 0,X
                Psha                          ; Guardar contador en la pila
                Ldaa #4
Nibb_MED        Tsta
                Bne ShiftR_3
                Pula                          ; Reestablecer contador
                Ldy #Nibble_MED
                Stab A,Y
                Bra Nibb_LOW
ShiftR_3        Lsrb
                Deca
                Bra Nibb_MED
Nibb_LOW        Ldab 1,X+
                Andb #$0F                     ; Obtener la parte baja
                Ldy #Nibble_LOW
                Stab A,Y
                Inca
                Cmpa CANT                     ; para comparar con CANT
                Bne Loop_2
                Rts

;*******************************************************************************
;                               SUBRUTINA IMPRIMIR
;*******************************************************************************

IMPRIMIR        Ldx #0
                Clra
                Ldab CONT
                Pshd
                Ldd #MSG2
                Jsr [Printf,X]
                Ldx #0
                Ldd #MSG3
                Jsr [Printf,X]
                Ldy #Nibble_UP
                Jsr IMPRIMIR_TABLA
                Ldy #Nibble_MED
                Jsr IMPRIMIR_TABLA
                Ldy #Nibble_LOW
                Jsr IMPRIMIR_TABLA
                
                
;*******************************************************************************
;                       SUBRUTINA IMPRIMIR_TABLA
;*******************************************************************************

IMPRIMIR_TABLA  Clra
        	Ldx #0
        	Ldy CANT     		      ; Apunta al último elemento
        	Dey
Loop_3  	Ldaa 0,Y
        	Psha
        	Dey            		      ; Avanzar hacia el anterior
        	Decb
        	Bne Loop_3

Loop_4  	Ldd #MSG6          	      ; Carga mensaje base
        	Jsr [Printf,X]

        	Dey
        	Cpy #0
        	Bne Comma          ; Si no llegó a 0, imprime coma y repite

        	Ldx #0             ; Reinicia X a 0
        	Ldd #MSG6
        	Jsr [Printf,X]

        	Puld
        	Rts                ; Termina la rutina

Comma   	Ldd #MSG7          ; Carga mensaje con la coma (", ")
        	Jsr [Printf,X]
        	Bra Loop_4         ; Vuelve a imprimir siguiente valor



                
                
                
                
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
        
CRLF:   db CR,LF

                ORG $1500
Datos_IoT:      db $32,$37,$35,$35,$32,$37,$35,$35

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
                ;Ldy #Datos_BIN
                ;Jsr MOVER
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

ASCII_BIN       Leas 2,SP                        ; Saltar la direccion de retorno
		Pulx                          ; Desapilar direccion Datos_IoT
                Movb #0,CONT
                Movb #0,ACC
                Movb #0,Offset
Loop		Ldaa Offset
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
                Ldaa #0
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
                Leas -2,SP
                Rts

;*******************************************************************************
;                               SUBRUTINA MOVER
;*******************************************************************************

MOVER           Ldaa CANT                     ; Guardar CANT en la pila
                Psha
Loop_2          Ldaa CANT
                Ldab A,X
                Anda $0F
                Ldy #Nibble_UP
                Stab A,Y
                Inca
                Staa CANT                     ; Usar CANT como indice
                Ldab A,X
                Andb $F0                      ; Obtener la parte alta
                Ldaa #4
Nibb_MED        Tsta
                Bne ShiftR_3
                Ldy #Nibble_MED
                Stab A,Y
                Bra Nibb_LOW
ShiftR_3        Lsrb
                Decb
                Bra Nibb_MED
Nibb_LOW        Ldaa CANT
                Ldab A,X
                Andb $0F                      ; Obtener la parte baja
                Ldy #Nibble_LOW
                Stab A,Y
                Pula
                Psha
                Cmpb CANT
                Bne Loop_2
                Rts

;*******************************************************************************
;                               IMPRIMIR
;*******************************************************************************

IMPRIMIR        Ldy #0
                
                
                
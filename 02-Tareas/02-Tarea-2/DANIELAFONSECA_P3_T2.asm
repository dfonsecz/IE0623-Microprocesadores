;*******************************************************************************
;                               PROGRAMA CONVERSIONES
;*******************************************************************************
;       Version: 1.0
;       Autor: Daniela Fonseca Zumbado
;
; Descripcion: Este programa toma un binario de 12 bits constante, que se en-
; cuentra en la direccion Binario, y hace la conversion a BCD, utilizando el
; algoritmo XS3. El resultado lo guarda en la direccion Num_BCD. Posteriormente,
; toma un valor constante en BCD, que se encuentra en la direccion BCD, y lo
; convierte en su valor binario correspondiente, con el metodo de multiplicacion
; de decadas y suma. El resultado de esta conversion la guarda en la direccion
; Num_BIN.
;
;...............................................................................
;
;*******************************************************************************
;                       DECLARACION DE ESTRUCTURAS DE DATOS
;*******************************************************************************

        ORG $1000
Binario:   dw $0234
BCD:       dw $9999

        ORG $1010
Num_BCD:   ds 2

        ORG $1020
Num_BIN:   ds 2

        ORG $1030
BCD_L:     ds 1                 ; Variable para parte baja de un numero de 16b
BCD_H:     ds 1                 ; Variable para parte alta de un numero de 16b
Temp:      ds 2


;...............................................................................
;
;*******************************************************************************
;                               PROGRAMA PRINCIPAL
;*******************************************************************************

                ORG $2000
                Lds #$3FFF
                Ldd Binario
                Jsr BIN_BCD
                Ldd BCD
                Jsr BCD_BIN
                Bra *

BIN_BCD         Clr BCD_L
                Clr BCD_H
                Clr Num_BCD
                Ldx #4
ShiftL_4b       Cpx #0                  ; Despues de hacer shift izq por 4 bits,
                Beq Algoritmo           ; continuar a Algoritmo
                Lsld
                Dex
                Bra ShiftL_4b           ; Regresar al inicio del ciclo
Algoritmo       Ldx #12                 ; Se debe hacer shift por 12 bits
Ciclo_BIN_BCD   Lsld
                Rol BCD_L
                Rol BCD_H
                Std Temp
Eval_Nib1       Ldaa BCD_L              ; Evaluar el nibble menos significa-
                Anda #$0F               ; tivo de variable con la parte baja
                Cmpa #$05               ; Si (A)>=5, sumar 3 al nibble, sino
                Bcs Eval_Nib2           ; continuar con la evaluacion del si-
                Adda #$03               ; guiente nibble
Eval_Nib2       Ldab BCD_L              ; Evaluar el nibble mas significativo
                Andb #$F0               ; de la variable con la parte baja
                Cmpb #$50
                Bcs Sum_Nib_1_2
                Addb #$30
Sum_Nib_1_2     Aba                     ; Sumar msb con lsb
                Staa BCD_L              ; Reemplazar variable con la parte baja
Eval_Nib3       Ldaa BCD_H              ; Evaluar el nibble menos significa-
                Anda #$0F               ; tivo de la variable con la parte alta
                Cmpa #$05
                Bcs Eval_Nib4
                Adda #$03
Eval_Nib4       Ldab BCD_H              ; Evaluar el nibble mas significativo
                Andb #$F0               ; de la variable con la parte alta
                Cmpb #$50
                Bcs Sum_Nib_3_4
                Addb #30
Sum_Nib_3_4     Aba                     ; Sumar msb con lsb
                Staa BCD_H              ; Reemplazar variable con la parte alta
                Dex
		Tfr X,A
                Tsta
                Beq Fin_BIN_BCD
                Ldd Temp
                Bra Ciclo_BIN_BCD       ; Regresar al inicio del ciclo
Fin_BIN_BCD     Ldaa BCD_H
                Ldab BCD_L
                Std Num_BCD             ; Guardar resultado en espacio asignado
                Rts

BCD_BIN         Staa BCD_H
                Stab BCD_L
                Clr Num_BIN
                Clra
                Ldab BCD_L
                Andb #$0F               ; Evaluar los 4 lsb de la parte baja
                Std Num_BIN             ; Guardar el resultado de unidades
                Ldab BCD_L
                Andb #$F0               ; Evaluar los 4 msb de la parte baja
                Ldaa #4
ShiftR_C_4b     Lsrb
                Deca
                Tsta
                Bne ShiftR_C_4b
                Ldy #10
                Emul
                Addd Num_BIN
                Std Num_BIN             ; Guardar el resultado de decenas
                Clra
                Ldab BCD_H
                Andb #$0F               ; Evaluar los 4 lsb de la parte alta
                Ldy #100
                Emul
                Addd Num_BIN
                Std Num_BIN             ; Guardar el resultado de centenas
                Ldab BCD_H
                Andb #$F0               ; Evaluar los 4 msb de la parte alta
                Ldaa #4
ShiftR_M_4b     Lsrb
                Deca
                Cmpa #0
                Bne ShiftR_M_4b
                Ldy #1000
                Emul
                Addd Num_BIN
                Std Num_BIN             ; Guardar el resultado de millares
                Rts
                
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
Binario:   dw $0FA5
BCD:       dw $5555

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
Conversiones    Ldd Binario
                Jsr BIN-BCD
                Ldd BCD
                Jsr BCD-BIN
                Bra *

BIN-BCD         Clr BCD_L
                Clr BCD_H
                Clr Num_BCD
                Ldx #4
ShiftL-4b       Cpx #0                  ; Despues de hacer shift izq por 4 bits,
                Beq Algoritmo           ; continuar a Algoritmo
                Lsld
                Std Temp
                Tfr X,A
                Suba #1
                Tfr A,X
                Ldd Temp
                Bra ShiftL-4b           ; Regresar al inicio del ciclo
Algoritmo       Ldx #12                 ; Se debe hacer shift por 12 bits
Ciclo-BIN-BCD   Lsld
                Rol BCD_L
                Rol BCD_H
                Std Temp
Eval-Nib1       Ldaa BCD_L              ; Evaluar el nibble menos significa-
                Anda #$0F               ; tivo de variable con la parte baja
                Cmpa #$05               ; Si (A)>=5, sumar 3 al nibble, sino
                Beq Eval-Nib2           ; continuar con la evaluacion del si-
                Adda #$03               ; guiente nibble
Eval-Nib2       Ldab BCD_L              ; Evaluar el nibble mas significativo
                Andb #$F0               ; de la variable con la parte baja
                Cmpb #$50
                Beq Sum-Nib-1-2
                Addb #$30
Sum-Nib-1-2     Aba
                Staa BCD_L              ; Reemplazar variable con la parte baja
Eval-Nib3       Ldaa BCD_H              ; Evaluar el nibble menos significa-
                Anda #$0F               ; tivo de la variable con la parte alta
                Cmpa #$05
                Beq Eval-Nib4
                Adda #$03
Eval-Nib4       Ldab BCD_H              ; Evaluar el nibble mas significativo
                Andb #$F0               ; de la variable con la parte alta
                Cmpb #$50
                Beq Sum-Nib-3-4
                Addb #30
Sum-Nib-3-4     Aba
                Staa BCD_H              ; Reemplazar variable con la parte alta
                Tfr X,A
                Suba #1
                Cmpa #0
                Beq Fin-BIN-BCD
                Tfr A,X
                Ldd Temp
                Bra Ciclo-BIN-BCD       ; Regresar al inicio del ciclo
Fin-BIN-BCD     Ldaa BCD_H
                Ldab BCD_L
                Std Num_BCD             ; Guardar resultado en espacio asignado
                Rts

BCD-BIN         Staa BCD_H
                Stab BCD_L
                Clr Num_BIN

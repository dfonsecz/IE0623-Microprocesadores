;**************************************************************************
;                       Programa ORDENE 3
;**************************************************************************
;               v2.0
;               AUTOR: GDELGADO
;
; Descripcion: Este es un programa que ordena tres datos, de mayor a menor,
; ubicados en las variables U, V y W. Los datos ordenados quedan en las
; direcciones R, S y T , siendo que el mayor queda en T. Se requiere de una
; posicion temporal denominada TEMP
;..........................................................................
;..........................................................................
;                       DECLARACION DE ESTRUCTURAS DE DATOS
;..........................................................................

        ORG $1000
U:          db $12      ; Variables con los datos a ordenar
V:          db $94
W:          db $56
Temp:       ds 1

        ORG $1010
R:          ds 1        ; Variables ordenadas en el orden RST
S:          ds 1
T:          ds 1
;..........................................................................

;**************************************************************************
;                       PROGRAMA PRINCIPAL
;**************************************************************************

        ORG $1100
            Ldaa U
            Cmpa V      ; se compara U con V
            Blt U_Menor
            Staa S      ; U es mayor: se guarda (U) en S
            Ldaa V
            Staa R      ; U es mayor: se guarda (V) en R
            Bra W_con_S
U_menor     Staa R      ; U es menor: se guarda (U) en R
            Ldaa V
            Staa S      ; U es menor: se guarda (V) en S
W_con_S     Ldaa W
            Cmpa S      ; se compara W con S
            Blt W_menor
            Staa T      ; W es mayor: se guarda (W) en T
            Bra Fin
W_Menor     Ldaa S      ; W es menor: se guarda (S) en T
            Staa T
            Ldaa W
            Staa S      ; W es menor: se guarda (W) en S
            Cmpa R      ; Se compara S con R
            Bge Fin
            Ldaa R
            Staa Temp   ; S es menor: se guarda (R) en TEMP
            Ldaa S
            Staa R      ; se guarda (S) en R
            Ldaa Temp
            Staa S      ; se guarda (TEMP) en S
            
Fin         Bra *       ; Fin del programa
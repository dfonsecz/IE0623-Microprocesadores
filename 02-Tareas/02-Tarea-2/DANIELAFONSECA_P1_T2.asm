;*******************************************************************************
;                               PROGRAMA DIVISOR
;*******************************************************************************
;       Version: 1.0
;       Autor: Daniela Fonseca Zumbado
;
; Descripcion: Este programa recorre una tabla contenida a partir de la direc-
; cion Datos, de tamano variable almacenado en Long. El programa verifica si los
; valores almacenados en la tabla Datos son divisibles por 4, y en el caso de
; que lo sean, los almacena en otra tabla contenida a partir de la direccion
; Div_4. Ademas, lleva cuenta de la cantidad de elementos de Datos que son di-
; visibles por 4.
;
;...............................................................................
;
;*******************************************************************************
;                       DECLARACION DE ESTRUCTURAS DE DATOS
;*******************************************************************************

        ORG $1000
Long:      ds 1
Cant_4:    ds 1

        ORG $1100
Datos:     db $68, $34, $52, $70, $90, $63, $23, $FA, $C8, $0C

        ORG $1200
Div_4:     ds 255               ; La tabla de Datos tiene menos de 255 elemen-
                                ; tos, por lo que el maximo de elementos de
                                ; Div_4 es el mismo
                                
;...............................................................................
;
;*******************************************************************************
;                               PROGRAMA PRINCIPAL
;*******************************************************************************

                ORG $2000
Divisor         Ldx #Datos
                Ldy #Div_4
                Clr Cant_4
                Movb #10, Long          ; Inicializar variable Long
                Clrb
Ciclo           Tst Long                ; Si (Long)=0, terminar el programa
                Beq Fin
                Ldaa 1,X+
                Dec Long                ; Decrementar Long progresivamente
                Anda #$03               ; Evaluar los 2 lsb
                Tsta                    ; Si los 2 lsb son 0, el numero es mul-
                Bne Ciclo               ; tiplo de 4 y se guarda en Div_4
                Movb -1,X, B,Y          ; Guardar el valor divisible por 4 en la
                Addb #1                 ; tabla sin modificar la direccion en Y
                Inc Cant_4
                Bra Ciclo
Fin             Bra *
                
                
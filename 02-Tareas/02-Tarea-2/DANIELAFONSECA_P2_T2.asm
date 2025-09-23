;*******************************************************************************
;                               PROGRAMA SELECTOR
;*******************************************************************************
;       Version: 1.0
;       Autor: Daniela Fonseca Zumbado
;
; Descripcion: Este programa recorre dos tablas, Datos y Mascaras, de tamanos
; variables, que pueden ser diferentes, pero tienen al menos 1 y menos de 255
; elementos. La tabla Datos contiene numeros con signo entre -127 y +127, para
; la cual el valor de su ultimo elemento es $80. Por otra parte, la tabla Mas-
; caras contiene numeros sin signo, que representan mascaras que deben ser apli-
; cadas a los numeros en la tabla de Datos. Se realiza un barrido de XOR del
; ultimo numero con la primera mascara, el penultimo numero con la segunda mas-
; cara, y asi consecutivamente hasta procesar todos los datos, hasta que se
; acabe alguna de las tablas. Por ultimo, se agregan los resultados que hayan
; sido negativos en una tabla dada a partir de la direccion Puntero
;
;...............................................................................
;
;*******************************************************************************
;                       DECLARACION DE ESTRUCTURAS DE DATOS
;*******************************************************************************

        ORG $1000
Puntero:   ds 2

        ORG $1050
Datos:     db $E5, $D8, $A0, $47, $80

        ORG $1150
Mascaras:  db $FF, $AA, $55, $0F, $15, $FE
;...............................................................................
;
;*******************************************************************************
;                               PROGRAMA PRINCIPAL
;*******************************************************************************

                ORG $2000
                Ldx #Datos
                Ldy #Mascaras
                Movw #$1250,Puntero
Ult_Mascara     Ldaa 1,X+               ; Encontrar ultima mascara
                Cmpa #$80
                Bne Ult_Mascara
Ciclo           Ldab 1,Y+
                Cmpb #$FE               ; Si llega al fin de Mascaras,
                Beq Fin                 ; terminar programa
                Dex
                Cpx #Datos              ; Si llega al inicio de Datos,
                Beq Fin                 ; terminar programa
                Ldaa -1,X
                Eora -1,Y               ; Aplicar mascara con XOR
                Cmpa #0
                Bge Ciclo               ; Si (A)>=0, omitir resultado
                Tfr Y,B
                Ldy Puntero             ; Guardar resultado de aplicar mascaras
                Staa 1,Y+               ; en la direccion de puntero
                Sty Puntero
                Ldaa #$11
                Exg D,Y
                Bra Ciclo               ; Pasar a siguiente iteracion

Fin             Bra *                   ; Terminar programa
                
        
        
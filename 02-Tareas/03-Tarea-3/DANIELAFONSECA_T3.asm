;*******************************************************************************
;                       	TAREA 3
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
        ORG $1000
CANT:   ds 1            ; Cantidad de elementos a recorrer

        ORG $1030
MSG:    FCC "INGRESE UN VALOR (ENTRE 0 Y 50): "
;...............................................................................
;
;*******************************************************************************
;                              PROGRAMA
;*******************************************************************************
        	ORG $2000
        	
GET_CANT	Lds #$3BFF                    ; Subrutina
        	Ldx #0
        	Ldd #MSG
        	Jsr [Printf,X]
ObtenerChar1	Ldx #0
                Jsr [GetChar,X]               ; Leer valor de botones
                Cmpb #$30                     ; Comparar entrada con 0 en ASCII
                Bcs ObtenerChar1
                Cmpb #$39                     ; Comparar entrada con 9 en ASCII
                Bcs ObtenerChar1
                Subb #30                      ; Obtener valor del digito
                Ldaa #$10
                Mul                           ; Multiplicar 10*Caracter
                Stab CANT
                Ldx #$0
                Clra
                Jsr [PutChar,X]               ; Escribir valor en terminal
ObtenerChar2    Ldx #$0
                Jsr [GetChar,X]               ; Leer valor de botones
                Cmpb #$30                     ; Comparar entrada con 0 en ASCII
                Bcs ObtenerChar2
                Cmpb #$39                     ; Comparar entrada con 9 en ASCII
                Bcs ObtenerChar2
                Subb #30                      ; Obtener valor del digito
                Ldaa #$10
                Mul                           ; Multiplicar 10*Caracter
                Stab CANT
                Ldx #$0
                Clra
                Jsr [PutChar,X]               ; Escribir valor en terminal
                Cmpb #1                       ; Si el valor es menor a 1,
                Bcs ObtenerChar1              ; volver a leer caracteres
                Cmpb #50                      ; Si el valor es mayor a 50,
                Bcs ObtenerChar1              ; volver a leer caracteres
                Rts
                
                
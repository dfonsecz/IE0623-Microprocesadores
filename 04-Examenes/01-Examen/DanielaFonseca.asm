;*******************************************************************************
;                      I EXAMEN PARCIAL - ALGORITMO ORDENA
;*******************************************************************************
;               Autor: Daniela Fonseca Zumbado
;               Version: 1.0
;               Algoritmo disenado por: Geovanny Delgado
;               Fecha de realizacion: 4 de Octubre de 2025
;
; Descripcion: Este programa procesa una tabla DATOS_BCD que contiene datos de
; 1 byte en BCD. Coloca en las primers posiciones de un arreglo ORDENADOS los
; valores binarios que, siendo pares, son mayores o iguales a 50, y en las si-
; guientes posiciones, los valores que, siendo impares son menores que 50
;
;*******************************************************************************
;             		DECLARACION DE ESTRUCTURAS DE DATOS
;*******************************************************************************

        	ORG $1000
BANDERAS:       ds 1                     ; Variable que contiene las banderas
OFFSET:         ds 1                     ; Variable usada como almacenamiento
                                         ; temporal

                ORG $1020
ORDENADOS:      ds 10

                ORG $1010
Datos_BCD:      db $78,$96,$67,$55,$23,$31,$25,$46,$18,$50,$15,$FF

PAR:                                    ; Bandera

;...............................................................................
;*******************************************************************************
;                       	PROGRAMA ORDENA
;*******************************************************************************

        ORG $2000
Ordena  Lds #$4000
        Ldy #ORDENADOS                  ; Direccion a arreglo de datos ordenados
        Ldx #Datos_BCD                  ; Direccion de arreglo que evaluar
        Ldab #0
        BSet BANDERAS,$01               ; CORREGIR CON ETIQUETA
Ciclo   Ldaa B,X                        ; Cargar el valor actual de Datos_BCD
        Incb
        Stab OFFSET
        Cmpa #$FF                       ; Revisar si es el fin de Datos_BCD
        Beq SiFin
        Jsr BCDaBin
        BrSet BANDERAS,$01,SiPar
        Bita #$01                       ; Evalua si es impar
        Beq SOffset
        Cmpa #50                        ; Si es menor a 50, descartar
        Bhs SOffset
        Bra Guardar
SiPar   Bita #$01
        Bne SOffset
        Cmpa #50
        Blo SOffset
Guardar Staa 1,Y+
SOffset Ldab OFFSET
        Bra Ciclo
SiFin	BrClr BANDERAS,$01,Fin
	BClr BANDERAS,$01
        Ldab #0
        Bra Ciclo
Fin     Bra *
        
;*******************************************************************************
;                              SUBRUTINA BCDaBIN
;
; Descripcion: Esta subrutina convierte un byte de BCD a binario
;*******************************************************************************

BCDaBIN Psha
        Anda #$F0                       ; Obtener la parte alta del byte
        Lsra                            ; Decenas*8
        Tab                             ; Mover dato al otro acumulador
        Lsrb                            ; Decenas*4
        Lsrb
        Aba                             ; Decenas*2
        Pulb
        Andb #$0F                       ; Obtener la parte baja del byte
        Aba
        Rts
;...............................................................................
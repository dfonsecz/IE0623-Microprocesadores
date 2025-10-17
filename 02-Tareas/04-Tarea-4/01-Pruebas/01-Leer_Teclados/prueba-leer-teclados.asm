;*******************************************************************************
;                       PRUEBA: SUBRUTINA Leer_Teclado
;*******************************************************************************
#include registers.inc

;*******************************************************************************
;                   DECLARACION DE LAS ESTRUCTURAS DE DATOS
;*******************************************************************************
        ORG $1001
Tecla:  ds 1

        ORG $1004
Patron: ds 1

        ORG $1020
Teclas: db $1,$2,$3
        db $4,$5,$6
        db $7,$8,$9
        db $B,$0,$E
        
;*******************************************************************************
;                               PROGRAMA PRINCIPAL
;*******************************************************************************

                ORG $2000
Main            Movb #$F0,DDRA
		Jsr Leer_Teclado
                ;Ldy #0
                ;Ldd Tecla
                ;Jsr [PutChar,X]
                Bra Main

;*******************************************************************************
;                             SUBRUTINA: Leer_Teclado
;*******************************************************************************

Leer_Teclado    Clra
                Movb #$EF,Patron                ; Patron 11101111 para puerto A
                Ldx #Teclas                     ; Direccion de tabla Teclas
Cont_Lectura    Movb Patron,PORTA               ; Escribir Patron en puerto A
		BrClr PORTA,#$01,Obt_Tecla       ; Si el bit 0 de PORTA es 0,
                Inca                            ; el btn esta en la 1er columna
                BrClr PORTA,#$02,Obt_Tecla       ; Si el bit 1 de PORTA es 0,
                Inca                            ; el btn esta en la 2da columna
                BrClr PORTA,#$04,Obt_Tecla       ; Si el bit 2 de PORTA es 0,
                Inca                            ; el btn esta en la 2da columna
                Ldab Patron
                Cmpb #$7F                       ; Si Patron llega a 01111111,
                Beq Clr_Tecla                   ; no se presiono ninguna tecla
                Sec                             ; Cargar carry = 1
                Rol Patron                      ; Rotar a la izquierda
                Bra Cont_Lectura
Clr_Tecla       Movb #$FF,Tecla                 ; Limpiar valor de Tecla
                Bra Rt_Leer_Teclado
Obt_Tecla       Movb A,X,Tecla
Rt_Leer_Teclado Rts

       
# Tarea #4

## Arquitectura de Hardware

Se implementa un teclado con la matriz de botones de la Dragon 12+. Para esto se tienen en cuenta las siguientes consideraciones:
- En todo momento se dispone de los LEDs menos significativos, etiquetados como **PB3-PB0**, para indicar cuál función está activa.
- Se utiliza el botón etiquetado como **PH0** para borrar la secuencia de teclas ingresada en cualquier momento, mediante un *LongPress* de dicho botón. Al presionar el botón se borra **NUM_Array** y la bandera **ArrayOK**, dejando el programa listo para el ingreso de una nueva secuencia de teclas.
- Un *ShortPress* de **CLEAR** encenderá el LED **PORTB.6**, mientras que una acción de borrado lo apagará.
- Se crea una subrutina llamada **Borrar_Num_Array** que borra el arreglo utilizando direccionamiento indexado de post incremento. Esta subrutina borrará el arreglo cuyo tamaño está definido en la constante **MAX_TCL**.

## Arquitectura de Software

- Para el ingreso de una secuencia de teclas válida, el programa utiliza una tabla denominada Teclas que contendrá: **$01, $02, ..., $08, $09, $0B, $00 y $0E**, en ese orden. El valor **$0B** es el código asignado para la tecla B (borrar) y el valor **$0E** es el valor asignado para la tecla (enter).
- La tabla **Teclas** es accesada por direccionamiento indexado por acumulador, donde la dirección base es **Teclas** y el offset está definido por la tecla presionada.
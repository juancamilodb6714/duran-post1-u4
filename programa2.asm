; programa2.asm - Laboratorio Post2 Unidad 4

%include "macros.asm"               ; incluir biblioteca de macros utilitarias

section .data
    titulo      db "=== Macros y Control de Flujo ===", 0Dh, 0Ah, 24h
    linea_a     db "[Linea A] Primera impresion", 0Dh, 0Ah, 24h
    linea_b     db "[Linea B] Segunda impresion", 0Dh, 0Ah, 24h
    msg_mayor   db "El valor mayor es: ", 24h
    msg_iguales db "Los valores son iguales.", 0Dh, 0Ah, 24h
    msg_fin     db "Fin del programa.", 0Dh, 0Ah, 24h

section .bss
    valor_a     resw 1
    valor_b     resw 1

section .text
    global main

main:
    mov ax, seg titulo              ; segmento de datos (NASM no reconoce @data)
    mov ds, ax

    ; Demostracion de macros sin parametros
    print_str titulo                ; expansion: mov ah,09h / mov dx,titulo / int 21h

    ; Demostracion de macro repetir_str
    repetir_str linea_a, 3          ; imprimir linea_a exactamente 3 veces
    repetir_str linea_b, 2          ; imprimir linea_b exactamente 2 veces

    fin_dos                         ; terminar programa

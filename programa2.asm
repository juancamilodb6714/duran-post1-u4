; programa2.asm - Laboratorio Post2 Unidad 4

%include "macros.asm"               ; incluir biblioteca de macros utilitarias

section .data
    titulo      db "=== Macros y Control de Flujo ===", 0Dh, 0Ah, 24h
    linea_a     db "[Linea A] Primera impresion", 0Dh, 0Ah, 24h
    linea_b     db "[Linea B] Segunda impresion", 0Dh, 0Ah, 24h
    msg_mayor   db "El valor mayor es: ", 24h
    msg_iguales db "Los valores son iguales.", 0Dh, 0Ah, 24h
    msg_fin     db "Fin del programa.", 0Dh, 0Ah, 24h
    separador_corto db "---", 0Dh, 0Ah, 24h
    msg_menor_igual db "AX es menor o igual: ", 24h
    msg_mayor2      db "AX es mayor: ", 24h

section .bss
    valor_a     resw 1
    valor_b     resw 1

section .text
    global main

main:
    mov ax, seg titulo              ; segmento de datos (NASM no reconoce @data)
    mov ds, ax

    ; 1. Encabezado con macro
    print_str titulo

    ; 2. Demostracion de repetir_str
    repetir_str linea_a, 3

    ; 3. Suma 1+2+3 = 6
    mov cx, 3
    call sumar_serie                ; AX = 6
    push ax                         ; guardar AX, INT 21h 09h cambia AL
    print_str msg_mayor
    pop ax
    print_digito                    ; imprime "6"
    nueva_linea

    ; 4. Comparar 9 vs 4 -> mayor es 9
    mov ax, 9
    mov bx, 4
    call comparar_e_imprimir

    ; 5. Comparar 5 vs 5 -> iguales
    mov ax, 5
    mov bx, 5
    call comparar_e_imprimir

    ; 7. Bloque decorativo desenrollado con %rep (3 copias)
    bloque_decorativo 3

    ; 8. Comparacion con condicion JLE, reutilizando macros existentes
    mov ax, 3
    mov bx, 8
    call comparar_menor_o_igual     ; imprime: "AX es menor o igual: 3"

    ; 6. Mensaje final y terminacion
    print_str msg_fin
    fin_dos

; Procedimiento: suma acumulativa 1+2+3+...+N
; Entrada: CX = N (numero de iteraciones)
; Salida: AX = suma total
sumar_serie:
    push cx                         ; preservar CX (se modifica con LOOP)
    xor ax, ax                      ; AX = 0 (acumulador)
.paso:
    add ax, cx                      ; AX += CX (suma N, N-1, ..., 1)
    loop .paso                      ; CX--; si CX != 0, continuar
    pop cx                          ; restaurar CX original
    ret

; Procedimiento: comparar AX y BX e imprimir el mayor
; Modifica: AH, DX (los preserva en la pila)
comparar_e_imprimir:
    push ax
    push bx

    cmp ax, bx                      ; actualiza flags: AX - BX (sin modificar operandos)
    je  .son_iguales                ; si AX == BX (ZF=1)
    jg  .ax_mayor                   ; si AX > BX con signo (SF=OF, ZF=0)

    ; Caso: BX es mayor
    print_str msg_mayor             ; imprimir etiqueta
    mov al, bl                      ; AL = valor de BX
    print_digito                    ; imprimir digito
    nueva_linea
    jmp .fin_comp

.ax_mayor:
    push ax                         ; guardar AX, INT 21h 09h cambia AL
    print_str msg_mayor
    pop ax
    print_digito                    ; AX sigue en AL desde el push (se restaura despues)
    nueva_linea
    jmp .fin_comp

.son_iguales:
    print_str msg_iguales

.fin_comp:
    pop bx
    pop ax
    ret

; Procedimiento: comparar AX y BX e indicar si AX es menor o igual, o mayor
; Reutiliza las macros print_str, print_digito y nueva_linea de macros.asm; a diferencia
; de comparar_e_imprimir (que decide con JE/JG), aqui la decision se toma con JLE
comparar_menor_o_igual:
    push ax
    push bx

    cmp ax, bx                      ; actualiza flags: AX - BX
    jle .menor_o_igual              ; si AX <= BX (con signo)

    push ax                         ; guardar AX, INT 21h 09h cambia AL
    print_str msg_mayor2
    pop ax
    print_digito
    jmp .fin_cmp2

.menor_o_igual:
    push ax                         ; guardar AX, INT 21h 09h cambia AL
    print_str msg_menor_igual
    pop ax
    print_digito

.fin_cmp2:
    nueva_linea
    pop bx
    pop ax
    ret

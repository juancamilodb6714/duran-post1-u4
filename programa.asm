; programa.asm - Laboratorio Post1 Unidad 4
; Proposito: demostrar directivas de seccion, datos y constantes en NASM

; -- Constantes (EQU, no reservan memoria) ------------------------------------
CR          EQU 0Dh                 ; Carriage Return
LF          EQU 0Ah                 ; Line Feed
TERMINADOR  EQU 24h                 ; "$" terminador de cadena para DOS
ITERACIONES EQU 5                   ; numero de repeticiones del bucle

; -- Datos inicializados ------------------------------------------------------
section .data
    bienvenida  db "=== Laboratorio NASM - Unidad 4 ===", CR, LF, TERMINADOR
    separador   db "----------------------------------------", CR, LF, TERMINADOR
    linea_gruesa:
        TIMES 40 DB '='             ; repite el byte '=' 40 veces en tiempo de ensamblado
                 DB CR, LF, TERMINADOR
    etiqueta_a  db "Variable A (word): ", TERMINADOR
    etiqueta_b  db "Variable B (dword): ", TERMINADOR
    fin_msg     db "Programa finalizado correctamente.", CR, LF, TERMINADOR

    ; Tipos de datos demostrados
    var_byte    db 42               ; 1 byte con valor 42
    var_word    dw 1234h            ; 2 bytes con valor 0x1234
    var_dword   dd 0DEADBEEFh       ; 4 bytes
    tabla_bytes db 10, 20, 30, 40, 50 ; 5 bytes consecutivos

; -- Datos no inicializados ---------------------------------------------------
section .bss
    buffer      resb 80             ; 80 bytes para entrada (no usada aun)
    resultado   resw 1              ; 1 word para almacenar calculo

; -- Codigo ejecutable --------------------------------------------------------
section .text
    global main

main:
    ; Inicializar registro de segmento de datos
    mov ax, seg bienvenida          ; valor del segmento .data (NASM no reconoce @data)
    mov ds, ax                      ; DS apunta a la seccion de datos

    ; Imprimir mensaje de bienvenida
    mov ah, 09h                     ; funcion DOS: imprimir cadena
    mov dx, bienvenida              ; DX = direccion del mensaje
    int 21h                         ; llamar a DOS

    mov dx, separador
    int 21h

    ; === Funcion 09h: imprimir cadenas ===
    mov ah, 09h
    mov dx, etiqueta_a
    int 21h

    ; === Funcion 02h: imprimir un caracter ===
    ; Imprimir el valor de var_word como dos digitos hexadecimales
    mov al, [var_byte]              ; AL = 42 (0x2A)
    add al, 30h                     ; convertir a ASCII: 42 + 48 = 90 ("Z") - solo para demo
    mov ah, 02h                     ; funcion DOS: imprimir caracter en DL
    mov dl, al
    int 21h

    ; Imprimir nueva linea
    mov ah, 02h
    mov dl, CR
    int 21h
    mov dl, LF
    int 21h

    ; === Recorrer tabla de bytes e imprimir cada elemento ===
    lea si, tabla_bytes             ; SI apunta al inicio de la tabla
    mov cx, ITERACIONES             ; CX = 5 iteraciones

imprimir_tabla:
    mov al, [si]                    ; AL = byte actual de la tabla
    add al, 30h                     ; conversion simple a ASCII (valida para 0-9)
    mov ah, 02h
    mov dl, al
    int 21h

    mov ah, 02h                     ; imprimir espacio entre elementos
    mov dl, 20h
    int 21h

    inc si                          ; avanzar al siguiente byte
    loop imprimir_tabla             ; CX--; si CX != 0, repetir

    ; Imprimir nueva linea despues de la tabla
    mov ah, 02h
    mov dl, CR
    int 21h
    mov dl, LF
    int 21h

    ; Imprimir mensaje final
    mov ah, 09h
    mov dx, fin_msg
    int 21h

    ; === Linea decorativa generada con TIMES ===
    mov ah, 09h
    mov dx, linea_gruesa
    int 21h

    ; Terminar el programa
    mov ax, 4C00h                   ; funcion DOS: terminar, codigo 0
    int 21h

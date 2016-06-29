

; Prints a character
; r0 - Screen Position
; r1 - Character
; r2 - Color
PrintChar:
    push r1 ; Caractere

    add r1, r1, r2 ; Adicionando cor
    outchar r1, r0 ; Printando caractere

    pop r1
rts

; Erases a character at given position
; r0 - Screen Position
EraseChar:
    push r1 ; ' '

    loadn r1, #' ' ; Espaço

    outchar r1, r0 ; Apagando o caractere

    pop r1
rts

; Prints a String
; r0 - Screen Position
; r1 - String Address
; r2 - Color
; r3 - Character to be skipped
PrintString:
    push r0 ; Screen Position
    push r1 ; String Address
    push r4 ; '\0'
    push r5 ; Caractere (auxiliar)

    loadn r4, #'\0' ; Terminador de String
    loadi r5, r1 ; Carregando um caractere da String

    cmp r5, r4 ; Comparando o caractere atual com o '\0'
    jeq PrintString_EndIf_1 ; if (r5 != '\0')
        PrintString_Loop: ; while (r5 != '\0')
            cmp r5, r3 ; Comparando com o caractere a ser pulado

            jeq PrintString_EndIf_2 ; if (r5 != r3)
                add r5, r5, r2 ; Adicionando cor ao caractere
                outchar r5, r0 ; Imprimindo o caractere
            PrintString_EndIf_2:

            inc r0 ; Inc Screen Position
            inc r1 ; Inc String Address

            loadi r5, r1 ; Carregando um caractere da string para a r4

            cmp r5, r4 ; Comparando com o '\0'
        jne PrintString_Loop
    PrintString_EndIf_1:

    pop r5
    pop r4
    pop r1
    pop r0
rts

; Prints the entire Screen
; r1 - Last String's Address
; r2 - Color
; r3 - Character to be skipped
PrintScreen:
    push r0 ; Screen Position
    push r1 ; String Address
    push r4 ; Screen Position decrement
    push r5 ; Address decrement

    loadn r0, #1200 ; Initial Screen Position
    loadn r4, #40 ; Screen Position decrement
    loadn r5, #41 ; Address decrement

    add r1, r1, r5 ; Inicializando r1 com 41 a mais

    PrintScreen_Loop: ; while (r0 != 0)
        sub r1, r1, r5 ; Dec Address
        sub r0, r0, r4 ; Dec Screen Positon
        call PrintString ; Imprimindo a linha
    jnz PrintScreen_Loop

    pop r5
    pop r4
    pop r1
    pop r0
rts

; Erases the entire Screen
EraseScreen:
    push r0 ; Screen Position
    push r1 ; ' '

    loadn r0, #1200
    loadn r1, #' '

    EraseScreen_Loop: ; while (r0 != 0)
        dec r0 ; Decrementando a posição da tela
        outchar r1, r0 ; Printando o espaço
    jnz EraseScreen_Loop

    pop r1
    pop r0
rts

; Paints the entire Screen
; r2 - Color
PaintScreen:
    push r0 ; Screen Position
    push r1 ; ' '

    loadn r0, #1200
    loadn r1, #' '

    add r1, r1, r2

    PaintScreen_Loop: ; while (r0 != 0)
        dec r0 ; Decrementando a posição da tela
        outchar r1, r0 ; Printando o espaço
    jnz PaintScreen_Loop

    pop r1
    pop r0
rts

; Delay de alguns milisegundos
Delay:
    push r0 ; For externo
    push r1 ; For interno

    loadn r0, #10000

    Delay_Loop1: ; while (r0 != 0)
        loadn r1, #10

        Delay_Loop2: ; while (r1 != 0)
            dec r1
        jnz Delay_Loop2

        dec r0
    jnz Delay_Loop1

    pop r1
    pop r0
rts

; Retorna pela pilha o caractere lido
; Para recuperar o caractere lido, use pop rX logo
; após a chamada da função.
; r6 - Seu conteúdo será perdido
; r7 - Seu conteúdo será perdido
GetChar:
    push r5 ; 0

    loadn r6, #255 ; Código enviado pelo teclado quando nenhuma tecla está pressionada
    loadn r5, #0 ; Código enviado quando nenhuma tecla está pressionada no início da execução

    ; Esperando apertar uma tecla
    ; Esperando enviar um código diferente de 0 e 255
    GetChar_Loop_1:
        inchar r7 ; Recebendo caractere
        cmp r7, r5 ; Comparando com 0
    jeq GetChar_Loop_1
        cmp r7, r6 ; Comparando com 255
    jeq GetChar_Loop_1

    ; Esperando soltar a tecla
    ; Esperando enviar o código 255
    GetChar_Loop_2:
        inchar r5 ; Recebendo caractere
        cmp r5, r6 ; Comparando com 255
    jne GetChar_Loop_2

    pop r5

    pop r6 ; Recuperando endereço de retorno
    push r7 ; Empilhando caractere lido
    push r6 ; Empilhando endereço de retorno
rts

; Recebe uma String de no máximo 40 caracteres
; r1 - String Address
; r2 - Max characters
ScanString:
    push r0 ; Character
    push r3 ; '\n'
    push r4 ; i
    push r5 ; Const Max String Size
    push r6 ; Auxiliar

    loadn r3, #13 ; Colocando o '\n' no r3 (13 == '\n')
    loadn r4, #0 ; int i
    loadn r5, #40 ; Tamanho horizontal máximo

    ScanString_Loop: ; while (r0 != '\n' && i != r2 && i != r5)
        call GetChar
        pop r0 ; Recuperando o caractere lido

        cmp r0, r3 ; Se for enter
    jeq ScanString_End ; if (r0 == '\n')

        add r6, r1, r4 ; r6 = r1 + i
        storei r6, r0 ; String[r6] = r0

        inc r4 ; i++

        cmp r4, r2 ; Verifica se r4 == r2
    jeq ScanString_End ; if (r0 == r2)
        cmp r4, r5 ; Verifica se r4 == 40
    jne ScanString_Loop

    ScanString_End:

    store WordSize, r4 ; Atualiza o tamanho da palavra

    ; Colocando o '\0'
    loadn r0, #'\0'
    add r6, r1, r4 ; r6 = r1 + i
    storei r6, r0 ; String[r6] = '\0'

    pop r6
    pop r5
    pop r4
    pop r3
    pop r0
rts

; ------- TABELA DE CORES -------
; Adicione ao caractere para imprimir com a cor correspondente

; 0 branco							0000 0000
; 256 marrom						0001 0000
; 512 verde							0010 0000
; 768 oliva							0011 0000
; 1024 azul marinho					0100 0000
; 1280 roxo							0101 0000
; 1536 teal							0110 0000
; 1792 prata						0111 0000
; 2048 cinza						1000 0000
; 2304 vermelho						1001 0000
; 2560 lima							1010 0000
; 2816 amarelo						1011 0000
; 3072 azul							1100 0000
; 3328 rosa							1101 0000
; 3584 aqua							1110 0000
; 3840 preto						1111 0000

; <  - E4
; >  - E6
; ^  - E8
; v  - E2
; \n - 0D


var nave_pos #1, #10 
Move_Nave:
    push r0
    push r1
    push r2
    push r3
    push r4

    load r0, nave_pos;dando load na posição da nave
    loadn r2, #1280;cor da nave
    inchar r1;lendo o teclado para se movimentar

    ;switch
    loadn r4, #'w'
    cmp r1, r4
    jeq nave_cima
    loadn r4, #'a'
    cmp r1, r4
    jeq nave_esqueda
    loadn r4, #'s'
    cmp r1, r4
    jeq nave_baixo
    loadn r4, #'d'
    cmp r1, r4
    jeq nave_direita
    jmp nave_default


    nave_cima:; W vai apra cim
        loadn r1, #' '
        call PrintChar
        loadn r3, #40
        sub r0, r0, r3
        jmp nave_default

    nave_esqueda:; A vai para esquerda
        loadn r1, #' '
        call PrintChar
        loadn r3, #1
        sub r0, r0, r3
        jmp nave_default

    nave_baixo:; S ir para baixo
        loadn r1, #' '
        call PrintChar
        loadn r3, #40
        add r0, r0, r3
        jmp nave_default

    nave_direita:; D ir para direita
        loadn r1, #' '
        call PrintChar
        loadn r3, #1
        add r0, r0, r3
        jmp nave_default
    nave_default:

    loadn r1, #'>'
    call PrintChar
    store nave_pos, r1

    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
rts

var tiro_pos #1 
var tiro_bool #0
Tiro:
    push r0
    push r1
    push r2
    push r3
    push r4

    loadn r2, #' ';carregando o r1 com a tecla que é o tiro
    inchar r1; lendo o teclado
    cmp r1, r2; comaprando se a tecla apertada e a tecla do tiro
    jne not_tiro; se nao for tiro pular para a proxima
        loadn r1, #1; carregando com 1 o r1
        store tiro_bool, r1; colcoando a flaq de tiro como 1
        load r1, nave_pos; carregando o r1 com a posição da nave para para gerar a posição do tiro 
        inc r1; gerando a poisçao do tiro
        store tiro_pos, r1; salvando a posição do tiro
    not_tiro:

    ;vendo se tem algum tiro ocorrendo
    load r1, tiro_bool
    loadn r2, #1
    cmp r1, r2
    jne not_ocorrendo_tiro

        load r0, tiro_pos;
        loadn r1, #'-'
        loadn r2, #10
        PrintChar

    not_ocorrendo_tiro:

    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
main:

    call EraseScreen
    loadn r0, #1;
    loadn r2, #0;

    Game_Loop:
        loadn r1, #10
        mod r1, r0, r1
        cmp r1, r2
        ceq Move_Nave

        loadn r1, #30 
        mod r1, r0, r1
        cmp r1, r2
        ceq Tiro

        call Delay
        inc r0
    jmp Game_Loop
   
halt

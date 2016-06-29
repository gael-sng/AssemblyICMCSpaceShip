
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

nave_pos: var #1
tiro_bool: var #1
; Função que move a nave do jogador
Move_Nave:
    push r0
    push r1
    push r2
    push r3
    push r4

    load r0, nave_pos; Carregando para um registrador a posição da nave
    inchar r1;lendo o teclado para se movimentar

    ;switch
    loadn r4, #' '
    cmp r1, r4
    jeq nave_tiro
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
        ;verificar se ele nao esta no topo da tela
        loadn r1, #40
        cmp r0, r1; r0 = posição atual da nave; r1 = 40
        jle nave_default; se a posição atual da nave for menor do que 40, ignorar o movimento
        
        loadn r1, #' '
        call PrintChar
        loadn r3, #40
        sub r0, r0, r3
        jmp nave_default

    nave_esqueda:; A vai para esquerda
        ; Verificando se ele nao esta na borda esquerda da tela
        loadn r1, #40;
        mod r1, r0, r1; r1 = r0 % r1; r1 = 40; r0 =  posição atual da nave 
        loadn r2, #0;
        cmp r1, r2; r1 = resultado do mod; r2 = 0
        jeq nave_default; Se o resultado do mod for 0 ignorar o movimento

        loadn r1, #' ';
        call PrintChar
        loadn r3, #1
        sub r0, r0, r3
        jmp nave_default

    nave_baixo:; S ir para baixo
        ;verificar se ele nao esta no fim da tela
        loadn r1, #1160
        cmp r0, r1; r0 = posição atual da nave; r1 = 40
        jeg nave_default; se a posição atual da nave for igual ou maior do que 1160, ignorar o movimento

        loadn r1, #' '
        call PrintChar
        loadn r3, #40
        add r0, r0, r3
        jmp nave_default

    nave_direita:; D ir para direita
        ; Verificando se ele nao esta na borda direita da tela
        loadn r1, #40;
        mod r1, r0, r1; r1 = r0 % r1; r1 = 39; r0 =  posição atual da nave 
        loadn r4, #39;
        cmp r1, r4; r1 = resultado do mod; r2 = 0
        jeq nave_default; Se o resultado do mod for 0 ignorar o movimento

        loadn r1, #' '
        call PrintChar
        loadn r3, #1
        add r0, r0, r3
        jmp nave_default

    nave_tiro:; ' ' começar a atirar ou parar
        loadn r2, #0;
        loadn r3, #1;
        load r1, tiro_bool
        cmp r1, r2; r1 = 1 ou 0; r2 = 0
        jeq tiro_0;
        
        tiro_1:; Se o tiro for 1
            store tiro_bool, r2; Guarda 0 no bool
            jmp nave_default
        
        tiro_0:; Se o tiro for 0
            store tiro_bool, r3; Guarda 1 no bool
            jmp nave_default
        
    nave_default:

    loadn r2, #1024; cor da nave
    loadn r1, #'>'
    call PrintChar
    store nave_pos, r0

    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
rts

 
; vetor de tiros que ira guardar as posiçoes 
; da tela em que estao ocorrendo um tiro
; se em uma posição do vetor tiver 0 é uma 
; posição vazia do contrarios é uma posição que
; esta acontecendo um tiro
tiro_list: var #50;
Tiro:
    push r0
    push r1
    push r2
    push r3
    push r4

    load r0, tiro_bool; carregando a flag de tiro
    loadn r1, #1; 1 significa que esta dando o tiro

    cmp r0, r1; r0 = 1 ou 0; r1 = 0
    jne tiro_end_if
        loadn r0, #tiro_list; pegando o começo do vetor
        loadn r1, #0; colocando um 0 para poder comparar com o conteudo do vetor de tiros

        load r3, nave_pos; pegando a posiçao atual da nave
        inc r3; incrementando a posição atual para posicionar o tiro a frente da nave

        ; no começo do loop tem um 'inc', esse dec é apra ele 
        ; começar verificando a primeira posição do vetor e nao a segunda
        dec r0
        
        ;procurando no vetor de tiro uma posiçao vazia
        find_empty_tiro_list_loop:
            inc r0; para ir para a proxima posiçao do vetor
            loadi r2, r0; pegando o conteudo do vetor para um registrador

        cmp r1, r2; r2 esta com o conteudo do vetor e r1 com um 0
        jne find_empty_tiro_list_loop; se a posição nao for um 0 nao sai do loop

        ;depois do loop achei uma posição que é 0
        storei r0, r3; salvando a posiçao do tiro(r3) no vetor de tiros(r0)

    tiro_end_if:;

    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
rts

Mov_tiros:
    push r0;
    push r1;
    push r2;
    push r3;
    push r4;
    push r5;
    push r7;

    call colisao

    loadn r0, #tiro_list; Lista de tiros
    loadn r1, #50; Numero maximo de tiros
    loadn r2, #0; Contador
    loadn r7, #2560 ;cor lima
    ; Percorre o vetor de tiros
    mov_tiros_loop:
        loadi r3, r0; pegando o conteudo do vetor para o r3
        
        ; Compara para ver se o tiro atual é 0
        loadn r4, #0;
        cmp r3, r4;
        ; Se for zero ignora
        jeq tiro_zero;
            ; Apaga a posição atual do tiro
            loadn r4, #' ';
            outchar r4, r3; Coloca um espaço na posição atual do tiro

            inc r3; Incrementa para fazer o tiro andar

            ; Verifica se o tiro chegou na borda do mapa, se sim apagalo(zerar a posição do vetor vetor)
            loadn r4, #40; 
            mod r4, r3, r4; Fazendo o mod da nova posição do tiro com 40 
            loadn r5, #0; Carregando um 0 para uso
            cmp r5, r4; Comparando para ver se o resultado do mod deu 0
            jne tiro_tela_borda; Se nao for 0 o resultado do mod quer diser que nao chegou na borda
                loadn r3, #0; Se chegou na borda colocar um 0 para apagar o tiro
                jmp tiro_zero; Se o tiro é zero nao precisa ser imprimido na tela e nem fazer colisão com inimigos
            tiro_tela_borda:
            
            ; Imprimindo na tela
            loadn r4, #'-'; Carregando o caracter do tiro
            add r4, r4, r7
            outchar r4, r3; Imprimindo na nova posição

        tiro_zero:
        storei r0, r3; Salvando no vetor de tiros a nova posição

        inc r0; indo para proxima posição do vetor de tiros
        inc r2; incrementa o contador

    cmp r1, r2; r2 é o contador e r1 o numero 100
    jne mov_tiros_loop; Se o contador r2 nao for 100 ele ira continuar no loop
    
    call colisao

    pop r7;
    pop r5;
    pop r4;
    pop r3;
    pop r2;
    pop r1;
    pop r0;
rts;


;parametros:
;   r0 endereço do vetor
;   r1 tamanho do vetor
zera_vetor:
    push r0;
    push r1;
    push r2;
    push r3;

    loadn r2, #0; contador
    loadn r3, #0; um 0 para zerar a memoria
    zera_vetor_loop:

        storei  r0, r3; zerando a posição da memoria
        inc r0; incrementando a posição do vetor

    inc r2; incrementando o contador
    cmp r2, r1; comparando se chegou no fim do contador
    jne zera_vetor_loop;

    pop r3;
    pop r2;
    pop r1;
    pop r0;
rts;

enemy_list: var #50
cria_inimigo:
    push r0
    push r1
    push r2
    push r3
    push r4
    
    loadn r0, #enemy_list; pegando o começo do vetor
    loadn r1, #0; colocando um 0 para poder comparar com o conteudo do vetor de inimigos

    ;gerando uam posição inicial "aleatoria"
    load r3, nave_pos; pegando a posiçao atual da nave
    load r2, clock
    add r3, r2, r3
    loadn r2, #1200
    mod r3, r3, r2

    loadn r2, #40

    mod r2, r3, r2
    sub r3, r3, r2
    dec r3
    loadn r2, #40
    add r3, r2, r3

    ; no começo do loop tem um 'inc', esse dec é apra ele 
    ; começar verificando a primeira posição do vetor e nao a segunda
    dec r0
    
    ;procurando no vetor de inimigo uma posiçao vazia
    find_empty_enemy_list_loop:
        inc r0; para ir para a proxima posiçao do vetor
        loadi r2, r0; pegando o conteudo do vetor para um registrador

    cmp r1, r2; r2 esta com o conteudo do vetor e r1 com um 0
    jne find_empty_enemy_list_loop; se a posição nao for um 0 nao sai do loop

    ;depois do loop achei uma posição que é 0
    storei r0, r3; salvando a posiçao do inimigo(r3) no vetor de inimigos(r0)
    loadn r1, #'<'
    outchar r1, r3
    
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
rts

rand_r4:
    push r0
    push r1
    push r2

    loadn r0, #rand_vector ;carregando o endereço 0 do vetor de rand
    load r1, rand_counter ; carregando o indice do vetor de rand

    add r0, r0, r1 ; pular para o a posição do vetor indexada pelo rand_counter

    inc r1; incrementar o rand_counter
    loadn r2, #30
    mod r1, r1, r2 ; fazer o mod 30 apra ele nao passar do 29 e acessar memoria errada
    store rand_counter, r1; salvar o novo rand_counter

    loadi r4, r0; careegar o conteudo do vetor na posiçao rand counter para o registrador r4 que e'o retorno da função
    
    pop r2
    pop r1
    pop r0
rts

mov_enemys:
    push r0;
    push r1;
    push r2;
    push r3;
    push r4;
    push r5;

    loadn r0, #enemy_list ; Lista de tiros
    loadn r1, #50; Numero maximo de tiros
    loadn r2, #0; Contador
    ; Percorre o vetor de tiros
    mov_enemy_loop:
        loadi r3, r0; pegando o conteudo do vetor para o r3
        
        ; Compara para ver se o inimigo atual é 0
        loadn r4, #0;
        cmp r3, r4;
        ; Se for zero ignora
        jeq enemy_zero;
            ; Apaga a posição atual do inimigo
            loadn r4, #' ';
            outchar r4, r3; Colocar um espaço na posição atual do inimigo

            mov r4, r3; a posição atual da nave sera usada como parametro apra o nuemro aleatorio
            call rand_r4;sera colocado um numero de 0 a 3 "aleatoriamente" no r4 para indicar a direção em que ele ira

            ;switch
            loadn r5, #0
            cmp r5, r4
            jeq inimigo_cima

            loadn r5, #1
            cmp r5, r4
            jeq inimigo_baixo
            
            loadn r5, #2
            cmp r5, r4
            jeq inimigo_esqueda
            
            loadn r5, #3
            cmp r5, r4
            jeq inimigo_direita
            jmp inimigo_default

            inimigo_cima:; W vai apra cim
                ;verificar se ele nao esta no topo da tela
                loadn r5, #40
                cmp r3, r5; r3 = posição atual do inimigo; r5 = 40
                jle inimigo_default; se a posição atual da nave for menor do que 40, ignorar o movimento
                
                ;indo apra a nova posição
                loadn r5, #40
                sub r3, r3, r5
                jmp inimigo_default

            inimigo_esqueda:; A vai para esquerda
                ; Verificando se ele nao esta na borda esquerda da tela
                loadn r5, #40;
                mod r5, r3, r5; r1 = r0 % r1; r1 = 40; r0 =  posição atual da nave 
                loadn r4, #0;
                cmp r4, r5; r1 = resultado do mod; r2 = 0
                jeq inimigo_default; Se o resultado do mod for 0 ignorar o movimento

                loadn r5, #1
                sub r3, r3, r5
                jmp inimigo_default

            inimigo_baixo:; S ir para baixo
                ;verificar se ele nao esta no fim da tela
                loadn r4, #1160
                cmp r3, r4; r0 = posição atual da nave; r1 = 40
                jeg inimigo_default; se a posição atual da nave for igual ou maior do que 1160, ignorar o movimento

                loadn r4, #40
                add r3, r3, r4
                jmp inimigo_default

            inimigo_direita:; D ir para direita
                ; Verificando se ele nao esta na borda direita da tela
                loadn r4, #40;
                mod r4, r3, r4; r1 = r0 % r1; r1 = 39; r0 =  posição atual da nave 
                loadn r5, #39;
                cmp r5, r4; r1 = resultado do mod; r2 = 0
                jeq inimigo_default; Se o resultado do mod for 0 ignorar o movimento

                loadn r4, #1
                add r3, r3, r4
                jmp inimigo_default
            inimigo_default:
            
            ; Imprimindo na tela
            loadn r4, #'<'; Carregando o caracter do tiro
            outchar r4, r3; Imprimindo na nova posição

        enemy_zero:
        storei r0, r3; Salvando no vetor de tiros a nova posição

        inc r0; Indo para proxima posição do vetor de tiros
        inc r2; Incrementa o contador

    cmp r1, r2; r2 é o contador e r1 o numero 50
    jne mov_enemy_loop; Se o contador r2 nao for 50 ele ira continuar no loop
    
    pop r5;
    pop r4;
    pop r3;
    pop r2;
    pop r1;
    pop r0;
rts

colisao:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7

    loadn r4, #50; tamanho maximo de ambos os vetores
    loadn r7, #0; um 0 para zerar os vetores

    loadn r0, #tiro_list
    loadn r2, #0; contado do vetor de tiros
    loop_1:;loop que percorre todos os tiros
        loadn r1, #enemy_list;voltando para a primeira posição do vetor de inimigos
        loadn r3, #0; contador do vetor de inimigos
        loadi r5, r0; carregando o tiro que sera comparado com todos os inimigos
        loop_2:; loop que percorre todos os inimigos
            loadi r6, r1; carregando o inimigo que sera comaprado com o tiro
            cmp r5, r6; r5 = posição do tiro; r6 = posição do inimigo
            jne nao_teve_colisao; se a posição nao for igual ignora
                ;se forem iguais zera ambas as posiçoes
                storei r0, r7; r0 = posição atual do vetor de tiros; r7 = zero
                storei r1, r7; r0 = posição atual do vetor de inimigos; r7 = zero
                ;apaga a tela nas posiçoes que foram destruidas
                outchar r7, r5
                ;sai do loop colocando o contdor em 50
                loadn r3, #49; coloca 49 pois sera incrementado em seguida e é apra ficar com 50 na comparação
            nao_teve_colisao:
        inc r1;incrementando o vetor de inimigos
        inc r3;incrementando o contador
        cmp r3, r4; r3 = 0->50; r4 = 50; vendo se nao chego no final do loop quando contador for igual a 50
        jne loop_2
    inc r0; incrementando o vetor de tiros
    inc r2; incrementando o contador
    cmp r2, r4; r2 = 0->50; r4 = 50; vendo se nao chego no final do loop quando contador for igual a 50
    jne loop_1

    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
rts

;Função que acha num vetor a primeira posição que tem 0
;parametros
    ;r0 = primeiro endereço do vetor
    ;r1 = tamanho maximo do vetor
;Retorno:
    ;r0 = endereço da primeira posição vazia(com 0)
find_empty_vector_position:
    push r3
    push r4
    push r5

    loadn r3, #0; contador do vetor
    loadn r4, #0; um zero para usar para comparar
    find_empty_vector_position_loop:
        loadi r5, r0; pegando o conteudo do vetor
        cmp r5, r4; r5 = conteudo do vetor; r4 = zero
        jeq find_empty_vector_position_loop_end; se for zero a funçãoa acaba pois foi localizada a posição que esta vazia

    inc r0; incrementando o vetor
    inc r3; incrementando o contador
    cmp r3, r1; comparando se deu o maximo
    jne find_empty_vector_position_loop; se o contador chego no amximo ele sai do loop, se não continua no loop

    find_empty_vector_position_loop_end:

    pop r5
    pop r4
    pop r3
rts

tiro_list_2: var #200
tiro_inimigo:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7

    loadn r0, #enemy_list; r0 tera o vetor de inimigos
    loadn r1, #0; contador do vetor de inimigos
    loadn r2, #50; tamanho do vetor de inimigos
    loadn r7, #0; um zero apra comparar
    
    todos_inimigos_loop:
        ;verificar se esta posição tem um inimigo
        loadi r6, r0; pegando a posição do inimigo no vetor de inimigos
        cmp r6, r7; r6 = posição do inimigo; r7 = zero
        jeq posicao_vazia; Se a posição for 0 nao tem inimigo, então ignorar
            ;se tiver inimigo procurar uma posição valida do vetor para guardar o tiro
            push r0
            push r1
            
            loadn r0, #tiro_list_2; r3 tera o vetor de tiros dos inimigos
            loadn r1, #200; tamanho maximo do vetor de tiros de inimigos

            call find_empty_vector_position

            dec r6; decrementando a posição do inimigo salva em r6 para posicionar a frente dele(frente virada para o player a esquerda)
            storei r0, r6 ; salvando a posição do tiro na posição do vetor
            
            pop r1
            pop r0 
        posicao_vazia:
    inc r0; incrementando o vetor e inimigos para ir para o proximo inimigo
    inc r1; incrementando o contado do vetor de inimigos
    cmp r1, r2; r1 = 0->50; r2 = 50
    jne todos_inimigos_loop

    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
rts

mov_tiro_inimigo:
    push r0;
    push r1;
    push r2;
    push r3;
    push r4;
    push r5;
    push r6
    push r7;

    loadn r0, #tiro_list_2 ; Lista de tiros
    loadn r1, #200; Numero maximo de tiros
    loadn r2, #0; Contador
    load r7, nave_pos; pegando a posição da nave para ver se ela foi acertada
    loadn r6, #2816 ;cor do tiro amarelo
    ; Percorre o vetor de tiros
    mov_tiros_loop_2:
        loadi r3, r0; pegando o conteudo do vetor para o r3
        
        ; Compara para ver se o tiro atual é 0
        loadn r4, #0;
        cmp r3, r4;
        ; Se for zero ignora
        jeq tiro_zero_2;
            ; Apaga a posição atual do tiro
            loadn r4, #' ';
            outchar r4, r3; Coloca um espaço na posição atual do tiro

            ;verificando se a posição atual é a do player
            cmp r3, r7
            ceq game_over

            dec r3; Decrementando para fazer o tiro andar para o lado do player

            ;verificando se a nova posição é a do player
            cmp r3, r7
            ceq game_over

            ; Verifica se o tiro chegou na borda do mapa, se sim apagalo(zerar a posição do vetor vetor)
            loadn r4, #40; 
            mod r4, r3, r4; Fazendo o mod da nova posição do tiro com 40 
            loadn r5, #39; Carregando um 0 para uso
            cmp r5, r4; Comparando para ver se o resultado do mod deu 0
            jne tiro_tela_borda_2; Se nao for 0 o resultado do mod quer diser que nao chegou na borda
                loadn r3, #0; Se chegou na borda colocar um 0 para apagar o tiro
                jmp tiro_zero_2; Se o tiro é zero nao precisa ser imprimido na tela e nem fazer colisão com inimigos
            tiro_tela_borda_2:
            
            ; Imprimindo na tela
            loadn r4, #'-'; Carregando o caracter do tiro
            add r4, r4, r6; colocando a cor amarela no tiro
            outchar r4, r3; Imprimindo na nova posição

        tiro_zero_2:
        storei r0, r3; Salvando no vetor de tiros a nova posição

        inc r0; indo para proxima posição do vetor de tiros
        inc r2; incrementa o contador

    cmp r1, r2; r2 é o contador e r1 o numero 200
    jne mov_tiros_loop_2; Se o contador r2 nao for 200 ele ira continuar no loop
    
    pop r7;
    pop r6;
    pop r5;
    pop r4;
    pop r3;
    pop r2;
    pop r1;
    pop r0;
rts


game_over:
    call EraseScreen
    loadn r0, #600
    loadn r1, #Game_15
    loadn r2, #512
    loadn r3, #' '
    call PrintString

    loadn r0, #800
    loadn r1, #Game_20
    call PrintString

    game_over_loop:
        inchar r1
        loadn r2, #' '
        cmp r1, r2
    jne game_over_loop
    call EraseScreen
    jmp main
rts

clock: var #1
main:
    call EraseScreen;

    loadn r0, #tiro_list; endereço do vetor de tiro na posiçãp 0
    loadn r1, #50; numero maximo de tiros
    call zera_vetor;

    loadn r0, #enemy_list; endereço do vetor de inimigos na posiçãp 0
    loadn r1, #50; numero maximo de tiros
    call zera_vetor;

    loadn r0, #tiro_list_2
    loadn r1, #200
    call zera_vetor;

    loadn r0, #401; contador do jogo e a posição inicial da nave
    store nave_pos, r0; colocando a posição inicial da nave em 400
    loadn r2, #0; para comparar com os resultados dos mods

    Game_Loop:
        
        loadn r1, #10; carrega o r1 com 10
        mod r1, r0, r1; faz mod 10 do contador(r0) para ver se a nave vai se mover
        cmp r1, r2; compara se o resultado do mod deu 0 pois o r2 tem 0 
        ceq Move_Nave;

        loadn r1, #25;
        mod r1, r0, r1;
        cmp r1, r2;
        ceq Tiro;
        
        loadn r1, #8;
        mod r1, r0, r1;
        cmp r1, r2;
        ceq Mov_tiros;
    
        loadn r1, #80;
        mod r1, r0, r1;
        cmp r1, r2;
        ceq cria_inimigo;

        loadn r1, #27;
        mod r1, r0, r1;
        cmp r1, r2;
        ceq mov_enemys;
       
        loadn r1, #200;
        mod r1, r0, r1;
        cmp r1, r2;
        ceq tiro_inimigo

        loadn r1, #20;
        mod r1, r0, r1;
        cmp r1, r2;
        ceq mov_tiro_inimigo

        call Delay;
        inc r0;
        store clock, r0
        
    jmp Game_Loop;
   
halt


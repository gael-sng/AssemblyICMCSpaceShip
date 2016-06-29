jmp main

; Variáveis
Word: var #20 ; Aloca espaço para a palavra (19 chars e um '\0')
WordSize: var #1 ; Aloca espaço para o tamanho da palavra
rand_vector: var #30 ; Aloca espaço para a o vetor de numeros randomicos que vão de 0-3
rand_counter: var #1 ; Aloca espaço para a o vetor de numeros randomicos que vão de 0-3

; Inicializando variáveis
static rand_counter + #0, #0 ;

static rand_vector + #0, #0 ;
static rand_vector + #1, #1 ;
static rand_vector + #2, #0 ;
static rand_vector + #3, #0 ;
static rand_vector + #4, #1 ;
static rand_vector + #5, #2 ;
static rand_vector + #6, #1 ;
static rand_vector + #7, #2 ;
static rand_vector + #8, #1 ;
static rand_vector + #9, #0 ;
static rand_vector + #10, #0 ;
static rand_vector + #11, #2 ;
static rand_vector + #12, #0 ;
static rand_vector + #13, #0 ;
static rand_vector + #14, #1 ;
static rand_vector + #15, #0 ;
static rand_vector + #16, #1 ;
static rand_vector + #17, #0 ;
static rand_vector + #18, #2 ;
static rand_vector + #19, #1 ;
static rand_vector + #20, #2 ;
static rand_vector + #21, #0 ;
static rand_vector + #22, #3 ;
static rand_vector + #23, #0 ;
static rand_vector + #24, #1 ;
static rand_vector + #25, #2 ;
static rand_vector + #26, #0 ;
static rand_vector + #27, #2 ;
static rand_vector + #28, #2 ;
static rand_vector + #29, #1 ;
; Mensagens para o usuário
TypeInAWord: string "Escreva uma palavra e pressione ENTER:"


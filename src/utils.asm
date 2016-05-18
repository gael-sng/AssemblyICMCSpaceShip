Letter: var #1 ; Aloca espaço para uma letra (Input Purposes)
; r0 - Screen Position
; r1 - Character
; r2 - Color
PrintChar:
     push r1

    add r1, r1, r2 ; Adicionando cor
    outchar r1, r0 ; Printando caractere

    pop r1
rts

; r0 - Screen Position
; r1 - String Address
; r2 - Color
; r3 - Character to be skipped
;PrintString:
    
;:

; r0 should contain the Screen Position
; r1 should contain the String Address
; r2 should contain a color
; r6 should contain the character to be skipped
;PrintString:
  ;  push fr
   ; push r0
  ;  push r1
  ;  push r2
  ;  push r3
  ;  push r4
    
  ;  loadn r3, #'\0' ; Definindo terminador
  ;  loadi r4, r1 ; Carregando um caractere da string para r4

  ;  cmp r4, r3 ; Comparando com o '\0'
  ;  jeq PrintString_EndIf1 ; if (r4 != '\0')
  ;      PrintString_Loop: ; while (r4 != '\0')
  ;          cmp r4, r6 ; Comparando com o caractere a ser pulado
;
  ;          jeq PrintString_EndIf2 ; if (r4 != skip)
  ;              add r4, r2, r4 ; Adicionando cor ao caractere
 ;               outchar r4, r0 ; Imprimindo o caractere
 ;           PrintString_EndIf2:
;
 ;           inc r0 ; Inc Screen Position
;            inc r1 ; Inc String Address
;            loadi r4, r1 ; Carregando um caractere da string para a r4
 ;           cmp r4, r3 ; Comparando com o '\0'
 ;       jne PrintString_Loop
 ;   PrintString_EndIf1:

 ;   pop r4
 ;   pop r3
 ;   pop r2
 ;   pop r1
 ;   pop r0
 ;   pop fr
;rts

; Prints the entire Screen
; r1 should contain last string's address
; r2 should contain a color code
; r6 should contain the character to be skipped
;PrintScreen:
  ;  push fr
   ; push r0
    ;push r1
  ;  push r2
  ;  push r3
  ;  push r4
  ;  push r5
  ;  push r6

;    loadn r0, #1200 ; Initial screen position
 ;   loadn r3, #40 ; Screen position decrement
 ;   loadn r4, #41 ; Address decrement

 ;   add r1, r1, r4 ; Initializing r1

 ;   PrintScreen_Loop:
 ;       sub r1, r1, r4 ; Dec Address
 ;       sub r0, r0, r3 ; Dec Screen Positon
 ;      call PrintString
 ;   jnz PrintScreen_Loop

  ;  pop r6
 ;   pop r5
  ;  pop r4
 ;   pop r3
 ;   pop r2
 ;   pop r1
 ;   pop r0
 ;   pop fr
;rts

; Erases the entire Screen
EraseScreen:
    push fr
    push r0
    push r1

    loadn r0, #1200
    loadn r1, #' '

    EraseScreen_Loop:
        dec r0
        outchar r1, r0
    jnz EraseScreen_Loop

    pop r1
    pop r0
    pop fr
rts

Delay:
    push fr
    push r0
    push r1

    loadn r0, #1000

    Delay_Loop1:
        loadn r1, #1000

        Delay_Loop2:
            dec r1
        jnz Delay_Loop2

        dec r0
    jnz Delay_Loop1

    pop r1
    pop r0
    pop fr
rts

GetChar:
    push fr
    push r0
    push r1
    push r2

    loadn r1, #255 ; Código enviado pelo teclado quando nenhuma tecla está pressionada
    loadn r2, #0 ; Código enviado quando nenhuma tecla está pressionada no início da execução

    ; Esperando apertar uma tecla
    ; Esperando enviar um código diferente de 0 e 255
    GetChar_Loop1:
        inchar r0 ; Recebendo caractere
        cmp r0, r2 ; Comparando com 0
    jeq GetChar_Loop1
        cmp r0, r1 ; Comparando com 255
    jeq GetChar_Loop1

    store Letter, r0 ; Gravando a letra lida na memória

    ; Esperando soltar a tecla
    ; Esperando enviar o código 255
    GetChar_Loop2:
        inchar r0 ; Recebendo caractere
        cmp r0, r1 ; Comparando com 255
    jne GetChar_Loop2

    pop r2
    pop r1
    pop r0
    pop fr
rts

;ScanString:
;    push fr
;    push r0
;    push r1
;    push r2
;    push r3
;    push r4
;    push r5

;    loadn r1, #13 ; Colocando o '\n' no r1 (13 == '\n')
;    loadn r2, #0 ; int i
;    loadn r3, #Word ; Endereço da palavra
;    loadn r5, #19 ; Tamanho máximo da palavra

;    ScanString_Loop:
;        call GetChar
;        load r0, Letter ; Carregando r0 com a letra

 ;       cmp r0, r1 ; Se for enter
 ;       jeq ScanString_End

 ;       add r4, r3, r2 ; r4 = r3 + i, tal que r4 é o endereço da string
 ;       storei r4, r0 ; String[r4] = r0
  ;      inc r2 ; i++
  ;      store WordSize, r2 ; Atualiza o tamanho da palavra

   ;     cmp r2, r5 ; verifica se r2 = 40
   ;     jne ScanString_Loop

   ; ScanString_End:

    ; Colocando o '\0'
   ; loadn r0, #'\0' 
   ; add r4, r3, r2
   ; storei r4, r0

;    pop r5
;    pop r4
;    pop r3
;    pop r2
;    pop r1
;    pop r0
;    pop fr

 ;   rts

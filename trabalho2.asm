# Segmento de dados globais
.data
    msgSoma:    .asciiz    "Soma: "

# Segmento de texto (instruções do programa)
.text
main:
    # Aloca espaço na pilha
    addi    $sp, $sp, -80   # 80 bytes para um vetor de 20 inteiros
    
    # Inicializa variáveis locais
    move    $s0, $sp        # vet aponta para o início do vetor na pilha
    li      $s1, 0          # soma = 0
    
    # Chama a função inicializaVetor
    move    $a0, $s0        # Primeiro parâmetro: vet
    li      $a1, 20         # Segundo parâmetro: SIZE
    li      $a2, 71         # Terceiro parâmetro: 71
    jal     inicializaVetor # Chama a função inicializaVetor
    nop # NOP Necessário, pois a próxima instrução precisa aguardar o valor de $v0 ser calculado, e se definir os $a da próxima chamada imprimeVetor, estes podem ser alterados dentro da inicializaVetor
    move    $s1, $v0        # Guarda o retorno da função em soma
    
    # Chama a função imprimeVetor
    move    $a0, $s0        # Primeiro parâmetro: vet
   	li      $a1, 20         # Segundo parâmetro: SIZE
    jal     imprimeVetor    # Chama a função imprimeVetor
    nop # NOP Necessário, pois não há garantias de o $a0 estar preservado após a chamada de imprimeVetor, então se deve defini-lo após o retorno da função
    
    # Chama a função ordenaVetor
    move    $a0, $s0        # Primeiro parâmetro: vet
    li      $a1, 20         # Segundo parâmetro: SIZE
    jal     ordenaVetor     # Chama a função ordenaVetor
    nop # NOP Necessário, pois não há garantias de o $a0 estar preservado após a chamada de ordenaVetor, então se deve defini-lo após o retorno da função
    
    # Chama a função imprimeVetor
    move    $a0, $s0        # Primeiro parâmetro: vet
    li      $a1, 20         # Segundo parâmetro: SIZE
    jal     imprimeVetor    # Chama a função imprimeVetor
    nop # NOP Necessário, pois não há garantias de o $a0 estar preservado após a chamada de imprimeVetor, então se deve defini-lo após o retorno da função
    
    # Chama a função zeraVetor
    move    $a0, $s0        # Primeiro parâmetro: &vet[0]
    addi    $a1, $s0, 80    # Segundo parâmetro: &vet[20]
    jal     zeraVetor       # Chama a função zeraVetor
    nop # NOP Necessário, pois não há garantias de o $a0 estar preservado após a chamada de zeraVetor, então se deve defini-lo após o retorno da função
    
    # Chama a função imprimeVetor
    move    $a0, $s0        # Primeiro parâmetro: vet
    li      $a1, 20         # Segundo parâmetro: SIZE
    jal     imprimeVetor    # Chama a função imprimeVetor
    nop # NOP Necessário, pois não há garantias de o $v0 estar preservado após a chamada de imprimeVetor, então se deve defini-lo após o retorno da função
    
    # Impressão em tela: printf("Soma: %d\n", soma);
    li      $v0, 4          # Código 4 para impressão de string
    la      $a0, msgSoma    # Primeiro parâmetro: endereço da string "Soma: "
    syscall
    li      $v0, 1          # Código 1 para impressão de inteiro
    move    $a0, $s1        # Primeiro parâmetro: soma ($s1)
    syscall
    li      $v0, 11         # Código 11 para impressão de caractere
    li      $a0, 10         # Primeiro parâmetro: \n (ASCII)
    syscall
    
    # Libera espaço na pilha
    addi    $sp, $sp, 80    # Libera os 80 bytes alocados pela função

    # Fim do programa
    li      $v0, 17         # Código 17 para exit com valor de retorno
    li      $a0, 0          # Primeiro parâmetro: valor de retorno 0
    syscall 


zeraVetor:
    # Esta função é folha
    # O primeiro parâmetro é o ponteiro para o início do vetor
    # O segundo parâmetro é ponteiro para o fim do vetor
    
    # Faz a execução inicial do loop
    bge    $a0, $a1, zeraFim    # Se inicio >= fim vai para zeraFim
    nop # NOP Necessário, pois não se pode permitir manipular a memória de um índice inválido
    # Executa a primeira instrução do corpo da função
    sw      $zero, 0($a0)       # Salva valor 0 no endereço apontado por inicio
    
    zeraLoop:
        bge     $a0, $a1, zeraFim    # Se inicio >= fim vai para zeraFim
        # NOP Desnecessário, pois se pode incrementar o contador sempre, e sua manipulação não impacta o epílogo da função
        addi    $a0, $a0, 4         # Incrementa inicio para a próxima posição
        j       zeraLoop            # Repete o laço
        # NOP Desnecessário, pois o slot é preenchido com a primeira instrução do corpo da função
        sw      $zero, 0($a0)       # Salva valor 0 no endereço apontado por inicio
    	
    zeraFim:
    # Fim da função    
    jr      $ra             # Retorna
    nop # NOP Necessário, pois não há mais instruções a serem executadas no escopo da função
    

imprimeVetor:
    # Esta função não é folha
    # O primeiro parâmetro é o ponteiro para o início do vetor
    # O segundo parâmetro é o tamanho do vetor
    
    # Aloca espaço na pilha
    addi    $sp, $sp, -16   # 16 bytes para $ra, $s0, $s1, $s2
    sw      $ra, 0($sp)     # Salva $ra na pilha
    sw      $s0, 4($sp)     # Salva $s0 na pilha
    sw      $s1, 8($sp)     # Salva $s1 na pilha
    sw      $s2, 12($sp)    # Salva $s2 na pilha
    
    # Inicializa variáveis
    move    $s0, $a0        # Parâmetro vet salvo em $s0
    move    $s1, $a1        # Parâmetro tam salvo em $s1
    li      $s2, 0          # Variável i = 0 em $s2
    
    # Faz a primeira verificação do índice, e a primeira antiga instrução da função
    beq     $s2, $s1, imprimeFim    # Se i == tam vai para imprimeFim
    # NOP Desnecessário, pois o cálculo de $t0 não impacta no epílogo do loop
    sll     $t0, $s2, 2         # $t0 = i * 4
    imprimeLoop: 
        add     $t0, $s0, $t0       # $t0 = &vet[i]
        
        li      $v0, 1              # Código 1 para impressão de inteiro
        lw      $a0, 0($t0)         # Primeiro parâmetro: vet[i]
        syscall
    
        li      $v0, 11             # Código 11 para impressão de caractere
        li      $a0, 32             # Primeiro parâmetro: " " (espaço)
        syscall
    
        beq     $s2, $s1, imprimeFim    # Se i == tam vai para imprimeFim
        # NOP Desnecessário, pois preenche o slot com a instrução addi, para incrementar o contador
		addi    $s2, $s2, 1         # Incremento i++
        j       imprimeLoop         # Repete o laço, caso não tenha sido deslocado
        # NOP Desnecessário, pois preenche o slot com a primeira instrução do antigo corpo da função
        sll     $t0, $s2, 2         # $t0 = i * 4
        
                
    imprimeFim:
    li      $v0, 11         # Código 11 para impressão de caractere
    li      $a0, 10         # Primeiro parâmetro: \n
    syscall
    
    # Libera espaço na pilha
    lw      $ra, 0($sp)     # Recupera $ra da pilha
    lw      $s0, 4($sp)     # Recupera $s0 da pilha
    lw      $s1, 8($sp)     # Recupera $s1 da pilha
    lw      $s2, 12($sp)    # Recupera $s2 da pilha
    addi    $sp, $sp, 16    # Libera os 16 bytes alocados pela função
    
    # Fim da função
    jr      $ra             # Retorna
    nop # NOP Necessário, pois não há mais instruções a serem executadas no escopo da função
    

inicializaVetor:
    # Esta função não é folha
    # O primeiro parâmetro é o ponteiro para o início do vetor
    # O segundo parâmetro é o tamanho do vetor
    # O terceiro parâmetro é o último valor aleatório utilizado na inicialização

    # Aloca espaço na pilha
    addi    $sp, $sp, -20   # 20 bytes para $ra, $s0, $s1, $s2 e $s3
    sw      $ra, 0($sp)     # Salva $ra na pilha
    sw      $s0, 4($sp)     # Salva $s0 na pilha
    sw      $s1, 8($sp)     # Salva $s1 na pilha
    sw      $s2, 12($sp)    # Salva $s2 na pilha
    sw      $s3, 16($sp)    # Salva $s3 na pilha

    # Inicializa variáveis
    move    $s0, $a0        # Parâmetro vet salvo em $s0
    move    $s1, $a1        # Parâmetro tamanho salvo em $s1
    move    $s2, $a2        # Parâmetro ultimoValor salvo em $s2
    li      $s3, 0          # novoValor = 0

    # Caso base da recursão
    move    $v0, $zero      # Prepara valor de retorno 0
    ble     $s1, $zero, inicializaFim   # Se tamanho <= 0 vai para inicializaFim
    # NOP Desnecessário, pois a alteração do $a0 não impacta no epílogo da recursão
    
    # Passo recursivo
    # Chama a função valorAleatorio
    move    $a0, $s2        # Primeiro parâmetro: ultimoValor
    li      $a1, 47         # Segundo parâmetro: 47    
    li      $a2, 97         # Terceir parâmetro: 97
    li      $a3, 337        # Quarto parâmetro: 337
    
    addi    $sp, $sp, -4    # Aloca 4 bytes na pilha para o quinto parâmetro
    li      $t0, 3          # $t0 = 3
    sw      $t0, 0($sp)     # Quinto parâmetro: 3    
    jal     valorAleatorio
    nop # NOP Necessário, pois $s3 e as demais instruções dependem do cálculo de $v0, além de que não se pode permitir diminuir o tamanho da pilha imediatamente, dado que o quinto parâmetro está armazenado nela
    addi    $sp, $sp, 4     # Libera 4 bytes na pilha do quinto parâmetro
    
    move    $s3, $v0        # novoValor = $v0 (retorno da função valorAleatorio)
    
    addi    $t0, $s1, -1    # $t0 = tamanho - 1
    sll     $t0, $t0, 2     # $t0 = (tamanho - 1) * 4
    add     $t0, $s0, $t0   # $t0 = &vet[tamanho - 1]
    sw      $s3, 0($t0)     # vet[tamanho - 1] = novoValor
    
    # Chama recursivamente a função inicializaVetor
    move    $a0, $s0        # Primeiro parâmetro: vet
    addi    $a1, $s1, -1    # Segundo parâmetro: tamanho - 1
    move    $a2, $s3        # Terceiro parâmetro: novoValor
    jal     inicializaVetor
    nop # NOP Necessário, dado que permitir a execução da próxima instrução alteraria o valor de $v0 sem o cálculo apropriado, que é dado por inicializaVetor
    
    # Prepara valor de retorno
    add     $v0, $v0, $s3   # Prepara valor de retorno novoValor + retorno da recursão 

    inicializaFim:
    # Libera espaço na pilha
    lw      $ra, 0($sp)     # Recupera $ra da pilha
    lw      $s0, 4($sp)     # Recupera $s0 da pilha
    lw      $s1, 8($sp)     # Recupera $s1 da pilha
    lw      $s2, 12($sp)    # Recupera $s2 da pilha
    lw      $s3, 16($sp)    # Recupera $s3 da pilha
    addi    $sp, $sp, 20    # Libera os 20 bytes alocados pela função
    
    # Fim da função
    jr      $ra             # Retorna
    nop # NOP Necessário, pois não há mais instruções a serem executadas no escopo da função
    

ordenaVetor:
    # Esta função não é folha
    # O primeiro parâmetro é o ponteiro para o início do vetor
    # O segundo parâmetro é o tamanho do vetor

    # Aloca espaço na pilha
    addi    $sp, $sp, -24   # 24 bytes para $ra, $s0, $s1, $s2, $s3 e $s4
    sw      $ra, 0($sp)     # Salva $ra na pilha
    sw      $s0, 4($sp)     # Salva $s0 na pilha
    sw      $s1, 8($sp)     # Salva $s1 na pilha
    sw      $s2, 12($sp)    # Salva $s2 na pilha
    sw      $s3, 16($sp)    # Salva $s3 na pilha
    sw      $s4, 20($sp)    # Salva $s4 na pilha

    # Inicializa variáveis
    move    $s0, $a0        # Parâmetro vet salvo em $s0
    move    $s1, $a1        # Parâmetro n salvo em $s1
    li      $s2, 0          # i = 0
    li      $s3, 0          # j = 0
    li      $s4, 0          # min_idx = 0
    
    # Laço externo
    li      $s2, 0          # i = 0
    ordenaFor1:
        addi    $t0, $s1, -1            # $t0 = n - 1
        bge     $s2, $t0, ordenaFim1    # Se i >= n - 1 vai para ordenaFim1
        nop
        move    $s4, $s2                # min_idx = i
    
        # Laço interno
        addi    $s3, $s2, 1             # j = i + 1
        ordenaFor2:
            bge     $s3, $s1, ordenaFim2    # Se j >= n vai para ordenaFim2
            nop
                    
            # Condicional dentro do lanço interno
            # Leitura do valor de vet[j]
            sll     $t0, $s3, 2             # $t0 = j * 4
            add     $t0, $s0, $t0           # $t0 = &vet[j]
            lw      $t0, 0($t0)             # $t0 = vet[j]

            # Leitura do valor de vet[min_idx]
            sll     $t1, $s4, 2             # $t1 = min_idx * 4
            add     $t1, $s0, $t1           # $t1 = &vet[min_idx]
            lw      $t1, 0($t1)             # $t1 = vet[min_idx]
            
            bge     $t0, $t1, sortIf1Fim    # Se vet[j] >= vet[min_idx] vai para sortIf1Fim
            nop
            move    $s4, $s3                # min_idx = j                        
            
            sortIf1Fim:
            addi    $s3, $s3, 1             # j++
            j       ordenaFor2              # Repete o laço interno
            nop
        
        ordenaFim2:
        # Condicional após o laço interno
        beq     $s4, $s2, ordenaIfFim       # Se min_idx == i vai para ordenaIfFim
        nop
        
        # Chama função troca
        sll     $t0, $s4, 2             # $t0 = min_idx * 4
        add     $a0, $s0, $t0           # Primeiro parâmetro: &vet[min_idx]
        sll     $t0, $s2, 2             # $t0 = i * 4
        add     $a1, $s0, $t0           # Segundo parâmetro: &vet[i]
        jal     troca
        nop
        
        ordenaIfFim:
        addi    $s2, $s2, 1             # i++
        j       ordenaFor1              # Repete o laço externo
        nop
    
    ordenaFim1:
    # Libera espaço na pilha
    lw      $ra, 0($sp)     # Recupera $ra da pilha
    lw      $s0, 4($sp)     # Recupera $s0 da pilha
    lw      $s1, 8($sp)     # Recupera $s1 da pilha
    lw      $s2, 12($sp)    # Recupera $s2 da pilha
    lw      $s3, 16($sp)    # Recupera $s3 da pilha
    lw      $s4, 20($sp)    # Recupera $s4 da pilha
    addi    $sp, $sp, 24    # Libera os 24 bytes alocados pela função
    
    # Fim da função
    jr      $ra             # Retorna
    nop
                  
troca:
    # Esta função é folha
    # O primeiro parâmetro é o ponteiro para a posição a no vetor
    # O segundo parâmetro é o ponteiro para a posição b no vetor
    
    # Teste da condicional
    beq     $a0, $a1, trocaFim  # Se a == b vai para trocaFim
    nop
    
    # Troca de valores
    lw      $t0, 0($a0)     # $t0 = *a
    lw      $t1, 0($a1)     # $t1 = *b
    sw      $t1, 0($a0)     # *a = $t1
    sw      $t0, 0($a1)     # *b = $t0
    
    trocaFim:
    # Fim da função
    jr      $ra             # Retorna
    nop
                      
                                                                                                                                                                                                                                                          
valorAleatorio:
    # Esta função é folha
    # Os quatro primeiros parâmetros estão nos registradores $a0 -- $a3
    # O quinto parâmetro está na pilha
    
    # Recupera o quinto parâmetro (e) da pilha
    lw      $t0, 0($sp)    # $t0 = e
    
    # Calcula o valor de retorno
    mul     $v0, $a0, $a1   # $v0 = a * b
    add     $v0, $v0, $a2   # $v0 = a * b + c
    div     $v0, $a3        # hi = (a * b + c) % d
    mfhi    $v0             # $v0 = hi
    sub     $v0, $v0, $t0   # $v0 = (a * b + c) % d - e
        
    # Fim da função
    jr      $ra             # Retorna
    nop # NOP Necessário, pois não há mais instruções a serem executadas no escopo da função



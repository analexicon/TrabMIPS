.data	# Área para dados na memória principal
	size: 20	# Tamanho do vetor em número de posições
	vet:	# Declaração do vetor
		.align 2	# Tamanho de cada elemento
		.space 80	# Quantidade de bytes de espaço alocados (20 espaços de 4 bytes)
	soma: .asciiz "Soma: "

.text	# Área para instruções do programa

	# Programa principal
	.main
		# Prólogo
		#
		la $s0, vet		# Endereço do vetor
		lw $s1, size	# Tamanho do vetor em posições
		
		# Corpo
		#
		# Chama inicializaVetor
		move $a0, $s0		# Arg: vetor = vet
		move $a1, $s1		# Arg: tamanho = size
		addi $a2, $zero, 71	# Arg: ultimoValor = 71
		jal inicializaVetor	
		move $s2, $v0		# soma = inicializaVetor(...)
		
		# Chama imprimeVetor
		move $a0, $s0		# Arg: vetor = vet
		move $a1, $s1		# Arg: tamanho = size
		jal imprimeVetor
		
		# Chama ordenaVetor
		move $a0, $s0		# Arg: vet = vet
		move $a1, $s1		# Arg: n = size
		jal ordenaVetor
		
		# Chama imprimeVetor
		move $a0, $s0		# Arg: vetor = vet
		move $a1, $s1		# Arg: tamanho = size
		jal imprimeVetor
		
		# Chama zeraVetor
		move $a0, $s0		# Arg: inicio = &vet[0]
		sll $t0, $s1, 2		# sizeBytes = size * 4
		add $a1, $s0, $t0	# Arg: fim = inicio + sizeBytes
		jal zeraVetor
		
		# Chama imprimeVetor
		move $a0, $s0		# Arg: vetor = vet
		move $a1, $s1		# Arg: tamanho = size
		jal imprimeVetor

		# Imprime soma
		la $a0, soma	# Arg: a = "Soma: "
		li $v0, 4		# Instrução: imprime string
		syscall			
		move $a0, $s2	
		li $v0, 1		# Instrução: imprime inteiro
		syscall

		# Epílogo
		#
		li $v0, 10	# Instrução: encerra o programa
		syscall
	# ========== #
	
	# Funções
	#
	#
	
	# Função que ordena os elementos do vetor (SelectionSort)
	# Param: int vet[] - Endereço base do vetor; int n - Tamanho do vetor em posições
	# Retorno: void
	ordenaVetor:
		# Prólogo
		#
		addi $sp, $sp, -28	# Ajusta a pilha
		sw $s0, 0($sp)		# Salva reg: $s0
		sw $s1, 4($sp)		# Salva reg: $s1
		sw $s2, 8($sp)		# Salva reg: $s2
		sw $s3, 12($sp)		# Salva reg: $s3
		sw $s4, 16($sp)		# Salva reg: $s4
		sw $s5, 20($sp)		# Salva reg: $s5
		sw $ra, 24($sp)		# Salva endereço de retorno
		move $s0, $a0		# Salva arg: vet
		move $s1, $a1		# Salva arg: n
		
		# Corpo
		#
		move $t0, $zero		# i = 0; índice
		addi $s2, $s1, -1	# ultPos = n - 1
				
		ordenaVetorLaco1:
			bge $s3, $s2, ordenaVetorPosLaco1	# if(i >= ultPos)... sai do laço
			addi $s4, $s3, 1	# j = i + 1
			move $s5, $s3		# min_idx = i
			
			ordenaVetorLaco2:
				bge $s4, $s1, ordenaVetorPosLaco2	# if(j >= n)... sai do laço
				
				sll $t0, $s4, 2		# jBytes = j * 4
				add $t0, $s0, $t0	# &vet[j] = &vet[0] + jBytes
				lw $t2, 0($t0)		# auxJ = vet[j]
				
				sll $t1, $s5, 2		# min_idxBytes = min_idx * 4
				add $t1, $s0, $t1	# &vet[min_idx] = &vet[0] + min_idxBytes
				lw $t4, 0($t1)		# auxMin_idx = vet[min_idx]			
				
				bge $t2, $t4, ordenaVetorElse1	# if(auxJ >= auxMin_idx)... redireciona para o else
				move $s5, $s4		# min_idx = j
				ordenaVetorElse1:
				# ~~~~~~~~~~ #
				
				addi $s4, $s4, 1	# j++
				j ordenaVetorLaco2
			# ~~~~~~~~~~ #
			
			ordenaVetorPosLaco2:
				beq $s5, $s3, ordenaVetorElse2	# if(min_idx == i)... redireciona para o else
				# Chama função troca
				sll $t2, $s5, 2		# min_idxBytes = min_idx * 4
				add $a0, $s0, $t2	# Arg: inicio = &vet[min_idx] = &vet[0] + min_idxBytes
				sll $t3, $s3, 2		# iBytes = i * 4
				add $a1, $s0, $t3	# Arg: fim = &vet[i] = &vet[0] + iBytes
				jal troca
				ordenaVetorElse2:
				# ~~~~~~~~~~ #
			
				addi $s3, $s3, 1	# i++
				j ordenaVetorLaco1
		# ~~~~~~~~~~ #
		
		ordenaVetorPosLaco1:		
		# Epílogo
		#
		lw $s0, 0($sp)		# Recupera reg: $s0
		lw $s1, 4($sp)		# Recupera reg: $s1
		lw $s2, 8($sp)		# Recupera reg: $s2
		lw $s3, 12($sp)		# Recupera reg: $s3
		lw $s4, 16($sp)		# Recupera reg: $s4
		lw $s5, 20($sp)		# Recupera reg: $s5
		lw $ra, 24($sp)		# Recupera endereço de retorno
		addi $sp, $sp, 28	# Reajusta pilha
		jr $ra	
	# ---------- #
	
	# Função que troca os valores entre duas posições do vetor
	# Param: int *a - Endereço da priemira posição; int *b - Endereço da segunda posição
	# Retorno: void
	troca:
		# Corpo
		#
		beq $a0, $a1, trocaElse
		lw $t0, 0($a0)	# auxA = *a
		lw $t1, 0($a1)	# auxB = *b
		sw $t1, 0($a0)	# *a = auxB
		sw $t0, 0($a1)	# *b = auxA

		trocaElse:
		# Epílogo
		#
		jr $ra	
	# ---------- #
	
	# Função para zerar o vetor
	# Param: int *inicio - Endereço base do vetor; int *fim - Endereço para a posição posterior ao fim do vetor
	# Retorno: void
	zeraVetor:
		# Prólogo
		#
		move $t0, $a0	# Salva arg: inicio
		
		# Corpo
		#
		zeraVetorLaco:
			bge $t0, $a1, zeraVetorPosLaco # if(inicio >= fim)... sai do laço
			sw $zero, 0($t0)	# *(inicio) = 0
			addi $t0, $t0, 4	# inicio++
			j zeraVetorLaco
		
		zeraVetorPosLaco:
		# Epílogo
		#
		jr $ra	
	# ---------- #
	
	# Função para imprimir o vetor
	# Param: int vet[] - Endereço base do vetor; int tam - Tamanho do vetor em posições
	# Retorno: void
	imprimeVetor:
		# Prólogo
		#
		move $t0, $a0	# Salva arg: vet
		move $t1, $a1	# Salva arg: tam
		move $t3, $zero	# i = 0; índice
		
		# Corpo
		#
		imprimeVetorLacoImpressao:
			beq $t3, $t1, imprimeVetorPosLacoImpressao	# if(i == tam)... sai do laço
			sll $t4, $t3, 2				# iBytes = i * 4
			add $t5, $t0, $t4			# &vet[i] = &vet[0] + (iBytes)
			lw $a0, 0($t5)				# Arg: a = vet[i]
			li $v0, 1					# Instrução: imprime inteiro
			syscall						
			li $a0, ' '					# Arg: a = ' '
			li $v0, 11					# Instrução: imprime caractere
			syscall						
			addi $t3, $t3, 1			# i++
			j imprimeVetorLacoImpressao
		
		imprimeVetorPosLacoImpressao:
			li $a0, '\n'	# Arg: a = '\n'
			li $v0, 11		# Instrução: imprime caractere
			syscall
			
		# Epílogo
		#
		jr $ra	
	# ---------- #
	
	# Gera número pseudo-aleatório por congruência linear
	# Param: int a - 1o inteiro; int b - 2o inteiro; int c - 3o inteiro; int d - 4o inteiro
	# Retorno: inteiro aleatório
	valorAleatorio:
		# Prólogo
		#
		lw $t0, 16($sp)	# Recupera o parâmetro int e
		
		# Corpo
		#
		mult $a0, $a1	# aux = a * b
		mflo $t1
		add $t1, $t1, $a2	# aux = aux + c
		div $t1, $a3	# aux = aux % d
		mfhi $t1
		sub $t1, $t1, $t0	# aux = aux - e
		
		# Epílogo
		#
		move $v0, $t1	# return aux
		jr $ra	
	# ---------- #
	
	
	# Inicializa vetor com número pseudo-aleatórios
	# Param: int vetor[] - Endereço base do vetor; int tamanho - Tamanho do vetor em posições; int ultimoValor - Último valor alteatório utilizado
	# Retorno: inteiro aleatório
	inicializaVetor:
		# Prólogo
		#
		addi $sp, $sp, -40	# Ajusta a pilha
		sw $a0, 0($sp)		# Salva arg: vetor
		sw $a1, 4($sp)		# Salva arg: tamanho
		sw $a2, 8($sp)		# Salva arg: ultimoValor
		sw $s0, 20($sp)		# Salva reg: $s0
		sw $s1, 24($sp)		# Salva reg: $s1
		sw $s2, 28($sp)		# Salva reg: $s2
		sw $s3, 32($sp)		# Salva reg: $s3
		sw $ra, 36($sp)		# Salva endereço de retorno
		
		# Corpo
		#
		move $s0, $a0	# Guarda arg: vetor
		move $s1, $a1	# Guarda arg: tamanho
		
		inicializaVetorLaco:
			ble  $s1, $zero, inicializaVetorCasoBase	# if (tamanho <= 0)... chama caso base
			# tamanho > 0...
			# Chama valorAleatorio
			move $a0, $a2			# Arg: a = ultimoValor
			addi $a1, $zero, 47		# Arg: b = 47
			addi $a2, $zero, 97		# Arg: c = 97
			addi $a3, $zero, 337	# Arg: d = 337
			addi $t0, $zero, 3		# Arg: e = 3
			sw $t0, 16($sp)			# Guarda argumento extra na memória
			jal valorAleatorio
			move $s2, $v0			# novoValor = valorAleatorio(...)
			
			# Preenche atual última posição do vetor
			addi $t1, $s1, -1	# ultimaPosicao = tamanho - 1
			sll $t2, $t1, 2		# Posição do vetor em bytes (deslocamento) = ultimaPosicao * 4
			add $t3, $s0, $t2	# Endereço da última posição = Base do vetor + deslocamento
			sw $s2, 0($t3)		# vetor[tamanho - 1] = novoValor
			
			# Prepara passo recursivo
			move $a0, $s0			# Arg: vetor = vetor
			move $a1, $t1			# Arg: tamanho = ultimaPosicao
			move $a2, $s2			# Arg: ultimoValor = novoValor
			jal inicializaVetor		# Chama função recursiva
			move $s4, $v0			# valProxPosicao = inicializaVetor(...)
			
			# Prepara retorno
			add $t4, $s2, $s4			# valorRetorno = novoValor + valProxPosicao
			move $v0, $t4				# return valorRetorno
			j inicializaVetorEpilogo


		inicializaVetorCasoBase:
			move $v0, $zero	# return 0
		
		# Epílogo
		#
		inicializaVetorEpilogo:
			lw $a0, 0($sp)		# Recupera arg: vetor
			lw $a1, 4($sp)		# Recupera arg: tamanho
			lw $a2, 8($sp)		# Recupera arg: ultimoValor
			lw $s0, 20($sp)		# Recupera reg: $s0
			lw $s1, 24($sp)		# Recupera reg: $s1
			lw $s2, 28($sp)		# Recupera reg: $s2
			lw $s3, 32($sp)		# Recupera reg: $s3
			lw $ra, 36($sp)		# Recupera endereço de retorno
			addi $sp, $sp, 40	# Reajusta a pilha
			jr $ra
	# ---------- #
	
.data	# Área para dados na memória principal
	size: 20	# Tamanho do vetor em número de posições
	vet:	# Declaração do vetor
		.align 2	# Tamanho de cada elemento
		.space 80	# Quantidade de bytes de espaço alocados (20 espaços de 4 bytes)

.text	# Área para instruções do programa

	# Programa principal
	.main
		# Prólogo
		#
		addi $sp, $sp, -20
		la $s0, vet		# Endereço do vetor
		lw $s1, size	# Tamanho do vetor em posições
		
		# Corpo
		#
		# Chama inicializaVetor
		move $a0, $s0		# Arg: vetor = vet
		move $a1, $s1		# Arg: tamanho = size
		addi $a2, $zero, 71	# Arg: ultimoValor = 71
		jal inicializaVetor
		
		# Chama imprimeVetor
		move $a0, $s0		# Arg: vetor = vet
		move $a1, $s1		# Arg: tamanho = size
		jal imprimeVetor

		# Epílogo
		#
		addi $sp, $sp, 20
		li $v0, 10	# Instrução: encerra o programa
		syscall
	# ========== #
	
	# Funções
	#
	#
	
	# Função para imprimir o vetor
	# Param: int vet[] - Endereço base do vetor, int tam - Tamanho do vetor em posições
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
	
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
		lw $s1, size	# sizeTamanho do vetor em bytes
		
		# Corpo
		#
		# Chama inicializaVetor
		move $a0, $s0		# Arg: vetor = vet
		move $a1, $s1		# Arg: tamanho = size
		addi $a2, $zero, 71	# Arg: ultimoValor = 71
		jal inicializaVetor
		
		move $a0, $v0
		li $v0, 1
		syscall
	
		# Epílogo
		#
		addi $sp, $sp, 20
		li $v0, 10	# Instrução: encerra o programa
		syscall
	# ========== #
	
	# Funções
	#
	#
		
	# Gera número pseudo-aleatório por congruência linear
	# Param: int a - 1o inteiro; int b - 2o inteiro; int c - 3o inteiro; int d - 4o inteiro
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
	# Param: int vetor[] - Endereço base do vetor; int tamanho - Tamanho do vetor em bytes; int ultimoValor - Último valor alteatório utilizado
	inicializaVetor:
		# Prólogo
		#
		addi $sp, $sp, -20	# Ajusta a pilha
		sw $a0, 0($sp)		# Salva arg: vetor
		sw $a1, 4($sp)		# Salva arg: tamanho
		sw $a2, 8($sp)		# Salva arg: ultimoValor
		sw $ra, 12($sp)		# Salva endereço de retorno
		
		# Corpo
		#
		inicializaVetorLaco:
			ble  $a1, $zero, inicializaVetorCasoBase	# if (tamanho <= 0)... chama caso base
			# tamanho > 0...
			# Chama valorAleatorio
			move $a0, $a2			# Arg: a = ultimoValor
			addi $a1, $zero, 47		# Arg: b = 47
			addi $a2, $zero, 97		# Arg: c = 97
			addi $a3, $zero, 337	# Arg: d = 337
			addi $t0, $zero, 3		# Arg: e = 3
			sw $t0, 16($sp)			#
			jal valorAleatorio
			#move $t0, $v0			# aux = valorAleatorio()
			j inicializaVetorEpilogo
		
		inicializaVetorCasoBase:
			move $v0, $zero	# return 0
		
		# Epílogo
		#
		inicializaVetorEpilogo:
			lw $a0, 0($sp)		# Recupera arg: vetor
			lw $a1, 4($sp)		# Recupera arg: tamanho
			lw $a2, 8($sp)		# Recupera arg: ultimoValor
			lw $ra, 12($sp)		# Recupera endereço de retorno
			addi $sp, $sp, 20	# Reajusta a pilha
			jr $ra
	# ---------- #
	
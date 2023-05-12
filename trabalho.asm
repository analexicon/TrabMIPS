.data
	# Área para dados na memória principal
	#
	
	size: 80	# Tamanho do vetor em bytes (20 espaços de 4 bytes)
	
	vetor:	# Declaração do vetor
		.align 2	# Tamanho de cada elemento
		.space 80	# Quantidade de bytes de espaço alocados (20 espaços de 4 bytes)

.text
	# Área para instruções do programa
	#
	

		
	
	# Inicializa vetor com número pseudo-aleatórios
	# Param: $a0 - Endereço base do vetor; $a1 - Tamanho do vetor em bytes; $a2 - Último valor alteatório utilizado
#	inicializaVetor:
	# Prólogo
#		addi $sp, $sp, -0	# Ajusta a pilha
#		sw $a0, 0($sp)
#		sw $a1, 0($sp)
#		sw $a2, 0($sp)
#		sw $ra, 0($sp)
		
		# Loop
#		inicializaVetorLaco1:
#			move $t0, $v0
		
		# Epílogo
#		inicializaVetorEpilogo:
#			lw $a0, 0($sp)
		
	
	.main	# Programa principal
#		move $t0, $zero	# Índice do vetor
#		move $t1, $zero	# Valor a ser colocado no vetor
#		lw $t2, size	# Tamanho do vetor em bytes
		
		addi $a0, $zero, 10
		addi $a1, $zero, 4
		jal valorAleatorio
		
		move $a0, $v0
		li $v0, 1
		syscall
		
	
		foraDaImpressao:
			li $v0, 10	# Instrução: encerra o programa
			syscall
	
	
	# Funções
	#
		
	# Gera número pseudo-aleatório por congruência linear
	# Param: $a0 - 1o inteiro; $a1 - 2o inteiro; $a2 - 3o inteiro; $a3 - 4o inteiro
	valorAleatorio:
		#lw $t0, 16($sp)	# $t0 recebe o 5o argumento
		mult $a0, $a1	# a * b
		mflo $t1
		move $v0, $t1
		jr $ra

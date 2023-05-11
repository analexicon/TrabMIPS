.data
	# Área para dados na memória principal
	
	size: 80	# Tamanho do vetor em bytes (20 espaços de 4 bytes)
	
	vetor:	# Declaração do vetor
		.align 2	# Tamanho de cada elemento
		.space 80	# Quantidade de bytes de espaço alocados (20 espaços de 4 bytes)

.text
	# Área para instruções do programa
	 
	move $t0, $zero	# Índice do vetor
	move $t1, $zero	# Valor a ser colocado no vetor
	lw $t2, size	# Tamanho do vetor em bytes
	
	loop:	# Preenche um vetor com o índice de cada elemento
		beq $t0, $t2, foraDaInicializacao	# Percorre do começo ao fim do vetor
		sw $t1, vetor($t0)	# Guarda o índice natural (0,1...n) na posição atual do vetor
		addi $t0, $t0, 4	# Incrementa o índice de bytes
		addi $t1, $t1, 1	# Incrementa o índice natural
		j loop
		
	foraDaInicializacao:
		move $t0, $zero
		imprime:	# Imprime o vetor
			beq $t0, $t2, foraDaImpressao	# Percorre do começo ao fim do vetor
			lw $a0, vetor($t0)	# Carrega o elemento no registrador para impressão
			li $v0, 1	# Instrução: imprime palavra
			syscall
			addi $t0, $t0, 4	# Incrementa o índice de bytes
			j imprime
	
	foraDaImpressao:
		li $v0, 10	# Instrução: encerra o programa
		syscall
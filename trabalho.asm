.data
	# Área para dados na memória principal
	msg: .asciiz "Olá, mundo!" # Mensagem a ser exibida para o usuário
	numero: .word 47 # Número a ser exibido

.text
	# Área para instruções do programa
	 
	li $v0, 4 # Instrução para impressão de string
	la $a0, msg # Indica o endereço onde está a mensagem
	syscall # Imprime
	
	li $v0, 1 # Instrução para imprimir palavra
	lw $a0, numero # Carrega o endereço da mensagem
	syscall # Imprime
	
	li $v0, 10 # Instrução: encerra o programa
	syscall
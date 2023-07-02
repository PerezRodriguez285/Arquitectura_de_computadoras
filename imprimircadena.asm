.data
	#Realizamos la creacion de nuestras variables
	cadena: .asciiz "Soy Antonio Alberto de la Luz"

.text
	li $v0, 4	#Colocamos el mensaje en el registro
	la $a0, cadena
	syscall		#Llamamos al sistema
	

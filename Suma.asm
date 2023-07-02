.data
	#creacion de variables para la operacion
	numero1: .asciiz "Ingresa el primer numero:\n"
	numero2: .asciiz "Ingresa el segundo numero:\n"
	resultado: .asciiz "Resultado: "
	
.text

	#Guardamos el primer numero
	li $v0, 4	#lo guardamos en el registro 0
	la $a0, numero1 #Almacenamos la primer variable
	syscall		#Llamamos al sistema
	
	#Se registra el primer numero
	li $v0, 5	#Ingresamos un numero por teclado
	syscall
	
	#Movemos el numero1 a otro registro
	move $t0, $v0	#Movemos lo que esta el registro v0 al registro t0
	
	#Guardamos el segundo numero
	li $v0, 4	#lo guardamos en el registro 0
	la $a0, numero2 #Almacenamos la segunda variable
	syscall		#Llamamos al sistema
	
	#Se registra el segundo numero
	li $v0, 5	
	syscall
	
	#Movemos el numero1 a otro registro
	move $t1, $v0	#Movemos lo que esta el registro v0 al registro t1
	
	#Se hace la suma de los 2 numeros
	add $t2, $t0, $t1 #Guardamos el resultado en el registro t2
	
	#Mostrar el mendaje de resultado
	li $v0, 4
	la $a0, resultado
	syscall
	
	#Se imprimer el resultado
	li $v0, 1	#Mostramos el resultado en enteros
	move $a0, $t2	#Mover lo que se guardo en t2 al registro a0
	syscall
	
	#terminamos el programa
	li $v0, 10
	syscall
	
	
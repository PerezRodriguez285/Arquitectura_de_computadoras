	.data 			#Apartado de variables 	
tira1: 	.asciiz "Hola Mundo"	#Cadena de caracteres
	.text 			#Fin del apartado de variables

main: 

	li $v0,4 	#Se llama al servicio 4 para imprimir una cadena
	la $a0,tira1 	#Se carga la cadena tira1 a  --> a0
	syscall 	#Se finaliza la instruccion 
	
	li $v0,17	#Carga el servico 17 para dar exit 
	li $a0,0	#Se carga el valor 0 en $a0
	syscall 	#Da finalizacion del programa
	
	

.data
    prompt: .asciiz "Ingrese un ángulo en grados: "
    menuP: .asciiz	"\nElige una función:\n1. Movimiento circular uniformemente acelerado\n2. Seno\n3. Seno inverso\n4. Secante\n5. Secante inversa\n6. ax + b = y\n7. Salir\n"
    invalid_msg: .asciiz "Opción inválida. Intente de nuevo.\n"
    result_msg: .asciiz "Resultado: "
    pi: .double 3.14159265359
    zero: .double	0.0
    two: .double	2.0
    one: .double	1.0
    norm: .double 360.0
    radians: .double 180.0
    
    
.text
.globl main
# Función para mostrar el menú

main:
	#$t0 = iteraciones de maclaurin
	li $t0, 8 		
	        
    	# Imprimir opciones del menú
    	li $v0, 4
    	la $a0, menuP
    	syscall
    	
    	# Leer opción del usuario
    	li $v0, 5
    	syscall
    	move $t8, $v0        # Guardar la opción en $a0
    	# Saltar a la función correspondiente
    	beq $t8, 1, mcua
    	beq $t8, 2, pedirAngulo
    	beq $t8, 3, pedirAngulo
    	beq $t8, 4, pedirAngulo
    	beq $t8, 5, pedirAngulo
    	beq $t8, 6, eq
    	beq $t8, 7, exit
    	j no_valida
# Función para manejar opciones inválidas
no_valida:
    li $v0, 4
    la $a0, invalid_msg
    syscall
    j main
        
exit:
	li $v0, 10
	syscall 


# Movimiento Circular Uniformemente Acelerado
mcua:
     
    

#sen(x)
seno:
	#x - (pow(x,3)/3!) + (pow(x,5)/5!) - ...	
	#$f28 = resultado aproximacion
	#$t1 = iterador (k)
	#$f26 = potencia
	#$t2 = factorial
	#$f12 = angulo en radianes
	#$t3 = 2k+1
	#$t6 = bandera signo
	li $t1, 1
	l.d $f28, zero
	l.d $f26, zero
	add.d $f28, $f28,$f12 	#resultado aproximado	
	add.d $f26, $f26,$f12 	#potencia
	li $t6, 2
	
loopS:
	bge $t1, $t0, salir			
	mul $t3, $t1, 2		#calculo de t3
	add $t3, $t3, 1		#calculo de t3
	
	li $t4, 1 			#contador temporal
	jal potencia
	li $t2, 1 			#factorial
	li $t4, 1 			#contador temporal
	jal factorial 		#Está el resultado en $t2	
	mtc1 $t2, $f2			#factorial en double	
	cvt.d.w $f2, $f2		#word a double para operar
	div.d $f22, $f26, $f2	#potencia / factorial
	
	beq $t6, 1, sumarS
	beq $t6, 2, restarS		
sumarS:
	add.d $f28, $f28, $f22
	addi $t1, $t1, 1
	li $t6, 2
	j loopS

restarS: 
	sub.d $f28, $f28, $f22
	addi $t1, $t1, 1
	li $t6, 1
	j loopS		


# arcsin(x)
asin:

    # $t1 = iterador (k)
    # $f28 = resultado aproximado
    # $f26 = potencia
    li $t1, 1
    l.d $f28, zero
    l.d $f26, zero
    add.d $f28, $f28, $f12 	# resultado aproximado	
    add.d $f26, $f26, $f12 	# potencia

loopAsin:
    bge $t1, $t0, salir    # Salir del bucle cuando se alcance el número de iteraciones deseado

    mul $t3, $t1, 2         # cálculo de t3
    add $t3, $t3, 1         # cálculo de t3

    li $t4, 1               # contador temporal
    jal potencia            # Llama a la función potencia
    li $t2, 1               # factorial
    li $t4, 1               # contador temporal
    jal factorial           # Llama a la función factorial

    mtc1 $t2, $f2           # factorial en double	
    cvt.d.w $f2, $f2        # word a double para operar
    div.d $f22, $f26, $f2   # potencia / factorial

    beq $t6, 1, sumarAsin
    beq $t6, 2, restarAsin

sumarAsin:
    add.d $f28, $f28, $f22
    addi $t1, $t1, 1
    li $t6, 2
    j loopAsin

restarAsin: 
    sub.d $f28, $f28, $f22
    addi $t1, $t1, 1
    li $t6, 1
    j loopAsin
        

    
#sec(x)
sec:
    # 1 / cos(x)
    li $t1, 1            # Inicializamos el iterador (k) con 1
    li $t6, 2            # Inicializamos la bandera de signo con 2
    jal cos       
    	
cos:
    # Inicializar variables
    li $t1, 1
    l.d $f28, one       # Inicializar el resultado aproximado a 1 (primer término de la serie)
    l.d $f26, one       # Inicializar la potencia a 1 (x^0)
    li $t6, 2           # Inicializar la bandera de signo a 2 (restar en el primer término)

    loopC:
        bge $t1, $t0, salirC  # Si hemos alcanzado el número de iteraciones deseado, salir del bucle
        
        # Cálculos para el término actual
        mul $t3, $t1, 2     # 2k
        li $t4, 1           # Inicializar contador temporal para el factorial
        jal potencia        # Calcular potencia ($f26 = x^(2k))
        li $t2, 1           # Inicializar factorial a 1
        li $t4, 1           # Reinicializar contador temporal para el factorial
        jal factorial       # Calcular factorial ($t2 = (2k)!)
        mtc1 $t2, $f2       # Convertir factorial a double
        cvt.d.w $f2, $f2    # Convertir a double para operar
        div.d $f22, $f26, $f2   # Potencia / Factorial
        
        # Actualizar resultado
        beq $t6, 1, restarC
        beq $t6, 2, sumarC
        
        sumarC:
            add.d $f28, $f28, $f22
            addi $t1, $t1, 1
            li $t6, 2
            j loopC

        restarC:
            sub.d $f28, $f28, $f22
            addi $t1, $t1, 1
            li $t6, 1
            j loopC
salirC:
    l.d $f16, one
    div.d $f22, $f16, $f28 # 1 / cos(x)
    j salir

#arcsec(x)
asec:
    # Inicializar variables
    li $t1, 1
    l.d $f28, zero       # Inicializar el resultado aproximado a 0
    l.d $f26, one        # Inicializar la potencia a 1 (x^0)
    li $t6, 2            # Inicializar la bandera de signo a 2 (restar en el primer término)

    loopAsec:
        bge $t1, $t0, salirAsec  # Si hemos alcanzado el número de iteraciones deseado, salir del bucle

        # Cálculos para el término actual
        mul $t3, $t1, 2     # 2k
        li $t4, 1           # Inicializar contador temporal para el factorial
        jal potencia        # Calcular potencia ($f26 = x^(2k))
        li $t2, 1           # Inicializar factorial a 1
        li $t4, 1           # Reinicializar contador temporal para el factorial
        jal factorial       # Calcular factorial ($t2 = (2k)!)
        mtc1 $t2, $f2       # Convertir factorial a double
        cvt.d.w $f2, $f2    # Convertir a double para operar
        div.d $f22, $f26, $f2   # Potencia / Factorial

        # Actualizar resultado
        beq $t6, 1, restarAsec
        beq $t6, 2, sumarAsec

        sumarAsec:
            add.d $f28, $f28, $f22
            addi $t1, $t1, 1
            li $t6, 2
            j loopAsec

        restarAsec:
            sub.d $f28, $f28, $f22
            addi $t1, $t1, 1
            li $t6, 1
            j loopAsec
    salirAsec:
        l.d $f16, one
        div.d $f22, $f16, $f28 # 1 / arcsec(x)
        j salir

# Función: ax + b = y
eq:
# Inicializar variables
    l.d $f28, zero      # Inicializar el resultado aproximado a 0
    l.d $f26, one       # Inicializar la potencia a 1 (x^0)
    l.d $f22, one       # Inicializar el término constante del polinomio
    li $t1, 1           # Inicializar el iterador (k) a 1
    li $t6, 2           # Inicializar la bandera de signo a 2 (restar en el primer término)

    loopEq:
        bge $t1, $t0, salirEq  # Si hemos alcanzado el número de iteraciones deseado, salir del bucle

        # Cálculos para el término actual
        li $t2, 1           # Inicializar el factorial a 1
        li $t3, 1           # Inicializar el contador temporal para el factorial a 1
        jal factorial       # Calcular factorial ($t2 = 1!)

        mtc1 $t2, $f2       # Convertir factorial a double
        cvt.d.w $f2, $f2    # Convertir a double para operar
        div.d $f24, $f26, $f2   # x / factorial

        # Actualizar resultado
        beq $t6, 1, restarEq
        beq $t6, 2, sumarEq

        sumarEq:
            add.d $f28, $f28, $f24  # Añadir al resultado
            addi $t1, $t1, 1        # Incrementar el iterador
            li $t6, 2               # Cambiar la bandera de signo a sumar
            j loopEq

        restarEq:
            sub.d $f28, $f28, $f24  # Restar del resultado
            addi $t1, $t1, 1        # Incrementar el iterador
            li $t6, 1               # Cambiar la bandera de signo a restar
            j loopEq
    salirEq:
       
        j salir
            
    
                          
#Funciones globales

pedirAngulo:
	#Pedir angulo
	li $v0, 4
	la $a0, prompt
	syscall 
	#ingreso de angulo en $f0 como double
	l.d $f0, zero
	li $v0, 7
	syscall
	
	jal normalizar

normalizar:	
	l.d $f14, norm	
	c.le.d $f14, $f0         # Compare angle with 360
	bc1f radian 		    # If angle <= 360, convertir a radianes
	div.d $f0, $f0, $f14
	c.le.d 1, $f14, $f0
	bc1f normalizar
	
radian:
	l.d $f14, radians
	l.d $f16, pi
	div.d $f18, $f16, $f14
	mul.d $f12, $f0, $f18	#$f12 = angulo en radianes	
	j menu2
menu2:
	beq $t8, 2, seno
    	beq $t8, 3, asin
    	beq $t8, 4, sec
    	beq $t8, 5, asec
	
potencia:	
	bge $t4, $t3, volver
	mul.d $f26, $f26, $f12
	addi $t4, $t4, 1	
	j potencia

factorial:
	bgt  $t4, $t3, volver
	mul $t2, $t2, $t4
	addi $t4, $t4, 1
	j factorial
	
volver: 
	jr $ra
		
salir: 
	mov.d $f12, $f28
	li $v0, 4
	la $a0, result_msg
	syscall	
	li $v0, 3
	syscall	
	j main   





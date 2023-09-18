.data
theta0:      .float 0.0   # Posición angular inicial
omega0:      .float 0.0   # Velocidad angular inicial
alfa:       .float 0.0   # Aceleración angular constante
t:           .float 0.0   # Tiempo



    
menu: .asciiz "\nSeleccione una opción:\n1. Calcular posición angular\n2. Calcular velocidad angular\n3. Calcular velocidad tangencial\n4. Calcular aceleración angular\n5. Salir\nOpción: "
resultado_concatenado:  .asciiz "El resultado es: "

entrada_theta: .asciiz "Ingrese la posición angular inicial (en radianes): "
entrada_omega: .asciiz "Ingrese la velocidad angular inicial (en radianes por segundo): "
entrada_alfa: .asciiz "Ingrese la aceleración angular constante (en radianes por segundo al cuadrado): "
entrada_tiempo:     .asciiz "Ingrese el tiempo (en segundos): "
entrada_radio: .asciiz"Ingrese el radio (en metros): "


.text
.globl main

main:
    # Imprimir el menú
    li $v0, 4
    la $a0, menu
    syscall

    # Leer entrada
    li $v0, 5
    syscall
    move $t0, $v0   # Almacenar la opción en $t0

    beq $t0, 1, calcular_posicion
    beq $t0, 2, calcular_velocidad_angular
    beq $t0, 3, calcular_velocidad_tangencial
    beq $t0, 4, calcular_aceleracion
    beq $t0, 5, salir

calcular_posicion:
    li $v0, 4
    la $a0, entrada_theta
    syscall

    li $v0, 6
    syscall
    mov.s $f0, $f0  

    li $v0, 4
    la $a0, entrada_omega
    syscall

    li $v0, 6
    syscall
    mov.s $f1, $f0  

    li $v0, 4
    la $a0, entrada_alfa
    syscall

    li $v0, 6
    syscall
    mov.s $f2, $f0  

    li $v0, 4
    la $a0, entrada_tiempo
    syscall

    li $v0, 6
    syscall
    mov.s $f3, $f0  

    # Calcular la posición angular: theta = theta0 + omega0 * t + 0.5 * alfa * t^2
    mul.s $f4, $f2, $f3       # alfa * t
    mul.s $f5, $f4, $f3       # alfa * t^2
    mul.s $f6, $f1, $f3       # omega0 * t
    add.s $f7, $f0, $f6       # theta0 + omega0 * t
    add.s $f8, $f7, $f5       # theta = theta0 + omega0 * t + 0.5 * alfa * t^2


    li $v0, 4
    la $a0, resultado_concatenado
    syscall


    li $v0, 2
    mov.s $f12, $f8
    syscall

    j main

calcular_velocidad_angular:


    li $v0, 4
    la $a0, entrada_omega
    syscall

    li $v0, 6
    syscall
    mov.s $f1, $f0  

    li $v0, 4
    la $a0, entrada_alfa
    syscall
    li $v0, 6
    syscall
    mov.s $f2, $f0   

    li $v0, 4
    la $a0, entrada_tiempo
    syscall

    li $v0, 6
    syscall
    mov.s $f3, $f0   

    # Calcular la velocidad angular # omega0 + alfa * t
    add.s $f9, $f1, $f2    

    li $v0, 4
    la $a0, resultado_concatenado
    syscall

    li $v0, 2
    mov.s $f12, $f9        
    syscall

    j main

calcular_velocidad_tangencial:


    li $v0, 4
    la $a0, entrada_alfa
    syscall

    li $v0, 6
    syscall
    mov.s $f2, $f0  

    li $v0, 4
    la $a0, entrada_radio
    syscall

    li $v0, 6
    syscall
    mov.s $f3, $f0   
    
    # Calcular la velocidad tangencial ; omega * radio
    mul.s $f10, $f2, $f3    
    add.s $f11, $f1, $f10   

    li $v0, 4
    la $a0, resultado_concatenado
    syscall

    li $v0, 2
    mov.s $f12, $f11        
    syscall

    j main

calcular_aceleracion:

    li $v0, 4
    la $a0, entrada_alfa
    syscall
    li $v0, 6
    syscall

    mov.s $f2, $f0   
    li $v0, 4
    la $a0, resultado_concatenado
    syscall

    li $v0, 2
    mov.s $f12, $f2        
    syscall

    j main

salir:
    li $v0, 10
    syscall
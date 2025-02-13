;
; Laboratorio1.asm
;
; Created: 7/02/2025 16:51:44
; Author : Daniela Alexandra Moreira Cruz 2841
;Descripcion: creacion de dos contadores binarios de 4 bits con subrutinas 
;
// Encabezado
.include "M328PDEF.inc"
.cseg
.org 0x0000
// Configurar la pila
	LDI		R16, LOW(RAMEND)
	OUT		SPL, R16
	LDI		R16, HIGH(RAMEND)
	OUT		SPH, R16
SETUP:
	// Configuracion de pines de entrada y salida (DDRx, PORTx, PINx)
	// PORTC como entrada con pull-up habilitado
	LDI		R16, 0x00
	OUT		DDRC, R16 // Puerto D como entrada al ingresar bit como 0
	LDI		R16, 0xFF
	OUT		PORTC, R16 // Habilitar pull-ups en puerto C

	//Configurar el puerto B como salidas, estabecerlo en apagado
	LDI		R16, 0xFF
	OUT		DDRB, R16 // Setear puerto B como salida
	LDI		R16, 0x00
	OUT		PORTB, R16 //Todos los bits en apagado 
	LDI		R17, 0xFF // Variable para guardar estado de botones
					// se usa como comparacion 
	LDI		R18, 0x00 //contador 1 
	//Configurar el puerto D como salidas, estabecerlo en apagado
	LDI		R16, 0xFF
	OUT		DDRD, R16 // Setear puerto B como salida
	LDI		R16, 0x00
	OUT		PORTD, R16 //Todos los bits en apagado 
	LDI		R20, 0x00 //contador 2

// Loop infinito para anti rebote 
MAIN:
	IN		R16, PINC // Guardando el estado de PORTC en R16 0xFF
	CP		R17, R16 // Comparamos estado "viejo" con estado "nuevo"
	BREQ	MAIN
	CALL	DELAY
	IN		R16, PINC
	CP		R17, R16
	BREQ	MAIN
	// Volver a leer PIND
	MOV		R17, R16 //copia el estado actual del pin en R17
	SBRS	R16, 2 // Salta si el bit 2 del PINC es 1 (no apachado)
	CALL	SUMA1 //si el botón esta presionado suma
	SBRS	R16, 3 //Si el bit 3 de PINC es 1 (botón NO presionado), salta la siguiente instrucción
	CALL	RESTA1 // Si el boton 2 está presionado, llama a RESTA
	SBRS	R16, 4 // Salta si el bit 2 del PINC es 1 (no apachado)
	CALL	SUMA2 //si el botón esta presionado suma
	SBRS	R16, 5 //Si el bit 3 de PINC es 1 (botón NO presionado), salta la siguiente instrucción
	CALL	RESTA2 // Si el boton 2 está presionado, llama a RESTA
	RJMP	MAIN

//Para el contador 1 
SUMA1: 
	INC		R18
	CPI		R18, 0x10 //comparar con 16
	BREQ	OF1 //si es 16 ejecutar el break 
	OUT		PORTB, R18 //si no es 16 cargar el valor 
	RET
OF1:
	LDI		R18, 0x00 //si es 16 el valor hay of y se hace 0
	OUT		PORTB, R18
	RET
UF1:
	LDI		R18, 0x0F // para que cuando regrese sea 15
	OUT		PORTB, R18 
	RET
RESTA1:
	CPI		R18, 0x00
	BREQ	UF1 // si es 0 ir a under flow 
	DEC		R18 // si no es 0 restar y luego dar el resultado
	OUT		PORTB, R18 
	RET
//Para el contador 2 
SUMA2: 
	INC		R20
	CPI		R20, 0x10 //comparar con 16
	BREQ	OF2 //si es 16 ejecutar el break 
	OUT		PORTD, R20 //si no es 16 cargar el valor 
	RET
OF2:
	LDI		R20, 0x00 //si es 16 el valor hay of y se hace 0
	OUT		PORTD, R20 
	RET
UF2:
	LDI		R20, 0x0F // 16 para que cuando regrese sea 15
	OUT		PORTD, R20 
	RET
RESTA2:
	CPI		R20, 0x00
	BREQ	UF2 // si es 0 ir a under flow 
	DEC		R20 // si no es 0 restar y luego dar el resultado
	OUT		PORTD, R20 
	RET 

// Sub-rutina 
DELAY:
	LDI		R19, 0xFF
SUB_DELAY1:
	DEC		R19
	CPI		R19, 0
	BRNE	SUB_DELAY1
	LDI		R19, 0xFF
SUB_DELAY2:
	DEC		R19
	CPI		R19, 0
	BRNE	SUB_DELAY2
	LDI		R19, 0xFF
SUB_DELAY3:
	DEC		R19
	CPI		R19, 0
	BRNE	SUB_DELAY3
	RET
;########### SECCION DE DATOS

section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global complex_sum_z
global packed_complex_sum_z
global product_9_f

;########### DEFINICION DE FUNCIONES
;extern uint32_t complex_sum_z(complex_item *arr, uint32_t arr_length);
;registros: arr[rdi], arr_length[rsi]
complex_sum_z:
	;prologo
	push rbp
	mov  rbp, rsp

	mov rax, 0; Acumulador
	mov rdx, 0
	mov rcx, rsi
	
.cycle:			; etiqueta a donde retorna el ciclo que itera sobre arr

;	[ Base + ( Index * Scale ) + Displacement ]
	add rax, [rdi + rdx + 0x18]
	add rdx, 0x20
	loop .cycle		; decrementa ecx y si es distinto de 0 salta a .cycle
	
	;epilogo
	pop rbp
	ret
	
;extern uint32_t packed_complex_sum_z(packed_complex_item *arr, uint32_t arr_length);
;registros: arr[?], arr_length[?]
packed_complex_sum_z:

	;prologo
	push rbp
	mov  rbp, rsp

	mov rax, 0; Acumulador
	mov rdx, 0
	mov rcx, rsi

.cycle:			; etiqueta a donde retorna el ciclo que itera sobre arr
	;	[ Base + ( Index * Scale ) + Displacement ]
	add rax, [rdi + rdx + 0x14]
	add rdx, 0x18
	loop .cycle		; decrementa ecx y si es distinto de 0 salta a .cycle

	;epilogo
	pop rbp
	ret


; Convierte todos los parámetros a double, realiza la multiplicación de todos ellos y 
; aloja el resultado en destination. 
; Nota de implementación: Ir multiplicando todos los floats en primer lugar, luego, 
; ir multiplicando ese resultado con cada entero, uno a uno.

;extern void product_9_f(uint32_t * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[rsi], f1[xmm0], x2[rdx], f2[xmm1], x3[rcx], f3[xmm2], x4[r8], f4[xmm3]
;	, x5[r9], f5[xmm4], x6[STACK], f6[xmm5], x7[STACK], f7[xmm6], x8[STACK], f8[xmm7],
;	, x9[STACK], f9[STACK]
product_9_f:

	;prologo 
	push rbp
	mov rbp, rsp
	
	mov r15, rdi
	;convertimos los flotantes de cada registro xmm en doubles
	
	movq xmm0, xmm0
	call convertirFloatADouble
	movq xmm15, xmm14

	movq xmm0, xmm1
	call convertirFloatADouble
	movq xmm1, xmm14

	movq xmm0, xmm2
	call convertirFloatADouble
	movq xmm2, xmm14

	movq xmm0, xmm3
	call convertirFloatADouble
	movq xmm3, xmm14

	movq xmm0, xmm4
	call convertirFloatADouble
	movq xmm4, xmm14

	movq xmm0, xmm5
	call convertirFloatADouble
	movq xmm5, xmm14

	movq xmm0, xmm6
	call convertirFloatADouble
	movq xmm6, xmm14

	movq xmm0, xmm7
	call convertirFloatADouble
	movq xmm7, xmm14

	movq xmm0, [rbp + 0x30]
	call convertirFloatADouble
	movq xmm8, xmm14

	movq xmm0, xmm15
	
	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	
	mulsd xmm0, xmm1
	mulsd xmm0, xmm2
	mulsd xmm0, xmm3
	mulsd xmm0, xmm4
	mulsd xmm0, xmm5
	mulsd xmm0, xmm6
	mulsd xmm0, xmm7
	mulsd xmm0, xmm8
	
	; Ya tenemos los punto flotante multiplicados

;	Movemos el producto de floats a xmm15
	movq xmm15, xmm0

	; convertimos los enteros en doubles y los multiplicamos por xmm0. 

	mov  rdi, rsi
	call convertirIntADouble
	movq xmm1, xmm0

	mov  rdi, rdx
	call convertirIntADouble
	movq xmm2, xmm0

	mov  rdi, rcx
	call convertirIntADouble
	movq xmm3, xmm0

	mov  rdi, r8
	call convertirIntADouble
	movq xmm4, xmm0

	mov  rdi, r9
	call convertirIntADouble
	movq xmm5, xmm0

	mov  rdi, [rbp + 0x10]
	call convertirIntADouble
	movq xmm6, xmm0

	mov  rdi, [rbp + 0x18]
	call convertirIntADouble
	movq xmm7, xmm0

	mov rdi, [rbp + 0x20]
	call convertirIntADouble
	movq xmm8, xmm0

	mov rdi, [rbp + 0x28]
	call convertirIntADouble
	movq xmm9, xmm0

;	Devolvemos el producto de floats a xmm0
	movq xmm0, xmm15

	mulsd xmm1, xmm2
	mulsd xmm1, xmm3
	mulsd xmm1, xmm4
	mulsd xmm1, xmm5
	mulsd xmm1, xmm6
	mulsd xmm1, xmm7
	mulsd xmm1, xmm8
	mulsd xmm1, xmm9
	
	; COMPLETAR 

	mulsd xmm0, xmm1

	; NOTA MENTAL : SIEMPRE TENER EN CUENTA DONDE PRESERVAMOS EL RDI
	movq [r15], xmm0

	; epilogo 
	pop rbp
	ret


;cvtsi2sd = Esta es la funcion para convertir de float a double y lo mismo con integer 
; convertirFloatADouble:
; convertirIntADouble:

convertirFloatADouble: 
	cvtss2sd xmm14, xmm0
	ret

convertirIntADouble:
	cvtsi2sd xmm0, rdi
	ret


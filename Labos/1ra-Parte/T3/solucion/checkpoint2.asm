extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_simplified
global alternate_sum_8
global product_2_f
global alternate_sum_4_using_c

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[edi], x2[esi], x3[edx], x4[ecx]
alternate_sum_4:
	;prologo

	; COMPLETAR 
	;recordar que si la pila estaba alineada a 16 al hacer la llamada
	;con el push de RIP como efecto del CALL queda alineada a 8
	push 	rbp
	mov 	rbp, rsp

	mov 	eax, edi
	sub		eax, esi
	add		eax, edx
	sub 	eax, ecx

	;epilogo
	; COMPLETAR 
	pop		rbp
	ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
; devuelve el resultado la operación x1 - x2 + x3 - x4, usando obligatoriamente para las operaciones 
alternate_sum_4_using_c: 

	;prologo
    push rbp ; alineado a 16
    mov rbp,rsp

	call restar_c

	mov		rdi, rax
	mov		rsi, rdx
	call sumar_c

	mov		rdi, rax
	mov		rsi, rcx
	call restar_c

	;epilogo
	pop rbp
    ret 



; uint32_t alternate_sum_4_simplified(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[edi], x2[esi], x3[edx], x4[ecx]

alternate_sum_4_simplified:

	mov 	eax, edi
	sub		eax, esi
	add		eax, edx
	sub 	eax, ecx

	ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);	
; registros y pila: x1[edi], x2[esi], x3[edx], x4[ecx], x5[r8], x6[r9], x7[STACK], x8[STACK]
alternate_sum_8:
	;prologo

	push	rbp
	mov 	rbp, rsp
	

	; COMPLETAR 

	mov 	eax, edi
	sub		eax, esi
	add		eax, edx
	sub 	eax, ecx
	add		eax, r8d
	sub 	eax, r9d
	add		eax, [rbp + 0x10]
	sub 	eax, [rbp + 0x18]

	;epilogo

	pop 	rbp
	ret

;El stack crece para arriba hacia las dir menores.	
	;RBP	
	;RIP
	;x7 <- RBP + 0x10
	;x8 <- dir mas grande. RBP + 0x18

; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[rdi], x1[rsi], f1[XXM0]
product_2_f:
	;prologo
	push rbp
	mov  rbp, rsp
	dec  rsi
	movq  xmm1, xmm0

sumar:	addss xmm0, xmm1 
		sub rsi, 1
		jnz sumar

;	Esta es la que va, funciona
;	cvtss2si  rcx, xmm0 ;

;	Convert lowest SP FP from XMM/Mem to one 32-bit signed
	cvttss2si  rcx, xmm0 ;
	mov [rdi], rcx

	pop rbp
	ret
	
; MOVD -> 32-bits
; MOVQ -> 64-bits

section .data
	ldFormat: db "%ld ", 0
	dFormat: db "%d ", 0

section .bss

    temp: resq 1
    counter: resq 1
    memory: resq 1

section .text
    global main
    extern scanf, printf, malloc, free

main:
    push rbp
    mov rbp, rsp
	xor rax, rax

    .inputLoop:
        mov rdi, ldFormat
        mov rsi, temp
        call scanf
        cmp eax, -1
        je .insertInput
        push qword [temp]
		sub rsp, 8
        inc qword [counter]
        jmp .inputLoop

    .insertInput:
        mov rax, [counter]
		mov rbx, 4
        mul rbx
        mov rdi, rax
        call malloc             ; malloc(*counter * sizeof(int))
        mov [memory], rax
        mov rcx, [counter]
        mov rax, [memory]
        .fillMemory:            ; iterate input from the end
			add rsp, 8
            pop qword rbx
			mov [rax + 4*rcx - 4], ebx   ; memory[rcx - 4] = currentItem
            loop .fillMemory, rcx
	
	xor rcx, rcx				; main loop index
	mov rdi, [memory]
	.mainLoop:
		cmp dword [rdi + 4*rcx], 0
		jnz .body
		cmp dword [rdi + 4*rcx + 4], 0
		jnz .body
		cmp dword [rdi + 4*rcx + 8], 0
		jz .print

		.body:
			xor rax, rax
			xor rbx, rbx
			mov eax, dword [rdi + 4*rcx]			; M[i]
			mov ebx, dword [rdi + 4*rcx + 4]		; M[i+1]
			mov edx, dword [rdi + 4*rbx]			; M[M[i+1]]
			sub dword [rdi + 4*rax], edx			; substructing B from A
			cmp dword [rdi + 4*rax], 0
			jge .iterate
			mov ecx, dword [rdi + 4*rcx + 8]		; M[i+2]
			jmp .mainLoop

			.iterate:
				add rcx, 3
				jmp .mainLoop
	
	.print:
		xor rcx, rcx
		.printLoop:
			mov rdi, [memory]
			xor rsi, rsi
			mov rsi, [rdi + 4*rcx]
			mov rdi, dFormat
			xor rax, rax
			push rcx
			push rcx
			call printf
			pop rcx
			pop rcx
			inc rcx
			cmp rcx, [counter]
			jne .printLoop
			
	.done:
		mov rdi, [memory]
		call free
		mov rsp, rbp
		pop rbp
		ret
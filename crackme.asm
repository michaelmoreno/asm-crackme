section .data
    pass db 'SNICEBSRFFBE', 0
    pass_len equ $ - pass

    prompt db 'Enter the serial number: ', 0
    prompt_len equ $ - prompt

    win_msg db 'Thanks for registering!', 0
    win_msg_len equ $ - win_msg

    lose_msg db 'Sorry, that serial number is not valid.', 0
    lose_msg_len equ $ - lose_msg

section .bss
    user_input resd 256

section .text
    global _start

_start:

_decrypt:
    mov esi, pass

_decryptLoop:
    mov al, [esi] ; get current character
    cmp al, 0 ; compare it to 0, end of string
    je _sendPrompt ; jump to next stage if done
    sub al, 13 ; otherwise, sub 13 from the character value
    ; compare the new value to 'A'
    cmp al, 'A' 
    jb _add26
    jmp _storeChar

_add26:
    add al, 26 ; otherwise, add 26 first

_storeChar:
    mov [esi], al ; store the character
    inc esi ; increment the pointer
    jmp _decryptLoop ; jump back to the beginning of the loop
    
_readInput:
    mov eax, 3 ; sys-read 
    mov ebx, 0 ; source (stdin)
    mov edx, pass_len ; how many values to read/write
    mov ecx, user_input ; first-address of write location
    int 0x80 ; invoke system call
    call _makeZeroTerminated ; replace newline in input string with 0
    jmp _checkInput

_puts:
    mov ebx, 1 ; stdout
    mov eax, 4 ; write 
    int 0x80
    ret

_sendPrompt:
    mov edx, prompt_len
    mov ecx, prompt
    call _puts
    jmp _readInput 


_checkInput:
    mov rsi, pass
    mov rdi, user_input
    mov rcx, pass_len
    repe cmpsb ;
    jne _lose
    jmp _win

_makeZeroTerminated:
    mov edi, user_input ; this is the address to scan
    mov al, 10 ; this is the character to scan for
    mov ah, 0
    repne scasb; scan until we find a match
    mov [edi-1], ah ; set the location to null (edi will point to the character after)
    ret

_lose:
    mov edx, lose_msg_len
    mov ecx, lose_msg
    call _puts
    jmp _exit
    
_win:
    mov edx, win_msg_len
    mov ecx, win_msg
    call _puts
    jmp _exit

_exit:
    mov eax, 1
    int 0x80 ; 


    
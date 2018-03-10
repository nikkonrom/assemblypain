; multi-segment executable file template.

data segment
    ; add your data here!
    intro db "Input array of 30 numbers:", 0Dh, 0Ah, "$"
    inputsmg db "Enter array[$"
    numbuf db 6 dup("$")
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    
            
    lea dx, intro
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    lea di, numbuf
    mov cx, 30
    
    
    inputarray:
    mov ax, 30
    sub ax, cx
    call word_to_udec_str   
     
    mov ah, 09h
    
    lea dx, inputsmg    
    int 21h
    mov dx, di
    int 21h
    call newline
    
    loop inputarray
    
    
    
    
    
    mov ax, 4c00h ; exit to operating system.
    int 21h

newline proc near                  
        push ax
        mov dl,0Dh
        call outchar
        mov dl,0Ah
        call outchar
	    pop ax
        ret
newline endp 

outchar proc near   ;  outchar dl 
        mov  ah,2     
        int 21h
        ret
outchar endp

word_to_udec_str:
    pusha
    xor cx,cx               ;Обнуление CX
    mov bx,10               ;В BX делитель (10 для десятичной системы)
 
divandstoreloop:                  ;Цикл получения остатков от деления
    xor dx,dx               ;Обнуление старшей части двойного слова
    div bx                  ;Деление AX=(DX:AX)/BX, остаток в DX
    add dl,'0'              ;Преобразование остатка в код символа
    push dx                 ;Сохранение в стеке
    inc cx                  ;Увеличение счетчика символов
    test ax,ax              ;Проверка AX
    jnz divandstoreloop           ;Переход к началу цикла, если частное не 0.
 
restoreloop:                  ;Цикл извлечения символов из стека
    pop dx                  ;Восстановление символа из стека
    mov [di],dl             ;Сохранение символа в буфере
    inc di                  ;Инкремент адреса буфера
    loop restoreloop          ;Команда цикла
    
    mov [di], "]"
    inc di
    mov [di], ":"
    popa
    ret
    
ends

end start ; set entry point and stop the assembler.

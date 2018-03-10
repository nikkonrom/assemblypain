; multi-segment executable file template.

data segment
    ; add your data here!
    intro db "Input array of 30 numbers:", 0Dh, 0Ah, "$"
    inputmsg db "Enter array[$"
    length db 5
    numbuf db 6 dup("$")
    numinputbuf db 8 dup("$")
    spacebuf db 30 dup(" "), "$"
    
    array dw 30 dup(0)
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
    lea si, array
    
    inputarray:
    mov ax, 30
    sub ax, cx
    call word_to_udec_str   
     
    mov ah, 09h
    
    lea dx, inputmsg    
    int 21h
    mov dx, di
    int 21h
    
    xor bx, bx
    mov bl, length
    mov [numinputbuf], bl
    mov [numinputbuf + 1], 0
    lea dx, numinputbuf
    mov ah, 0Ah
    int 21h
    
    mov al, [numinputbuf + 1]
    add dx, 2
    call str_to_udec_word
    mov [si], ax
    add si, 2
        
    mov dl, 0Dh
    call outchar
    
    lea dx, spacebuf
    mov ah, 09h
    int 21h
    
    mov dl, 0Dh
    call outchar
    
    loop inputarray
    
    lea si, array
    mov cx, 29
    mov ax, [si]
    loopfindmax:
    add si, 2
    cmp [si], ax
    jg assignmax
    continueloop: 
    loop loopfindmax
    jmp endfindmax
    
    assignmax:
    mov ax, [si]
    jmp continueloop
    
    endfindmax:  
    
    loopfindmin:
    lea si, array
    mov cx, 29
    mov ax, [si]
    
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

word_to_udec_str proc near
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
word_to_udec_str endp


str_to_udec_word proc near
    push cx                 
    push dx
    push bx
    push si
    push di
 
    mov si,dx               
    mov di,10               
    xor cx,cx 
    mov cl,al                
    jcxz studw_error        
    xor ax,ax               
    xor bx,bx               
 
studw_lp:
    mov bl,[si]             
    inc si                  
    cmp bl,'0'              
    jl studw_error          
    cmp bl,'9'              
    jg studw_error          
    sub bl,'0'              
    mul di                  
    jc studw_error          
    add ax,bx               
    jc studw_error          
    loop studw_lp           
    jmp studw_exit          
 
studw_error:
    xor ax,ax               
    stc                     
 
studw_exit:
    pop di                  
    pop si
    pop bx
    pop dx
    pop cx
    ret

str_to_udec_word endp
    
ends
end start ; set entry point and stop the assembler.

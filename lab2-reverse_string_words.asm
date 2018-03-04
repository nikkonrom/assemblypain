; multi-segment executable file template.

data segment
    ; add your data here!
    intro db "Enter string...", 0Dh,0Ah,"$"
    strbuf db 255 dup("$")
    length db 250
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
            
    lea dx, intro
    mov ah, 9
    int 21h        ; output intro string at ds:dx
    
    mov al, length      ;load max string length in al register for subsequent loading in string buffer 
    mov [strbuf], al
    mov [strbuf + 1], 0
    lea dx, strbuf
    mov ah, 0Ah
    int 21h
    mov al, [strbuf + 1]
    add dx,2
    
    mov bx, dx
    xor ah,ah
    add bx, ax
    add bx, 1    
    mov byte ptr[bx], 0Ah
    
    push dx
    call newline
    pop dx
    
    
    
    mov ah, 09h
    int 21h
    
    
    
    
    
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
   
ends

end start ; set entry point and stop the assembler.

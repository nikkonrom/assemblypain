; multi-segment executable file template.

data segment
    ; add your data here!
    intro db "Enter string...", 0Dh,0Ah,"$"
    strbuf db 255 dup("$")
    length db 250
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
    
    mov al, length        ;load max string length in al register for subsequent loading in string buffer 
    mov [strbuf], al      ;load max string length to first byte in string buffer
    mov [strbuf + 1], 0   ;null the second string buffer byte (fact length)
    lea dx, strbuf        ;load string buffer to dx
    mov ah, 0Ah           ;load 10th DOS func to ah (string input)
    int 21h               ;interrupt generating
    mov al, [strbuf + 1]  ;saving fact string length into al
    mov length, al
    add dx,2              ;moving dx ptr to fisrt string character
    
    mov bx, dx            ;moving dx ptr in bx register
    xor ah,ah             ;null ah (for clear adding ax register (only ah))
    add bx, ax            ;moving to str ending
    add bx, 1             ;moving over 0Dh, stored in string ending (check in debugger)
    mov byte ptr[bx], 0Ah ;adding a 0Ah over 0Dh dor new line in string ending ("sample/r/n" - in C)
    
    push dx               ;storing dx
    call newline          ;display newline in console
    pop dx                ;restoring dx
    
    mov bx, dx
    mov si, dx
    dec bx    
    loop_reverse_string:
    inc bx       
    call reverseword    
    cmp [bx], 0Dh
    loopne loop_reverse_string
    je continue 
    
    
    continue:
    mov dx, si    
    mov ah, 09h
    int 21h  
    
    mov ah, 4Ch ; exit to operating system.
    int 21h

reverseword proc near
        xor ax,ax
        xor cx,cx
        mov cl, length
        mov dx, bx 
        loopstore:
                
        mov al, [bx]
        push ax
        inc bx
        cmp [bx], " "
        je restore  
        cmp [bx], 0Dh
        je restore              
        loopne loopstore
        
        
        restore:
        xor cx,cx
        mov cl, length
        mov bx,dx
        looprestore:
        pop ax
        mov [bx], al
        inc bx
        cmp [bx], 0Dh
        je exit
        cmp [bx], " "
        je exit       
        loopne looprestore
        
        exit:
        
        mov length, cl        
        ret
reverseword endp        

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

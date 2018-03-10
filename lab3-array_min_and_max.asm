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
    xor cx,cx               ;��������� CX
    mov bx,10               ;� BX �������� (10 ��� ���������� �������)
 
divandstoreloop:                  ;���� ��������� �������� �� �������
    xor dx,dx               ;��������� ������� ����� �������� �����
    div bx                  ;������� AX=(DX:AX)/BX, ������� � DX
    add dl,'0'              ;�������������� ������� � ��� �������
    push dx                 ;���������� � �����
    inc cx                  ;���������� �������� ��������
    test ax,ax              ;�������� AX
    jnz divandstoreloop           ;������� � ������ �����, ���� ������� �� 0.
 
restoreloop:                  ;���� ���������� �������� �� �����
    pop dx                  ;�������������� ������� �� �����
    mov [di],dl             ;���������� ������� � ������
    inc di                  ;��������� ������ ������
    loop restoreloop          ;������� �����
    
    mov [di], "]"
    inc di
    mov [di], ":"
    popa
    ret
    
ends

end start ; set entry point and stop the assembler.

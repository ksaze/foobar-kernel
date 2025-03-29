org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A 

start:
  jmp main


; 
; Prints a string to the screen 
; Params 
;   - ds:si points to string 
; 
puts:
  ; save registers we need to modify
  push si 
  push ax 
  push bx 

.loop:
  lodsb ; loads next char into al 
  or al, al ; verify if the next character is null
  jz .done 
  
  mov ah, 0x0e ; call BIOS interrupt 
  mov bh, 0  ; Set page number to 0 
  int 0x10 ; call BIOS interrupt for printing to tty 

  jmp .loop 

.done:
  pop bx 
  pop ax 
  pop si 
  ret 

main:
  ; setup data segments
  mov ax, 0 ; can't write to ds and es directly
  mov ds, ax
  mov es, ax 

  ; setup stack 
  mov ss, ax 
  mov sp, 0x7C00 ; Stack grows downwards from where we are loaded in memory 

  mov si, msg_hello 
  call puts 

  hlt

.halt:
  jmp .halt

msg_hello: db 'Hello World!', ENDL, 0 
  
times 510-($-$$) db 0 
dw 0AA55H

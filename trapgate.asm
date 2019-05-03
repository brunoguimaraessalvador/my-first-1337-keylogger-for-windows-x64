.DATA?
BaseOfIdt1 DQ ?
BaseOfIdt2 DQ ?
BaseOfIdt_ DQ ?
BaseOfIdt__ DQ ?
LowIdt DQ ?
IDTR STRUCT
Limit DW ?
OffsetOfIsr DQ ?
IDTR ENDS
IDTable IDTR <?>
.CODE
DriverEntry PROC
Start1:
lea     rdx,[IDTable]
push    rdx
sidt    [rsp-2]                 ; Interrupt table to stack
pop     rdx
mov BaseOfIdt1,rdx
Start2:
lea     rdx,[IDTable]
push    rdx
sidt    [rsp-2]                 ; Interrupt table to stack
pop     rdx
mov BaseOfIdt_,rdx
mov rax,BaseOfIdt1
cmp BaseOfIdt_,rax
jz Start2

L2:
mov rdx,BaseOfIdt1
mov rax,0040ee0000101009h
add rdx,280h
mov rcx,[rdx]
mov BaseOfIdt2,rcx	;BaseOfIdt2 == MSB Of Idt1
mov rdi,[rdx+8]		;rdi == LSB
mov  [rdx],rax
mov rcx,0
mov [rdx+8],rcx
L3:
mov rdx,BaseOfIdt_
mov rax,0040ee0000101009h
add rdx,280h
mov rcx,[rdx]
mov BaseOfIdt__,rcx
mov rsi,[rdx+8]
mov  [rdx],rax
mov rcx,0
mov [rdx+8],rcx

mov rcx,0a00000000h
call delay
;AGORA RESTAURA VALORES
mov rdx,BaseOfIdt2
mov LowIdt,rdi
mov rbx,BaseOfIdt1
mov [rbx+280h],rdx
mov rcx,LowIdt
mov [rbx+288h],rcx

mov rdx,BaseOfIdt__
mov LowIdt,rsi
mov rbx,BaseOfIdt_
mov [rbx+280h],rdx
mov rcx,LowIdt
mov [rbx+288h],rcx
ret

DriverEntry ENDP
delay proc
mov rax,rcx
L01:
cmp rax,0
jz L02
dec rax
jmp L01
L02:
ret
delay endp
END
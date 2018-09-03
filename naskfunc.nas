;naskfunc

[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[BITS 32]
[FILE "naskfunc.nas"]

		GLOBAL _io_hlt, _io_cli, _io_sti, _io_stihlt
		GLOBAL _io_in8, _io_in16, _io_in32
        GLOBAL _io_out8, _io_out16, _io_out32
        GLOBAL _io_load_eflags, _io_store_eflags
		GLOBAL _load_gdtr, _load_idtr
        GLOBAL _load_cr0, _store_cr0
        GLOBAL _asm_inthandler21, _asm_inthandler27, _asm_inthandler2c
        GLOBAL _memtest_sub
        EXTERN _inthandler21, _inthandler27, _inthandler2c

[SECTION .text]

_io_hlt:
		HLT
		RET

_io_cli:
		CLI
		RET

_io_sti:
		STI
		RET

_io_stihlt:
		STI
		HLT
		RET

_io_in8:
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,0
		IN		AL,DX
		RET

_io_in16:
		MOV		EDX,[ESP+4]
		MOV		EAX,0
		IN		AX,DX
		RET

_io_in32:
		MOV		EDX,[ESP+4]		; port
		IN		EAX,DX
		RET

_io_out8:
		MOV		EDX,[ESP+4]		; port
		MOV		AL,[ESP+8]		; data
		OUT		DX,AL
		RET

_io_out16:
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,AX
		RET

_io_out32:
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,EAX
		RET

_io_load_eflags:
		PUSHFD
		POP		EAX
		RET

_io_store_eflags:
		MOV		EAX,[ESP+4]
		PUSH	EAX
		POPFD
		RET

_load_gdtr:
		MOV		AX,[ESP+4]
		MOV		[ESP+6],AX
		LGDT	[ESP+6]
		RET

_load_idtr:
		MOV		AX,[ESP+4]
		MOV		[ESP+6],AX
		LIDT	[ESP+6]
		RET
_load_cr0:
        MOV     EAX,CR0
        RET
_store_cr0:
        MOV     EAX,[ESP+4]
        MOV     CR0,EAX
        RET

_asm_inthandler21:
        PUSH    ES
        PUSH    DS
        PUSHAD
        MOV     EAX,ESP
        PUSH    EAX
        MOV     AX,SS
        MOV     DS,AX
        MOV     ES,AX
        CALL    _inthandler21
        POP     EAX
        POPAD
        POP     DS
        POP     ES
        IRETD

_asm_inthandler27:
        PUSH    ES
        PUSH    DS
        PUSHAD
        MOV     EAX,ESP
        PUSH    EAX
        MOV     AX,SS
        MOV     DS,AX
        MOV     ES,AX
        CALL    _inthandler27
        POP     EAX
        POPAD
        POP     DS
        POP     ES
        IRETD

_asm_inthandler2c:
        PUSH    ES
        PUSH    DS
        PUSHAD
        MOV     EAX,ESP
        PUSH    EAX
        MOV     AX,SS
        MOV     DS,AX
        MOV     ES,AX
        CALL    _inthandler2c
        POP     EAX
        POPAD
        POP     DS
        POP     ES
        IRETD

_memtest_sub:
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,0xaa55aa55
        MOV     EDI,0x55aa55aa
        MOV     EAX,[ESP+12+4]
mts_loop:
        MOV     EBX,EAX
        ADD     EBX,0xffc
        MOV     EDX,[EBX]
        MOV     [EBX],ESI
        XOR     DWORD [EBX],0xffffffff
        CMP     EDI,[EBX]
        JNE     mts_fin
        XOR     DWORD [EBX],0xffffffff
        CMP     ESI,[EBX]
        JNE     mts_fin
        MOV     [EBX],EDX
        ADD     EAX,0x1000
        CMP     EAX,[ESP+12+8]
        JBE     mts_loop
        POP     EBX
        POP     ESI
        POP     EDI
        RET
mts_fin:
        MOV     [EBX],EDX
        POP     EBX
        POP     ESI
        POP     EDI
        RET

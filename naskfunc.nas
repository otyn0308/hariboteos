;naskfunc

[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[BITS 32]

[FILE "naskfunc.nas"]

		GLOBAL _io_hlt
		GLOBAL _write_mem8

[SECTION .text]

_io_hlt:
		HLT
		RET

_write_mem8:
		MOV		ECX,[ESP+4]
		MOV		AL,[ESP+8]
		MOV		[ECX],AL
		RET

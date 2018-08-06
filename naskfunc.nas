;naskfunc

[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[BITS 32]

[FILE "naskfunc.nas"]
		GLOBAL	_io_hlt
		GLOBAL	_write_mam8

[SECTION .text]	;オブジェクトファイルではこれを書いてからプログラムを書く
_io_hlt:
		HLT
		RET
_write_mem8: 	;void write_mem8(int addr, int data)
		MOV		ECX,[ESP+4]		;[ESP+4]にaddrが入っているのでそれをECXに読みこむ
		MOV		AL,[ESP+8]		;[ESP+8]にdataが入っているのでそれをALに読み込む
		MOV		[ECX],AL
		RET

; hello-os
; コメントがつけられる

	ORG	0x7c00

; 以下は標準的なFAT12フォーマットフロッピーディスクのための記述

	JMP	entry
	DB	0x90
	DB	"HARIBOTE"	; ブートセクタの名前を自由に書いてよい(8byte)
	DW	512		; 1セクタの大きさ(512にしなければならない)
	DB	1		; クラスタの大きさ(1セクタにしなければならない)
	DW	1		; FATがどこから始まるか(普通は1セクタ目からにする)
	DB	2		; FATの個数(2にしなければならない)
	DW	224		; ルートディレクトリ領域の大きさ(普通は224エントリにする)
	DW	2880		; このドライブの大きさ(2880セクタにしなければならない)
	DB	0xf0		; メディアのタイプ(0xf0にしなければならない)
	DW	9		; FAT領域の長さ(9セクタにしなければならない)
	DW	18		; 1トラックにいくつセクタがあるか(18にしなければならない)
	DW	2		; ヘッドの数(2にしなければならない)
	DD	0		; パーティションを使っていないので0
	DD	2880		; ドライブの大きさをもう一度書く
	DB	0,0,0x29	; よく分からないがこの値にしておくと良いらしい
	DD	0xffffffff	; ボリュームシリアル番号
	DB	"HARIBOTEOS   "	; ディスクの名前(11byte)
	DB	"FAT12   "	; フォーマットの名前(8byte)
	RESB	18		; 18byteあけておく

; プログラム本体

entry:
	MOV	AX,0		; レジスタ初期化
	MOV	SS,AX
	MOV	SP,0x7c00
	MOV	DS,AX
	MOV	AX,0x0820
	MOV	ES,AX
	MOV	CH,0
	MOV	DH,0
	MOV	CL,2
	MOV	SI,0
retry:
	MOV	AH,0x02
	MOV	AL,1
	MOV	BX,0
	MOV	DL,0x00
	INT	0x13
	JNC	fin
	ADD	SI,1
	CMP	SI,5
	JAE	error
	MOV	AH,0x00
	MOV	DL,0x00
	INT	0x13
	JMP	retry
error:
	MOV	SI,msg
putloop:
	MOV	AL,[SI]
	ADD	SI,1		; SIに1を足す
	CMP	AL,0
	JE	fin
	MOV	AH,0x0e		; 一文字表示ファンクション
	MOV	BX,15		; カラーコード
	INT	0x10
	JMP	putloop
fin:
	HLT			; 何かあるまでCPUを停止させる
	JMP	fin		; 無限ループ
msg:
	DB	0x0a, 0x0a	; 改行を２つ
	DB	"load error"
	DB	0x0a		; 改行
	DB	0

	RESB	0x7dfe-$	; 0x7dfeまでを0x00で埋める

	DB	0x55, 0xaa	; ブートセクタ

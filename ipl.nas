; hello-os
; コメントがつけられる

CYLS	EQU		10

		ORG		0x7c00

; 以下は標準的なFAT12フォーマットフロッピーディスクのための記述

		JMP		entry
		DB		0x90
		DB		"HARIBOTE"		;ブートセクタの名前を自由に書いてよい(8byte)
		DW		512				;1セクタの大きさ(512にしなければならない)
		DB		1				;クラスタの大きさ(1セクタにしなければならない)
		DW		1				;FATがどこから始まるか(普通は1セクタ目からにする)
		DB		2				;FATの個数(2にしなければならない)
		DW		224				;ルートディレクトリ領域の大きさ(普通は224エントリにする)
		DW		2880			;このドライブの大きさ(2880セクタにしなければならない)
		DB		0xf0			;メディアのタイプ(0xf0にしなければならない)
		DW		9				;FAT領域の長さ(9セクタにしなければならない)
		DW		18				;1トラックにいくつセクタがあるか(18にしなければならない)
		DW		2				;ヘッドの数(2にしなければならない)
		DD		0				;パーティションを使っていないので0
		DD		2880			;ドライブの大きさをもう一度書く
		DB		0,0,0x29		;よく分からないがこの値にしておくと良いらしい
		DD		0xffffffff		;ボリュームシリアル番号
		DB		"HARIBOTEOS "	;ディスクの名前(11byte)
		DB		"FAT12   "		;フォーマットの名前(8byte)
		RESB	18				;18byteあけておく

; プログラム本体

entry:
		MOV		AX,0			; レジスタ初期化
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0			;シリンダ0
		MOV		DH,0			;ヘッド0
		MOV		CL,2			;セクタ0
readloop:
		MOV		SI,0			;失敗回数を数えるレジスタ
retry:
		MOV		AH,0x02			;AH=0x20:ディスク読み込み
		MOV		AL,1			;1セクタ
		MOV		BX,0
		MOV		DL,0x00			;Aドライブ
		INT		0x13			;ディスクBIOS呼び出し
		JNC		next			;エラーが起きなければnextへ
		ADD		SI,1			;SIに1を足す
		CMP		SI,5			;SIを5と比較
		JAE		error			;SI >= 5だったらerrorへ
		MOV		AH,0x00
		MOV		DL,0x00			;Aドライブ
		INT		0x13			;ドライブのリセット
		JMP		retry
next:
		MOV		AX,ES			;アドレスを0x200埋める
		ADD		AX,0x0020
		MOV		ES,AX			;ADD ES 0x020という命令が無いのでこうしてる
		ADD		CL,1			;CLに1を足す
		CMP		CL,18			;CLと18を比較
		JBE		readloop		;CL <= だったらreadloopへ
		MOV		CL,1
		ADD		DH,1
		CMP		DH,2
		JB		readloop		;DH < 2 だったらreadloopへ
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop		;CH < CYLS だったらreadloopへ


		MOV		[0x0ff0],CH
		JMP		0xc200
error:
		MOV		SI,msg
putloop:
		MOV		AL,[SI]
		ADD		SI,1			;SIに1を足す
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			;1文字表示ファンクション
		MOV		BX,15			;カラーコード
		INT		0x10
		JMP		putloop
fin:
		HLT						;何かあるまでCPUを停止させる
		JMP		fin				;無限ループ
msg:
		DB		0x0a, 0x0a		;改行を2つ
		DB		"load error"
		DB		0x0a			;改行
		DB		0

		RESB	0x7dfe-$		;0x7dfeまでを0x00で埋める

		DB	0x55, 0xaa			;ブートセクタ
